classdef Tolerance_ISO286 < Component
    % Tolerance_ISO286 - ISO 286-2 tolerance and fit calculator
    % Calculate limit deviations for holes and shafts, and analyze fits.
    % Author: Yu Xie

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Echo'          % Print flag
            'Unit'          % Output unit: 'um' or 'mm'
            'TableFile'     % External table file path (optional)
            };

        inputExpectedFields = {
            'NominalSize'       % Nominal size [mm]
            'HoleTolerance'     % Hole tolerance code, e.g. 'H7'
            'ShaftTolerance'    % Shaft tolerance code, e.g. 'g6'
            };

        outputExpectedFields = {
            'Hole'      % Hole deviation and limit sizes
            'Shaft'     % Shaft deviation and limit sizes
            'Fit'       % Fit properties
            };

        baselineExpectedFields = {};

        default_Echo = 1;
        default_Unit = 'um';
        default_TableFile = '';

    end

    methods

        function obj = Tolerance_ISO286(paramsStruct, inputStruct)
            obj = obj@Component(paramsStruct, inputStruct);
            obj.documentname = 'Tolerance_ISO286.pdf';
        end

        function obj = solve(obj)
            % Check required inputs
            obj.Check();

            D = obj.input.NominalSize;
            holeCode = obj.input.HoleTolerance;
            shaftCode = obj.input.ShaftTolerance;

            % Parse tolerance codes
            [holeLetter, holeIT] = parseToleranceCode(obj, holeCode);
            [shaftLetter, shaftIT] = parseToleranceCode(obj, shaftCode);

            % Get standard tolerance values
            holeITval = getITValue(obj, D, holeIT);
            shaftITval = getITValue(obj, D, shaftIT);

            % Get limit deviations
            holeDev = getLimitDeviation(obj, D, holeLetter, holeIT, holeITval, 'hole');
            shaftDev = getLimitDeviation(obj, D, shaftLetter, shaftIT, shaftITval, 'shaft');

            % Calculate limit sizes and fit
            obj.output.Hole = calculateFeature(obj, D, holeDev, 'hole');
            obj.output.Shaft = calculateFeature(obj, D, shaftDev, 'shaft');
            obj.output.Fit = calculateFit(obj, obj.output.Hole, obj.output.Shaft);

            % Unit conversion if requested
            if strcmpi(obj.params.Unit, 'mm')
                obj.output = convertOutputUnit(obj, obj.output, 1e-3);
            end

            % Print result
            if obj.params.Echo
                printResult(obj);
            end
        end

    end

    methods (Hidden)

        function [letter, itGrade] = parseToleranceCode(~, code)
            % Parse tolerance code like 'H7', 'g6', 'CD7' or 'JS7' into letter and IT grade
            if ~ischar(code) && ~isstring(code)
                error('Tolerance code must be a string, e.g. ''H7''.');
            end
            code = char(code);
            if length(code) < 2
                error('Tolerance code must contain a letter and an IT grade, e.g. ''H7''.');
            end
            idx = find(isstrprop(code, 'digit'), 1);
            if isempty(idx)
                error('Tolerance code must end with an IT grade number, e.g. ''H7''.');
            end
            letter = code(1:idx-1);
            itGrade = str2double(code(idx:end));
            if isnan(itGrade) || itGrade < 0 || itGrade > 18 || mod(itGrade,1) ~= 0
                error('Invalid IT grade in tolerance code %s.', code);
            end
        end

        function itVal = getITValue(obj, D, itGrade)
            % Return standard tolerance value in micrometers (um)
            table = getITTable(obj);
            idx = findSizeRangeIndex(obj, D, table.sizeRanges);
            itVal = table.values(idx, itGrade + 2);
            if isnan(itVal)
                error('IT grade IT%d is not defined for nominal size %.3f mm.', itGrade, D);
            end
        end

        function dev = getLimitDeviation(obj, D, letter, itGrade, itVal, type)
            % Return limit deviation structure in micrometers (um)
            % For hole: dev.ES, dev.EI
            % For shaft: dev.es, dev.ei

            switch type
                case 'hole'
                    letter = upper(letter);
                    switch letter
                        case 'JS'
                            % Symmetric
                            dev.ES = itVal / 2;
                            dev.EI = -itVal / 2;
                        otherwise
                            dev = getDeviationFromTable(obj, D, letter, itGrade, itVal, 'hole');
                    end

                case 'shaft'
                    letter = lower(letter);
                    switch letter
                        case 'js'
                            % Symmetric
                            dev.es = itVal / 2;
                            dev.ei = -itVal / 2;
                        otherwise
                            dev = getDeviationFromTable(obj, D, letter, itGrade, itVal, 'shaft');
                    end

                otherwise
                    error('Unknown feature type %s. Use ''hole'' or ''shaft''.', type);
            end
        end

        function dev = getDeviationFromTable(obj, D, letter, itGrade, itVal, type)
            % Get deviation from private folder table or external table file
            % Private tables are stored as: +method/@Tolerance_ISO286/private/<type>_<letter>.m

            funcName = sprintf('%s_%s', type, letter);
            classDir = fileparts(which(class(obj)));
            funcPath = fullfile(classDir, 'private', [funcName, '.m']);

            if exist(funcPath, 'file')
                % Built-in table in private folder
                table = feval(funcName);
                dev = lookupDeviationTable(obj, D, letter, itGrade, itVal, type, table);
            elseif ~isempty(obj.params.TableFile) && exist(obj.params.TableFile, 'file')
                % Try external table file
                extTable = loadExternalTable(obj);
                key = sprintf('%s_%s', type, letter);
                if isfield(extTable, key)
                    dev = lookupDeviationTable(obj, D, letter, itGrade, itVal, type, extTable.(key));
                else
                    error('Fundamental deviation %s for %s is not available in built-in or external tables.', letter, type);
                end
            else
                error('Fundamental deviation %s for %s is not implemented. Supported shaft deviations: h, g, k, n, p, s, js. Supported hole deviations: H, G, K, N, P, S.', letter, type);
            end
        end

        function dev = lookupDeviationTable(obj, D, letter, itGrade, itVal, type, table)
            % Look up fundamental deviation from table and compute second deviation
            idx = findSizeRangeIndex(obj, D, table.sizeRanges);

            % Handle IT-dependent tables (matrix values with itGrades field)
            if size(table.values, 2) > 1
                if ~isfield(table, 'itGrades')
                    error('Table for %s_%s is matrix but lacks itGrades field.', type, letter);
                end
                col = find(table.itGrades == itGrade, 1);
                if isempty(col)
                    error('IT grade IT%d is not supported by table %s_%s.', itGrade, type, letter);
                end
                val = table.values(idx, col);
            else
                val = table.values(idx);
            end

            switch type
                case 'hole'
                    % For holes A-H: EI is fundamental, ES = EI + IT
                    % For holes K-ZC: ES is fundamental, EI = ES - IT
                    switch upper(letter)
                        case {'A','B','C','CD','D','E','EF','F','FG','G','H'}
                            dev.EI = val;
                            dev.ES = dev.EI + itVal;
                        otherwise
                            dev.ES = val;
                            dev.EI = dev.ES - itVal;
                    end

                case 'shaft'
                    % For shafts a-h: es is fundamental, ei = es - IT
                    % For shafts k-zc: ei is fundamental, es = ei + IT
                    switch letter
                        case {'a','b','c','cd','d','e','ef','f','fg','g','h'}
                            dev.es = val;
                            dev.ei = dev.es - itVal;
                        otherwise
                            dev.ei = val;
                            dev.es = dev.ei + itVal;
                    end
            end
        end

        function feat = calculateFeature(~, D, dev, type)
            % Calculate limit sizes from deviations
            switch type
                case 'hole'
                    feat.ES = dev.ES;
                    feat.EI = dev.EI;
                    feat.UpperLimit = D + dev.ES * 1e-3;
                    feat.LowerLimit = D + dev.EI * 1e-3;
                    feat.Tolerance = dev.ES - dev.EI;
                case 'shaft'
                    feat.es = dev.es;
                    feat.ei = dev.ei;
                    feat.UpperLimit = D + dev.es * 1e-3;
                    feat.LowerLimit = D + dev.ei * 1e-3;
                    feat.Tolerance = dev.es - dev.ei;
            end
        end

        function fit = calculateFit(~, hole, shaft)
            % Calculate fit properties
            fit.MaxClearance = hole.UpperLimit - shaft.LowerLimit;
            fit.MinClearance = hole.LowerLimit - shaft.UpperLimit;

            if fit.MinClearance > 0
                fit.Type = 'clearance';
            elseif fit.MaxClearance < 0
                fit.Type = 'interference';
            else
                fit.Type = 'transition';
            end

            fit.MaxInterference = -fit.MinClearance;
            fit.MinInterference = -fit.MaxClearance;
        end

        function output = convertOutputUnit(~, output, factor)
            % Convert deviation and tolerance values to requested unit
            % Limit sizes are always in mm and should not be converted
            devFields.Hole = {'ES', 'EI', 'Tolerance'};
            devFields.Shaft = {'es', 'ei', 'Tolerance'};
            fields = {'Hole', 'Shaft'};
            for i = 1:length(fields)
                f = fields{i};
                sub = output.(f);
                for j = 1:length(devFields.(f))
                    fieldName = devFields.(f){j};
                    if isfield(sub, fieldName)
                        sub.(fieldName) = sub.(fieldName) * factor;
                    end
                end
                output.(f) = sub;
            end
        end

        function printResult(obj)
            unit = obj.params.Unit;
            fprintf('=== ISO 286-2 Tolerance Analysis ===\n');
            fprintf('Nominal size: %.3f mm\n', obj.input.NominalSize);
            fprintf('Hole: %s, Shaft: %s\n', obj.input.HoleTolerance, obj.input.ShaftTolerance);
            fprintf('\nHole deviations [%s]:\n', unit);
            fprintf('  ES = %.3f, EI = %.3f\n', obj.output.Hole.ES, obj.output.Hole.EI);
            fprintf('  Limits: %.4f ~ %.4f mm\n', obj.output.Hole.LowerLimit, obj.output.Hole.UpperLimit);
            fprintf('\nShaft deviations [%s]:\n', unit);
            fprintf('  es = %.3f, ei = %.3f\n', obj.output.Shaft.es, obj.output.Shaft.ei);
            fprintf('  Limits: %.4f ~ %.4f mm\n', obj.output.Shaft.LowerLimit, obj.output.Shaft.UpperLimit);
            fprintf('\nFit type: %s\n', obj.output.Fit.Type);
            fprintf('Max clearance: %.4f mm\n', obj.output.Fit.MaxClearance);
            fprintf('Min clearance: %.4f mm\n', obj.output.Fit.MinClearance);
        end

        function idx = findSizeRangeIndex(~, D, ranges)
            % ranges: Nx2 matrix [lower, upper] in mm
            idx = find(D > ranges(:,1) & D <= ranges(:,2), 1);
            if isempty(idx)
                error('Nominal size %.3f mm is out of supported range.', D);
            end
        end

        function table = getITTable(~)
            % ISO 286-2 Table 1: Standard tolerance grades IT01 ~ IT18
            % Values in micrometers (um)
            table.sizeRanges = [
                0, 3;
                3, 6;
                6, 10;
                10, 18;
                18, 30;
                30, 50;
                50, 80;
                80, 120;
                120, 180;
                180, 250;
                250, 315;
                315, 400;
                400, 500;
                500, 630;
                630, 800;
                800, 1000;
                1000, 1250;
                1250, 1600;
                1600, 2000;
                2000, 2500;
                2500, 3150;
                ];
            % Columns: IT01 IT0 IT1 IT2 IT3 IT4 IT5 IT6 IT7 IT8 IT9 IT10 IT11 IT12 IT13 IT14 IT15 IT16 IT17 IT18
            table.values = [
                0.3, 0.5, 0.8, 1.2, 2, 3, 4, 6, 10, 14, 25, 40, 60, 100, 140, 250, 400, 600, 1000, 1400;
                0.4, 0.6, 1.0, 1.5, 2.5, 4, 5, 8, 12, 18, 30, 48, 75, 120, 180, 300, 480, 750, 1200, 1800;
                0.4, 0.6, 1.0, 1.5, 2.5, 4, 6, 9, 15, 22, 36, 58, 90, 150, 220, 360, 580, 900, 1500, 2200;
                0.5, 0.8, 1.2, 2, 3, 5, 8, 11, 18, 27, 43, 70, 110, 180, 270, 430, 700, 1100, 1800, 2700;
                0.6, 1.0, 1.5, 2.5, 4, 6, 9, 13, 21, 33, 52, 84, 130, 210, 330, 520, 840, 1300, 2100, 3300;
                0.6, 1.0, 1.5, 2.5, 4, 7, 11, 16, 25, 39, 62, 100, 160, 250, 390, 620, 1000, 1600, 2500, 3900;
                0.8, 1.2, 2, 3, 5, 8, 13, 19, 30, 46, 74, 120, 190, 300, 460, 740, 1200, 1900, 3000, 4600;
                1.0, 1.5, 2.5, 4, 6, 10, 15, 22, 35, 54, 87, 140, 220, 350, 540, 870, 1400, 2200, 3500, 5400;
                1.2, 2.0, 3.5, 5, 8, 12, 18, 25, 40, 63, 100, 160, 250, 400, 630, 1000, 1600, 2500, 4000, 6300;
                2.0, 3.0, 4.5, 7, 10, 14, 20, 29, 46, 72, 115, 185, 290, 460, 720, 1150, 1850, 2900, 4600, 7200;
                2.5, 4.0, 6.0, 8, 12, 16, 23, 32, 52, 81, 130, 210, 320, 520, 810, 1300, 2100, 3200, 5200, 8100;
                3.0, 5.0, 7.0, 9, 13, 18, 25, 36, 57, 89, 140, 230, 360, 570, 890, 1400, 2300, 3600, 5700, 8900;
                4.0, 6.0, 8.0, 10, 15, 20, 27, 40, 63, 97, 155, 250, 400, 630, 970, 1550, 2500, 4000, 6300, 9700;
                nan(1, 2), 9, 11, 16, 22, 32, 44, 70, 110, 175, 280, 440, 700, 1100, 1750, 2800, 4400, 7000, 11000;
                nan(1, 2), 10, 13, 18, 25, 36, 50, 80, 125, 200, 320, 500, 800, 1250, 2000, 3200, 5000, 8000, 12500;
                nan(1, 2), 11, 15, 21, 28, 40, 56, 90, 140, 230, 360, 560, 900, 1400, 2300, 3600, 5600, 9000, 14000;
                nan(1, 2), 13, 18, 24, 33, 47, 66, 105, 165, 260, 420, 660, 1050, 1650, 2600, 4200, 6600, 10500, 16500;
                nan(1, 2), 15, 21, 29, 39, 55, 78, 125, 195, 310, 500, 780, 1250, 1950, 3100, 5000, 7800, 12500, 19500;
                nan(1, 2), 18, 25, 35, 46, 65, 92, 150, 230, 370, 600, 920, 1500, 2300, 3700, 6000, 9200, 15000, 23000;
                nan(1, 2), 22, 30, 41, 55, 78, 110, 175, 280, 440, 700, 1100, 1750, 2800, 4400, 7000, 11000, 17500, 28000;
                nan(1, 2), 26, 36, 50, 68, 96, 135, 210, 330, 540, 860, 1350, 2100, 3300, 5400, 8600, 13500, 21000, 33000;
                ];
        end

        function extTable = loadExternalTable(obj)
            % Load external table file (.mat format expected)
            % File should contain a struct named 'ToleranceTable'
            data = load(obj.params.TableFile);
            if isfield(data, 'ToleranceTable')
                extTable = data.ToleranceTable;
            else
                error('External table file must contain a variable named ''ToleranceTable''.');
            end
        end

    end
end

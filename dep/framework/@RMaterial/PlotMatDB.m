function obj = PlotMatDB(obj, varargin)
% PlotMatDB - Visualize material database with interactive plotting
%
% SYNTAX:
%   obj = PlotMatDB(obj)
%   obj = PlotMatDB(obj, 'SheetName', 'Composite', 'XField', 'E1', 'YField', 'E2')
%
% INPUTS:
%   obj       - RMaterial object
%
% OPTIONAL PARAMETERS:
%   'SheetName' - Material sheet name (skips selection dialog)
%   'XField'    - X-axis field name (skips selection dialog)
%   'YField'    - Y-axis field name (skips selection dialog)
%   'Unit'      - Unit system: 1 (tonne mm s, default) or 2 (kg m s)
%
% OUTPUTS:
%   obj       - RMaterial object (supports method chaining)
%
% EXAMPLES:
%   S = RMaterial('Composite');
%   PlotMatDB(S);
%   PlotMatDB(S, 'XField', 'E1', 'YField', 'E2');
%   PlotMatDB(S, 'SheetName', 'Spring', 'XField', 'Density', 'YField', 'E');
%
% Author : Xie Yu
% Date   : 2025-02-19

    %% Parse input parameters
    p = inputParser;
    addParameter(p, 'SheetName', []);
    addParameter(p, 'XField', []);
    addParameter(p, 'YField', []);
    addParameter(p, 'Unit', 1);
    parse(p, varargin{:});
    opt = p.Results;

    % Use object's SheetName if SheetName not provided
    if isempty(opt.SheetName)
        sheetName = obj.SheetName;
    else
        sheetName = opt.SheetName;
    end

    xField = opt.XField;
    yField = opt.YField;
    unit = opt.Unit;

    %% Define available material databases
    sheetList = {'Basic', 'Gear', 'Bolt', 'Composite', 'Magnetic', 'FEA', 'Lubricant', 'Spring'};

    %% Step 1: Select material database (if not specified)
    if isempty(sheetName)
        [selection, ok] = listdlg('PromptString', 'Select Material Database:', ...
                                   'SelectionMode', 'single', ...
                                   'ListString', sheetList);
        if ~ok
            if obj.Echo
                fprintf('Material database selection cancelled.\n');
            end
            return;
        end
        sheetName = sheetList{selection};
    else
        % Validate sheet name
        if ~ismember(sheetName, sheetList)
            error('RMaterial:InvalidSheet', 'SheetName must be one of: %s', strjoin(sheetList, ', '));
        end
    end

    %% Step 2: Load material data for selected sheet
    % Use object's Sheet if it matches, otherwise create new object
    if strcmp(obj.SheetName, sheetName)
        dataSheet = obj.Sheet;
    else
        tempObj = RMaterial(sheetName, 'Echo', 0);
        dataSheet = tempObj.Sheet;
    end

    %% Step 3: Select X-axis field (if not specified)
    if isempty(xField)
        % Filter to numeric fields only
        fieldList = dataSheet.Properties.VariableNames;
        numericFields = {};
        for i = 1:length(fieldList)
            fieldName = fieldList{i};
            fieldData = dataSheet.(fieldName);
            if isnumeric(fieldData) || (iscell(fieldData) && all(cellfun(@isnumeric, fieldData)))
                % Exclude 'No' (index) field
                if ~strcmp(fieldName, 'No')
                    numericFields{end+1} = fieldName;
                end
            end
        end

        [selection, ok] = listdlg('PromptString', 'Select X-axis field:', ...
                                   'SelectionMode', 'single', ...
                                   'ListString', numericFields);
        if ~ok
            if obj.Echo
                fprintf('X-axis field selection cancelled.\n');
            end
            return;
        end
        xField = numericFields{selection};
    else
        % Validate xField exists and is numeric
        if ~ismember(xField, dataSheet.Properties.VariableNames)
            error('RMaterial:InvalidField', 'XField ''%s'' not found in sheet ''%s''', xField, sheetName);
        end
    end

    %% Step 4: Select Y-axis field (if not specified)
    if isempty(yField)
        % Filter to numeric fields only
        fieldList = dataSheet.Properties.VariableNames;
        numericFields = {};
        for i = 1:length(fieldList)
            fieldName = fieldList{i};
            fieldData = dataSheet.(fieldName);
            if isnumeric(fieldData) || (iscell(fieldData) && all(cellfun(@isnumeric, fieldData)))
                % Exclude 'No' (index) field
                if ~strcmp(fieldName, 'No')
                    numericFields{end+1} = fieldName;
                end
            end
        end

        [selection, ok] = listdlg('PromptString', 'Select Y-axis field:', ...
                                   'SelectionMode', 'single', ...
                                   'ListString', numericFields);
        if ~ok
            if obj.Echo
                fprintf('Y-axis field selection cancelled.\n');
            end
            return;
        end
        yField = numericFields{selection};
    else
        % Validate yField exists and is numeric
        if ~ismember(yField, dataSheet.Properties.VariableNames)
            error('RMaterial:InvalidField', 'YField ''%s'' not found in sheet ''%s''', yField, sheetName);
        end
    end

    %% Step 5: Extract data
    xData = dataSheet.(xField);
    yData = dataSheet.(yField);

    % Get material names for labels
    if ismember('Name', dataSheet.Properties.VariableNames)
        labels = dataSheet.Name;
    else
        % Use row numbers if Name field doesn't exist
        labels = arrayfun(@(x) sprintf('Mat %d', x), (1:height(dataSheet))', 'UniformOutput', false);
    end

    % Get color grouping data (use 'Type' field if available)
    colorData = [];
    if ismember('Type', dataSheet.Properties.VariableNames)
        colorData = dataSheet.Type;
        colorLabel = 'Type';
    elseif ismember('ASTM', dataSheet.Properties.VariableNames)
        colorData = dataSheet.ASTM;
        colorLabel = 'ASTM';
    elseif ismember('SAE', dataSheet.Properties.VariableNames)
        colorData = dataSheet.SAE;
        colorLabel = 'SAE';
    elseif ismember('Origin_Region', dataSheet.Properties.VariableNames)
        colorData = dataSheet.Origin_Region;
        colorLabel = 'Origin_Region';
    end

    %% Step 6: Handle unit conversions
    switch unit
        case 1 % tonne mm s - default (no conversion needed for stored values)
            % Values are already in correct units
        case 2 % kg m s
            % Convert from unit 1 to unit 2
            % Density: tonne/mm^3 -> kg/m^3 (multiply by 1e9)
            % Stress/Modulus: MPa -> Pa (multiply by 1e6)
            % Length: mm -> m (multiply by 1e-3)
            if strcmpi(xField, 'Density')
                xData = xData * 1e9;
            elseif ismember(xField, {'E', 'E1', 'E2', 'E3', 'G12', 'G23', 'G13', ...
                                   'SigmaF', 'SigmaH', 'F1t', 'F2t', 'F3t', ...
                                   'F1c', 'F2c', 'F3c', 'F4', 'F6'})
                xData = xData * 1e6;
            end

            if strcmpi(yField, 'Density')
                yData = yData * 1e9;
            elseif ismember(yField, {'E', 'E1', 'E2', 'E3', 'G12', 'G23', 'G13', ...
                                   'SigmaF', 'SigmaH', 'F1t', 'F2t', 'F3t', ...
                                   'F1c', 'F2c', 'F3c', 'F4', 'F6'})
                yData = yData * 1e6;
            end
        otherwise
            error('RMaterial:InvalidUnit', 'Unit must be 1 or 2');
    end

    %% Step 7: Filter out NaN values
    validIdx = ~isnan(xData) & ~isnan(yData);
    xData = xData(validIdx);
    yData = yData(validIdx);
    labels = labels(validIdx);
    if ~isempty(colorData)
        colorData = colorData(validIdx);
    end

    %% Step 8: Check for empty data
    if isempty(xData) || isempty(yData)
        error('RMaterial:EmptyData', 'No valid data points found for the selected fields');
    end

    %% Check number of color categories - limit to reasonable number for color map
    useColorGrouping = ~isempty(colorData);
    if useColorGrouping
        uniqueColors = unique(colorData);
        if length(uniqueColors) > 8
            useColorGrouping = false;
            if obj.Echo
                fprintf('Warning: Too many color categories (%d), using single color\n', length(uniqueColors));
            end
        end
    end

    %% Step 9: Create Rplot visualization
    try
        % Create Rplot with color grouping if available and reasonable number of categories
        if useColorGrouping
            g = Rplot('x', xData, 'y', yData, 'label', labels, 'color', colorData);
            % Add color map for better visualization
            g = set_color_options(g, 'map', 'brewer2');
            if obj.Echo
                fprintf('Using color grouping by %s\n', colorLabel);
            end
        else
            g = Rplot('x', xData, 'y', yData, 'label', labels);
        end

        % Add labels next to data points
        g = geom_label(g, 'VerticalAlignment', 'middle', ...
                          'HorizontalAlignment', 'center', ...
                          'BackgroundColor', 'auto', ...
                          'Color', 'k');

        % Set axis labels
        g = set_names(g, 'x', xField, 'y', yField);

        % Set plot title
        g = set_title(g, ['Material Database: ' sheetName]);

        % Add extra margin for labels
        g = set_limit_extra(g, [0.1 0.1], [0.1 0.1]);

        % Draw the plot with larger figure size
        figure('Position', [100, 100, 1200, 800])
        draw(g);

        if obj.Echo
            fprintf('Plot created: %s vs %s for %s materials (%d data points)\n', ...
                    yField, xField, sheetName, length(xData));
        end

    catch ME
        error('RMaterial:PlotError', 'Error creating plot: %s', ME.message);
    end

end

classdef HelicalCompressionSpring < Component
    % HelicalCompressionSpring - Helical Compression Spring Design Component
    % Based on Component framework, implementing Chapter 14 of
    % "Machine Design: An Integrated Approach"
    %
    % Features:
    %   - Complete helical compression spring engineering design
    %   - Geometric parameters, spring rate, stress calculation
    %   - Static/dynamic load strength verification
    %   - Buckling and surge failure protection
    %   - Material selection and process selection
    %
    % Author: Based on Request.md
    % Date: 2026-02-20
    % Reference: Norton, "Machine Design: An Integrated Approach", Chapter 14

    properties(Hidden, Constant)
        %% Expected Fields Definition

        % Input fields: design input parameters
        inputExpectedFields = {
            'WireDiameter'       % (mm) Wire diameter d
            'MeanDiameter'       % (mm) Mean coil diameter D
            'FreeLength'         % (mm) Free length Lf
            'WorkingForce'       % (N) Working load F
            'WorkingDeflection'  % (mm) Working deflection y
            'LoadType'           % 'static' or 'dynamic'
            'EndType'           % 'open', 'open_ground', 'square', 'square_ground'
            'EndCondition'       % 'fixed_fixed' or 'fixed_free'
            'LoadingFreq'        % (Hz) Loading frequency (required for dynamic)
            };

        % Output fields: design results
        outputExpectedFields = {
            'OuterDiameter'      % (mm) Outer diameter Do
            'InnerDiameter'      % (mm) Inner diameter Di
            'TotalCoils'         % Total coils Nt
            'ActiveCoils'        % Active coils Na
            'SpringIndex'        % Spring index C
            'SpringRate'         % (N/mm) Spring rate k
            'ActualDeflection'   % (mm) Actual deflection
            'SolidLength'        % (mm) Solid length Ls
            'ClashAllowance'     % (mm) Clash allowance y_clash
            'MaxShearStress'    % (MPa) Maximum shear stress tau_max
            'WahlFactor'         % Wahl factor Kw
            'DirectShearFactor'  % Direct shear factor Ks
            'NaturalFrequency'    % (Hz) Natural frequency fn
            'SurgeRatio'         % Surge ratio fn/f_load
            'IsBucklingRisk'     % Buckling risk flag
            'IsSurgeRisk'        % Surge risk flag
            'FatigueLife'        % Estimated fatigue life
            'SafetyFactorStatic'  % Static safety factor
            'SafetyFactorFatigue'% Fatigue safety factor
            };

        % Parameter fields: material and configuration
        paramsExpectedFields = {
            'MaterialGrade'      % Material grade
            'ShearModulus'      % (MPa) Shear modulus G
            'IsSet'             % Is set (pre-set) process
            'IsShotPeened'      % Is shot peened
            'AllowableStress'   % (MPa) Allowable stress (optional)
            'RequiredCycleLife' % Expected cycle life
            'Echo'              % Print calculation progress
            };

        % Baseline fields: safety requirements
        baselineExpectedFields = {
            'MinSpringIndex'     % Minimum spring index
            'MaxSpringIndex'     % Maximum spring index
            'MinClashPercent'    % Minimum clash allowance percentage
            'MinSafetyFactorStatic'   % Minimum static safety factor
            'MinSafetyFactorFatigue'  % Minimum fatigue safety factor
            'MinSurgeRatio'      % Minimum surge ratio
            'MaxSlendernessRatio'% Maximum slenderness ratio Lf/D
            };

        %% Default Parameter Values

        % Material defaults (A228 music wire)
        default_MaterialGrade = 'A228';
        default_ShearModulus = 79300;      % (MPa) Music wire shear modulus
        default_IsSet = false;
        default_IsShotPeened = false;
        default_AllowableStress = [];      % Auto-calculate
        default_RequiredCycleLife = Inf;    % Infinite life
        default_Echo = true;

        %% Baseline Default Values

        base_MinSpringIndex = 4;          % Engineering criteria: C >= 4
        base_MaxSpringIndex = 12;         % Engineering criteria: C <= 12
        base_MinClashPercent = 10;        % Clash allowance 10-15%
        base_MinSafetyFactorStatic = 1.0;  % Default safety factor
        base_MinSafetyFactorFatigue = 1.0; % Default fatigue safety factor
        base_MinSurgeRatio = 13;          % Natural frequency > 13x load frequency
        base_MaxSlendernessRatio = 4;      % Lf/D > 4 has buckling risk

    end

    methods
        %% Constructor
        function obj = HelicalCompressionSpring(paramsStruct, inputStruct, varargin)
            % HelicalCompressionSpring constructor
            %
            % Parameters:
            %   paramsStruct - Material parameters struct
            %   inputStruct - Input design parameters struct
            %   varargin - Optional baseline struct

            % Call parent constructor
            obj = obj@Component(paramsStruct, inputStruct, varargin);

            % Set help document name
            obj.documentname = 'Request.md';
        end

        %% Override Check method for conditional LoadingFreq
        function Check(obj)
            % Check - Override base class Check to handle conditional LoadingFreq
            % LoadingFreq is only required for dynamic loads

            % Check all input fields
            for ii = 1:numel(obj.inputExpectedFields)
                fieldName = obj.inputExpectedFields{ii};

                % Skip LoadingFreq check if static load
                if strcmp(fieldName, 'LoadingFreq') && strcmp(obj.input.LoadType, 'static')
                    continue;
                end

                % Check if field is empty
                if isempty(obj.input.(fieldName))
                    error(['Please input ', fieldName, ' !']);
                end
            end
        end

        %% Core solve method
        function obj = solve(obj)
            % solve - Execute helical compression spring design calculation
            %
            % Calculation steps:
            %   1. Check input completeness
            %   2. Calculate geometric parameters
            %   3. Calculate material strength
            %   4. Calculate spring rate and deflection
            %   5. Stress analysis (based on load type and process)
            %   6. Natural frequency and surge check
            %   7. Buckling check
            %   8. Safety verification

            % 1. Check input completeness
            Check(obj);

            % Print information
            if obj.params.Echo
                fprintf('\n========================================\n');
                fprintf('Helical Compression Spring Design\n');
                fprintf('========================================\n\n');
                fprintf('Material Grade: %s\n', obj.params.MaterialGrade);
                fprintf('Wire Diameter: %.3f mm\n', obj.input.WireDiameter);
                fprintf('Mean Diameter: %.3f mm\n', obj.input.MeanDiameter);
                fprintf('Free Length: %.2f mm\n', obj.input.FreeLength);
                fprintf('Working Force: %.1f N\n', obj.input.WorkingForce);
                fprintf('Load Type: %s\n', obj.input.LoadType);
            end

            % 2. Calculate geometric parameters
            obj = calculateGeometry(obj);

            % 3. Calculate material strength
            [~, ~, S_sys, S_fw_prime, S_ew_prime] = calculateMaterialStrength(obj);

            % 4. Calculate spring rate and deflection
            obj = calculateSpringRate(obj);

            % 5. Stress analysis
            obj = calculateStress(obj, S_sys, S_fw_prime, S_ew_prime);

            % 6. Natural frequency and surge check
            obj = calculateNaturalFrequency(obj);

            % 7. Buckling check
            obj = checkBuckling(obj);

            % 8. Calculate capacity metrics
            obj = calculateCapacity(obj);

            % 9. Print results
            if obj.params.Echo
                printResults(obj);
            end

            % 10. Safety verification
            checkSafety(obj);
        end

        %% Geometric parameter calculation
        function obj = calculateGeometry(obj)
            % calculateGeometry - Calculate spring geometric parameters

            % Spring index
            C = obj.input.MeanDiameter / obj.input.WireDiameter;
            obj.output.SpringIndex = C;

            % Outer and inner diameters
            obj.output.OuterDiameter = obj.input.MeanDiameter + obj.input.WireDiameter;
            obj.output.InnerDiameter = obj.input.MeanDiameter - obj.input.WireDiameter;

            % Estimate total coils (based on deflection formula)
            % y = (8*F*D^3*Na) / (d^4*G)
            d = obj.input.WireDiameter;
            D = obj.input.MeanDiameter;
            F = obj.input.WorkingForce;
            y = obj.input.WorkingDeflection;
            G = obj.params.ShearModulus;

            Na = (y * d^4 * G) / (8 * F * D^3);

            % Determine total coils based on end type
            switch obj.input.EndType
                case 'open'
                    Nt = Na;
                case 'open_ground'
                    Nt = Na + 1;
                case {'square', 'square_ground'}
                    Nt = Na + 2;
            end

            % Round to 1/4 coil (manufacturing precision)
            Nt = round(Nt * 4) / 4;
            obj.output.TotalCoils = Nt;

            % Recalculate active coils
            switch obj.input.EndType
                case 'open'
                    obj.output.ActiveCoils = Nt;
                case 'open_ground'
                    obj.output.ActiveCoils = Nt - 1;
                case {'square', 'square_ground'}
                    obj.output.ActiveCoils = Nt - 2;
            end

            % Solid length
            if strcmp(obj.input.EndType, 'square_ground')
                % Square ground: each end removes about 0.5 coil
                Ls = Nt * d;
            else
                Ls = (Nt + 1) * d;
            end
            obj.output.SolidLength = Ls;

            % Clash allowance
            obj.output.ClashAllowance = obj.input.FreeLength - obj.input.WorkingDeflection - Ls;
        end

        %% Material strength calculation
        function [S_ut, S_us, S_sys, S_fw_prime, S_ew_prime] = calculateMaterialStrength(obj)
            % calculateMaterialStrength - Calculate material strength
            %
            % Returns:
            %   S_ut - Tensile strength (MPa)
            %   S_us - Ultimate shear strength (MPa)
            %   S_sys - Torsional yield strength (MPa)
            %   S_fw_prime - Torsional fatigue strength (MPa)
            %   S_ew_prime - Torsional endurance limit (MPa)

            d = obj.input.WireDiameter;  % mm

            % Material coefficients (Table 14-5)
            matCoeffs = connection.HelicalCompressionSpring.getMaterialCoefficients(obj.params.MaterialGrade);

            % Tensile strength (Formula 14.3)
            S_ut = matCoeffs.A * (d^matCoeffs.b);  % MPa

            % Ultimate shear strength (Formula 14.4)
            S_us = 0.67 * S_ut;  % MPa

            % Torsional yield strength (Table 14-9)
            S_sys = connection.HelicalCompressionSpring.getYieldStrength(obj.params.MaterialGrade, S_ut, obj.params.IsSet);

            % Torsional fatigue strength (Table 14-10)
            S_fw_prime = connection.HelicalCompressionSpring.getFatigueStrength(obj.params.MaterialGrade, S_ut, ...
                                          obj.params.RequiredCycleLife, obj.params.IsShotPeened);

            % Torsional endurance limit (infinite life)
            S_ew_prime = connection.HelicalCompressionSpring.getEnduranceLimit(obj.params.MaterialGrade, S_ut, obj.params.IsShotPeened);
        end

        %% Spring rate and deflection calculation
        function obj = calculateSpringRate(obj)
            % calculateSpringRate - Calculate spring rate and actual deflection

            d = obj.input.WireDiameter;
            D = obj.input.MeanDiameter;
            Na = obj.output.ActiveCoils;
            G = obj.params.ShearModulus;
            F = obj.input.WorkingForce;

            % Spring rate (Formula 14.7)
            k = (d^4 * G) / (8 * D^3 * Na);  % N/mm
            obj.output.SpringRate = k;

            % Actual deflection (Formula 14.6)
            y_actual = (8 * F * D^3 * Na) / (d^4 * G);  % mm
            obj.output.ActualDeflection = y_actual;
        end

        %% Stress calculation
        function obj = calculateStress(obj, S_sys, S_fw_prime, S_ew_prime)
            % calculateStress - Calculate stress and safety factors

            d = obj.input.WireDiameter;
            D = obj.input.MeanDiameter;
            F = obj.input.WorkingForce;
            C = obj.output.SpringIndex;

            % Direct shear factor (Formula 14.8)
            Ks = 1 + 0.5 / C;
            obj.output.DirectShearFactor = Ks;

            % Wahl factor (Formula 14.9a)
            Kw = (4*C - 1) / (4*C - 4) + 0.615 / C;
            obj.output.WahlFactor = Kw;

            % Select stress calculation method based on load type and process
            if strcmp(obj.input.LoadType, 'static')
                if obj.params.IsSet
                    % Static and set: use Ks
                    tau_max = Ks * (8 * F * D) / (pi * d^3);
                else
                    % Static not set: use Kw (conservative)
                    tau_max = Kw * (8 * F * D) / (pi * d^3);
                end
            else  % dynamic
                % Dynamic: use Kw
                tau_max = Kw * (8 * F * D) / (pi * d^3);
            end
            obj.output.MaxShearStress = tau_max;  % MPa

            % Static safety factor
            obj.output.SafetyFactorStatic = S_sys / tau_max;

            % Dynamic fatigue safety factor
            if strcmp(obj.input.LoadType, 'dynamic')
                obj.output.SafetyFactorFatigue = S_fw_prime / tau_max;

                % Estimate fatigue life
                obj.output.FatigueLife = connection.HelicalCompressionSpring.estimateFatigueLife(tau_max, S_fw_prime, S_ew_prime);
            else
                obj.output.FatigueLife = Inf;
                obj.output.SafetyFactorFatigue = [];
            end
        end

        %% Natural frequency and surge check
        function obj = calculateNaturalFrequency(obj)
            % calculateNaturalFrequency - Calculate natural frequency and surge ratio

            if strcmp(obj.input.LoadType, 'static')
                % Skip surge calculation for static load
                obj.output.NaturalFrequency = [];
                obj.output.SurgeRatio = [];
                obj.output.IsSurgeRisk = false;
                return;
            end

            d = obj.input.WireDiameter;  % mm
            D = obj.input.MeanDiameter;  % mm
            Na = obj.output.ActiveCoils;
            G = obj.params.ShearModulus;  % MPa = N/mm^2
            g = 9810;  % mm/s^2

            % Material weight density (steel)
            gamma = 0.000077;  % N/mm^3 (7.7 g/cm^3 * 9.81 / 1000)

            % Effective coils (double for fixed-free)
            if strcmp(obj.input.EndCondition, 'fixed_free')
                Na_effective = 2 * Na;
            else
                Na_effective = Na;
            end

            % Natural frequency (Formula 14.12c)
            fn = (2 / (pi * Na_effective)) * (d / D^2) * sqrt((G * g) / (32 * gamma));  % Hz
            obj.output.NaturalFrequency = fn;

            % Surge ratio
            f_load = obj.input.LoadingFreq;
            surgeRatio = fn / f_load;
            obj.output.SurgeRatio = surgeRatio;

            % Surge risk determination
            obj.output.IsSurgeRisk = surgeRatio < obj.baseline.MinSurgeRatio;
        end

        %% Buckling check
        function obj = checkBuckling(obj)
            % checkBuckling - Check buckling risk

            slendernessRatio = obj.input.FreeLength / obj.input.MeanDiameter;
            obj.output.IsBucklingRisk = slendernessRatio > obj.baseline.MaxSlendernessRatio;
        end

        %% Calculate capacity metrics
        function obj = calculateCapacity(obj)
            % calculateCapacity - Calculate actual capacity metrics

            % Spring index evaluation - use MinSpringIndex as reference
            C = obj.output.SpringIndex;
            obj.capacity.MinSpringIndex = C;  % Actual value
            obj.capacity.MaxSpringIndex = C;  % Actual value

            % Clash allowance percentage
            clashPercent = (obj.output.ClashAllowance / obj.input.WorkingDeflection) * 100;
            obj.capacity.MinClashPercent = clashPercent;  % Actual value

            % Static safety factor ratio
            obj.capacity.MinSafetyFactorStatic = obj.output.SafetyFactorStatic;  % Actual value

            % Fatigue safety factor ratio
            if ~isempty(obj.output.SafetyFactorFatigue)
                obj.capacity.MinSafetyFactorFatigue = obj.output.SafetyFactorFatigue;  % Actual value
            end

            % Surge ratio
            if ~isempty(obj.output.SurgeRatio)
                obj.capacity.MinSurgeRatio = obj.output.SurgeRatio;  % Actual value
            end

            % Slenderness ratio
            slendernessRatio = obj.input.FreeLength / obj.input.MeanDiameter;
            obj.capacity.MaxSlendernessRatio = slendernessRatio;  % Actual value
        end

        %% Print results
        function printResults(obj)
            % printResults - Print design result summary

            fprintf('\n--- Geometric Parameters ---\n');
            fprintf('Spring Index: %.2f\n', obj.output.SpringIndex);
            fprintf('Outer Diameter: %.3f mm\n', obj.output.OuterDiameter);
            fprintf('Inner Diameter: %.3f mm\n', obj.output.InnerDiameter);
            fprintf('Total Coils: %.2f\n', obj.output.TotalCoils);
            fprintf('Active Coils: %.2f\n', obj.output.ActiveCoils);
            fprintf('Solid Length: %.2f mm\n', obj.output.SolidLength);
            fprintf('Clash Allowance: %.2f mm (%.1f%%)\n', ...
                    obj.output.ClashAllowance, obj.capacity.MinClashPercent);

            fprintf('\n--- Spring Rate & Deflection ---\n');
            fprintf('Spring Rate: %.3f N/mm\n', obj.output.SpringRate);
            fprintf('Actual Deflection: %.3f mm\n', obj.output.ActualDeflection);

            fprintf('\n--- Stress Analysis ---\n');
            fprintf('Wahl Factor: %.3f\n', obj.output.WahlFactor);
            fprintf('Direct Shear Factor: %.3f\n', obj.output.DirectShearFactor);
            fprintf('Max Shear Stress: %.2f MPa\n', obj.output.MaxShearStress);

            fprintf('\n--- Safety Factors ---\n');
            fprintf('Static Safety Factor: %.2f (baseline: %.2f)\n', ...
                    obj.output.SafetyFactorStatic, obj.baseline.MinSafetyFactorStatic);

            if strcmp(obj.input.LoadType, 'dynamic')
                fprintf('Fatigue Safety Factor: %.2f (baseline: %.2f)\n', ...
                        obj.output.SafetyFactorFatigue, obj.baseline.MinSafetyFactorFatigue);
                fprintf('Natural Frequency: %.1f Hz\n', obj.output.NaturalFrequency);
                fprintf('Surge Ratio: %.2f (baseline: %.2f)\n', ...
                        obj.output.SurgeRatio, obj.baseline.MinSurgeRatio);
            end

            fprintf('\n--- Risks ---\n');
            fprintf('Buckling Risk: %s\n', string(obj.output.IsBucklingRisk));
            if strcmp(obj.input.LoadType, 'dynamic')
                fprintf('Surge Risk: %s\n', string(obj.output.IsSurgeRisk));
            end

            fprintf('========================================\n\n');
        end

        %% Safety verification
        function checkSafety(obj)
            % checkSafety - Check if safety requirements are met

            % Spring index check
            C = obj.output.SpringIndex;
            if C < obj.baseline.MinSpringIndex
                warning(['HelicalCompressionSpring:SpringIndex', ...
                         'Spring index %.2f less than minimum %.2f, difficult to manufacture'], ...
                         C, obj.baseline.MinSpringIndex);
            end
            if C > obj.baseline.MaxSpringIndex
                warning(['HelicalCompressionSpring:SpringIndex', ...
                         'Spring index %.2f greater than maximum %.2f, prone to buckling'], ...
                         C, obj.baseline.MaxSpringIndex);
            end

            % Clash allowance check
            if obj.capacity.MinClashPercent < obj.baseline.MinClashPercent
                warning(['HelicalCompressionSpring:ClashAllowance', ...
                         'Clash allowance %.1f%% less than required %.1f%%, increase free length'], ...
                         obj.capacity.MinClashPercent, obj.baseline.MinClashPercent);
            end

            % Static safety check
            if obj.capacity.MinSafetyFactorStatic < obj.baseline.MinSafetyFactorStatic
                warning(['HelicalCompressionSpring:StaticSafety', ...
                         'Static safety factor %.2f less than required %.2f, increase wire diameter or reduce load'], ...
                         obj.output.SafetyFactorStatic, obj.baseline.MinSafetyFactorStatic);
            end

            % Fatigue safety check (only for dynamic loads)
            if ~isempty(obj.output.SafetyFactorFatigue)
                if obj.capacity.MinSafetyFactorFatigue < obj.baseline.MinSafetyFactorFatigue
                    warning(['HelicalCompressionSpring:FatigueSafety', ...
                             'Fatigue safety factor %.2f less than required %.2f, adjust design or use shot peening'], ...
                             obj.output.SafetyFactorFatigue, obj.baseline.MinSafetyFactorFatigue);
                end
            end

            % Surge check
            if obj.output.IsSurgeRisk
                warning(['HelicalCompressionSpring:Surge', ...
                         'Surge ratio %.2f less than required %.2f, resonance risk'], ...
                         obj.output.SurgeRatio, obj.baseline.MinSurgeRatio);
            end

            % Buckling check
            if obj.output.IsBucklingRisk
                warning(['HelicalCompressionSpring:Buckling', ...
                         'Slenderness ratio %.2f greater than limit %.2f, buckling risk, use guide device'], ...
                         obj.input.FreeLength / obj.input.MeanDiameter, obj.baseline.MaxSlendernessRatio);
            end
        end
    end

    methods (Static)
        %% Get material coefficients (Table 14-5)
        function coeffs = getMaterialCoefficients(materialGrade)
            % getMaterialCoefficients - Return material strength calculation coefficients
            %
            % S_ut = A * d^b  (d unit: mm, S_ut unit: MPa)

            coeffs.A = [];
            coeffs.b = [];

            switch materialGrade
                case 'A227'  % Cold-drawn wire
                    coeffs.A = 1783;
                    coeffs.b = -0.1905;
                case 'A228'  % Music wire
                    coeffs.A = 2170;
                    coeffs.b = -0.162;
                case 'A229'  % Oil-tempered wire
                    coeffs.A = 1789;
                    coeffs.b = -0.2014;
                case 'A232'  % Chrome-vanadium steel
                    coeffs.A = 1892;
                    coeffs.b = -0.167;
                case 'A401'  % Chrome-silicon steel
                    coeffs.A = 2059;
                    coeffs.b = -0.162;
                case 'StainlessA313'
                    coeffs.A = 1690;
                    coeffs.b = -0.186;
                case 'Brass'
                    coeffs.A = 1000;
                    coeffs.b = -0.15;
                case 'Bronze'
                    coeffs.A = 1100;
                    coeffs.b = -0.15;
                otherwise
                    error('Unknown material grade: %s', materialGrade);
            end
        end

        %% Get yield strength (Table 14-9)
        function S_sys = getYieldStrength(materialGrade, S_ut, isSet)
            % getYieldStrength - Return torsional yield strength
            %
            % S_sys is a percentage of S_ut

            % Cold-drawn carbon steel
            if any(strcmp(materialGrade, {'A227', 'A228'}))
                if isSet
                    S_sys = 0.70 * S_ut;  % After set: 60-70%
                else
                    S_sys = 0.45 * S_ut;  % Not set: 45%
                end
            % Quenched and tempered carbon/low alloy steel
            elseif any(strcmp(materialGrade, {'A229', 'A232', 'A401'}))
                if isSet
                    S_sys = 0.75 * S_ut;  % After set: 65-75%
                else
                    S_sys = 0.50 * S_ut;  % Not set: 50%
                end
            % Austenitic stainless steel / Non-ferrous alloys
            else
                if isSet
                    S_sys = 0.65 * S_ut;  % After set: 55-65%
                else
                    S_sys = 0.35 * S_ut;  % Not set: 35%
                end
            end
        end

        %% Get fatigue strength (Table 14-10)
        function S_fw_prime = getFatigueStrength(~, S_ut, cycleLife, isShotPeened)
            % getFatigueStrength - Return torsional fatigue strength
            %
            % S_fw_prime is a percentage of S_ut

            % Default use A228 music wire data
            if isShotPeened
                switch cycleLife
                    case 1e5
                        percent = 0.42;
                    case 1e6
                        percent = 0.39;
                    case 1e7
                        percent = 0.36;
                    case Inf
                        percent = 0.36;  % Close to endurance limit
                    otherwise
                        % Linear interpolation
                        percent = 0.36;  % Conservative estimate
                end
            else
                switch cycleLife
                    case 1e5
                        percent = 0.36;
                    case 1e6
                        percent = 0.33;
                    case 1e7
                        percent = 0.30;
                    case Inf
                        percent = 0.30;
                    otherwise
                        percent = 0.30;
                end
            end

            S_fw_prime = percent * S_ut;
        end

        %% Get endurance limit
        function S_ew_prime = getEnduranceLimit(~, ~, isShotPeened)
            % getEnduranceLimit - Return torsional endurance limit
            %
            % For spring wire with diameter d < 10mm
            % Not shot peened ~ 45 kpsi (310 MPa)

            if isShotPeened
                S_ew_prime = 350;  % MPa, after shot peening
            else
                S_ew_prime = 310;  % MPa
            end
        end

        %% Estimate fatigue life
        function life = estimateFatigueLife(tau_max, S_fw_prime, S_ew_prime)
            % estimateFatigueLife - Estimate fatigue life
            %
            % Simplified S-N curve estimation

            % 10^3 cycles
            S_ms = 0.9 * 0.67 * S_fw_prime;

            % 10^7 cycles and above
            S_ew = S_ew_prime;

            % Linear log interpolation
            if tau_max >= S_ms
                life = 1e3;
            elseif tau_max <= S_ew
                life = Inf;
            else
                % log(N) = log(1e3) + (log(1e7)-log(1e3)) * (S_ms - tau_max)/(S_ms - S_ew)
                life = 10^(3 + 4 * (S_ms - tau_max)/(S_ms - S_ew));
            end
        end

        %% Get material library
        function matLib = getMaterialLibrary()
            % getMaterialLibrary - Get predefined material parameter library

            matLib = struct();

            % A228 music wire
            matLib.A228.Grade = 'A228';
            matLib.A228.ShearModulus = 79300;  % MPa
            matLib.A228.Name = 'Music Wire';

            % A232 chrome-vanadium steel
            matLib.A232.Grade = 'A232';
            matLib.A232.ShearModulus = 79300;  % MPa
            matLib.A232.Name = 'Chrome-Vanadium Steel';

            % A401 chrome-silicon steel
            matLib.A401.Grade = 'A401';
            matLib.A401.ShearModulus = 79300;  % MPa
            matLib.A401.Name = 'Chrome-Silicon Steel';

            % A313 stainless steel
            matLib.StainlessA313.Grade = 'StainlessA313';
            matLib.StainlessA313.ShearModulus = 69000;  % MPa
            matLib.StainlessA313.Name = 'Stainless Steel Type 302';
        end
    end
end

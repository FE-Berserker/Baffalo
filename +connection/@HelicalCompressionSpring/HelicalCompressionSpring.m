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
            'SafetyFactorStatic'  % Static safety factor
            'SafetyFactorFatigue' % Fatigue safety factor
            'S_ut'              % (MPa) Tensile strength
            'S_us'              % (MPa) Ultimate shear strength
            'S_sys'             % (MPa) Torsional yield strength
            'S_fw_prime'        % (MPa) Torsional fatigue SN curve
            'S_ew_prime'        % (MPa) Torsional endurance limit
            'yintial' % Intial deflection
            'BucklingEndType'   % Buckling end type description
            'Mass'              % (kg) Spring mass

            };

        % Parameter fields: material and configuration
        paramsExpectedFields = {
            'IsSet'             % Is set (pre-set) process
            'IsShotPeened'      % Is shot peened
            'AllowableStress'   % (MPa) Allowable stress (optional)
            'Cycles' % Cycle
            'Echo'              % Print calculation progress
            'Material' % Material property (full struct from RMaterial)
            'g' % Gravity
            'R' % Stress ratio
            };

        % Baseline fields: safety requirements
        baselineExpectedFields = {
            'MinSpringIndex'     % Minimum spring index
            'MaxSpringIndex'     % Maximum spring index
            'MinClashPercent'    % Minimum clash allowance percentage 10%
            'MinSafetyFactorStatic'   % Minimum static safety factor
            'MinSafetyFactorFatigue'  % Minimum fatigue safety factor
            'MinSurgeRatio'      % Minimum surge ratio
            };

        %% Default Parameter Values

        % Material defaults (A228 music wire - row 2)
        default_IsSet = false;
        default_IsShotPeened = false;
        default_AllowableStress = [];      % Auto-calculate
        default_Cycles = 1e7;    % cycles
        default_Echo = true;
        default_g=9.81; %m/s^2
        default_Material=[];      % Full material struct from RMaterial
        default_R=0;

        %% Baseline Default Values

        base_MinSpringIndex = 4;          % Engineering criteria: C >= 4
        base_MaxSpringIndex = 12;         % Engineering criteria: C <= 12
        base_MinClashPercent = 10;        % Clash allowance 10-15%
        base_MinSafetyFactorStatic = 1.0;  % Default safety factor
        base_MinSafetyFactorFatigue = 1.0; % Default fatigue safety factor
        base_MinSurgeRatio = 13;          % Natural frequency > 13x load frequency

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
            obj.documentname = 'HelicalCompressionSpring.md';
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

            % Material selection:
            % If Material is provided, use it
            % Otherwise, use default A227 music wire (row 2)
            if isempty(obj.params.Material)
                S=RMaterial('Spring');
                mat=GetMat(S,1);  % A227 music wire
                obj.params.Material=mat{1,1};
            end
            Mat=obj.params.Material;

            if obj.params.R>0
                obj.params.IsSet=1;
            end


            % Print information
            if obj.params.Echo
                fprintf('\n========================================\n');
                fprintf('Helical Compression Spring Design\n');
                fprintf('========================================\n\n');
                fprintf('Material name: %s\n', Mat.Name);
                fprintf('Wire Diameter: %.3f mm\n', obj.input.WireDiameter);
                fprintf('Mean Diameter: %.3f mm\n', obj.input.MeanDiameter);
                fprintf('Free Length: %.2f mm\n', obj.input.FreeLength);
                fprintf('Working Force: %.1f N\n', obj.input.WorkingForce);
                fprintf('Load Type: %s\n', obj.input.LoadType);
            end

            % 2. Calculate geometric parameters
            obj = calculateGeometry(obj);

            % 3. Calculate material strength
            [S_ut, S_us, S_sys, S_fw_prime, S_ew_prime] = calculateMaterialStrength(obj);

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

            % Parse - Store material strength values in output
            obj.output.S_ut = S_ut;
            obj.output.S_us = S_us;
            obj.output.S_sys = S_sys;
            obj.output.S_fw_prime = S_fw_prime;
            obj.output.S_ew_prime = S_ew_prime;
        end
    end


end

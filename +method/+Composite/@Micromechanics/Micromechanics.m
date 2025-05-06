classdef Micromechanics < Component
    % Micromechanics of Composite Material
    % Author: Yu Xie

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Micromechanics
            'Theory'% 'Voigt' 'Reuss' 'MT' 'MOC' 'MOCu' 'GMC' 'HFGMC' 'All'
            'Echo' % Print
            'RUCid'% Repating unit cell geometry id
            'Criterion'% Failure criterion
            'Damage'% Apply micro progressive damage simulation
            'DamageFactor'  % Stiffness reduction factor for damaged material
            };

        inputExpectedFields = {
            'Fiber' % Fiber Material
            'Matrix' % Matrix Material
            'Interface' % Interface Material
            'Vf' % Volume ratio
            'Vi' % Interface ratio
            'Load' % Load for micromechanics
            };

        outputExpectedFields = {
            'Plyprops' % Ply properties
             % 'Plystrength' % Ply strength
            'SG'% Vector of stress component
            'MicroField'% Micro field
            'DamageResult'% Micro progressive Damage results
            };

        baselineExpectedFields = {}

        default_Name='Micromechanics_1'
        default_Theoty= 'Voigt'
        default_Echo=1
        default_RUCid=26
        default_Criterion=1
        default_Damage=0
        default_DamageFactor=0.0001
    end

    methods

        function obj = Micromechanics(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Composite_Micromechanics.pdf';
        end

        function obj = solve(obj)
            %calculate outputs
            Constits.Fiber=obj.input.Fiber;
            Constits.Matrix=obj.input.Matrix;
            Constits.Interface=obj.input.Interface;

            E = 1;  % -- Applied loading type identifier (strains)
            S = 2;  % -- Applied loading type identifier (stresses)
            Load=obj.input.Load;
            Load.E = E;
            Load.S = S;

            if obj.params.Theory=="All"
                Theory='Voigt';
                [plyprops{1,1}]=RunMicro(Theory,...
                    obj.params.Name,...
                    obj.input.Vf,...
                    Constits);
                Theory='Reuss';
                [plyprops{2,1}]=RunMicro(Theory,...
                    obj.params.Name,...
                    obj.input.Vf,...
                    Constits);
                Theory='MT';
                [plyprops{3,1}]=RunMicro(Theory,...
                    obj.params.Name,...
                    obj.input.Vf,...
                    Constits);
                Theory='MOC';
                [plyprops{4,1}]=RunMicro(Theory,...
                    obj.params.Name,...
                    obj.input.Vf,...
                    Constits);
                Theory='MOCu';
                [plyprops{5,1}]=RunMicro(Theory,...
                    obj.params.Name,...
                    obj.input.Vf,...
                    Constits);
            elseif obj.params.Theory=="GMC"
                if isempty(obj.input.Vi)
                    Vi=0;
                else
                    Vi=obj.input.Vi;
                end
                [plyprops]=RunMicro(obj.params.Theory,...
                    obj.params.Name,...
                    struct('Vf',obj.input.Vf,'Vi',Vi),...
                    Constits,obj.params.RUCid);
                % Solve loading and calculate local fields for micromechanics
                if ~isempty(obj.input.Load)
                end

            elseif obj.params.Theory=="HFGMC"
                if isempty(obj.input.Vi)
                    Vi=0;
                else
                    Vi=obj.input.Vi;
                end
                [plyprops]=RunMicro(obj.params.Theory,...
                    obj.params.Name,...
                    struct('Vf',obj.input.Vf,'Vi',Vi),...
                    Constits,obj.params.RUCid);
                              
            else
                [plyprops]=RunMicro(obj.params.Theory,...
                    obj.params.Name,...
                    obj.input.Vf,...
                    Constits);
            end

            obj.output.Plyprops=plyprops;
            %% Print
            if obj.params.Echo
                fprintf('Successfully calculate the properties .\n');
            end

            if ~isempty(obj.input.Load)
                % Solve loading and calculate local fields for micromechanics
                [SG, FullGlobalStrain] = SolveLoading(6, plyprops.Cstar,[0;0;0;0;0;0], Load);
                % Calculate micro scale (constituent level) fields
                [Results] = MicroFields(FullGlobalStrain, 0, plyprops);

                obj.output.SG=SG;
                obj.output.MicroField=Results;
                %% Print
                if obj.params.Echo
                    fprintf('Successfully calculate the micro field .\n');
                end
            end

            if obj.params.Damage==1
                % Start micro progressive damage analysis
                obj = RunMicroDamage(obj);
            end

        end
    end
end
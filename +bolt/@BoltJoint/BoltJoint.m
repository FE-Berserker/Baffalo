classdef BoltJoint < Component
    % BoltJoint
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the Bolt
            'Echo' % Print
            'JointType' % SV1~SV6
            'MuT' % Frictional coefficient of parts
            'qF'
            'ConShear' % Consider FQ in SF calculation
            };

        inputExpectedFields = {
            'Bolt' % Class bolt  
            'Clamping' % [Height,Materialno]
            'DA' % Exernal diameter
            'DA1' % Outsize diameter (Supporting effect of the envoronment)
            'lA' % Length of connected solid
            'ak' % Distance of connected solid
            'FAmax' % Axial force
            'FAmin' % Axial forcce
            'FQ' % Shearing force
            'MT' % Torsional force
            'ra' % Frictional radius
            'Nz' % cyclic times
            'n'
            };

        outputExpectedFields = {
            'deltap'
            'deltapzu'
            'deltas'
            'n'
            'Phin'
            };

        baselineExpectedFields = {
            'SF' % Yield failure
            'SD' % Fatigue failure
            'SG' % Slide failure
            'SA' % Shearing failure
            };
        default_Name='BoltJoint1';
        default_Material=[];
        default_Echo=1
        default_JointType='SV1'
        default_MuT=0.15
        default_qF=1;
        default_ConShear=0;
        base_SF=1;
        base_SD=1;
        base_SG=1.2;
        base_SA=1.1;
    end
    methods

        function obj = BoltJoint(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='BoltJoint.pdf';
        end

        function obj = solve(obj)
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat;
            end

            if isempty(obj.input.Nz)
                obj.input.Nz=2e6;
            end


            if isempty(obj.input.FQ)
                obj.input.FQ=0;
            end

            if ~isempty(obj.input.MT)
                if isempty(obj.input.ra)
                    error('Please input the frictional radius!')
                end
            else
                obj.input.MT=0;
            end

            % Check input
            lk=obj.input.Bolt.input.lk;
            if lk~=sum(obj.input.Clamping(:,1))
                error('Clamping thickness is not equal to bolt lk !')
            end
            % Calculate clamping compliance
            obj=CalCompliance(obj);
            obj=Caln(obj);
            obj=CalPhi(obj);
            obj=CalSafety(obj);

        end


    end
end


classdef FlangeBolt < Component
    % FlangeBolt
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the Bolt
            'Echo' % Print
            'FlangeType' % Type=1 ring
            'MuT' % Frictional coefficient of parts
            'ConShear' % Consider FQ in SF calculation
            };

        inputExpectedFields = {
            'Bolt' % Class bolt  
            'Clamping' % [Height,Materialno]
            'FQ' % Shearing force
            'Nz' % cyclic times
            'FAmax' % Axial force [N]
            'FAmin' % Axial forcce [N]
            'MT' % Torsional moment [Nmm]
            'nB' % Bolt Number
            'Geom' % Type=1 [dt,da,di]
            };

        outputExpectedFields = {
            'deltap'
            'deltapzu'
            'deltas'
            'n'
            'Phin'
            };

        baselineExpectedFields = {
            'SF'
            'SD'
            'SG'
            'SA'
            };
        default_Name='FlangeBolt_1';
        default_Material=[];
        default_Echo=1
        default_FlangeType=1
        default_MuT=0.15
        default_ConShear=0;
        base_SF=1;
        base_SD=1;
        base_SG=1.2;
        base_SA=1.1;
    end
    methods

        function obj = FlangeBolt(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='FlangeBolt.pdf';
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

            if ~isempty(obj.input.FQ)
                FQ=obj.input.FQ;
            else
                FQ=0;
            end

            % Check input
            lk=obj.input.Bolt.input.lk;
            if lk~=sum(obj.input.Clamping(:,1))
                error('Clamping thickness is not equal to bolt lk !')
            end
            % Calculate input
            if ~isempty(obj.input.MT)
                MT=obj.input.MT;
            else
                MT=0;
            end

            if ~isempty(obj.input.nB)
                nB=obj.input.nB;
            else
                error('Please input the number of bolt !')
            end

            Bolt=obj.input.Bolt;
            dh=Bolt.input.dh;

            switch obj.params.FlangeType
                case 1
                    Geom=obj.input.Geom;
                    dt=Geom(1);
                    da=Geom(2);
                    di=Geom(3);
                    FQ=2*MT/nB/dt+FQ/nB;
                    DA=((da-di)/2+2*dt/nB*pi-dh)/2;
                    DA1=DA;
                case 2
            end


            inputStruct.Bolt=Bolt;
            inputStruct.DA=DA;
            inputStruct.DA1=DA1;
            inputStruct.FAmax=obj.input.FAmax/nB;
            inputStruct.FAmin=obj.input.FAmin/nB;
            inputStruct.FQ=FQ;
            inputStruct.Nz=obj.input.Nz;
            inputStruct.Clamping=obj.input.Clamping;
            inputStruct.n=1;
            paramsStruct.Material=obj.params.Material;
            paramsStruct.ConShear=obj.params.ConShear;
            paramsStruct.Echo=obj.params.Echo;
            paramsStruct.MuT=obj.params.MuT;
            baselineStruct.SF=obj.baseline.SF;
            baselineStruct.SD=obj.baseline.SD;
            baselineStruct.SG=obj.baseline.SG;
            baselineStruct.SA=obj.baseline.SA;
            BoltJoint=bolt.BoltJoint(paramsStruct, inputStruct,baselineStruct);
            BoltJoint= BoltJoint.solve();

            % Parse output
            obj.output.deltap=BoltJoint.output.deltap;
            obj.output.deltapzu=BoltJoint.output.deltapzu;
            obj.output.deltas=BoltJoint.output.deltas;
            obj.output.n=BoltJoint.output.n;
            obj.output.Phin=BoltJoint.output.Phin;

            % Parse capacity
            obj.capacity.SF=BoltJoint.capacity.SF;
            obj.capacity.SD=BoltJoint.capacity.SD;
            obj.capacity.SG=BoltJoint.capacity.SG;
            obj.capacity.SA=BoltJoint.capacity.SA;
        end


    end
end


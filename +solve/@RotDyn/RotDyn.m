classdef RotDyn < Component
    % Class RotDyn
    % Single shaft rotor dynamic analysis
    % Author: Xie Yu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Default is steel
            'Damping'
            'Name' % Name
            'Modopt'% Modal analysis option
            'HRopt'% Harmonic analysis option
            'NStep'
            'NMode'% Number of modes
            'Freq'
            'Coriolis'
            'PrintCampbell'
            'PrintMode'
            'Position'
            'ShaftTorsion' % Consider Shaft torsional
            'PStress' % Consider pre stress
            'ey' % Eccentricity [mm]
            'ez' % Eccentricity [mm]
            'Type' % Solution Type  Type=2：Modal analysis Type=3: Harmonic analysis 
            % Type=4 : Stationary solution (Time integration with constant rotation speed)
            % Type=5 : Speedup solution (Time integration with speed range)
      
            'Solver' % Solver='ANSYS' RotDyn will use ANSYS to simulate Solver='Local' RotDyn will use AMRotor solver to simulate
            'Rayleigh'% Rayleigh damping
            'FRFType'
            'StationaryType'% 'ode15s'
            'Echo'
            };

        inputExpectedFields = {
            'Shaft'
            'MaterialNum'
            'Speed' % RPM
            'SpeedRange' %RPM range (Type=5)
            'Discs' % NodeNum, Outer diameter, Inner diameter,Length, Material Num
            'Springs' % Node number, Kxx, Kyy
            'PointMass' % Node number, m, JT, JD
            'BCNode'% boundry conditions
            % Node
            % number,ux,uy,uz,rotx,roty,rotz,cux,cuy,cuz,crotx,croty,crotz
            'Bearing'% Bearing connected to ground
            % Node number,kx,K11,K22,K12,K21,Cx,C11,C22,C12,C21
            'TorBearing'
            % Node number,krot,Crot
            'Table'
            'LUTBearing'
            % Node number,Table no
            'KeyNode' % Node Number
            'UnBalanceForce' % UnbalanceForce
            % Node number, me
            'BalanceQuality'
            % G,n,positionA,positionB,Type
            % Type=0 in the same parse Type=1 reverse parse
            'InNode' % NodeNum
            'OutNode' % NodeNum
            'TimeSeries' % NodeNum, TimeSeries
            'PIDController'% PID controller
            };

        outputExpectedFields = {
            'Assembly'
            'RotorSystem'
            'Campbell'
            'Shape'
            'CriticalSpeed'
            'TotalNode'
            'TotalElement'
            'SpeedUp'
            'Mass' % Total mass of shaft
            'Xc' % center of the shaft in the x direction
            'FRFResult' % FRF result
            'ModeResult'% Modal result
            'eigenVectors'
            'eigenValues'
            'EWf'
            'EWb'
            'Time'
            'TimeSeriesResult'
            };

        baselineExpectedFields = {
            };

        default_Name='RotDyn1';
        default_Material=[];
        default_Damping=[];
        default_Modopt='QRDAMP'
        default_HRopt="FULL"
        default_NMode=12
        default_Freq=[0,2000]
        default_Coriolis=1;
        default_PrintCampbell=1;
        default_PrintMode=1;
        default_Position=[0,0,0,0,0,0];
        default_AccNode=[];
        default_AccElement=[];
        default_ShaftTorsion=0;
        default_Echo=1;
        default_PStress=0;
        default_ey=[0,0];
        default_ez=[0,0];
        default_G=0;
        default_Type=2;
        default_NStep=400;
        default_Solver='ANSYS' % Local
        default_Rayleigh=[];
        default_FRFType='d'% displacement 'd', velocity 'v',accleration 'a'
        default_StationaryType='ode15s'

    end
    methods

        function obj = RotDyn(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            if isempty(obj.input.MaterialNum)
                Num=size(obj.input.Shaft,1);
                obj.input.MaterialNum=ones(Num,1);
            end

            if isempty(obj.params.Position)
                Num=size(obj.input.Shaft,1);
                Temp=[0,0,0,0,0,0];
                obj.params.Position=repmat(Temp,Num,1);
            end

            if ~isempty(obj.params.Rayleigh)
                if size(obj.params.Rayleigh,2)~=2
                    error('Please input rayleigh damping parameter alpha and beta !')
                end
            end

            obj.documentname='RotDyn.pdf';

            Num=size(obj.input.Shaft.Meshoutput.nodes,1);
            obj.output.TotalNode=Num;

            Num=size(obj.input.Shaft.Meshoutput.elements,1);
            obj.output.TotalElement=Num;
            obj=CalculateShape(obj);
        end

        function obj = solve(obj)
            % Calculate Mass
            obj=CalculateMass(obj);
            % Calculate balance quality
            if ~isempty(obj.input.BalanceQuality)
                obj=CalculateBalanceQuality(obj);
            end

            obj=GenerateKeyNode(obj);

            switch obj.params.Type
                case 1
                    obj.output.FRFResult=[];
                    obj=OutputAMrotorSystem(obj);
                    obj=CalculateFRF(obj);
                case 2
                    obj.output.Campbell=[];
                    if obj.params.Solver=="ANSYS"
                        obj=OutputAss(obj);
                        if size(obj.input.Speed,2)>1
                            ANSYS_Output(obj.output.Assembly,'MultiSolve',1,'Warning',0)
                        else
                            ANSYS_Output(obj.output.Assembly,'MultiSolve',0,'Warning',0)
                        end
                    else
                        obj=OutputAMrotorSystem(obj);
                        if size(obj.input.Speed,2)>1
                            obj=CalculateCampbell(obj);
                        else
                            obj=CalculateModal(obj);
                        end
                    end
                case 3
                    obj=OutputAss(obj);
                    if size(obj.input.Speed,2)>1
                        ANSYS_Output(obj.output.Assembly,'MultiSolve',1)
                    else
                        ANSYS_Output(obj.output.Assembly,'MultiSolve',0)
                    end
                case 4        
                    if isempty(obj.input.TimeSeries)
                        error('Please input Time series !')
                    else
                        obj.output.Time=obj.input.TimeSeries{1,1}.Time;
                    end

                    if isempty(obj.input.Speed)
                        obj.input.Speed=0;
                    end
                    obj=OutputAMrotorSystem(obj);
                    switch obj.params.StationaryType
                        case 'ode15s'
                            obj=compute_ode15s_ss(obj);
                    end
                case 5
                    if isempty(obj.input.SpeedRange)
                        error('Please input Speed range !')
                    end
                    if isempty(obj.input.TimeSeries)
                        error('Please input Time series !')
                    else
                        obj.output.Time=obj.input.TimeSeries{1,1}.Time;
                    end
                    obj=OutputAMrotorSystem(obj);
                    switch obj.params.StationaryType
                        case 'ode15s'
                            obj=compute_ode15s_ss_1(obj);
                    end
                case 6


            end
        end

    end
end


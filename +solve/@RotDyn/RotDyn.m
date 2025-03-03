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
            'PrintORB'
            'Position'  
            'ShaftTorsion' % Consider Shaft torsional
            'PStress' % Consider pre stress
            'ey' % Eccentricity [mm]
            'ez' % Eccentricity [mm]
            'Type' % Solution Type  Type=2：Modal analysis Type=3: Harmonic analysis
            'Echo'
            };

        inputExpectedFields = {     
            'Shaft'
            'MaterialNum'
            'Speed' % RPM
            'Discs' % NodeNum, Outer diameter, Inner diameter,Length, Material Num
            'Springs' % Node number, Kxx, Kyy
            'PointMass' % Node number, m, JT, JD
            'BCNode'% boundry conditions
            'Support'% Spring connected to ground
            % Node number,kx,K11,K22,K12,K21,Cx,C11,C22,C12,C21
            'KeyNode' % Node Number
            'UnBalanceForce' % UnbalanceForce
            % Node number, me
            'UnBalance'
            % UnBalance=[node1 m1 uy1 uz1 ; node2 m2 uy2 uz2; ... nodeQ mQ uxQ uyQ]   node=1,2, .. 
            'BalanceQuality'
            % G,n,positionA,positionB
            };

        outputExpectedFields = {
            'Assembly'
            'Campbell'
            'Shape'
            'CriticalSpeed'
            'TotalNode'
            'TotalElement'
            'SpeedUp'
            'Mass' % Total mass of shaft
            'Xc' % center of the shaft in the x direction
            };

        baselineExpectedFields = {
            };

        statesExpectedFields = {};
        default_Name='RotDyn1';
        default_Material=[];
        default_Damping=[];
        default_Modopt='QRDAMP'
        default_HRopt="FULL"
        default_NMode=12
        default_Freq=[0,2000]
        default_Coriolis=1;
        default_PrintCampbell=0;
        default_PrintORB=0;
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

            obj=GenerateKeyNode(obj);
            obj=OutputAss(obj);
            if size(obj.input.Speed,2)>1
                ANSYS_Output(obj.output.Assembly,'MultiSolve',1)
            else
                ANSYS_Output(obj.output.Assembly,'MultiSolve',0)
            end
        end

    end
end


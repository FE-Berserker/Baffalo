classdef Bolt < Component
    % Bolt
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the Bolt
            'Order' % Element order
            'Type' % Type=1 Add max preload in Assembly Type=2 Add min preload in Assembly
            'Echo' % Print
            'WasherType' % 1.Type =1 DIN 7089
            'NutType' % Type=1 ISO 4032
            'ThreadType' % Thread Pitch Type=1 standard thread Type=2 fine therad
            'BoltType' % Type=0 User defined Type=1 ISO 4762 Type=2 ISO 4014 Type=3 ISO 4017
            'v' % Utilization of yield strength
            'MuG' % Coefficient of friction in thread
            'MuK' % Coefficient of friction at head support
            'alpha' % Flank angle
            'alphaA' % Tightening factor
            'Strength'
            'Washer'% 1. With washer 0. Without washer
            'Nut'% 1. With nut 0. Without nut
            'NutWasher'% 1. With Nut washer 0. without Nut washer
            'NutWasherType' % 1.Type =1 DIN 7089

            };

        inputExpectedFields = {
            'd' % Bolt size d [mm]
            'l' % Total length of the bolt (without head)
            'lk' % Clamping length [mm]
            'dh' % The hole diameter
            'dha' % The chamfer diameter at the clamped components
            'd0' % Hollow bolt inner diameter [mm]
            };

        outputExpectedFields = {
            'l1' % Length of the part without thread
            'K' % Bolt head height
            'sw' % Width across flats at the head
            'di' % Shank diameter [mm]
            'P' % Thread Pitch [mm]
            'd1' % Minor diameter of external thread [mm]
            'd2' % Pitch diameter [mm]
            'd3' % Minor diameter [mm]
            'H' % Height of the fundamental thread triangle [mm]
            'ds' % Stress section diameter [mm]
            'dw' % Outer head friction diameter [mm]
            'da' % Inner head friction diameter [mm]
            'Dkm' % Effective bearing diameter [mm]
            'As' % Stressed cross section of screw [mm2]
            'SigmaM' % Tensile stress in the bolt as a result of FM [MPa]
            'FMmax' % Maximum assembly preload [N]
            'FMmin' % Maximum assembly preload [N]
            'MG' % Thread torque [Nmm]
            'MK' % Head torque [Nmm]
            'MA' % Tightening torque [Nmm]
            'Fhmax' % Max allowable Tension force (Strecher) [N]
            'Fh' % Tension force (Strecher) [N]
            'Surface'% Section surface of bolt
            'lk' % Clamping length [mm] should consider washer thickness
            'Washer_d1'
            'Washer_d2'
            'Washer_h'
            'deltaM'
            'deltas'
            'Nut_s'
            'Nut_m'
            'Nut_sw'
            'NutWasher_d1'
            'NutWasher_d2'
            'NutWasher_h'
            'Rp'
            'Rm'
            'TauB'
            'Assembly' % Assembly of solidmesh bolt
            };

       baselineExpectedFields = {};
        default_Name='Bolt1';
        default_Material=[];
        default_Order=1
        default_Type=1
        default_Echo=1
        default_WasherType=1;
        default_NutWasherType=1;
        default_NutType=1;
        default_ThreadType=1;
        default_v=0.9
        default_BoltType=1
        default_MuG=0.12;
        default_MuK=0.12;
        default_Strength="10.9"
        default_alpha=60;
        default_alphaA=1.6
        default_Washer=1
        default_Nut=0
        default_NutWasher=0
    end
    methods

        function obj = Bolt(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Bolt.pdf';
        end

        function obj = solve(obj)
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,[1;1;1]);% Mat1: Bolt Mat2: Washer Mat3: Nut
                mat{1, 1}.E=205000;
                mat{2, 1}.E=205000;
                mat{3, 1}.E=205000;
                obj.params.Material=mat;
            end

            if isempty(obj.input.dh)
                obj.input.dh=0;
            end

            if isempty(obj.input.dha)
                obj.input.dha=obj.input.dh;
            end

            if isempty(obj.input.d0)
                obj.input.d0=0;
            end

            % Calculate outputs
            obj=CalOutput(obj);
            obj=CalCompliance(obj);
            obj=CalSurface(obj);
            obj=OutputAss(obj);

        end

        function Plot2D(obj)
            Plot(obj.output.Surface,'View',[0,90]);
        end

    end
end


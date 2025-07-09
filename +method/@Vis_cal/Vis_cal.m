classdef Vis_cal < Component
    % 润滑油粘度计算
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Echo' % Print
            'Material'
            
            };
        
        inputExpectedFields = {
            'T' % 输入温度 [℃]
            };
        
        outputExpectedFields = {
            'A' % 参数A according to ISO\TR 6336-22
            'B' % 参数B according to ISO\TR 6336-22
            'Vis1' % 该温度下的运动粘度 [mm2/s]
            'Vis2' % 该温度下的动力粘度 [Ns/mm2]
            'Rou' % 该温度下润滑油的密度 [g/cm3]

            };
        
        baselineExpectedFields = {};

        default_Echo=1
        default_Material=[]

        
    end
    methods
        
        function obj = Vis_cal(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Vis_cal.pdf';
        end
        
        function obj = solve(obj)
            % Check input
            if isempty(obj.params.Material)
                error('Please set material !')
            end

            if isempty(obj.input.T)
                error('Please input temperature !')
            end
            A=cal_A(obj);
            B=cal_B(obj);
            obj.output.A=A;
            obj.output.B=B;
            Temp1=A*log10(obj.input.T+273)+B;
            obj.output.Vis1=10^(10^(Temp1))-0.7;
            obj=cal_Rou(obj);
            obj.output.Vis2=obj.output.Vis1*obj.output.Rou;

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate viscosity ! .\n');
            end
        end

        function value=cal_A(obj)
            Mat=obj.params.Material;
            value=log10(log10(Mat.v40+0.7)/log10(Mat.v100+0.7))/log10(313/373);
        end

        function value=cal_B(obj)
            A=cal_A(obj);
            Mat=obj.params.Material;
            value=log10(log10(Mat.v40+0.7))-A*log10(313);

        end

        function obj=cal_Rou(obj)
            Mat=obj.params.Material;
            if isempty(Mat.Dens)
                Rou15=(43.37*log10(Mat.v40)+805.5)/1e3;
            else
                Rou15=Mat.Dens;
            end
            obj.output.Rou=Rou15*(1-1/15*((obj.input.T+273)-288)/1e3/Rou15);
        end
  
    end
end
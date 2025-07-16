classdef STransform < Component
    % STransform.m
    % Author: Yu Xie, Aug 2023
       
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            };
        
        inputExpectedFields = {
            'Theta'% 复合材料夹角
            'Sigma'% sigma_x;sigma_y;sigma_z;tau_yz;tau_zx;tau_xy
            };
        
        outputExpectedFields = {
            'Ts'% Stress transform matrix
            'Tans_S'% Transformed Stress
            };
        
        baselineExpectedFields = {};
        
    end
    
    methods
        
        function obj = STransform(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end
        
        function obj = solve(obj)
            %calculate outputs
            Ts=cal_Ts(obj);
            obj.output.Tans_S=Ts*obj.input.Sigma;
            obj.output.Ts=Ts;
            
        end
        
        function Ts=cal_Ts(obj)
            %函数功能：用于求解叠层结构三维应力转换矩阵。
            %调用格式：ThreeDimensionalStressTransformation(theta)。
            %输入参数：偏轴角度θ，单位为度，注意角度正负取值问题。
            %运行结果：6×6应力转换矩阵。
            m=cosd(obj.input.Theta);
            n=sind(obj.input.Theta);
            Ts=[m^2,n^2,0,0,0,2*m*n;
                n^2,m^2,0,0,0,-2*m*n;
                0,0,1,0,0,0;
                0,0,0,m,-n,0;
                0,0,0,n,m,0;
                -m*n,m*n,0,0,0,m^2-n^2];
        end
        
    end
end
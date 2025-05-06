classdef ETransform < cComponent
    %% ETransform.m
    % Author: Yu Xie, Aug 2023
    
    properties
        %other cComponentTemplate specific properties...
    end
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            };
        
        inputExpectedFields = {
            'Theta'% 复合材料夹角
            'Epison'% epison_x;epison_y;epison_z;gamma_yz;gamma_zx;gamma_xy
            };
        
        outputExpectedFields = {
            'Te'% Strain transform matrix
            'Tans_E'% Transformed Strain
            };
        
        statesExpectedFields = {};
        
    end
    
    methods
        
        function obj = ETransform(paramsStruct,inputStruct)
            obj = obj@cComponent(paramsStruct,inputStruct);
        end
        
        function obj = solve(obj)
            %calculate outputs
            Te=cal_Te(obj);
            obj.output.Tans_E=Te*obj.input.Epison;
            obj.output.Te=Te;
            
        end
        
        function Te=cal_Te(obj)
            %函数功能：用于求解叠层结构三维应变转换矩阵。
            %调用格式：ThreeDimensionalStrainTransformation(theta)。
            %输入参数：偏轴角度θ，单位为度，注意角度正负取值问题。
            %运行结果：6×6应力转换矩阵。
            m=cosd(obj.input.Theta);
            n=sind(obj.input.Theta);
            Te=[m^2,n^2,0,0,0,m*n;
                n^2,m^2,0,0,0,-m*n;
                0,0,1,0,0,0;
                0,0,0,m,-n,0;
                0,0,0,n,m,0;
                -2*m*n,2*m*n,0,0,0,m^2-n^2];
        end
        
    end
end
classdef Third_Strength_Theory < Component
    % Third_Strength_Theory.m
    % Author: Yu Xie, Feb 2023
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Resistance' % 材料抗力 [Mpa]
            
            };
        
        inputExpectedFields = {
            'Sigma_1' % 第一主应力 [Mpa]
            'Sigma_3' % 第三主应力 [Mpa]
            
            };
        
        outputExpectedFields = {
            'SRF' % 安全系数
            
            };
        
        baselineExpectedFields = {
            };
        
    end
    
    methods
        function obj = Third_Strength_Theory(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end
        
        function obj = solve(obj)
            Temp=obj.input.Sigma_1-obj.input.Sigma_3;
            obj.output.SRF=obj.params.Resistance/Temp;
        end
        
    end
end
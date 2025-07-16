classdef First_Strength_Theory < Component
    % First_Strength_Theory.m
    % Author: Yu Xie, Feb 2023
    
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Resistance' % ���Ͽ��� [Mpa]
            
            };
        
        inputExpectedFields = {
            'Sigma_1' % ��һ��Ӧ�� [Mpa]
            
            };
        
        outputExpectedFields = {
            'SRF' % ��ȫϵ��
            
            };
        
        baselineExpectedFields = {
            };
        
    end
    
    methods
        function obj = First_Strength_Theory(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end
        
        function obj = solve(obj)
            obj.output.SRF=obj.params.Resistance/obj.input.Sigma_1;
        end
        
    end
end
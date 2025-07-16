classdef Second_Strength_Theory < Component
    % Second_Strength_Theory.m
    % Author: Yu Xie, Feb 2023
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Resistance' % ���Ͽ��� [Mpa]
            'Xi' % ���ϲ��ɱ�
            
            };
        
        inputExpectedFields = {
            'Sigma_1' % ��һ��Ӧ�� [Mpa]
            'Sigma_2' % �ڶ���Ӧ�� [Mpa]
            'Sigma_3' % ������Ӧ�� [Mpa]
            
            };
        
        outputExpectedFields = {
            'SRF' % ��ȫϵ��
            
            };
        
        baselineExpectedFields = {
            };
        
    end
    
    methods
        function obj = Second_Strength_Theory(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end
        
        function obj = solve(obj)
            Temp=obj.input.Sigma_1-obj.params.Xi*(obj.input.Sigma_2+obj.input.Sigma_3);
            obj.output.SRF=obj.params.Resistance/Temp;
        end
        
    end
end
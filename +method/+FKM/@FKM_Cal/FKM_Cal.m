classdef FKM_Cal < Component
    % FKM规范计算
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Name' % 名称
            'KA'
            'Echo'
            };
        
        inputExpectedFields = {
            'Mat' % 材料属性
            'deff'
            };
        
        outputExpectedFields = {
            'Mat_Output'
            'KA'
            'Kdm'
            'Kdp'
            };
        
        baselineExpectedFields = {};
        default_Name='FKM_Cal_1'
        default_KA=1;
        default_Echo=1
    end
    methods
        
        function obj = FKM_Cal(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='FKM_Cal.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            %calculate outputs
            [Kdm,Kdp,Rm,Rp] = Size_Factor_Cal(obj);
            obj.output.Mat_Output=obj.input.Mat;
            obj.output.Mat_Output.allowables.Rm=Rm;
            obj.output.Mat_Output.allowables.Rp=Rp;
            obj.output.KA=obj.params.KA;
            obj.output.Kdm=Kdm;
            obj.output.Kdp=Kdp;
        end
    end
end
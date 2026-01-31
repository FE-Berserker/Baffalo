classdef RubberProperty < Component
    % RubberProperty
    % Author: Xie Yu
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Echo'
            'Name'
            };
        
        inputExpectedFields = {
            'HS'% 邵氏硬度
            };
        
        outputExpectedFields = {
            'E'% 弹性模量 [N/mm2]
            'd'% Ed/Es 动静比
            'G'% 剪切模量 [N/mm2]
            'v'% 泊松比
            'MR_Parameter'
            };
        baselineExpectedFields = {}
        
        default_Name='RubberProperty_1'
        default_Echo=1;

    end
    methods
        
        function obj = RubberProperty(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='RubberProperty.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            % Calculate outputs
            obj.output.E= E_Cal(obj);
            obj.output.d= d_Cal(obj);
            obj.output.G= G_Cal(obj);
            obj.output.v= obj.output.E/obj.output.G/2-1;
            [C10,C01]= MR_Estimate(obj);
            obj.output.MR_Parameter=[C10,C01];
            if obj.output.v>0.5
                obj.output.v=0.5;
            end
            % Print
            if obj.params.Echo==1
                fprintf('Successfully calculate the rubber property ! .\n');
            end
        end
    end
    
end
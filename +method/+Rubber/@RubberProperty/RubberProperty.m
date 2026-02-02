classdef RubberProperty < Component
    % RubberProperty
    % Author: Xie Yu
    %
    % 功能说明：
    % 这是一个橡胶材料属性计算类，继承自Component类。
    % 用于根据输入的邵氏硬度(HS)，计算橡胶材料的弹性模量(E)和剪切模量(G)。
    %
    % 主要方法：
    %   - E_Cal: 计算弹性模量
    %   - d_Cal: 计算动静态比(Ed/Es)
    %   - G_Cal: 计算剪切模量
    %   - MR_Estimate: 估计Mooney-Rivlin模型参数
    %
    % 输出参数：
    %   - E: 弹性模量 [N/mm²]
    %   - d: 动静态比(Ed/Es)
    %   - G: 剪切模量 [N/mm²]
    %   - v: 泊松比(默认为0.5)
    %   - MR_Parameter: Mooney-Rivlin参数 [C10, C01]

    properties (Hidden, Constant)
        % 隐藏常量属性

        paramsExpectedFields = {
            'Echo'        % 是否打印信息: 0=不打印, 1=打印
            'Name'         % 属性名称
            };

        inputExpectedFields = {
            'HS'           % 输入: 邵氏硬度(Shore Hardness)
            };

        outputExpectedFields = {
            'E'            % 输出: 弹性模量 [N/mm²]
            'd'            % 输出: 动静态比(Ed/Es)
            'G'            % 输出: 剪切模量 [N/mm²]
            'v'            % 输出: 泊松比(默认为0.5)
            'MR_Parameter'  % 输出: Mooney-Rivlin模型参数
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
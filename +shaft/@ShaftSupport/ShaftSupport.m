classdef ShaftSupport < Component
    % ShaftSupport - 轴支座有限元模型生成类
    % 继承自Component基类，用于创建不同类型的轴支座3D网格模型
    % Author: Yu Xie

    properties
        % 其他Component相关属性...
    end

    properties (Hidden, Constant)
        % 参数期望字段定义
        paramsExpectedFields = {
            'Material' % 材料属性，默认为钢材
            'Name' % 轴支座名称
            'E_Revolve' % 旋转分段数（用于圆周网格划分）
            'Order' % 实体单元阶次（1=一阶，2=二阶）
            'Type' % 轴支座类型（1-4）
            'Echo' % 是否打印输出信息
            };

        % 输入参数期望字段定义
        inputExpectedFields = {
            'N' % 壁厚 [mm]
            'L' % 轴支座长度 [mm]
            'D' % 轴直径 [mm]
            'H' % 底板尺寸 [mm]
            'T' % 底板厚度 [mm]
            'd1' % 孔直径 [mm]
            'P' % 孔距直径/孔分布圆直径 [mm]
            'NH' % 孔数量
            'K' % 类型2专用参数：方孔边长
            'W' % 类型3、4专用参数：方孔宽度
            'F' % 类型4专用参数：方孔间距
            };

        % 输出字段定义
        outputExpectedFields = {
            'SolidMesh'% 轴支座3D网格
            'Assembly'% 轴支座实体网格装配体
            };

        % 基线期望字段
        baselineExpectedFields = {
            };

        % 默认参数值
        default_Name='ShaftSupport_1';  % 默认名称
        default_E_Revolve=40;          % 默认旋转分段数（40）
        default_Material=[];           % 默认材料（空，使用钢材）
        default_Echo=1;                % 默认开启打印
        default_Type=1;               % 默认类型1
        default_Order=1;               % 默认一阶单元
    end

    methods
        % 构造函数
        function obj = ShaftSupport(paramsStruct,inputStruct)
            % 初始化父类Component
            obj = obj@Component(paramsStruct,inputStruct);
            % 设置输出文档名称
            obj.documentname='ShaftSupport.pdf';
        end

        % 求解函数 - 生成轴支座模型
        function obj = solve(obj)
            % 检查并修正旋转分段数，确保为8的倍数
            if mod(obj.params.E_Revolve,8)~=0
                obj.params.E_Revolve=ceil(obj.params.E_Revolve/8)*8;
            end

            % 材料设置 - 如果未指定材料，使用钢材
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % 根据类型生成不同的实体模型
            switch obj.params.Type
                case 1  % 类型1：圆形底板，圆孔沿圆周分布
                    obj=OutputSolidModel1(obj);
                case 2  % 类型2：方形带圆角底板，圆孔沿圆周分布（带平边）
                    obj=OutputSolidModel2(obj);
                case 3  % 类型3：长方形底板，圆孔沿圆周分布
                    obj=OutputSolidModel3(obj);
                case 4  % 类型4：长方形底板，4个固定孔呈方形布置
                    obj=OutputSolidModel4(obj);
            end

            % 生成装配体信息
            obj=OutputAss(obj);
        end
    end
end
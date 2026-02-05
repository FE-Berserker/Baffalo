% BossPlate - 带台阶的平板组件类
% 该类定义了一个 BossPlate 组件，表示工程中常用的带台阶（加强凸台）的平板结构
% 继承自 Component 基类
classdef BossPlate < Component
    % 类名：BossPlate
    % 作者：Yu Xie
    
    % 隐藏常量属性 - 定义参数和输入输出的字段规范
    properties (Hidden, Constant)

        % 预期参数字段 - 定义构造函数 paramsStruct 参数所需的字段
        paramsExpectedFields = {
            'Material' % 材料，默认为钢材
            'Name' % BossPlate 的名称
            'Order' % 实体单元阶次
            'Type' % 类型，1=向内侧拉伸凸台，2=向外侧拉伸凸台
            'HoleSeg'% 孔边分段数
            'Echo' % 是否打印输出信息

            };
        
        % 预期输入字段 - 定义构造函数 inputStruct 参数所需的字段
        inputExpectedFields = {
            'OutLine' % BossPlate 的外轮廓线 [mm]
            'MidLine' % BossPlate 的中间轮廓线 [mm]
            'InnerLine' % BossPlate 的内轮廓线 [mm]
            'InnerHole' % 内部区域的孔
            'OuterHole' % 外部区域的孔
            'BossHeight' % 凸台高度 [mm]
            'PlateThickness' % 平板厚度 [mm]
            'Meshsize' % 网格尺寸 [mm]
            };
        
        % 预期输出字段 - 定义输出结果所需的字段
        outputExpectedFields = {
            'PlateNode' % BossPlate 平板侧的节点
            'SolidMesh'% BossPlate 的三维网格
            'Assembly'% BossPlate 的实体网格装配体
            };

        % 基线预期字段（当前为空）
        baselineExpectedFields = {};

        % 默认参数值
        default_Name='BossPlate1';    % 默认名称
        default_Material=[];           % 默认材料为空，将在 solve 方法中设置为钢
        default_Echo=1;                % 默认开启打印输出
        default_Order=1;               % 默认使用一阶实体单元
        default_Type=1;                % 默认向内侧拉伸凸台
        default_HoleSeg=16;            % 默认孔边分段数为16
    end
    % 方法定义区
    methods

        % BossPlate 构造函数
        %   paramsStruct: 参数结构体，包含 Material, Name, Order, Type, HoleSeg, Echo 等
        %   inputStruct: 输入结构体，包含几何参数如 OutLine, MidLine, InnerLine 等
        function obj = BossPlate(paramsStruct,inputStruct)
            % 调用父类 Component 的构造函数初始化对象
            obj = obj@Component(paramsStruct,inputStruct);
            % 设置文档名称，用于生成帮助文档
            obj.documentname='BossPlate.pdf';
        end
        
        % solve - 执行 BossPlate 的求解/生成
        % 该方法完成以下工作：
        %   1. 设置材料属性（如果未指定，则使用默认钢材）
        %   2. 生成实体模型
        %   3. 生成装配体
        function obj = solve(obj)
            % 材料设置
            % 如果用户没有指定材料，则使用默认钢材
            if isempty(obj.params.Material)
                % 从材料库中获取 FEA 材料类型
                S=RMaterial('FEA');
                % 获取第一个材料（钢材）
                mat=GetMat(S,1);
                % 将材料赋值给参数
                obj.params.Material=mat{1,1};
            end

            % 输出实体模型 - 生成 BossPlate 的三维实体网格
            obj=OutputSolidModel(obj);
            % 输出装配体 - 生成 BossPlate 的装配结构
            obj=OutputAss(obj);
        end

    end
end
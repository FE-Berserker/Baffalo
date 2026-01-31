classdef Commonplate < Component
    % Commonplate - 通用板类
    % 用于创建和分析带孔的板件模型
    % 支持实体模型和壳模型两种有限元分析方式
    % Author: Yu Xie

    properties(Hidden, Constant)

        % 参数字段定义
        paramsExpectedFields = {
            'Material' % 材料属性，默认为钢材
            'N_Slices' % 高度方向的单元层数
            'Name' % 板的名称
            'Order' % 单元阶次：1=一阶，2=二阶
            'Offset' % 壳单元偏移：Mid=中面，Top=上面，Bottom=下面
            'Echo' % 是否打印信息：0=不打印，1=打印
            };

        % 输入字段定义
        inputExpectedFields = {
            'Outline' % 轮廓 [mm]，Nx2矩阵
            'Hole' % 孔 [mm]，Nx2矩阵
            'Thickness' % 厚度 [mm]
            'Meshsize' % 网格尺寸 [mm]
            };

        % 输出字段定义
        outputExpectedFields = {
            'Surface' % 板截面表面
            'SolidMesh' % 板3D实体网格
            'ShellMesh' % 板3D壳网格
            'Assembly' % 实体模型装配
            'Assembly1' % 壳模型装配
            };
        baselineExpectedFields = {
            };

        default_N_Slices=3;
        default_Name='Commonplate1';
        default_Material=[];
        default_Offset="Mid"
        default_Order=1;
        default_Echo=1;
    end
    methods

        function obj = Commonplate(paramsStruct,inputStruct)
            % 构造函数
            % Inputs:
            %   paramsStruct - 参数结构体
            %   inputStruct   - 输入结构体
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Commonplate.pdf';
        end

        function obj = solve(obj)
            % 求解方法
            % 主要功能：
            %   1. 创建带孔的2D截面
            %   2. 生成实体网格和壳网格
            %   3. 设置材料并创建装配

            %% 创建基准面（外轮廓）
            S=Surface2D(obj.input.Outline,'Echo',0);

            %% 添加孔
            for i=1:size(obj.input.Hole,1)
                S=AddHole(S,obj.input.Hole(i,1));
            end

            %% 保存截面
            obj.output.Surface=S;

            %% 设置材料（如果未指定则使用默认钢材）
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            %% 计算输出结果
            obj=OutputSolidModel(obj);  % 生成实体模型
            obj=OutputShellModel(obj);  % 生成壳模型
            obj=OutputAss(obj);       % 创建实体装配
            obj=OutputAss1(obj);      % 创建壳装配
        end

        function Plot2D(obj)
            % 绘制2D截面图
            Plot(obj.output.Surface);
        end

    end
end

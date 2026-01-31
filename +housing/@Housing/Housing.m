classdef Housing < Component
    % Housing - 旋转体（壳体）类
    % 通过截面轮廓旋转生成3D实体模型
    % Author: Xie Yu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % 材料属性，默认为钢材
            'N_Slice' % 旋转分段数（圆周方向离散化）
            'Degree' % 旋转角度 [°]
            'Axis' % 旋转轴：'x'或'y'
            'Name' % 名称
            'Echo' % 是否打印信息：0=不打印，1=打印
            'Order' % 单元阶次：1=一阶，2=二阶
            };

        inputExpectedFields = {
            'Outline' % 截面轮廓
            'Hole' % 孔几何
            'Meshsize' % 网格尺寸 [mm]
            };

        outputExpectedFields = {
            'Surface' % 壳体截面表面
            'SolidMesh' % 壳体实体网格
            'Assembly' % 实体模型装配
            };

        baselineExpectedFields = {};
        default_N_Slice=36; % 默认旋转分段数
        default_Name='Housing_1'; % 默认名称
        default_Material=[]; % 默认材料为空（使用钢材）
        default_Axis='x' % 默认旋转轴为x
        default_Degree=360 % 默认旋转角度360°
        default_Echo=1 % 默认打印信息
        default_Order=1 % 默认使用一阶单元
    end
    methods

        function obj = Housing(paramsStruct,inputStruct)
            % 构造函数
            % 继承Component类的构造函数
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Housing.pdf';
        end

        function obj = solve(obj)
            %% 求解方法 - 计算输出结果
            % 创建2D表面
            S=Surface2D(obj.input.Outline);

            % 添加所有孔
            for i=1:size(obj.input.Hole,1)
                S=AddHole(S,obj.input.Hole(i,1));
            end
            obj.output.Surface=S;

            %% 打印信息
            if obj.params.Echo
                fprintf('Successfully create surface .\n');
            end

            %% 获取材料属性
            % 如果未指定材料，使用钢材
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            %% 输出实体模型和装配
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
        end

        function Plot2D(obj)
            % 绘制2D截面图
            Plot(obj.output.Surface);
        end

    end
end


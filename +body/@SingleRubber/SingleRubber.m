classdef SingleRubber < Component
    % SingleRubber - 单个橡胶体类
    % 用于创建单个橡胶体的有限元网格
    % 支持旋转体和平板两种几何类型
    % Author: Xie Yu

    properties (Hidden, Constant)

        % 参数字段定义
        paramsExpectedFields = {
            'Type'     % 橡胶类型：'Rotary'(旋转体) 或 'Plate'(平板)
            'Name'     % 名称
            'Echo'     % 是否打印信息：0=不打印，1=打印
            };

        % 输入字段定义
        inputExpectedFields = {
            'HS'       % 邵氏硬度 (Shore Hardness)
            'Geometry' % 几何模型 (Type=Rotary时用Housing，Type=Plate时用Commonplate)
            };

        % 输出字段定义
        outputExpectedFields = {
            'RubberProperty'  % 橡胶材料属性
            'SolidMesh'       % 橡胶体3D实体网格
            'Assembly'        % 实体模型装配
            };

        baselineExpectedFields = {};

        default_Name='SingleRubber_1';
        default_Echo=1;
    end

    methods

        function obj = SingleRubber(paramsStruct,inputStruct)
            % 构造函数
            % Inputs:
            %   paramsStruct - 参数结构体，包含Type, Name, Echo
            %   inputStruct   - 输入结构体，包含HS, Geometry
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='SingleRubber.pdf';
        end

        function obj = solve(obj)
            % 求解方法
            % 主要功能：
            %   1. 计算橡胶材料属性
            %   2. 获取几何模型
            %   3. 创建装配

            %% 计算橡胶材料属性
            obj = CalculateRubberProperty(obj);

            %% 获取几何模型
            % 根据Type参数获取对应的几何模型
            if strcmpi(obj.params.Type, 'Rotary')
                % 旋转体：使用Housing对象的SolidMesh
                if isempty(obj.input.Geometry.output.SolidMesh)
                    % 如果SolidMesh未生成，先求解几何模型
                    obj.input.Geometry = obj.input.Geometry.solve();
                end
                obj.output.SolidMesh = obj.input.Geometry.output.SolidMesh;
            elseif strcmpi(obj.params.Type, 'Plate')
                % 平板：使用Commonplate对象的SolidMesh
                if isempty(obj.input.Geometry.output.SolidMesh)
                    % 如果SolidMesh未生成，先求解几何模型
                    obj.input.Geometry = obj.input.Geometry.solve();
                end
                obj.output.SolidMesh = obj.input.Geometry.output.SolidMesh;
            else
                error('Invalid Type: must be "Rotary" or "Plate"');
            end

            %% 创建装配
            obj = OutputAss(obj);

            %% 打印信息
            if obj.params.Echo
                fprintf('Successfully create single rubber mesh .\n');
            end
        end

        function obj = CalculateRubberProperty(obj)
            % 计算橡胶材料属性
            % 调用RubberProperty类计算E, G, v等材料参数

            % 创建RubberProperty对象
            paramsRP = struct('Echo', 0);
            inputRP = struct('HS', obj.input.HS);
            rubberProp = method.Rubber.RubberProperty(paramsRP, inputRP);
            rubberProp = rubberProp.solve();

            % 保存材料属性到输出
            obj.output.RubberProperty = rubberProp;
        end

        function Plot2D(obj)
            % 绘制2D截面图
            if strcmpi(obj.params.Type, 'Rotary')
                obj.input.Geometry.Plot2D();
            elseif strcmpi(obj.params.Type, 'Plate')
                obj.input.Geometry.Plot2D();
            end
        end

    end
end

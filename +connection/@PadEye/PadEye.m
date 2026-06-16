classdef PadEye < Component
    % Class Name
    % Author: Xie Yu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % Material of the Component
            'Order' % 单元阶次：1=一阶，2=二阶
            'Offset' % 壳单元偏移：Mid=中面，Top=上面，Bottom=下面
            'N_Slice' % 高度方向的单元层数

            };

        inputExpectedFields = {
            'Outline' % Outline of the PadEye
            'HoleDia' % Hole diameter of the hole
            'Meshsize' % 网格尺寸 [mm]
            'Thickness' % PadEye厚度 [mm]
            };

        outputExpectedFields = {
            'Surface' % 板截面表面
            'SolidMesh' % 板3D实体网格
            'ShellMesh' % 板3D壳网格
            'Assembly' % 实体模型装配
            'Assembly1' % 壳模型装配
            };

        baselineExpectedFields = {
            };

        default_Name='PadEye1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        default_Offset="Mid"
        default_Order=1;
        default_N_Slice=3;

    end
    methods

        function obj = PadEye(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='PadEye.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input is Null
            Check(obj)

            % Set Material
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            a=Point2D('HoleCenter');
            a=AddPoint(a,0,0);

            h=Line2D('PadEyeHole');
            h=AddCircle(h,obj.input.HoleDia/2,a,1);

            inputplate1.Outline= obj.input.Outline;
            inputplate1.Hole = h;
            inputplate1.Meshsize = obj.input.Meshsize;
            inputplate1.Thickness = obj.input.Thickness;
            paramsplate1.Echo = 0;
            paramsplate1.Order = obj.params.Order;
            paramsplate1.Offset = obj.params.Offset;
            paramsplate1.N_Slice = obj.params.N_Slice;

            obj1=plate.Commonplate(paramsplate1, inputplate1);
            obj1 = obj1.solve();

            % Output
            obj.output.Surface=obj1.output.Surface;
            obj.output.SolidMesh=obj1.output.SolidMesh;
            obj.output.ShellMesh=obj1.output.ShellMesh;
            obj.output.Assembly=obj1.output.Assembly;
            obj.output.Assembly1=obj1.output.Assembly1;

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate results .\n');
            end
        end

        function Plot2D(obj)
            % 绘制2D截面图
            Plot(obj.output.Surface);
        end
    end
end


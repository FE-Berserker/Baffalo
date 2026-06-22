classdef PadEyeBlock < Component
    % Class Name
    % Author: Xie Yu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % Material of the Component
            'Order' % 单元阶次：1=一阶，2=二阶
            'N_Slice' % 高度方向的单元层数

            };

        inputExpectedFields = {
            'a' % PadEyeBlock size a
            'b' % PadEye Block size b
            'HoleDia' % Hole diameter of the hole
            'Meshsize' % 网格尺寸 [mm]
            'Thickness' % PadEye Thickness [mm]
            'l' % PadEyeBlock size l
            'w' % PadEyeBlock size w
            'h' % PadEyeBlock size h
            };

        outputExpectedFields = {
            'Surface' % PadEyeBlock surface
            'SolidMesh' % PadEyeBliock solidmesh
            'Assembly' % 实体模型装配
            };

        baselineExpectedFields = {
            };

        default_Name='PadEyeBlock1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        default_Order=1;
        default_N_Slice=3;

    end
    methods

        function obj = PadEyeBlock(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='PadEyeBlock.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input is Null
            Check(obj)

            a=obj.input.a;
            b=obj.input.b;
            R=obj.input.HoleDia/2;
            w=obj.input.w;
            h=obj.input.h;

            % Check size
            if a<=R
                error('Size a should be larger than hole radius !')
            end

            if b<=R
                error('size b should be larger than hole radius !')
            end

            if h>=w
                error('size h should be smaller than size w !')
            end

            % Set Material
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            aa=Point2D('HoleCenter');
            aa=AddPoint(aa,0,0);
            aa=AddPoint(aa,[-R-w;-R-w+h],[-b;-b]);
            aa=AddPoint(aa,[-R-w+h;0],[-b;-b]);
            aa=AddPoint(aa,[0;-R-w+h],[b;b]);
            aa=AddPoint(aa,[-R-w+h;-R-w],[b;b]);
            aa=AddPoint(aa,[-R-w;-R-w],[b;-b]);

            bb=Line2D('PadEyeOutline');
            bb=AddLine(bb,aa,2);
            bb=AddLine(bb,aa,3);
            bb=AddEllipse(bb,a,b,aa,1,'sang',-90,'ang',180);
            bb=AddLine(bb,aa,4);
            bb=AddLine(bb,aa,5);
            bb=AddLine(bb,aa,6);

            h=Line2D('PadEyeHole');
            h=AddCircle(h,R,aa,1);

            %% 创建基准面（外轮廓）
            S=Surface2D(bb,'Echo',0);

            %% 添加孔
            S=AddHole(S,h);

            %% 保存截面
            obj.output.Surface=S;

            obj=OutputSolidModel(obj);
            obj = OutputAss(obj);

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

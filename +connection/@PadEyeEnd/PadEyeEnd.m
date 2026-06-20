classdef PadEyeEnd < Component
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
            'a' % PadEyeEnd size a
            'b' % PadEyeEnd size b
            'HoleDia' % Hole diameter of the hole
            'Meshsize' % 网格尺寸 [mm]
            'Thickness' % PadEyeEnd Thickness [mm]
            'w' % PadEyeEnd size l
            'h' % PadEyeEnd size w
            'Dia2' % Cylinder diameter
            'l' % Cylinder length
            };

        outputExpectedFields = {
            'Surface' % PadEyeEnd surface
            'Section' % PadEyeEnd section
            'SolidMesh' % PadEyeEnd solidmesh
            'Assembly' % 实体模型装配
            };

        baselineExpectedFields = {
            };

        default_Name='PadEyeEnd1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        default_Order=1;
        default_N_Slice=4;

    end
    methods

        function obj = PadEyeEnd(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='PadEyeEnd.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input is Null
            Check(obj)

            a=obj.input.a;
            b=obj.input.b;
            R=obj.input.HoleDia/2;
            R2=obj.input.Dia2/2;
            w=obj.input.w;
            h=obj.input.h;
            l=obj.input.l;

            if mod(obj.params.N_Slice,2)==1
                obj.params.N_Slice=obj.params.N_Slice+1;
            end

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

            aa=Point2D('HoleCenter','Echo',0);
            aa=AddPoint(aa,0,0);
            aa=AddPoint(aa,[-R-w+h;0],[-b;-b]);
            aa=AddPoint(aa,[0;-R-w+h],[b;b]);
            aa=AddPoint(aa,[-R-w+h;-R-w+h],[b;-b]);

            bb=Line2D('PadEyeOutline','Echo',0);
            bb=AddLine(bb,aa,2);
            bb=AddEllipse(bb,a,b,aa,1,'sang',-90,'ang',180);
            bb=AddLine(bb,aa,3);
            bb=AddLine(bb,aa,4);

            hh=Line2D('PadEyeHole','Echo',0);
            hh=AddCircle(hh,R,aa,1);

            %% 创建基准面（外轮廓）
            S=Surface2D(bb,'Echo',0);

            %% 添加孔
            S=AddHole(S,hh);

            %% 保存截面
            obj.output.Surface=S;

            m=Mesh2D('Temp','Echo',0);
            m=AddSurface(m,S);
            m=Mesh(m);

            aa1=Point2D('Transtion','Echo',0);
            bb1=Line2D('TranstionLine','Echo',0);

            aa1=AddPoint(aa1,[-R-w;-R-w+h],[-R2;-b]);
            aa1=AddPoint(aa1,[-R-w+h;-R-w+h],[-b;b]);
            aa1=AddPoint(aa1,[-R-w+h;-R-w],[b;R2]);
            aa1=AddPoint(aa1,[-R-w;-R-w],[R2;-R2]);

            for i=1:4
                bb1=AddLine(bb1,aa1,i);
            end

            S1=Surface2D(bb1,'Echo',0);
            m1=Mesh2D('Temp','Echo',0);
            m1=AddSurface(m1,S1);
            m1=Mesh(m1);

            aa2=Point2D('Cyclinder','Echo',0);
            bb2=Line2D('CyclinderLine','Echo',0);

            aa2=AddPoint(aa2,[-R-w-l;-R-w],[-R2;-R2]);
            aa2=AddPoint(aa2,[-R-w;-R-w],[-R2;R2]);
            aa2=AddPoint(aa2,[-R-w;-R-w-l],[R2;R2]);
            aa2=AddPoint(aa2,[-R-w-l;-R-w-l],[R2;-R2]);

            for i=1:4
                bb2=AddLine(bb2,aa2,i);
            end

            S2=Surface2D(bb2,'Echo',0);
            m2=Mesh2D('Temp','Echo',0);
            m2=AddSurface(m2,S2);
            m2=Mesh(m2);


            %% 创建section
            LL=Layer(obj.params.Name,'Echo',0);
            LL=AddElement(LL,m);
            LL=AddElement(LL,m1);
            LL=AddElement(LL,m2);

            obj.output.Section=LL;
            obj=OutputSolidModel(obj);
            obj = OutputAss(obj);

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate results .\n');
            end
        end

        function Plot2D(obj)
            % 绘制2D截面图
            Plot(obj.output.Section,'View',[0,90]);
        end
    end
end


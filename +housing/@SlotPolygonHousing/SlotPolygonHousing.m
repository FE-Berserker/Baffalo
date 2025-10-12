classdef SlotPolygonHousing < Component
    % Class SlotPolygonHousing
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % Material properties，default is steel
            'Name' % Name
            'Echo' % Print
            'Order' % Element order
            'SlotSlice' % Slot rotate number
            'ToothType'
            'SlotType'
            'LeftLimit'
            'RightLimit'
            };

        inputExpectedFields = {
            'Outline' % outline
            'Meshsize' % Mesh size
            'r' % Edge radius
            'EdgeNum'
            'SlotWidth' % Slot width
            'SlotPos' % Slot position
            };

        outputExpectedFields = {
            'Surface'% ToothShaft Section surface
            'SolidMesh'% ToothShaft solid mesh
            'ShellMesh'% ToothShaft shell mesh
            'Assembly'% Assembly of solid mesh
            'Divider1'
            'Divider2'
            };

        baselineExpectedFields = {};
        default_Name='PolygonHousing_1';
        default_Material=[];
        default_Echo=1
        default_Order=1
        default_SlotSlice=5
        default_ToothType=1
        default_SlotType=1
        default_LeftLimit=[];
        default_RightLimit=[];

    end
    methods

        function obj = SlotPolygonHousing(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='SlotPolygonHousing.pdf';
        end

        function obj = solve(obj)
            %% Check input

            if isempty(obj.input.r)
                obj.input.r=1;
            end

            Check(obj)

            if size(obj.input.SlotPos,2)~=2
                error('Wrong position input !')
            else
                SlotPos=obj.input.SlotPos;
                Point=obj.input.Outline.Point.P;
                minx=min(Point(:,1));
                maxx=max(Point(:,1));
                minsx=min(SlotPos);
                maxsx=max(SlotPos);
                if or(minsx<=minx,maxsx>=maxx)
                    error('Slot position exceed the limit !')
                end
            end

            if isempty(obj.params.LeftLimit)
                obj.params.LeftLimit=minx;
            end

            if isempty(obj.params.RightLimit)
                obj.params.RightLimit=maxx;
            end

            % Check intersection
            Tempa=Point2D('Temp','Echo',0);
            Tempa=AddPoint(Tempa,[Point(:,1);Point(1,1)],[Point(:,2);Point(1,2)]);
            Tempa=AddPoint(Tempa,[SlotPos(1);SlotPos(1)],[0;max(Point(:,2))+0.01]);

            Tempb=Line2D('Temp','Echo',0);
            Tempb=AddCurve(Tempb,Tempa,1);

            Tempb=AddLine(Tempb,Tempa,2);

            [x0,y0]=CurveIntersection(Tempb,1,2);

            if size(x0,1)~=2
                error('Wrong geometry input !')
            end

            % Calculate outputs
            obj.output.Divider1=[x0,y0];

            % Check intersection
            Tempa=Point2D('Temp','Echo',0);
            Tempa=AddPoint(Tempa,[Point(:,1);Point(1,1)],[Point(:,2);Point(1,2)]);
            Tempa=AddPoint(Tempa,[SlotPos(2);SlotPos(2)],[0;max(Point(:,2))+0.01]);

            Tempb=Line2D('Temp','Echo',0);
            Tempb=AddCurve(Tempb,Tempa,1);

            Tempb=AddLine(Tempb,Tempa,2);

            [x1,y1]=CurveIntersection(Tempb,1,2);

            if size(x1,1)~=2
                error('Wrong geometry input !')
            end

            % Calculate outputs
            obj.output.Divider2=[x1,y1];
            S=Surface2D(obj.input.Outline);
            obj.output.Surface=S;

            %% Print
            if obj.params.Echo
                fprintf('Successfully create surface .\n');
            end

            % Material
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
        end

        function Plot2D(obj)
            Plot(obj.output.ShellMesh);
        end

    end
end


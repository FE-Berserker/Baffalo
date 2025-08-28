classdef ToothShaft < Component
    % Class ToothShaft
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % Material properties，default is steel
            'Name' % Name
            'Echo' % Print
            'Order' % Element order
            'ToothType'
            'ToothSlice'% Tooth rotate number
            'SlotSlice' % Slot rotate number
            };

        inputExpectedFields = {
            'Outline' % outline
            'Meshsize' % Mesh size
            'ToothNum' % Tooth number
            'ToothPos' % Tooth position
            'ToothWidth' % Tooth width
            };

        outputExpectedFields = {
            'Surface'% ToothShaft Section surface
            'SolidMesh'% ToothShaft solid mesh
            'ShellMesh'% ToothShaft shell mesh
            'Assembly'% Assembly of solid mesh
            'Divider' % Divider of geometry 
            };

        baselineExpectedFields = {};
        default_Name='ToothShaft_1';
        default_Material=[];
        default_Echo=1
        default_Order=1
        default_ToothType=1
        defalt_ToothSlice=5
        default_SlotSlice=5
    end
    methods

        function obj = ToothShaft(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='ToothShaft.pdf';
        end

        function obj = solve(obj)
            ToothPos=obj.input.ToothPos;
            %% Check input
            if isempty(obj.input.Outline)
                error('Please input the outline !')
            end

            if isempty(ToothPos)
                error('Please input tooth position !')
            else
                Point=obj.input.Outline.Point.P;
                minx=min(Point,1);
                maxx=max(Point,1);
                if or(ToothPos<=minx,ToothPos>=maxx)
                    error('Tooth position exceed the limit !')
                end
            end
            % Check intersection
            Tempa=Point2D('Temp','Echo',0);
            Tempa=AddPoint(Tempa,[Point(:,1);Point(1,1)],[Point(:,2);Point(1,2)]);
            Tempa=AddPoint(Tempa,[ToothPos;ToothPos],[0;max(Point(:,2))+0.01]);

            Tempb=Line2D('Temp','Echo',0);
            Tempb=AddCurve(Tempb,Tempa,1);

            Tempb=AddLine(Tempb,Tempa,2);

            [x0,y0]=CurveIntersection(Tempb,1,2);

            if size(x0,1)~=2
                error('Wrong geometry input !')
            end

            % Calculate outputs
            obj.output.Divider=[x0,y0];
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


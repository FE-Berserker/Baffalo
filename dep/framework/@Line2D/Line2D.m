classdef Line2D < handle

    properties (Constant)
        LINE      = 1;
        CIRCLE    = 2;
        CURVE     = 3;
        ELLIPSE   = 4;
        BEZIER    = 5;
        BSPLINE   = 6;
        SPLINE    = 7;
        PARABOLA  = 8;
        HYPERBOLA = 9;
        NURB      = 10;
    end
    
    properties
        Atol  % for check of equality of among Line2d objects
        Rtol  % for check of relative error when calculate curve length
        Dtol  % distance tolerance
        Gtol  % geometric tolerance h/d
        Compress % Whether to compress points
        Point % Point storage of line
        Cell_Data % Cell_Data of line
        Meshoutput % Output to Mesh
        Coefs % Nurb curve control points
        Knots % Nurb curve knots
        Order % Nurb Order
        Dim   % Nurb Dim
    end

    properties
        Name % Name of Line2D
        Echo % print
        Arrow
        Form % Arrow Form
        Adfac  % factor for arrowhead size (def 0.05)
    end

    properties (SetAccess = private)
        C       % curve data
        CT      % curve type
        CIX     % index for curve data
        MP      % middle point MP(:,1)=x and MP(:,2)=y for label curves
        
    end

    % Derived control data
    properties (SetAccess = private)
        sizeX
        sizeY
        Ad      % arrowhead dimension
    end

    properties (SetAccess = private)
        Close   % curve closed
        CJ      % true = non-self intersecting
        CN      % number of points on curve used to calculate CL
        CL      % curve length
        CL0     % curve reference length CL/CN
        CHD     % max. h/d
    end

    methods
        function obj = Line2D(Name,varargin)
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            addParameter(p,'Gtol',0.04);
            addParameter(p,'Dtol',1e-5);
            addParameter(p,'Atol',1e-4);
            addParameter(p,'Rtol',1e-3);
            addParameter(p,'Adfac',0.1);
            addParameter(p,'Compress',1);
            addParameter(p,'Arrow',[]);
            addParameter(p,'Form',3);
            parse(p,varargin{:});
            opt=p.Results;

            %Create Line2D object with default value
            obj.Echo = opt.Echo;
            % set default values
            obj.Gtol = opt.Gtol;  % default tolerance for h/d
            obj.Dtol = opt.Dtol;  % distance tolerance
            obj.Atol = opt.Atol;
            obj.Rtol = opt.Rtol; % numerical calculation
            obj.Adfac = opt.Adfac;
            obj.Arrow=opt.Arrow;
            obj.Form=opt.Form;
            obj.Compress=opt.Compress;
            obj.Point=Point2D('Point','Dtol',opt.Dtol,'Echo',0);

            if obj.Echo
                fprintf('Creating Line2D object ...\n');
            end

        end

        function [obj,id] = addCurve_(obj,ctyp,cdat,varargin)
            % addCurve_ Save curve data

            k=inputParser;
            addParameter(k,'seg',[]);
            parse(k,varargin{:});
            opt=k.Results;
            cseg=false;
            if ~isempty(opt.seg)
                cseg=true;
                nseg=opt.seg;
            end

            if isempty(obj.C)
                id = 1;
                obj.CIX(1) = id;
            else
                id = length(obj.CIX);
            end

            obj.C = [obj.C;cdat];
            obj.CT = [obj.CT;ctyp];
            obj.CIX(id+1) = length(obj.C) + 1;

            obj=initCurve(obj,id);

            if cseg
                if nseg>=obj.CN(id)
                    obj.CN(id)=nseg;
                else
                    obj.CN(id)=nseg;
                    warning('Not satisfy the min segment!');
                end
            end

            % Calculate endpoints
            [x,y] = PolyCurve(obj,id);
            obj.CJ(id) = isCurveSimple(id,x,y,obj.Echo); %Check no self-intersecting
            if  obj.CT(id)==obj.CURVE
                obj.Point=AddPoint(obj.Point,x',y');
            elseif obj.CT(id)==obj.NURB
                obj.Point=AddPoint(obj.Point,x',y');
            else
                obj.Point=AddPoint(obj.Point,x,y);
            end
            obj.Point.Dtol=obj.Dtol;
            if obj.Compress
                obj.Point=CompressNpts(obj.Point,'all',1);
            end

            % Add mid point (for label location)
            if length(x) == 2
                obj.MP(id,1) = 0.5*(x(1) + x(2));
                obj.MP(id,2) = 0.5*(y(1) + y(2));
            else
                mp = ceil(length(x)/2);
                obj.MP(id,1) = x(mp);
                obj.MP(id,2) = y(mp);
            end
            % Geometry size
            obj.sizeX = max(x) - min(x);
            obj.sizeY = max(y) - min(y);
            obj=setAd(obj);

        end

        function obj=initCurve(obj,id)
            % Get length, number of points and h/d ratio
            [obj.CL(id),obj.CN(id),obj.CHD(id)] = getCurveLength(obj,id,...
                obj.Rtol,obj.Dtol,obj.Gtol);
            % Reference length
            obj.CL0(id) = obj.CL(id)/(obj.CN(id) - 1);
        end

        function [L,nn,tol] = getCurveLength(obj,id,rrtol,ddtol,ggtol)
            % getCurveLength Calculate curve length

            validateattributes(id,{'numeric'}, ...
                {'>=',1,'<=',obj.GetNcrv,'integer','scalar'});
            L1 = 0;
            c = GetCurve(obj,id);
            switch c.type
                case obj.BEZIER
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                case obj.BSPLINE
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                case obj.CIRCLE
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                    L1 = abs(c.data(1)*c.data(5)*pi/180);
                case obj.CURVE
                    ix = length(c.data)/2;
                    x = c.data(1:ix);
                    y = c.data(ix+1:end);
                    nn = ix;
                    L = 0;
                    for i = 1:nn - 1
                        L = L + norm([x(i+1)-x(i),y(i+1)-y(i)]);
                    end
                    tol = 0;
                case obj.ELLIPSE
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                    L1 = lengthOfEllipse(c.data(1),c.data(2),c.data(6),...
                        c.data(6) + c.data(7));
                case obj.HYPERBOLA
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                    L1 = lengthOfHyperbola(c.data(1),c.data(2),c.data(6),...
                        c.data(7));
                case obj.LINE
                    nn = 2;
                    L = norm([c.data(1) - c.data(3),...
                        c.data(2) - c.data(4)]);
                    tol= 0;
                case obj.PARABOLA
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                    L1 = lengthOfParabola(c.data(1),c.data(5),c.data(6));
                case obj.SPLINE
                    [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol);
                case obj.NURB
                    ix = length(c.data)/2;
                    x = c.data(1:ix);
                    y = c.data(ix+1:end);
                    nn = ix;
                    L = 0;
                    for i = 1:nn - 1
                        L = L + norm([x(i+1)-x(i),y(i+1)-y(i)]);
                    end
                    tol = 0;
            end
            if obj.Echo == 1
                if L1 > 0
                    if abs(L1 - L) > obj.Dtol
                        warning('Curve %d approx. L = %g true L = %g.',id,L,L1)
                    end
                end
                if tol > obj.Gtol
                    warning('Curve %d tol h/d = %g > %g.',id,tol,obj.Gtol)
                end
            end
        end

        function [L,nn,tol] = calcLength(obj,id,rrtol,ddtol,ggtol)
            % calcLength Calculate length of curve numericaly
            L0 = 0;
            ok = false;
            for nn = 3:2:1000 % # of pts must be odd to check h/d
                [x,y] = splitCurve( obj, id, nn);
                L = 0;
                Lmin = realmax;
                for i = 1:length(x) - 1
                    Li = norm([x(i+1) - x(i), y(i+1) - y(i)]);
                    L = L + Li;
                    Lmin = min(Lmin,Li);
                end
                if L0 > 0
                    if abs(L/L0 - 1) < rrtol && Lmin > ddtol
                        if gTolChk
                            ok = true;
                            break
                        end
                    end
                end
                if Lmin < obj.Dtol
                    if obj.Echo
                        warning('Curve %d: minimal length %g less than tolerance %g',...
                            id, Lmin,obj.Dtol)
                    end
                    break
                end
                L0 = L;
            end
            if ~ok
                if obj.Echo
                    warning('Curve %d: length calculation failed.',id)
                end
            end
            tol = calcMaxGtol;

            function ok = gTolChk
                % Check geometric tolerance
                for j = 1:2:length(x) - 2
                    d = norm([x(j+2)-x(j),y(j+2)-y(j)]);
                    h = distPL([x(j+2),y(j+2)],[x(j),y(j)],[x(j+1),y(j+1)]);
                    e = h/d;
                    if e > ggtol
                        ok = false;
                        return
                    end
                end
                ok = true;
            end

            function tol = calcMaxGtol
                % Calculate maximum geometric tolerance
                tol = 0;
                for j = 1:2:length(x) - 2
                    d = norm([x(j+2)-x(j),y(j+2)-y(j)]);
                    h = distPL([x(j+2),y(j+2)],[x(j),y(j)],[x(j+1),y(j+1)]);
                    e = h/d;
                    if e > tol
                        tol = e;
                    end
                end
            end
        end

        function obj=setAd(obj)
            % set arrowhead dimension
            obj.Ad = obj.Adfac*max(obj.sizeX,obj.sizeY);
        end

        function [x,y] = splitCurve( obj, id, nn)
            narginchk(3,3)
            validateattributes(id,{'numeric'}, ...
                {'>=',1,'<=',length(obj.CIX)-1,'integer','scalar'});
            validateattributes(nn,{'numeric'}, ...
                {'>=',1,'integer','scalar'});
            c = GetCurve(obj,id);
            switch c.type
                case obj.BEZIER
                    t = linspace(0,1,nn);
                    ix = length(c.data)/2;
                    [x,y] = evalBezier(c.data(1:ix),c.data(ix+1:end),t);
                case obj.BSPLINE
                    ix = (length(c.data)-1)/2;
                    [x,y] = evalBspline(c.data(end),c.data(1:ix),c.data(ix+1:end-1),nn);
                case obj.CIRCLE
                    sa = c.data(4);
                    da = c.data(5);
                    t = linspace(sa,sa+da,nn);
                    [x,y] = evalCircle(c.data(2),c.data(3),c.data(1),t);
                case obj.CURVE
                    ix = length(c.data)/2;
                    x = c.data(1:ix);
                    y = c.data(ix+1:end);
                case obj.ELLIPSE
                    sa = c.data(6);
                    da = c.data(7);
                    t = linspace(sa,sa+da,nn);
                    [x,y] = evalEllipse(c.data(1),c.data(2),c.data(3),...
                        c.data(4),c.data(5),t);
                case obj.HYPERBOLA
                    t = linspace(c.data(6),c.data(7),nn);
                    [x,y] = evalHyperbola(c.data(1),c.data(2),c.data(3),...
                        c.data(4),c.data(5),t);
                case obj.LINE
                    t = linspace(0,1,nn);
                    [x,y] = evalLine(c.data(1),c.data(2),c.data(3),c.data(4),t);
                case obj.PARABOLA
                    t = linspace(c.data(5),c.data(6),nn);
                    [x,y] = evalParabola(c.data(1),c.data(2),c.data(3),...
                        c.data(4),t);
                case obj.SPLINE
                    ix = (length(c.data)-5)/2;
                    [x,y,~] = evalSpline(c.data(end-4),c.data(1:ix),c.data(ix+1:end-5),...
                        [c.data(end-3),c.data(end-2)],[c.data(end-1),c.data(end)],nn);
                otherwise
                    error('Unknown curve type.')
            end
            if isrow(x)
                x = x';
            end
            if isrow(y)
                y = y';
            end
        end

        function checkCurveClose(obj)
            N=getNcrv(obj);
            tol = (0.01*obj.Dtol)^2;
            for i=1:N-1
                p1=GetPoint(obj.Point,i);
                p2=GetPoint(obj.Point,i+1);
                p1e=p1(end,:);
                p2s=p2(1,:);
                dist=sqrt((p1e(1,1)-p2s(1,1))^2-(p1e(1,2)-p2s(1,2))^2);
                if dist>tol
                    obj.Close=0;
                    break
                end
            end
            p1=GetPoint(obj.Point,N);
            p2=GetPoint(obj.Point,1);
            p1e=p1(end,:);
            p2s=p2(1,:);
            dist=sqrt((p1e(1,1)-p2s(1,1))^2-(p1e(1,2)-p2s(1,2))^2);
            if dist>tol
                obj.Close=0;
            end

            if obj.Close~=0
                obj.Close=1;
            elseif isempty(obj.Close)
                obj.Close=1;
            else
                warning('Curve is not closed');
            end
        end

    end
end


% PRIVATE FUNCTIONS
function L = lengthOfEllipse(a,b,t1,t2)
L = integral(@fun,t1,t2)*pi/180;
    function dL = fun(t)
        dx = -a*sind(t);
        dy = b*cosd(t);
        dL = sqrt(dx.^2 + dy.^2);
    end
end

function L = lengthOfHyperbola(a,b,t1,t2)
L = integral(@fun,t1,t2);
    function dL = fun(t)
        dx = a*sinh(t);
        dy = b*cosh(t);
        dL = sqrt(dx.^2 + dy.^2);
    end
end

function L = lengthOfParabola(f,t1,t2)
L = integral(@fun,t1,t2);
    function dL = fun(t)
        dx = 2*f*t;
        dy = 2*t;
        dL = sqrt(dx.^2 + dy.^2);
    end
end

function ok = isCurveSimple(id,x,y,Echo)
%ISCURVESIMPLE Check polyline if there is are intersecting segments. Return true is
% polyline is non-self intersecting.
tol = 1e-8;
nseg = length(x)-1;
for i = 1:nseg-1
    x1 = x(i);
    y1 = y(i);
    x2 = x(i+1);
    y2 = y(i+1);
    xmin = min(x1,x2);
    ymin = min(y1,y2);
    xmax = max(x1,x2);
    ymax = max(y1,y2);
    for j = i+1:nseg
        x3 = x(j);
        y3 = y(j);
        x4 = x(j+1);
        y4 = y(j+1);
        if min(y3,y4) > ymax || max(y3,y4) < ymin || ...
                min(x3,x4) > xmax || max(x3,x4) < xmin
            continue
        end
        d = x1*y3-x1*y4-x2*y3+x2*y4-x3*y1+x3*y2+x4*y1-x4*y2;
        if d == 0
            continue
        end
        t1 = ((y3-y4)*x1+(-y1+y4)*x3+x4*(y1-y3))/d;
        t2 = ((-y2+y3)*x1+(y1-y3)*x2-x3*(y1-y2))/d;
        if t1 > tol && t1 < 1-tol && t2 > tol && t2 < 1-tol
            ok = false;
            if Echo
                fprintf('Curve %d: segments #%d and #%d intersect.\n',id,i,j)
            end
            return
        end
    end
end
ok = true;
end


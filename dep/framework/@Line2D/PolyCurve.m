function [x,y] = PolyCurve( obj, id, varargin)
% Polynomal approx. of the curve

k=inputParser;
addParameter(k,'hmax',0);
addParameter(k,'opt',0);
parse(k,varargin{:});
set=k.Results;
% default values
nn   = obj.CN(id);
hmax = set.hmax;
opt  =set.opt;

if obj.CT(id) ~= obj.LINE && obj.CT(id) ~= obj.CURVE
    if hmax > 0
        if obj.CL0(id) > hmax
            nn = max(nn,ceil(obj.CL(id)/hmax));
        end
    end
end

if obj.CT(id) ~= obj.LINE && obj.CT(id) ~= obj.CURVE
    if mod(nn,2) == 0 && opt
        nn = nn + 1; % for check of gtol
    end
else
    opt = false;  % Optimization is meaningless
end

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
        t = linspace(sa,sa+da,nn)';
        [x,y] = evalCircle(c.data(2),c.data(3),c.data(1),t);
    case obj.CURVE
        ix = length(c.data)/2;
        x = c.data(1:ix);
        y = c.data(ix+1:end);
        return
    case obj.ELLIPSE
        sa = c.data(6);
        da = c.data(7);
        t = linspace(sa,sa+da,nn)';
        [x,y] = evalEllipse(c.data(1),c.data(2),c.data(3),...
            c.data(4),c.data(5),t);
    case obj.HYPERBOLA
        t = linspace(c.data(6),c.data(7),nn)';
        [x,y] = evalHyperbola(c.data(1),c.data(2),c.data(3),...
            c.data(4),c.data(5),t);
    case obj.LINE
        t = linspace(0,1,nn)';
        [x,y] = evalLine(c.data(1),c.data(2),c.data(3),c.data(4),t);
        return
    case obj.PARABOLA
        t = linspace(c.data(5),c.data(6),nn)';
        [x,y] = evalParabola(c.data(1),c.data(2),c.data(3),...
            c.data(4),t);
    case obj.SPLINE
        ix = (length(c.data)-5)/2;
        [x,y,~] = evalSpline(c.data(end-4),c.data(1:ix),c.data(ix+1:end-5),...
            [c.data(end-3),c.data(end-2)],[c.data(end-1),c.data(end)],nn);
    case obj.NURB
        ix = length(c.data)/2;
        x = c.data(1:ix);
        y = c.data(ix+1:end);
        return
end
if isrow(x)
    x = x';
end
if isrow(y)
    y = y';
end
if ~opt
    return
end
%TODO
xe = x(end);
ye = y(end);
isw = 0;
if x(1) == xe && y(1) == ye
    isw = 1;
end
id = zeros(length(x),1);
for i = 1:2:length(x) - 2
    L = norm([x(i+2)-x(i),y(i+2)-y(i)]);
    if L == 0
        continue
    end
    d = distPL([x(i+2),y(i+2)],[x(i),y(i)],[x(i+1),y(i+1)]);
    e = d/L;
    if e < 0.2*obj.Gtol
        id(i+1) = 1;
    end
end
x = x(id == 0);
y = y(id == 0);
if isw == 1
    % close curve
    if  x(1) ~= x(end) ||  y(1) ~= y(end)
        error('Closed curve %d become open after optimisation.',id)
    end
end
end


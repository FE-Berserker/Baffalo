function [x, y, th] = evalSpline(ctype, xv, yv, u, v, np)
%EVALSPLINE  Calculate points that form a cubic spline curve
%
%Usage:
%   [x, y, t, tv, th] = evalSpline(xc,yc)
%
%Input:
%   ctype   --  type of spline: 1=cubic, 2=Wilson-Fowler
%   xv,yv   --  control points
%   u, v    --  end vectors
%   np      --  number of points on the curve
%
%Output:
%   x,y     --  the points of the curve
%   th      --  tangent angle at end points in degrees
%

narginchk(6,6)
nargoutchk(3,3)

validateattributes(xv, {'numeric'}, {'real', 'vector'});
validateattributes(yv, {'numeric'}, {'real', 'vector'});
if ~isequal(length(xv),length(yv))
    error('The size of xv and yv must be equal.')
end
validateattributes(np, {'numeric'}, {'>',2,'integer', 'scalar'});

% calculate parameter
tv = zeros(size(xv));
tv(1) = 0;
for k = 2:length(xv)
    switch ctype
        case 1
            tv(k) = tv(k-1) + 1;
        case 2
            tv(k) = tv(k-1) + sqrt((xv(k) - xv(k-1))^2 + (yv(k) - yv(k-1))^2);
        otherwise
            error('Invalid spline type %d.',ctype)
    end
end

% calculate piecewise polynomal
if isempty(u) && isempty(v)
    px = spline(tv,xv);
    py = spline(tv,yv);
else
    if ~isempty(u) && isempty(v)
        v = [0 0];
    elseif  isempty(u) && ~isempty(v)
        u = [0 0];
    end
    px = spline(tv,[ u(1) xv v(1)]);
    py = spline(tv,[ u(2) yv v(2)]);
end

% calculate values
t = linspace(0,tv(end),np);
x = ppval(px,t);
y = ppval(py,t);

[~,coefs1,~,~,~] = unmkpp(px);
[~,coefs2,l2,~,~] = unmkpp(py);
th(1) = atan2d(coefs2(1,3),coefs1(1,3));
t2 = t(end)-tv(k-1);
th(2) = atan2d(3*coefs2(l2,1)*t2^2+2*coefs2(l2,2)*t2+coefs2(l2,3),...
    3*coefs1(l2,1)*t2^2+2*coefs1(l2,2)*t2+coefs1(l2,3));
end


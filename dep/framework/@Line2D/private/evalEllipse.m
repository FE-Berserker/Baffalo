function [x, y] = evalEllipse( a, b, xc, yc, rot, th)
%EVALELLIPSE Compute the points on the ellipse.
%
% Usage:
%   [x, y] = evalEllipse( a, b, xc, yc, rot, th )
%
% Input:
%   a,b      -- semi major and semin minor axes
%   xc, yc   -- center coordinates
%   rot      -- angle of rotation about center in degrees
%   th       -- angle in degrees
%
% Output:
%   x, y     --- points on ellipse
%

narginchk(6,6)
nargoutchk(2,2)

validateattributes(a,   {'numeric'}, {'positive', 'real', 'scalar'});
validateattributes(b,   {'numeric'}, {'positive', 'real', 'scalar'});
validateattributes(xc,  {'numeric'}, {'real', 'scalar'});
validateattributes(yc,  {'numeric'}, {'real', 'scalar'});
validateattributes(rot, {'numeric'}, {'real', 'scalar'});
validateattributes(th,  {'numeric'}, {'real', 'vector'});

xx = a*cosd(th);
yy = b*sind(th);

[x,y] = trRot2d( xx, yy, xc, yc, rot);

end



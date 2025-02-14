function [x, y] = evalHyperbola( a, b, xc, yc, rot, t)
%EVALHYPERBOLA Compute the points on the hyperbola.
%
% Usage:
%   [x, y] = evalHyperbola( a, b, xc, yc, rot, t )
%
% Input:
%   a, b     -- major and minor semi axes
%   xc, yc   -- center coordinates
%   rot      -- angle of rotation about center in degrees
%   t        -- parameter
%
% Output:
%   x, y     -- points on parabola
%

narginchk(6,6)
nargoutchk(2,2)

validateattributes(a,   {'numeric'}, {'positive', 'real', 'scalar'});
validateattributes(b,   {'numeric'}, {'positive', 'real', 'scalar'});
validateattributes(xc,  {'numeric'}, {'real', 'scalar'});
validateattributes(yc,  {'numeric'}, {'real', 'scalar'});
validateattributes(rot, {'numeric'}, {'real', 'scalar'});
validateattributes(t,   {'numeric'}, {'real', 'vector'});

xx = a*cosh(t);
yy = b*sinh(t);

[x,y] = trRot2d( xx, yy, xc, yc, rot);

end


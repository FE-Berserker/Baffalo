function [x, y] = evalParabola( f, xc, yc, rot, t)
%EVALPARABOLA Compute the points on the parabola.
%
% Usage:
%   [x, y] = evalParabola( f, xc, yc, rot, t )
%
% Input:
%   f        -- focal distance
%   xc, yc   -- center (appex)
%   rot      -- angle of rotation about center in degrees
%   t        -- values of parameter
%
% Output:
%   x, y     -- points on parabola
%
% Note:
%   The eqation of parabola is y^2 = 4*f*x.

narginchk(5,5)
nargoutchk(2,2)

validateattributes(f,   {'numeric'}, {'positive', 'real', 'scalar'});
validateattributes(xc,  {'numeric'}, {'real', 'scalar'});
validateattributes(yc,  {'numeric'}, {'real', 'scalar'});
validateattributes(rot, {'numeric'}, {'real', 'scalar'});
validateattributes(t,   {'numeric'}, {'real', 'vector'});

xx = f*t.^2;
yy = 2*f*t;

[x,y] = trRot2d( xx, yy, xc, yc, rot);

end



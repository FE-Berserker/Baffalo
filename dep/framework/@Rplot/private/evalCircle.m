function [x, y] = evalCircle( xc, yc, r, th)
%EVALCIRCLE Compute the points on a circular arc.
%
% Usage:
%   evalCircle( xc, yc, r, th )
%
% Input:
%   xc, yc   -- center 
%   r        -- radius
%   th       -- angle (in degrees)
% 
% Output:
%   x, y     --- points on circle
%

    narginchk(4,4)
    nargoutchk(2,2)
    
    validateattributes(xc, {'numeric'}, {'real', 'scalar'});    
    validateattributes(yc, {'numeric'}, {'real', 'scalar'});   
    validateattributes(r,  {'numeric'}, {'positive', 'real', 'scalar'});         
    validateattributes(th, {'numeric'}, {'real', 'vector'});    
    
    x = xc + r*cosd(th);
    y = yc + r*sind(th);

end



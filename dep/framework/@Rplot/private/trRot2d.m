function [xx,yy] = trRot2d( x, y, x0, y0, theta)
%TRROT2D  2D rotation.
%
%Usage:
%   [xx,yy] = trRot2d( x, y, x0, y0, theta)
%
%Input:
%   x,y    -v- points coordinates
%   x0,y0  -s- origin
%   theta  -s- rotation angle in degrees
%
%Output:
%   xx, yy -v- transformed points

    narginchk(5,5)
    nargoutchk(2,2)
    
    xx = x0 + x*cosd(theta) - y*sind(theta);
    yy = y0 + x*sind(theta) + y*cosd(theta);
    
end


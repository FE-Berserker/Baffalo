function [x, y] = evalLine( x1, y1, x2, y2, t)
%EVALLINE  Calculate points on the line
%
% Usage:
%   [x,y] = evalLine( x1, y1, x2, y2, t)
%
% Input:
%   x1, y1   --- start point
%   x2, y2   --- end point
%   t        --- paramerter

narginchk(5,5)
nargoutchk(2,2)

validateattributes(x1, {'numeric'}, {'real', 'scalar'});
validateattributes(y1, {'numeric'}, {'real', 'scalar'});
validateattributes(x2, {'numeric'}, {'real', 'scalar'});
validateattributes(y2, {'numeric'}, {'real', 'scalar'});
validateattributes(t,  {'numeric'}, {'real', 'vector'});

x = x1 + (x2 - x1)*t;
y = y1 + (y2 - y1)*t;

end


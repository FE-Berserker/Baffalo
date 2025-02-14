function [x, y] = evalBspline( c, xv, yv, np)
%EVALBSPLINE  Generate B-spline curve
%
%Input:
%   c       -- order of B-spline basis
%   xv, yv  -- coordinates of polygon vertices
%   np      -- number of points generated along the curve
%
%Output:
%   x,y     -- coordinates on B-spline curve. Number of points <= np
%
% Based on: BSPLINE in
%   Rogers, Adams -- Computer graphics, McGraw-Hill 1976
%
narginchk(4,4)
nargoutchk(2,2)

validateattributes(c,  {'numeric'}, {'>',0,'integer', 'scalar'});
validateattributes(xv, {'numeric'}, {'real', 'vector'});
validateattributes(yv, {'numeric'}, {'real', 'vector'});
if ~isequal(length(xv),length(yv))
    error('The size of xv and yv must be equal.')
end
validateattributes(np, {'numeric'}, {'>',2,'integer', 'scalar'});

x  = zeros(np,1);
y  = zeros(np,1);
nn = length(xv) - 1;
kv = knot( xv, yv, nn, c);  % knot vector
N  = zeros(nn+c+1, nn+c+1); % weighting functions
g  = 0;
h  = 0;
j  = 0;
for m = c:nn + 1
    for i = 1:nn + c
        if kv(i) == kv(i+1) || i ~= m
            N(i,1) = 0;
        else
            N(i,1) = 1;
        end
    end
    for t = kv(m):kv(nn+c+1)/(np-1):kv(m+1)-kv(nn+c+1)/(np-1)
        j = j + 1;
        for k = 2:c
            for i = 1:nn+1
                if N(i,k-1) ~= 0
                    d = ((t - kv(i))*N(i,k-1))/(kv(i+k-1) - kv(i));
                else
                    d = 0;
                end
                if N(i+1,k-1) ~= 0
                    e = ((kv(i+k) - t)*N(i+1,k-1))/(kv(i+k) - kv(i+1));
                else
                    e = 0;
                end
                N(i,k) = d + e;
                g = xv(i)*N(i,k) + g;
                h = yv(i)*N(i,k) + h;
            end
            if k == c
                break
            end
            g = 0;
            h = 0;
        end
        x(j) = g;
        y(j) = h;
        g = 0;
        h = 0;
    end
end
j = j + 1;
x(j) = xv(nn+1);
y(j) = yv(nn+1);
if j < np
    x(j+1:end) =[];
    y(j+1:end) =[];
end
end

function kv = knot( xv, yv, n, c)
%KNOT Generate knot vector
m  = n + c + 1;
kv = zeros(m,1);
for i = 1:m
    if i <= c
        kv(i) = 0;
        continue
    end
    if i >= n + 3
        kv(i) = kv(i-1);
        continue
    end
    % check repeating vertices
    if xv(i-c) ~= xv(i+1-c) || yv(i-c) ~= yv(i+1-c)
        % assign sucessive internal vectors
        kv(i) = kv(i-1) + 1;
    else
        % assign multiple or duplicate knot
        kv(i) = kv(i-1);
    end
end
end

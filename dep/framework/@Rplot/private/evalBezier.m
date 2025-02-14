function [x,y] = evalBezier( xv, yv, tt) 
%EVALBEZIER  Calculate points that form a Bezier curve
%
%Usage:
%   [x,y] = evalBezier(xv,yv,tt)
%
%Input:
%   xv,yv   --  control points 
%   tt      --  paramerer: 0<=tt<=1 
%
%Output:
%   x,y     --  the points on the curve
%
%Literature:
%   Rogers, Adams -- Mathematical Elements for Computer Graphics, pp 225-226
%

    narginchk(3,3)
    nargoutchk(2,2)
      
    validateattributes(xv, {'numeric'}, {'real', 'vector'});    
    validateattributes(yv, {'numeric'}, {'real', 'vector'});
    if ~isequal(length(xv),length(yv))
        error('The size of xv and yv must be equal.')
    end    
    validateattributes(tt, {'numeric'}, {'real', 'vector'});
    if min(tt) < 0 || max(tt) > 1
        error('A value of parameter is outside interval [0,1].')
    end
    
    % initialize
    x  = zeros(size(tt));
    y  = zeros(size(tt));    
    n1 = length(xv);         % number of control points
    C  = zeros(n1,1);        % binomial coefficients
    n  = n1 - 1;
    
    % calaculate binomila coefficients
    C(1)  = 1;
    C(n1) = 1;
    for i = 1:n-1
        C(i+1) = nchoosek(n,i);
    end

    %calculate coordinates
    k = 0;
    J = zeros(size(xv));
    for t = tt 
        for i = 0:n
            J(i+1) = C(i+1)*t^i*(1 - t)^(n - i);
        end
        k = k + 1;       
        x(k) = dot(J,xv);
        y(k) = dot(J,yv);        
    end

end


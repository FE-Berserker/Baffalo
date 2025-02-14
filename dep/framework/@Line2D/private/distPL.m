function [d,t] = distPL(x1,x2,x)
%DISTPL calculate distance from point (x) to line given by points x1 and x2.
%
%   t - line parameter
%   d - distance
%
    dx = x2(1) - x1(1);
    dy = x2(2) - x1(2);
    L = sqrt(dx^2 + dy^2);
    if L == 0
        % point distance
        t = 0;
        d = sqrt((x1(1) - x(1))^2 + (x1(2) - x(2))^2);
        return
    end
    t = (dx*(x(1) - x1(1)) + dy*(x(2) - x1(2)))/L^2;
    d = abs(dx*(x(2) - x1(2)) - dy*(x(1) - x1(1)))/L;
end


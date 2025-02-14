function [x0,y0]= CurveIntersection(obj,l1,l2)
% Calculate the curve intersection
[x1,y1] = PolyCurve(obj,l1);
[x2,y2] = PolyCurve(obj,l2);

[x0,y0]=curve_intersections(x1,y1,x2,y2,1);
%% Print
if obj.Echo
    fprintf('Successfully calculate the intersections .\n');
end
end


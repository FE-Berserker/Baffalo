function [x0,y0]= CurveIntersection(obj,l1,l2)
% Calculate the curve intersection
[x1,y1] = PolyCurve(obj,l1);
[x2,y2] = PolyCurve(obj,l2);

[x0,y0]=curve_intersections(x1,y1,x2,y2,1);

if isempty(x0)
    P = InterX([x1';y1'],[x2;y2]);
    if ~isempty(P)
        x0=P(1);
        y0=P(2);
    else
        warning('No intersections found !')
    end
end

%% Print
if obj.Echo
    fprintf('Successfully calculate the intersections .\n');
end
end


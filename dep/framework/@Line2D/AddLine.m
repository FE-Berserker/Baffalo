function obj=AddLine(obj,Point2D,P)
% Add line

if numel(Point2D.PP{P,1})~=4
    error('The Line only contains 2 points')
end
x1=Point2D.PP{P,1}(1,1);
y1=Point2D.PP{P,1}(1,2);
x2=Point2D.PP{P,1}(2,1);
y2=Point2D.PP{P,1}(2,2);

%% Parse
[obj,~]=addCurve_(obj,obj.LINE,[x1, y1, x2, y2]');

%% Print
if obj.Echo
    fprintf('Successfully add line .\n');
end
end


function obj=AddCurve(obj,Point2D,P)
% Add XY coordinates of curve
% Author : Xie Yu

x=Point2D.PP{P,1}(:,1);
y=Point2D.PP{P,1}(:,2);

%% Parse
[obj,~]=addCurve_(obj,obj.CURVE,[x;y]);

%% Print
if obj.Echo
    fprintf('Successfully add curve .\n');
    tic
end
end


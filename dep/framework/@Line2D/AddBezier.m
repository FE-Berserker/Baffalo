function obj=AddBezier(obj,Point2D,P)
% Add Bezier curve.

x=Point2D.PP{P,1}(:,1);
y=Point2D.PP{P,1}(:,2);

if ~isequal(length(x),length(y))
    error('The size of x and y must be equal.')
end

if length(x) < 3
    error('Polygon must contains at least 2 verices.')
end

x = x';
y = y';

%% Parse
[obj,~]=addCurve_(obj,obj.BEZIER,[x y]');

%% Print
if obj.Echo
    fprintf('Successfully add besizer curve .\n');
    tic
end

end


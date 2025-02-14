function obj=AddBspline( obj, c, Point2D, P )
% Add B-spline curve.

x=Point2D.PP{P,1}(:,1);
y=Point2D.PP{P,1}(:,2);

% check input
if ~isequal(length(x),length(y))
    error('The size of x and y must be equal.')
end
validateattributes(c, {'numeric'},...
    {'>',0,'<=',length(x),'integer', 'scalar'});

x = x';
y = y';

%% Parse
[obj,~]=addCurve_(obj,obj.BSPLINE,[x y c]');

%% Print
if obj.Echo
    fprintf('Successfully add bspline curve .\n');
    tic
end
end


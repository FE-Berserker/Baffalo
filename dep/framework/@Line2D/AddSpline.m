function obj=AddSpline( obj, ctype, Point2D, P, varargin )
% Add cubic spline curve.

k=inputParser;
addParameter(k,'a1',[]);
addParameter(k,'a2',[]);
addParameter(k,'s1',[0,0]);
addParameter(k,'s2',[0,0]);
parse(k,varargin{:});
opt=k.Results;

% default values
u=opt.s1;
v=opt.s2;

if ~isempty(opt.a1)
    u=[cosd(opt.a1),sind(opt.a1)];
end

if ~isempty(opt.a2)
    v=[cosd(opt.a2),sind(opt.a2)];
end

x=Point2D.PP{P,1}(:,1);
y=Point2D.PP{P,1}(:,2);

if ~isequal(length(x),length(y))
    error('The size of x and y must be equal.')
end

x = x';y = y';

%% Parse
[obj,~]=addCurve_(obj,obj.SPLINE,[x y ctype u v]');

%% Print
if obj.Echo
    fprintf('Successfully add spline .\n');
    tic
end
end


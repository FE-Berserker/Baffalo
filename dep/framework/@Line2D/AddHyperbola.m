function obj=AddHyperbola( obj, a, b,Point2D,P, varargin )
% Add hyperbola curve

k=inputParser;
addParameter(k,'rot',0);
addParameter(k,'t1',[]);
addParameter(k,'t2',[]);
parse(k,varargin{:});
opt=k.Results;
% default values
rot  = opt.rot;
t1=opt.t1;
t2=opt.t2;

% check input
xc=Point2D.PP{P,1}(:,1);
yc=Point2D.PP{P,1}(:,2);

%% Parse
[obj,~]=addCurve_( obj, obj.HYPERBOLA, [a, b, xc, yc, rot, t1, t2]');

%% Print
if obj.Echo
    fprintf('Successfully add hyperbola .\n');
    tic
end
end


function obj=AddParabola( obj,f,Point2D,P,varargin )
% Add parabolic.
k=inputParser;
addParameter(k,'rot',0);
addParameter(k,'t1',[]);
addParameter(k,'t2',[]);
parse(k,varargin{:});
opt=k.Results;
% default values
rot  = opt.rot;
t1  = opt.t1;
t2  = opt.t2;
  
xv=Point2D.PP{P,1}(:,1);
yv=Point2D.PP{P,1}(:,2);

%% Parse
[obj,~]=addCurve_(obj,obj.PARABOLA,[ f, xv, yv, rot, t1, t2]');

%% Print
if obj.Echo
    fprintf('Successfully add parabolic .\n');
    tic
end
    
end


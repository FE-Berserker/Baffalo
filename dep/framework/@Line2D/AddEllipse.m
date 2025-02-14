function obj=AddEllipse( obj, a, b,Point2D,P, varargin )
% Add elliptic arc.
k=inputParser;
addParameter(k,'rot',0);
addParameter(k,'sang',0);
addParameter(k,'ang',360);
addParameter(k,'seg',[]);
parse(k,varargin{:});
opt=k.Results;

% default values
rot=opt.rot;
sang=opt.sang;
ang=opt.ang;

xc=Point2D.PP{P,1}(1,1);
yc=Point2D.PP{P,1}(1,2);

%adjust angles
sang = sign(sang)*mod(abs(sang),360);
if sang < 0
    sang = sang + 360;
end
ang  = sign(ang)*mod(abs(ang),360);
if sang == 0 && ang == 0
    ang = 360;
end

%% Parse
if ~isempty(opt.seg)
    [obj,~]=addCurve_( obj, obj.ELLIPSE, [a, b, xc, yc, rot, sang, ang]','seg',opt.seg+1);
else
    [obj,~]=addCurve_( obj, obj.ELLIPSE, [a, b, xc, yc, rot, sang, ang]');    
end

%% Print
if obj.Echo
    fprintf('Successfully add ellipse .\n');
    tic
end
end


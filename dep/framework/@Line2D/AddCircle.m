function obj=AddCircle(obj,r,Point2D,P,varargin)
% Add circle or circular arc
k=inputParser;
addParameter(k,'sang',0);
addParameter(k,'ang',360);
addParameter(k,'seg',[]);
parse(k,varargin{:});
opt=k.Results;

xc=Point2D.PP{P,1}(1,1);
yc=Point2D.PP{P,1}(1,2);

%default values
sang = opt.sang;
ang  = opt.ang;

%adjust angles
sang = sign(sang)*mod(abs(sang),360);
if sang < 0
    sang = sang + 360;
end
ang  = sign(ang)*mod(abs(ang),360);
if sang == 0 && ang == 0
    ang = 360;
end
 
if ang==0
    ang=360;
end
%% Parse
if ~isempty(opt.seg)
    [obj,~]=addCurve_(obj,obj.CIRCLE,[ r, xc, yc, sang, ang]','seg',opt.seg+1);
else
    [obj,~]=addCurve_(obj,obj.CIRCLE,[ r, xc, yc, sang, ang]');
end

%% Print
if obj.Echo
    fprintf('Successfully add circle .\n');
    tic
end
    
end


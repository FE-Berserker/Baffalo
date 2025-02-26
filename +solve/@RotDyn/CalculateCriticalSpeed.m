function obj=CalculateCriticalSpeed(obj,varargin)
% Calculate critical speed
% Author : Xie Yu
p=inputParser;
addParameter(p,'Mul',1);% Frequency multiplier
addParameter(p,'NMode',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.NMode)
    opt.NMode=obj.params.NMode;
end

if isempty(obj.output.Campbell)
    obj=ImportCampbell(obj,'Campbell.txt',opt.NMode);
end
X=obj.input.Speed;
Y=table2array(obj.output.Campbell(:,3:end));

Y1st=X/60;
YY=Y1st*opt.Mul;

a=Point2D('Temp Point','Echo',0);
a=AddPoint(a,X',YY');
for i=1:size(Y,1)
    a=AddPoint(a,X',Y(i,:)');
end
b=Line2D('Speed Calculation','Echo',0);
for i=1:size(Y,1)+1
    b=AddCurve(b,a,i);
end

CriticalSpeed=[];
for i=1:size(Y,1)
    [x0,~]=CurveIntersection(b,1,i+1);
    CriticalSpeed=[CriticalSpeed;x0]; %#ok<AGROW> 
end

obj.output.CriticalSpeed=CriticalSpeed;

end
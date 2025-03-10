function obj=AddRoundPolygon(obj,r,seg,fillet,varargin)
% Add round polygon to Line2D
% Author : Xie Yu

%default values
k=inputParser;
addParameter(k,'sang',0);
parse(k,varargin{:});
opt=k.Results;

sang = opt.sang;

angle=linspace(0,360,seg+1);
x=r.*cos(angle/180*pi);
y=r.*sin(angle/180*pi);

xx=x.*cos(sang/180*pi)-y.*sin(sang/180*pi);
yy=x.*sin(sang/180*pi)+y.*cos(sang/180*pi);

b=Line2D('Temp Line','Echo',0);
a=Point2D('Temp Point','Echo',0);
for i=1:size(xx,2)-1
    a=AddPoint(a,[xx(i);(xx(i)+xx(i+1))/2;xx(i+1)],[yy(i);(yy(i)+yy(i+1))/2;yy(i+1)]);
end
for i=1:size(xx,2)-1
    b=AddCurve(b,a,i);
end

for i=1:2:2*size(xx,2)-3
    b=CreateRadius(b,i,fillet);
end

a=Point2D('Temp Point','Echo',0);
a=AddPoint(a,b.Point.P(:,1),b.Point.P(:,2));
obj=AddCurve(obj,a,1);

%% Print
if obj.Echo
    fprintf('Successfully add round polygon .\n');
    tic
end
end


function obj=AddPolygon(obj,r,seg,varargin)
% Add polygon to Line2D
% Author : Xie Yu

%default values
k=inputParser;
addParameter(k,'sang',0);
addParameter(k,'close',1);
parse(k,varargin{:});
opt=k.Results;

sang = opt.sang;

angle=linspace(0,360,seg+1);
x=r.*cos(angle/180*pi);
y=r.*sin(angle/180*pi);

xx=x.*cos(sang/180*pi)-y.*sin(sang/180*pi);
yy=x.*sin(sang/180*pi)+y.*cos(sang/180*pi);

a=Point2D('p','Echo',0);
if opt.close==1
    a=AddPoint(a,xx',yy');
else
    a=AddPoint(a,xx(1:end-1)',yy(1:end-1)');
end
obj=AddCurve(obj,a,1);
   
%% Print
if obj.Echo
    fprintf('Successfully add polygon .\n');
end

end


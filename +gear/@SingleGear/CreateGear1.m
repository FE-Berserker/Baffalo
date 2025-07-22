function obj=CreateGear1(obj)
% Create gear according to tool
% Author : Xie Yu

Tool=obj.output.Tool;
b=obj.output.ToolCurve;
r=Tool.mn*obj.input.Z/2;
rf=obj.output.df/2;
ra=obj.output.da/2;
Z=obj.input.Z;
%% Main

% phia
% xm=obj.input.x*Tool.mn;
xm=obj.output.xt*Tool.mn;% 变位量
yw=interp1(b.Point.PP{3,1}(:,1),b.Point.PP{3,1}(:,2),0,'spline');
hwf=Tool.hap+xm;
phia=(-hwf/(cos(Tool.alphap/180*pi)*sin(Tool.alphap/180*pi))+yw)/r/pi*180;
%phib
x0b=b.Point.PP{3,1}(1,1);
y0b=b.Point.PP{3,1}(1,2);
phib=(x0b/tan(Tool.alphap/180*pi)+y0b)/r/pi*180;
%phic
xc=Tool.cp+Tool.hap-xm-Tool.rho_fp*Tool.mn;
yc=b.Point.PP{2,1}(1,2);
Gamma1=0;
Gamma2=90-Tool.alphap;
phic1=yc/r/pi*180;
phic2=(tan(Gamma2/180*pi)*xc+yc)/r/pi*180;

% H-G curve
xHG=NaN(21,1);
yHG=NaN(21,1);
for i=1:21
    Gamma=Gamma1+(Gamma2-Gamma1)/20*(i-1);
    phi=(tan(Gamma/180*pi)*xc+yc)/r/pi*180;
    x0HG=xc+Tool.rho_fp*Tool.mn*cos(Gamma/180*pi);
    y0HG=yc-Tool.rho_fp*Tool.mn*sin(Gamma/180*pi);
    xHG(i,1)=(r-x0HG).*cos(phi./180*pi)+(r*phi./180*pi-y0HG).*sin(phi./180*pi)-rf*cos(pi/Z);
    yHG(i,1)=(r-x0HG).*sin(phi./180*pi)-(r*phi./180*pi-y0HG).*cos(phi./180*pi);
end
% G-K curve
xGK=NaN(201,1);yGK=NaN(201,1);

x0=b.Point.PP{3,1}(:,1);
y0=b.Point.PP{3,1}(:,2);
for i=1:201
    phi=phic2+(phia-phic2)/200*(i-1);
    yN1=r*phi/180*pi;xN1=0;
    yN2=0;xN2=r*phi/180*pi*tan(Tool.alphap/180*pi);
    fun=@(x)((yN2-yN1)/(xN2-xN1)*x+yN1);
    a=Point2D('Temp','Echo',0);
    a=AddPoint(a,[2*max(x0);2*min(x0)],[fun(2*max(x0));fun(2*min(x0))]);
    a=AddPoint(a,x0,y0);
    b1=Line2D('Temp','Echo',0);
    b1=AddLine(b1,a,1);
    b1=AddCurve(b1,a,2);
    [x1,y1]=CurveIntersection(b1,1,2);
    x2=(r-x1).*cos(phi./180*pi)+(r*phi./180*pi-y1).*sin(phi./180*pi)-rf*cos(pi/Z);
    y2=(r-x1).*sin(phi./180*pi)-(r*phi./180*pi-y1).*cos(phi./180*pi);
    xGK(i,1)=x2(1,1);
    yGK(i,1)=y2(1,1);
end


rGK=sqrt((xGK+rf*cos(pi/Z)).^2+yGK.^2);
Tempx=interp1(rGK,xGK,ra,'spline');
Tempy=interp1(rGK,yGK,ra,'spline');
xGK=xGK(rGK<ra,1);
yGK=yGK(rGK<ra,1);
xGK=[xGK;Tempx];
yGK=[yGK;Tempy];

a=Point2D('Points','Echo',0);
a=AddPoint(a,-rf*cos(pi/Z),0);
a=AddPoint(a,xHG,yHG);
a=AddPoint(a,xGK,yGK);
a=AddPoint(a,flip(xGK),flip(-yGK));
a=AddPoint(a,flip(xHG),flip(-yHG));


b2=Line2D('GearCurve','Echo',0);
ang1=atan(yHG(1,1)/(xHG(1,1)+rf*cos(pi/Z)))/pi*180-pi/Z/pi*180;
b2=AddCircle(b2,rf,a,1,'sang',pi/Z/pi*180,'ang',ang1,'seg',4);
b2=AddCurve(b2,a,2);
b2=AddCurve(b2,a,3);
sang2=atan(Tempy/(Tempx+rf*cos(pi/Z)))/pi*180;
ang2=-sang2;
b2=AddCircle(b2,ra,a,1,'sang',sang2,'ang',ang2,'seg',4);
b2=AddCircle(b2,ra,a,1,'sang',0,'ang',ang2,'seg',4);
b2=AddCurve(b2,a,4);
b2=AddCurve(b2,a,5);
b2=AddCircle(b2,rf,a,1,'sang',-pi/Z/pi*180-ang1,'ang',ang1,'seg',4);

%% Parse
obj.output.GearCurve=b2;


end
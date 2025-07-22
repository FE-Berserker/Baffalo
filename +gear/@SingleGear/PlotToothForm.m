function PlotToothForm(obj)
% Plot tooth form
% Author : Xie Yu

db=obj.output.db;
da=obj.output.da;

%% Main
a=Point2D('Temp');
a=AddPoint(a,0,0);



alphaa=acos(db/da)/pi*180;
alpha=0:alphaa/100:alphaa;
x=db/2*cos(INV(alpha)/180*pi)./cos(alpha/180*pi);
y=db/2*sin(INV(alpha)/180*pi)./cos(alpha/180*pi);
a=AddPoint(a,x',y');


b=Line2D('Tooth form');
b=AddCircle(b,db/2,a,1);
b=AddCurve(b,a,2);
Plot(b,'equal',1,'color',1)

%% Print
if obj.params.Echo
    fprintf('Successfully plot tooth form .\n');
end
end
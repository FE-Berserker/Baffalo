clc
clear
close all
%% Parameter
load('..\Params.mat');

%% Main
r1=81/2;
r2=52/2;
r3=Params.Shaft2_D/2;
rp=60/2;
a=Point2D('Points assembly');
a=AddPoint(a,0,0);
b1=Line2D('OutLine');
b1=AddCircle(b1,r1,a,1);
b2=Line2D('MidLine');

a=AddPoint(a,rp,0);
a=AddPoint(a,0,rp);
a=AddPoint(a,-rp,0);
a=AddPoint(a,0,-rp);

ang1=acos((9^2+rp^2-r2^2)/(2*rp*9))/pi*180;
ang2=acos((r2^2+rp^2-9^2)/(2*r2*rp))/pi*180;
for i=1:4
b2=AddCircle(b2,9,a,i+1,'sang',180+ang1+90*(i-1),'ang',-ang1*2);
b2=AddCircle(b2,r2,a,1,'sang',ang2+90*(i-1),'ang',90-ang2*2);
end

b3=Line2D('InnerLine');
b3=AddCircle(b3,r3,a,1);
h1=Line2D('Hole');
h2=Line2D('Hole');
h3=Line2D('Hole');
h4=Line2D('Hole');

h1=AddCircle(h1,8.1/2,a,2);
h2=AddCircle(h2,15/2,a,3);
h3=AddCircle(h3,8.1/2,a,4);
h4=AddCircle(h4,15/2,a,5);
inputFlange2.OutLine=b1;
inputFlange2.MidLine=b2;
inputFlange2.InnerLine=b3;
inputFlange2.BossHeight=18;
inputFlange2.PlateThickness=8;
inputFlange2.Meshsize=5;
inputFlange2.OuterHole=[h1;h2;h3;h4];
paramsFlange2.Type=1;
Flange2= plate.BossPlate(paramsFlange2, inputFlange2);
Flange2= Flange2.solve();
mm=Flange2.output.SolidMesh;
Cb=mm.Cb;
Vm=PatchCenter(mm);
r=sqrt(Vm(:,1).^2+Vm(:,2).^2);
Cb(r<=r3,:)=31;
mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
Flange2.output.SolidMesh=mm;
Flange2=OutputAss(Flange2);
Plot3D(Flange2);
%% Parse
Params.Flange2_Length=inputFlange2.PlateThickness+inputFlange2.BossHeight;
Params.Flange2_Assembly_X=Params.Shaft2_Assembly_X  ;
Params.Flange2_Dp=rp*2;
%% Save
save ..\Params Params
save Flange2 Flange2

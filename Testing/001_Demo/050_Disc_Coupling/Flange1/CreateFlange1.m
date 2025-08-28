clc
clear
close all
%% Parameter
load('..\Params.mat');

%% Main
r1=81/2;
r2=42/2;
r3=Params.Shaft1_D/2;
rp=60/2;
a=Point2D('Points assembly');
a=AddPoint(a,0,0);
b1=Line2D('OutLine');
b1=AddCircle(b1,r1,a,1);
b2=Line2D('MidLine');
b2=AddCircle(b2,r2,a,1);
b3=Line2D('InnerLine');
b3=AddCircle(b3,r3,a,1);
h1=Line2D('Hole');
h2=Line2D('Hole');
h3=Line2D('Hole');
h4=Line2D('Hole');
a=AddPoint(a,rp,0);
a=AddPoint(a,0,rp);
a=AddPoint(a,-rp,0);
a=AddPoint(a,0,-rp);
h1=AddCircle(h1,8.1/2,a,2);
h2=AddCircle(h2,15/2,a,3);
h3=AddCircle(h3,8.1/2,a,4);
h4=AddCircle(h4,15/2,a,5);
inputFlange1.OutLine=b1;
inputFlange1.MidLine=b2;
inputFlange1.InnerLine=b3;
inputFlange1.BossHeight=18;
inputFlange1.PlateThickness=8;
inputFlange1.Meshsize=5;
inputFlange1.OuterHole=[h1;h2;h3;h4];
paramsFlange1.Type=1;
Flange1= plate.BossPlate(paramsFlange1, inputFlange1);
Flange1= Flange1.solve();
mm=Flange1.output.SolidMesh;
Cb=mm.Cb;
Vm=PatchCenter(mm);
r=sqrt(Vm(:,1).^2+Vm(:,2).^2);
Cb(r<=r3,:)=31;
mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
Flange1.output.SolidMesh=mm;
Flange1=OutputAss(Flange1);
Plot3D(Flange1);
%% Parse
Params.Flange1_Length=inputFlange1.PlateThickness+inputFlange1.BossHeight;
Params.Flange1_Assembly_X=0;
Params.Flange1_Dp=rp*2;
%% Save
save ..\Params Params
save Flange1 Flange1

clc
clear
close all
%% Parameter
load('..\Params.mat');

r1=8.1/2;
r2=13/2;
t=Params.Shaft2_Assembly_X-Params.Membrane_Assembly_X2+8;

%% Main
a=Point2D('Point Ass');
a=AddPoint(a,0,0);
b1=Line2D('Line Ass');
b1=AddCircle(b1,r2,a,1);
b2=Line2D('Line Ass');
b2=AddCircle(b2,r1,a,1);
inputBush2.Outline= b1;
inputBush2.Hole= b2;
inputBush2.Thickness = t;
inputBush2.Meshsize=2.5;
paramsBush2= struct();
Bush2=plate.Commonplate(paramsBush2, inputBush2);
Bush2 = Bush2.solve();
Plot3D(Bush2);
%% Parse
Params.Bush2_Thickness=t;
Params.Bush2_Assembly_X1=Params.Washer2_Assembly_X1+8;
Params.Bush2_Assembly_X2=Params.Bush2_Assembly_X1-Params.Membrane_Thickness*Params.Membrane_Num-t;
Params.Bush2_Dp=Params.Tube_Dp2;
Params.Bush2_Num1=2;
Params.Bush2_Num2=2;
%% Save
save ..\Params Params
save Bush2 Bush2

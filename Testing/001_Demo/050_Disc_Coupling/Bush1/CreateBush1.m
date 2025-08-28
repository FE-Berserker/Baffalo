clc
clear
close all
%% Parameter
load('..\Params.mat');

r1=8.1/2;
r2=13/2;
t=Params.Membrane_Assembly_X1+8;

%% Main
a=Point2D('Point Ass');
a=AddPoint(a,0,0);
b1=Line2D('Line Ass');
b1=AddCircle(b1,r2,a,1);
b2=Line2D('Line Ass');
b2=AddCircle(b2,r1,a,1);
inputBush1.Outline= b1;
inputBush1.Hole= b2;
inputBush1.Thickness = t;
inputBush1.Meshsize=2.5;
paramsBush1= struct();
Bush1=plate.Commonplate(paramsBush1, inputBush1);
Bush1 = Bush1.solve();
Plot3D(Bush1);
%% Parse
Params.Bush1_Thickness=t;
Params.Bush1_Assembly_X1=0-8;
Params.Bush1_Assembly_X2=Params.Bush1_Assembly_X1+Params.Membrane_Thickness*Params.Membrane_Num+t;
Params.Bush1_Dp=Params.Tube_Dp1;
Params.Bush1_Num1=2;
Params.Bush1_Num2=2;
%% Save
save ..\Params Params
save Bush1 Bush1

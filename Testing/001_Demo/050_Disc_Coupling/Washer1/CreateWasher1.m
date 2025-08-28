clc
clear
close all
%% Parameter
load('..\Params.mat');

r1=8.1/2;
r2=13/2;
t=Params.Membrane_Assembly_X1;

%% Main
a=Point2D('Point Ass');
a=AddPoint(a,0,0);
b1=Line2D('Line Ass');
b1=AddCircle(b1,r2,a,1);
b2=Line2D('Line Ass');
b2=AddCircle(b2,r1,a,1);
inputWasher1.Outline= b1;
inputWasher1.Hole= b2;
inputWasher1.Thickness = t;
inputWasher1.Meshsize=2.5;
paramsWasher1= struct();
Washer1=plate.Commonplate(paramsWasher1, inputWasher1);
Washer1 = Washer1.solve();
Plot3D(Washer1);
%% Parse
Params.Washer1_Thickness=t;
Params.Washer1_Assembly_X1=0;
Params.Washer1_Assembly_X2=Params.Washer1_Assembly_X1+Params.Membrane_Thickness*Params.Membrane_Num+t;
Params.Washer1_Dp=Params.Tube_Dp1;
Params.Washer1_Num1=2;
Params.Washer1_Num2=2;
%% Save
save ..\Params Params
save Washer1 Washer1

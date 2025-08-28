clc
clear
close all
%% Parameter
load('..\Params.mat');

r1=8.1/2;
r2=15/2;
t=Params.Shaft2_Assembly_X-Params.Membrane_Assembly_X2;

%% Main
a=Point2D('Point Ass');
a=AddPoint(a,0,0);
b1=Line2D('Line Ass');
b1=AddCircle(b1,r2,a,1);
b2=Line2D('Line Ass');
b2=AddCircle(b2,r1,a,1);
inputWasher2.Outline= b1;
inputWasher2.Hole= b2;
inputWasher2.Thickness = t;
inputWasher2.Meshsize=2.5;
paramsWasher2= struct();
Washer2=plate.Commonplate(paramsWasher2, inputWasher2);
Washer2 = Washer2.solve();
Plot3D(Washer2);
%% Parse
Params.Washer2_Thickness=t;
Params.Washer2_Assembly_X1=Params.Shaft2_Assembly_X;
Params.Washer2_Assembly_X2=Params.Washer2_Assembly_X1-Params.Membrane_Thickness*Params.Membrane_Num-t;
Params.Washer2_Dp=Params.Tube_Dp2;
Params.Washer2_Num1=2;
Params.Washer2_Num2=2;
%% Save
save ..\Params Params
save Washer2 Washer2

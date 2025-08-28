clc
clear
close all
%% Parameter
load('..\Params.mat');
lk=Params.Bush1_Thickness+Params.Washer1_Thickness+Params.Membrane_Thickness*Params.Membrane_Num+8;
l=35;
%% Main
inputStruct.d=8;
inputStruct.l=l;
inputStruct.lk=lk;
paramsStruct.ThreadType=1;
paramsStruct.MuG=0.1;
paramsStruct.MuK=0.1;
paramsStruct.v=0.6;
paramsStruct.Nut=1;
paramsStruct.Washer=0;
Bolt1= bolt.Bolt(paramsStruct, inputStruct);
Bolt1= Bolt1.solve();
Plot2D(Bolt1);
Plot3D(Bolt1);
%% Parse
Params.Bolt1_Assembly_X1=Params.Flange1_Assembly_X-8;
Params.Bolt1_Assembly_X2=Params.Bolt1_Assembly_X1+lk;
Params.Bolt1_Dp=Params.Tube_Dp1;
Params.Bolt1_Num1=2;
Params.Bolt1_Num2=2;
%% Save
save ..\Params Params
save Bolt1 Bolt1

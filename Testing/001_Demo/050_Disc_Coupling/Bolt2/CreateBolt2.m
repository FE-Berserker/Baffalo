clc
clear
close all
%% Parameter
load('..\Params.mat');
lk=Params.Bush2_Thickness+Params.Washer2_Thickness+Params.Membrane_Thickness*Params.Membrane_Num+8;
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
Bolt2= bolt.Bolt(paramsStruct, inputStruct);
Bolt2= Bolt2.solve();
Plot2D(Bolt2);
Plot3D(Bolt2);
%% Parse
Params.Bolt2_Assembly_X1=Params.Flange2_Assembly_X+8;
Params.Bolt2_Assembly_X2=Params.Bolt2_Assembly_X1-lk;
Params.Bolt2_Dp=Params.Tube_Dp2;
Params.Bolt2_Num1=2;
Params.Bolt2_Num2=2;
%% Save
save ..\Params Params
save Bolt2 Bolt2

clc
clear
close all
%% Parameter
load('..\Params.mat');

%% Main
S=RMaterial('FEA');
mat=GetMat(S,6);

inputMembrane.GeomData=[27,81,60,8,8];
inputMembrane.HoleNum=4;
inputMembrane.Thickness=0.35;
inputMembrane.Meshsize=5;
paramsMembrane.Type=2;
paramsMembrane.Material=mat{1,1};
Membrane= plate.CouplingMembrane(paramsMembrane, inputMembrane);
Membrane= Membrane.solve();
Plot2D(Membrane)
Plot3D(Membrane)

%% Parse
Params.Membrane_Thickness=inputMembrane.Thickness;
Params.Membrane_Num=9;
Params.Membrane_Assembly_X1=((Params.Tube_Assembly_X-Params.Shaft1_Assembly_X)-Params.Membrane_Thickness*Params.Membrane_Num)/2;
Params.Membrane_Assembly_X2=Params.Shaft2_Assembly_X-Params.Membrane_Assembly_X1;
%% Save
save ..\Params Params
save Membrane Membrane




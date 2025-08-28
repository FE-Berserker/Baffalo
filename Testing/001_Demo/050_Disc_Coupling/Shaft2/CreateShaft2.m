clc
clear
close all
%% Parameter
load('..\Params.mat');

%% Main
inputShaft2.Length = 60;
inputShaft2.ID = [0,0];
inputShaft2.OD = [32,32];
paramsShaft2 = struct();
Shaft2 = shaft.Commonshaft(paramsShaft2, inputShaft2);
Shaft2 = Shaft2.solve();
Plot2D(Shaft2);
Plot3D(Shaft2);

%% Parse
Params.Shaft2_Assembly_X=89;
Params.Shaft2_D=inputShaft2.OD(1,1);
Params.Shaft2_l=inputShaft2.Length;
%% Save
save ..\Params Params
save Shaft2 Shaft2

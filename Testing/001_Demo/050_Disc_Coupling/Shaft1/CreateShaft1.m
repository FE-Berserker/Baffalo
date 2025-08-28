clc
clear
close all
%% Parameter
load('..\Params.mat');

%% Main
inputShaft1.Length = 60;
inputShaft1.ID = [0,0];
inputShaft1.OD = [26,26];
paramsShaft1 = struct();
Shaft1 = shaft.Commonshaft(paramsShaft1, inputShaft1);
Shaft1 = Shaft1.solve();
Plot2D(Shaft1);
Plot3D(Shaft1);

%% Parse
Params.Shaft1_Assembly_X=0;
Params.Shaft1_D=inputShaft1.OD(1,1);
Params.Shaft1_l=inputShaft1.Length;
%% Save
save ..\Params Params
save Shaft1 Shaft1

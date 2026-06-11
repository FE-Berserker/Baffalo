clc
clear
close all

% Parameter
PartName='Part2';
load('..\Params.mat');
a=Params.a;
b=Params.b;

% SetMaterial
S=RMaterial('Basic');
mat=GetMat(S,1);

% Part build
inputStruct1.a=a;
inputStruct1.b=b;

Part= shaft.Commonshaft(paramsStruct1, inputStruct1);
Part= Part.solve();

% Plot
Plot2D(Part)
Plot3D(Part)

% Parse
FileName=strcat(PartName,'.mat');
save(FileName,"Part"); 
clc
clear
close all

inputStruct.a=1;
inputStruct.b=2;
paramsStruct=struct();
baselineStruct.S1=2;% 4
T= TestComponent(paramsStruct, inputStruct,baselineStruct);
T = T.solve();
disp(T.capacity.S1)
PlotStruct(T);
Help(T)
PlotCapacity(T);
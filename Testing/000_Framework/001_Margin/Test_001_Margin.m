clc
clear
close all

inputStruct.a=1;
inputStruct.b=2;
paramsStruct=struct();
baselineStruct.S1=2;
T1=Component1(paramsStruct, inputStruct,baselineStruct);
T1 = T1.solve();

inputStruct.a=2;
inputStruct.b=1;
paramsStruct=struct();
baselineStruct.S1=2;
T2=Component2(paramsStruct, inputStruct,baselineStruct);
T2 = T2.solve();

inputStruct1.Component={T1,T2};
paramsStruct1=struct();
T=method.Margin(paramsStruct1, inputStruct1);
T = T.solve();

disp(T.capacity)
PlotStruct(T);
% Help(T)
PlotCapacity(T);
%% Demo Stress Strain Curve
clc
clear
plotFlag = true;
%% Demo Ramberg_Osgood
inputStruct1.E=71018.5;
inputStruct1.Ftu=468.8;
inputStruct1.Fty=386.12;
inputStruct1.Epsilon=0.1;
paramsStruct1=struct();
obj1=method.Stress_Strain_Curve.Ramberg_Osgood(paramsStruct1,inputStruct1);
obj1=obj1.solve();
obj1=obj1.plot();

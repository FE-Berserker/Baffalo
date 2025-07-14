%% Test Hertz Contact
clc
clear
close all
plotFlag = true;

%% Test Hertz_Contact_Cyclinder2Cyclinder
paramsStruct1.Contact_Length = 8;
paramsStruct1.E1 = 2.06e5;
paramsStruct1.E2 = 2.06e5;
paramsStruct1.Xi1 = 0.3;
paramsStruct1.Xi2 = 0.3;
paramsStruct1.Rho1 = 6;
paramsStruct1.Rho2 = 6;

inputStruct1.Contact_Load = 1500;
obj1 = method.Hertz_Contact.Hertz_Contact_Cyclinder2Cyclinder(paramsStruct1, inputStruct1);
obj1 = obj1.solve();
PlotPressure(obj1);
%% Test Hertz_Contact_Ball2Ball
paramsStruct2.E1 = 2.06e5;
paramsStruct2.E2 = 2.06e5;
paramsStruct2.Xi1 = 0.3;
paramsStruct2.Xi2 = 0.3;
paramsStruct2.Rho1 = 3;
paramsStruct2.Rho2 = 3;

inputStruct2.Contact_Load = 10;
obj2 = method.Hertz_Contact.Hertz_Contact_Ball2Ball(paramsStruct2, inputStruct2);
obj2= obj2.solve();
PlotPressure(obj2);
PlotPressure3D(obj2);
%% Test Sub_Surface_Stress
inputStruct3.Contact_Max_Stress = obj1.output.Contact_Max_Stress ;
inputStruct3.Contact_Half_Width = obj1.output.Contact_Half_Width;
inputStruct3.Relative_Rou = obj1.output.Relative_Rou;
inputStruct3.Cal_Depth = 0.5;
inputStruct3.Mu = 0;
% inputStruct3.Mu = 0.1;
inputStruct3.Mu = 0.3;
paramsStruct3=struct();
obj3 = method.Hertz_Contact.Sub_Surface_Stress(paramsStruct3, inputStruct3);
obj3= obj3.solve();
PlotTauxy(obj3);
PlotTau45(obj3)
DrawStress(obj3,'Stress','Tauxy')
DrawStress(obj3,'Stress','Sigmax')
DrawStress(obj3,'Stress','Sigmay')
DrawStress(obj3,'Stress','Sigma1')
DrawStress(obj3,'Stress','Sigma2')
DrawStress(obj3,'Stress','Tau45')

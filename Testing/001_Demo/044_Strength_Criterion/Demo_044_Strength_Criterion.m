%% Test Strength Criterion
clc
clear
close all
plotFlag = true;

%% Test Mohr_Circle
inputStruct1.Sigma_x = 10;
inputStruct1.Sigma_y = 40;
inputStruct1.Sigma_z = 50;
inputStruct1.Tau_xy = 20;
inputStruct1.Tau_yz = -20;
inputStruct1.Tau_xz = -20;
paramsStruct1 = struct();

obj1 = method.Strength_Criterion.Mohr_Circle(paramsStruct1, inputStruct1);
obj1 = obj1.solve();
PlotMohrCircle(obj1);
%% Test First_Strength_Theory
inputStruct2.Sigma_1 = obj1.output.Sigma_1;
paramsStruct2.Resistance=100;
obj2 = method.Strength_Criterion.First_Strength_Theory(paramsStruct2, inputStruct2);
obj2 = obj2.solve();
%% Test Second_Strength_Theory
inputStruct3.Sigma_1 = obj1.output.Sigma_1;
inputStruct3.Sigma_2 = obj1.output.Sigma_2;
inputStruct3.Sigma_3 = obj1.output.Sigma_3;
paramsStruct3.Resistance=100;
paramsStruct3.Xi=0.3;
obj3 = method.Strength_Criterion.Second_Strength_Theory(paramsStruct3, inputStruct3);
obj3 = obj3.solve();
%% Test Third_Strenght_Theory
inputStruct4.Sigma_1 = obj1.output.Sigma_1;
inputStruct4.Sigma_3 = obj1.output.Sigma_3;
paramsStruct4.Resistance=100;
obj4 = method.Strength_Criterion.Third_Strength_Theory(paramsStruct4, inputStruct4);
obj4 = obj4.solve();
%% Test Fourth_Strength_Theory 
inputStruct5.Sigma_1 = obj1.output.Sigma_1;
inputStruct5.Sigma_2 = obj1.output.Sigma_2;
inputStruct5.Sigma_3 = obj1.output.Sigma_3;
paramsStruct5.Resistance=100;
obj5 = method.Strength_Criterion.Fourth_Strength_Theory(paramsStruct5, inputStruct5);
obj5 = obj5.solve();
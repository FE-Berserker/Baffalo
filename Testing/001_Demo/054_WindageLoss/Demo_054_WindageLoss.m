%% Demo Windageloss
% 1. Demo WindageLoss

clc
clear
close all
flag=1;
DemoWindageLoss(flag);

function DemoWindageLoss(flag)
switch flag
    case 1
        inputStruct1.t=100;
        paramsStruct1=struct();
        Air=method.AirProperty(paramsStruct1, inputStruct1);
        Air=Air.solve();
        disp(Air.output)
        inputStruct2.Li=0.05;
        inputStruct2.dsh=0.012;
        inputStruct2.D2out=0.05;
        inputStruct2.D1in=0.056;
        inputStruct2.dsl=0.0018;
        inputStruct2.n=40000;
        inputStruct2.vax=10;
        paramsStruct2.Rho=Air.output.rho;
        paramsStruct2.Mu=Air.output.mu;
        Loss=method.Loss.WindageLoss(paramsStruct2, inputStruct2);
        Loss=Loss.solve();
        disp(Loss.output)
end
end
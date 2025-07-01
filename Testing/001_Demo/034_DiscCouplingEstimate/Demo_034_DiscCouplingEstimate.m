clc
clear
close all
% Demo_DiscCouplingEstimate
% 1. Demo1
flag=1;
DemoDiscCouplingEstimate(flag);

function DemoDiscCouplingEstimate(flag)
switch flag
    case 1

        inputStruct.N=4;
        inputStruct.t=0.35;
        inputStruct.E=1.93e5;
        inputStruct.R=77/2;
        inputStruct.Z=9;
        inputStruct.b=16.5;
        inputStruct.d1=13;

        paramsStruct=struct();
        D= method.DiscCouplingEstimate(paramsStruct, inputStruct);
        D=D.solve();
        disp(D.output.KT)
        disp(D.output.Kr)
        disp(D.output.Kalpha)

end
end

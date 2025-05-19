clc
clear
close all
% Demo RotatingDisc
% 1. Rotating disc analysis demo

flag=1;
DemoRotatingDisc(flag);

function DemoRotatingDisc(flag)
switch flag
    case 1
        inputStruct.Ri=140;
        inputStruct.Ro=500;
        inputStruct.Omega=5000;
        inputStruct.Location=140;
        paramsStruct=struct();
        C=method.RotatingDisc(paramsStruct, inputStruct);
        C=C.solve;
        disp(C.output.Stress);
        PlotStress(C)

end
end
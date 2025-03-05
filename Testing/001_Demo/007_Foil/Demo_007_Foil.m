clc
clear
close all
% Demo Foil
% 1. Create foil NACA 0010
flag=1;
DemoFoil(flag);

function DemoFoil(flag)
switch flag
    case 1
        inputStruct1.Alpha=0:1:10;
        inputStruct1.FoilName='NACA 0010';
        paramsStruct1=struct();
        obj=foil.Foil(paramsStruct1, inputStruct1);
        obj=obj.solve();
        Plot2D(obj);
        PlotData(obj);
end
end
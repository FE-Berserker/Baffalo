clc
clear
close all
% Demo WormGear
% 1. Create WormGear

flag=1;
DemoWormGear(flag);

function DemoWormGear(flag)
switch flag
    case 1
        mx=4;
        z2=41;
        inputSingleGear.mx= mx;
        inputSingleGear.alphan = 20;
        inputSingleGear.a=100;
        inputSingleGear.Z1=2;
        inputSingleGear.Z2=z2;
        inputSingleGear.b1=60;
        inputSingleGear.b2H=30;
        inputSingleGear.n1=1500;
        inputSingleGear.P2=4.5;
        paramsingleGear=struct();
        obj1=gear.WormGear(paramsingleGear, inputSingleGear);
        obj1=obj1.solve();
        PlotWormCurve(obj1);
        PlotWheelCurve(obj1);
        PlotWorm(obj1);
        PlotWheel(obj1);
        Plot3D(obj1);
        Ass=obj1.output.Assembly1;
        ANSYS_Output(Ass)
end

end
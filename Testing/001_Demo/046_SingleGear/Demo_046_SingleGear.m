clc
clear
close all
% Demo SingleGear
% 1. Create Single gear
% 2. Create Single gear
flag=2;
DemoSingleGear(flag);

function DemoSingleGear(flag)
switch flag
    case 1
        inputSingleGear.mn= 1;
        inputSingleGear.alphan = 20;
        inputSingleGear.Z=17;
        inputSingleGear.b=10;
        inputSingleGear.x=0.3;
        inputSingleGear.beta=0;
        paramsingleGear.MeshNTooth = 17;
        obj1=gear.SingleGear(paramsingleGear, inputSingleGear);
        obj1=obj1.solve();
        PlotCutting(obj1);
        PlotToolCurve(obj1);
        PlotGearCurve(obj1);
        Plot2D(obj1);
        Plot3D(obj1,'faceno',101);
    case 2
        inputSingleGear.mn= 4;
        inputSingleGear.alphan = 20;
        inputSingleGear.Z=41;
        inputSingleGear.b=10;
        inputSingleGear.x=0;
        inputSingleGear.beta=0;
        paramsingleGear.MeshNTooth = 5;
        obj1=gear.SingleGear(paramsingleGear, inputSingleGear);
        obj1=obj1.solve();
        PlotCutting(obj1);
        PlotToolCurve(obj1);
        PlotGearCurve(obj1);
        Plot2D(obj1);
        Plot3D(obj1,'faceno',101);
end

end
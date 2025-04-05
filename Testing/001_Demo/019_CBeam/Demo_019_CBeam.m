clc
clear
close all
% Demo CBeam
% 1. Create CBeam
% 2. Create CBeam with stiffner
flag=2;
DemoCBeam(flag);

function DemoCBeam(flag)
switch flag
    case 1
        inputStruct.t=[8.5,8.5];
        inputStruct.r=[8.5,8.5];
        inputStruct.b=[48,48];
        inputStruct.d=5.4;
        inputStruct.h=100;
        inputStruct.l=400;
        paramsStruct=struct();
        obj= beam.CBeam(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);
    case 2
        inputStruct.t=[8.5,8.5];
        inputStruct.r=[8.5,8.5];
        inputStruct.b=[48,48];
        inputStruct.d=5.4;
        inputStruct.h=100;
        inputStruct.l=480;
        inputStruct.Stiffner=[120+4,8;360-4,8];
        paramsStruct=struct();
        obj= beam.CBeam(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);

end
end
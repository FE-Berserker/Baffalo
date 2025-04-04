clc
clear
close all
% Demo IBeam
% 1. Create IBeam
% 2. Create IBeam with stiffner
flag=2;
DemoIBeam(flag);

function DemoIBeam(flag)
switch flag
    case 1
        inputStruct.t=[12,12];
        inputStruct.r=[4,4];
        inputStruct.b=[120,120];
        inputStruct.d=8;
        inputStruct.h=200;
        inputStruct.l=400;

        paramsStruct=struct();
        obj= beam.IBeam(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);
    case 2
        inputStruct.t=[16,16];
        inputStruct.r=[5,5];
        inputStruct.b=[180,180];
        inputStruct.d=12;
        inputStruct.h=240;
        inputStruct.l=480;
        inputStruct.Stiffner=[120+6,12;360-6,12];
        paramsStruct=struct();
        obj= beam.IBeam(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);

end
end
clc
clear
close all
% Demo LBeam
% 1. Create LBeam
% 2. Create LBeam with stiffner
flag=2;
DemoLBeam(flag);

function DemoLBeam(flag)
switch flag
    case 1
        inputStruct.r=7;
        inputStruct.b=[63,63];
        inputStruct.d=[8,8];
        inputStruct.l=400;
        paramsStruct=struct();
        obj= beam.LBeam(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);
    case 2
        inputStruct.r=7;
        inputStruct.b=[63,63];
        inputStruct.d=[8,8];
        inputStruct.l=480;
        inputStruct.Stiffner=[120+4,8;360-4,8];
        paramsStruct=struct();
        obj= beam.LBeam(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);

end
end
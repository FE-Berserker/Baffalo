clc
clear
close all
% Demo FoilGen
% 1. Create foil NACA 0010
flag=1;
DemoFoil(flag);

function DemoFoil(flag)
switch flag
    case 1
        % Foil 2D
        inputStruct1.Alpha=0;
        inputStruct1.FoilName='NACA 0010';
        paramsStruct1=struct();
        obj1=foil.Foil(paramsStruct1, inputStruct1);
        obj1=obj1.solve();
        % Foil 3D
        inputStruct2.Dz=(1:10)';
        inputStruct2.Dx=(1:10)';
        inputStruct2.Rotz=[1,2,3,4,5,6,7,8,9,10]';
        inputStruct2.Rotx=[1,2,3,4,5,6,7,8,9,10]';
        inputStruct2.Scale=[1,0.98,0.96,0.94,0.92,0.9,0.8,0.7,0.6,0.5]';
        inputStruct2.Foil=obj1.output.Coor*10;
        paramsStruct2.Origin=[0,0];
        obj2=foil.FoilGen(paramsStruct2, inputStruct2);
        obj2=obj2.solve();
        Plot2D(obj2);
        Plot3D(obj2);

end
end
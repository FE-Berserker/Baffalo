clc
clear
close all
% Test CouplingMembrane
% 1. Create CouplingMembrane Type 1
% 2. Create CouplingMembrane Type 2
% 3. Create CouplingMembrane Type 3
% 4. Create CouplingMembrane Type 4
flag=1;
DemoCouplingMembrane(flag);

function DemoCouplingMembrane(flag)
switch flag
    case 1
        inputStruct.GeomData=[60,93,77,8];
        inputStruct.HoleNum=4;
        inputStruct.Thickness=0.4;
        inputStruct.Meshsize=5;

        paramsStruct.Type=1;
        obj= plate.CouplingMembrane(paramsStruct, inputStruct);
        obj= obj.solve();

        Plot2D(obj)
        Plot3D(obj)
    case 2
        inputStruct.GeomData=[60,93,77,8,8];
        inputStruct.HoleNum=4;
        inputStruct.Thickness=0.4;
        inputStruct.Meshsize=5;

        paramsStruct.Type=2;
        obj= plate.CouplingMembrane(paramsStruct, inputStruct);
        obj= obj.solve();

        Plot2D(obj)
        Plot3D(obj)
    case 3
        inputStruct.GeomData=[60,93,77,8,150,70];
        inputStruct.HoleNum=4;
        inputStruct.Thickness=0.4;
        inputStruct.Meshsize=5;

        paramsStruct.Type=3;
        obj= plate.CouplingMembrane(paramsStruct, inputStruct);
        obj= obj.solve();

        Plot2D(obj)
        Plot3D(obj)
    case 4
        inputStruct.GeomData=[50,93,77,8,280];
        inputStruct.HoleNum=4;
        inputStruct.Thickness=0.4;
        inputStruct.Meshsize=5;

        paramsStruct.Type=4;
        obj= plate.CouplingMembrane(paramsStruct, inputStruct);
        obj= obj.solve();

        Plot2D(obj)
        Plot3D(obj)
end
end
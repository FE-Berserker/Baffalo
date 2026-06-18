clc
clear
close all
% Demo
% 1. Create PadEyeBlock

flag=1;
DemoPadEye(flag);

function DemoPadEye(flag)
switch flag
    case 1
        %% Parameters
        a=75;
        b=75;
        Dia=100;
        T=20;
        l=140;
        w=150;
        h=100;

        %% Create PadEye object
        paramsStruct.Name = 'PadEyeBlock1';
        paramsStruct.Echo = 1;
        paramsStruct.Material = [];
        paramsStruct.Order = 1;
        paramsStruct.N_Slice = 3;

        inputStruct.a = a;
        inputStruct.b = b;
        inputStruct.HoleDia = Dia;
        inputStruct.Meshsize = 5;
        inputStruct.Thickness = T;
        inputStruct.l = l;
        inputStruct.h = h;
        inputStruct.w = w;

        obj = connection.PadEyeBlock(paramsStruct, inputStruct);
        obj = obj.solve();

        %% Plot PadEye face
        Plot2D(obj);
        Plot3D(obj);
        Plot3D(obj,'faceno',21);

        %% OutputCatia
        OutputCatiaPart(obj)

end
end
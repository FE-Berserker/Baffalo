clc
clear
close all
% Demo
% 1. Create PadEyeEnd

flag=1;
DemoPadEyeEnd(flag);

function DemoPadEyeEnd(flag)
switch flag
    case 1
        %% Parameters
        a=75;
        b=75;
        Dia=100;
        T=100;
        w=120;
        h=50;
        Dia2=70;
        l=10;
        %% Create PadEye object
        paramsStruct.Name = 'PadEyeEnd1';
        paramsStruct.Echo = 1;
        paramsStruct.Material = [];
        paramsStruct.Order = 1;
        paramsStruct.N_Slice = 8;

        inputStruct.a = a;
        inputStruct.b = b;
        inputStruct.HoleDia = Dia;
        inputStruct.Meshsize = 5;
        inputStruct.Thickness = T;
        inputStruct.l = l;
        inputStruct.h = h;
        inputStruct.w = w;
        inputStruct.Dia2 = Dia2;

        obj = connection.PadEyeEnd(paramsStruct, inputStruct);
        obj = obj.solve();

        %% Plot PadEye face
        Plot2D(obj);
        Plot3D(obj);
        Plot3D(obj,'faceno',2);

        %% OutputCatia
        OutputCatiaPart(obj)

end
end
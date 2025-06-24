clc
clear
close all
% Demo_WovenCell
% 1. Weave 2D

flag=1;
DemoWovenCell(flag);

function DemoWovenCell(flag)
switch flag
    case 1
        S=RMaterial('Composite');
        mat=GetMat(S,[32,2]');
        inputStruct.FileName='Weave1';
        inputStruct.Dimension=[50,50,20];
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        paramsStruct.Vf=0.77;
        W= method.Composite.WovenCell(paramsStruct, inputStruct);
        W=W.solve();
        Plot3D(W,'Matrix',0,'SurfaceDistance',1);
        W=CalProperties(W);
        disp(W.output.Property)
end
end

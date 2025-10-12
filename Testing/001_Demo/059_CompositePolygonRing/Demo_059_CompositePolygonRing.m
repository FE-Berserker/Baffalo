clc
clear
close all
% Demo Composite polygon ring
% 1. Create composite polygon ring
flag=1;
DemoCompositeRing(flag);

function DemoCompositeRing(flag)
switch flag
    case 1
        S=RMaterial('Composite');
        mat=GetMat(S,[33,2]');
        inputStruct.Vf=0.65;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        paramsStruct.Theory='MT';
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        Plot(Ply);
        PlotAlpha(Ply);
        mat1{1,1}=Ply.output.Plyprops;

        inputRing.Di=270;
        inputRing.EdgeNum=6;
        inputRing.r=10;
        inputRing.Height=330;
        inputRing.Thickness=[5,3,3,3,3,5];
        inputRing.Angle=[90,0,45,-45,0,90];
        inputRing.MatNum=[1,1,1,1,1,1];
        paramRing.Material=mat1;
        obj=housing.CompositePolygonRing(paramRing, inputRing);
        obj=obj.solve();
        Plot3D(obj)
end
end

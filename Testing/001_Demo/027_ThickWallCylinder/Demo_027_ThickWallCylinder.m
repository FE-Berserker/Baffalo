clc
clear
close all
% Demo ThickWallCylinder
% 1. ThickWall cylinder analysis demo

flag=1;
DemoThicknessWallCylinder(flag);

function DemoThicknessWallCylinder(flag)
switch flag
    case 1
        inputStruct.Ri=140;
        inputStruct.Ro=500;
        inputStruct.Pi=0;
        inputStruct.Po=-36.4;
        inputStruct.Location=140;
        paramsStruct=struct();
        C=method.ThickWallCylinder(paramsStruct, inputStruct);
        C=C.solve;
        disp(C.output.Stress);
        PlotStress(C)

end
end
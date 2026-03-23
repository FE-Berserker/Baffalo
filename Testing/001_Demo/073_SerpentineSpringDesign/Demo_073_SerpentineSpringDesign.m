clc
clear
close all
% Demo SerpentineSpringDesign
% 1. Demo1 - 创建蛇形关节

flag = 1;
DemoSerpentineSpringDesign(flag);

function DemoSerpentineSpringDesign(flag)
switch flag
    case 1

        inputStruct1.OuterRadius =33.5;      % Outer radius [mm]
        inputStruct1.Thickness = 5;     % Spring thickness [mm]
        inputStruct1.K = 150;  % (Nm/rad) desired stiffness

        paramsStruct1 = struct();

        obj1 = connection.SerpentineSpringDesign(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);

end
end
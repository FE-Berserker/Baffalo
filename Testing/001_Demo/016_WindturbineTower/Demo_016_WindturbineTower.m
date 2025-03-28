clc
clear
close all
% Demo WindturbineTower
% 1. Create WindturbineTower
% 2. Change offset to bot and top

flag=2;
DemoWindturbineTower(flag);

function DemoWindturbineTower(flag)
switch flag
    case 1
        inputTower.Length= [1000;3800;1500;1720;1720;2900;2900;2900;2900;2900];
        inputTower.Thickness = [26;26;25;25;22;22;20;19;18;18];
        inputTower.Diameter=repmat([4300,4300],10,1);
        paramsTower = struct();
        obj1=housing.WindturbineTower(paramsTower, inputTower);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        ANSYS_Output(obj1.output.Assembly1);
    case 2
        inputTower.Length= [1000;3800;1500;1720;1720;2900;2900;2900;2900;2900];
        inputTower.Thickness = [26;26;25;25;22;22;20;19;18;18];
        inputTower.Diameter=repmat([4300,4300],10,1);
        paramsTower1.Offset = "BOT";
        obj1=housing.WindturbineTower(paramsTower1, inputTower);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        ANSYS_Output(obj1.output.Assembly1);
        paramsTower2.Offset = "TOP";
        obj2=housing.WindturbineTower(paramsTower2, inputTower);
        obj2=obj2.solve();
        Plot2D(obj2);
        Plot3D(obj2);
        ANSYS_Output(obj2.output.Assembly1);
end

end
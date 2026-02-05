clc
clear
close all
% Demo ShaftSupport - 测试所有类型的轴支座
% 1. Create ShaftSupport Type 1 - 圆形底板，装配孔沿圆周分布
% 2. Create ShaftSupport Type 2 - 方形带圆角底板（4个平边），装配孔沿圆周分布
% 3. Create ShaftSupport Type 3 - 长方形底板（2个平边），装配孔沿圆周分布
% 4. Create ShaftSupport Type 4 - 长方形底板，4个固定孔呈方形布置

% 测试所有类型 (1-4)
for flag = 1:4
    fprintf('========================================\n');
    fprintf('正在测试轴支座类型 %d...\n', flag);
    fprintf('========================================\n');
    DemoShaftSupport(flag);
    fprintf('类型 %d 测试完成！\n\n', flag);
end

function DemoShaftSupport(flag)
switch flag
    case 1
        inputShaftSupport.N= 3;
        inputShaftSupport.L = 15;
        inputShaftSupport.D=6;
        inputShaftSupport.H=28;
        inputShaftSupport.T=3.5;
        inputShaftSupport.d1=3.5;
        inputShaftSupport.P=20;
        inputShaftSupport.NH=4;
        paramsShaftSupport = struct();
        obj1=shaft.ShaftSupport(paramsShaftSupport, inputShaftSupport);
        obj1=obj1.solve();
        Plot3D(obj1);
        ANSYS_Output(obj1.output.Assembly);
    case 2
        inputShaftSupport.N= 3;
        inputShaftSupport.L = 15;
        inputShaftSupport.D=6;
        inputShaftSupport.H=28;
        inputShaftSupport.T=3.5;
        inputShaftSupport.d1=3.5;
        inputShaftSupport.P=20;
        inputShaftSupport.NH=4;
        inputShaftSupport.K=22;
        paramsShaftSupport.Type = 2;
        obj1=shaft.ShaftSupport(paramsShaftSupport, inputShaftSupport);
        obj1=obj1.solve();
        Plot3D(obj1);
        ANSYS_Output(obj1.output.Assembly);
    case 3
        inputShaftSupport.N= 3;
        inputShaftSupport.L = 15;
        inputShaftSupport.D=6;
        inputShaftSupport.H=28;
        inputShaftSupport.T=3.5;
        inputShaftSupport.d1=3.5;
        inputShaftSupport.P=20;
        inputShaftSupport.NH=2;
        inputShaftSupport.W=16;
        paramsShaftSupport.Type = 3;
        obj1=shaft.ShaftSupport(paramsShaftSupport, inputShaftSupport);
        obj1=obj1.solve();
        Plot3D(obj1);
        ANSYS_Output(obj1.output.Assembly);
    case 4
        inputShaftSupport.N= 3;
        inputShaftSupport.L = 32;
        inputShaftSupport.D=16;
        inputShaftSupport.H=40;
        inputShaftSupport.T=6;
        inputShaftSupport.d1=4.5;
        inputShaftSupport.P=28;
        inputShaftSupport.NH=4;
        inputShaftSupport.W=26;
        inputShaftSupport.F=16;
        paramsShaftSupport.Type = 4;
        obj1=shaft.ShaftSupport(paramsShaftSupport, inputShaftSupport);
        obj1=obj1.solve();
        Plot3D(obj1);
        ANSYS_Output(obj1.output.Assembly);
end
end
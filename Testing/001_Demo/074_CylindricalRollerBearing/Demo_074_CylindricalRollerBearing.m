clc
clear
close all
% Demo Roller_Calculation
% 1. Roller stress calculation
% 2. Roller bearing with Non_Hertz_Contact

flag=1;
DemoRollerCalculation(flag);

function DemoRollerCalculation(flag)
switch flag
    case 1
        inputStruct.Z=50;
        inputStruct.L=144; % 滚子长度 [mm]
        inputStruct.r=2; % 滚子倒角 [mm]
        inputStruct.Di=995; % 轴承内径 [mm]
        inputStruct.T=190;
        inputStruct.C=190;
        inputStruct.B=190;
        inputStruct.Do=1250;% 轴承外径 [mm]
        inputStruct.D1=1158;
        inputStruct.d1=1074.5;
        inputStruct.Modify_Method=0;
        inputStruct.Dpw=1118;% 轴承分度圆直径 [mm]
        inputStruct.Dw=70;% 轴承滚子直径 [mm]
        inputStruct.Uz=-0.3;% 轴承位移
        % inputStruct.Fz=-4e6;% 轴承力
        inputStruct.i=1;% 轴承列数
        paramsStruct.Name='Roller_Bearing';
        % paramsStruct.Pd0=0.644;
        paramsStruct.Pd0=-0.6;
        % paramsStruct.Temp=[75,70];
        paramsStruct.Dil=720;
        paramsStruct.DaA=1735;
        % paramsStruct.U=[0.36,0.106];

        paramsStruct.isOuterRid=[0,1];
        paramsStruct.isInnerRid=[1,1];
        Roller_Bearing=bearing.CylindricalRollerBearing(paramsStruct, inputStruct);
        Roller_Bearing = Roller_Bearing.solve();

        Plot_Roller_Force(Roller_Bearing);
        Plot_Roller_Stiffness(Roller_Bearing);
        Plot2D(Roller_Bearing);
        Plot3D(Roller_Bearing);
        Plot(Roller_Bearing.output.Assembly)

    case 2
        inputStruct.Z=13;
        inputStruct.L=14; % 滚子长度 [mm]
        inputStruct.r=0.7; % 滚子倒角 [mm]
        inputStruct.Di=35; % 轴承内径 [mm]
        inputStruct.T=21;
        inputStruct.C=21;
        inputStruct.B=21;
        inputStruct.Do=80;% 轴承外径 [mm]
        inputStruct.d1=56.4;
        inputStruct.Modify_Method=0;
        inputStruct.Dpw=63.4;% 轴承分度圆直径 [mm]
        inputStruct.Dw=10;% 轴承滚子直径 [mm]
        inputStruct.i=1;% 轴承列数
        paramsStruct.Name='Roller_Bearing';

        paramsStruct.isOuterRid=[0,0];
        paramsStruct.isInnerRid=[1,1];
        Roller_Bearing=bearing.CylindricalRollerBearing(paramsStruct, inputStruct);
        Roller_Bearing = Roller_Bearing.solve();

        Plot_Roller_Stiffness(Roller_Bearing);
        Plot2D(Roller_Bearing);
        Plot3D(Roller_Bearing);
        Plot(Roller_Bearing.output.Assembly)

        input1Struct.Q=1840;
        input1Struct.x=Roller_Bearing.output.Roller_point.x1;
        input1Struct.y=Roller_Bearing.output.Delta_y;
        input1Struct.Lwe=Roller_Bearing.output.Lwe ;
        input1Struct.D1=10;
        input1Struct.D2=inputStruct.Dpw-inputStruct.Dw;
        params1Struct=struct();
        Roller_Stress=method.Non_Hertz_Contact.Roller_Calculation(params1Struct, input1Struct);
        Roller_Stress=Roller_Stress.solve();

        PlotProfile(Roller_Stress)
        Plota(Roller_Stress)
        PlotP(Roller_Stress)
end


end
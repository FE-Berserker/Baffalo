clc
clear
% Demo_Oilseal
% 1. Demo1
flag=1;
DemoOilSeal(flag);

function DemoOilSeal(flag)
switch flag
    case 1
        %% Defination the size of oil seal
        inputStruct1.ID=50;
        inputStruct1.OD=70;
        inputStruct1.Length=10;
        paramsStruct1.Name='Demo_OilSeal';
        Oilseal1 = shaft.OilSeal(paramsStruct1, inputStruct1);
        Oilseal1=Oilseal1.plot2D();
        %% Oilseal frictional torque calculation
        Oilseal1.input.Rot_Speed=1000;
        Oilseal1=Oilseal1.cal_velocity();
        Oilseal1=Oilseal1.cal_torque1();%According to AGMA ISO 14179-1
        Torque1=Oilseal1.output.Ts;
        disp(Torque1)
        Oilseal1.params.Vis=10;
        Oilseal1=Oilseal1.cal_torque2();%According to NOK
        Torque2=Oilseal1.output.Ts;
        disp(Torque2)
        %% Oilseal temprature calculation
        Oilseal1=Oilseal1.cal_T2();%According to NOK
        %% Plot frictional torque&temperature curve
        %SAE 30 measured data
        T_SAE30=(0:10:100)';
        Vis_SAE30=[1257.25;553.2;271.56;146.7;85.76;53.8;35.69;24.89;18.1;13.62;10.58];
        Rou_SAE30=[0.8941;0.8878;0.8815;0.8754;0.8693;0.863;0.8569;0.8506;0.8444;0.8383;0.8322];
        figure
        yyaxis left
        plot(T_SAE30,Vis_SAE30)

        title('SAE30')
        xlabel('Temperature (℃)')
        ylabel('Kinematic Viscosity (mm2/s)')

        yyaxis right
        plot(T_SAE30,Rou_SAE30)
        ylabel('Density (g/cm3)')
        grid on
        %calculate
        Torque3=NaN(numel(T_SAE30),1);
        for i=5:numel(T_SAE30)
            Oilseal1.params.Vis=Vis_SAE30(i);
            Oilseal1.params.Rou=Rou_SAE30(i)*1e-9;
            Oilseal1=Oilseal1.cal_torque2();%According to NOK
            Torque3(i)=Oilseal1.output.Ts;
        end
        figure
        plot(T_SAE30(5:end,1),Torque3(5:end,1))
        title('SAE30 Frictional Torque & Temperature curve')
        xlabel('Temperature (℃)')
        ylabel('Ts (Nmm)')
        grid on
end
end
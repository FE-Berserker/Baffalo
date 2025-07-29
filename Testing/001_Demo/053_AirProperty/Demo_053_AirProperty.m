%% Demo AirProperty
% 1. Demo AirProperty
% 2. rho & pressure
% 3. rho & humidity

clc
clear
close all
flag=3;
DemoAirProperty(flag);

function DemoAirProperty(flag)
switch flag
    case 1
        inputStruct.t=15;
        inputStruct.p=1013.25;
        inputStruct.h=[];
        paramsStruct.xCO2=0.0004;
        Air=method.AirProperty(paramsStruct, inputStruct);
        Air=Air.solve();
        disp(Air.output)
    case 2
        inputStruct.t=15;  
        inputStruct.h=[];
        paramsStruct.xCO2=0.0004;
        rho=NaN(1,11);
        p=100:200:2100;

        for i=1:11
            inputStruct.p=p(i);
            Air=method.AirProperty(paramsStruct, inputStruct);
            Air=Air.solve();
            rho(i)=Air.output.rho;
        end

        figure
        plot(p,rho);
        xlabel('Pressure [hpa]')
        ylabel('Air density [kg m-3]')
    case 3
        inputStruct.t=15;
        inputStruct.p=1013.25;
        paramsStruct.xCO2=0.0004;
        rho=NaN(1,11);
        h=0:10:100;

        for i=1:11
            inputStruct.h=h(i);
            Air=method.AirProperty(paramsStruct, inputStruct);
            Air=Air.solve();
            rho(i)=Air.output.rho;
        end

        figure
        plot(h,rho);
        xlabel('Humidity [%]')
        ylabel('Air density [kg m-3]')

end
end
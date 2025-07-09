% Demo the Vis_cal
clc
clear
plotFlag = true;
%% Caculate the vis
S=RMaterial('Lubricant');
Mat=GetMat(S,3);

inputStruct1.T=70;
paramsStruct1.Material=Mat{1,1};
Vis=method.Vis_cal(paramsStruct1, inputStruct1);
Vis=Vis.solve();
%% Plot vis, rou&Tempearture curve
x=(30:10:150)';
y1=NaN(numel(x),1);
y2=NaN(numel(x),1);
for i=1:numel(x)
    Vis.input.T=x(i);
    Vis=Vis.solve();
    y1(i)=Vis.output.Vis1;
    y2(i)=Vis.output.Rou;  
end
figure
plot(x,y1)
title('Kinematic Viscosity & Temperature Curve')
xlabel('Temperature (℃)')
ylabel('Kinematic Viscosity (mm2/s)')

figure
plot(x,y2)
title('Density & Temperature Curve')
xlabel('Temperature (℃)')
ylabel('Density (g/cm3)')

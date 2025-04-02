% Demo RayleighEstimate
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1. Calculate rayleigh damping parameter
flag=1;
DemoRayleighEstimate(flag);

function DemoRayleighEstimate(flag)
switch flag
    case 1
        inputRayleigh.Xi=0.05;
        inputRayleigh.f1=10;
        inputRayleigh.f2=20;
        paramsRayleigh=struct();
        obj = method.RayleighEstimate(paramsRayleigh,inputRayleigh);
        obj = obj.solve();
        disp(obj.output.alpha)
        disp(obj.output.beta)
end
end
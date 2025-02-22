% Test ISO1940
clc
clear
close all
plotFlag = true;
% setRoTAPath
%% 1. Calculate Uper
flag=1;
DemoISO1940(flag);

function DemoISO1940(flag)
switch flag
    case 1
        inputUnbalance.LA=1500;
        inputUnbalance.LB=900;
        inputUnbalance.Mass=3.6;
        inputUnbalance.n=3000;
        paramsUnbalance.G=2.5;
        obj = method.ISO1940( paramsUnbalance,inputUnbalance);
        obj = obj.solve();
        disp(obj.output.UperA)
        disp(obj.output.UperB)
end
end
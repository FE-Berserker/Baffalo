clc
clear
close all
% Demo ForceLoad
% 1. Create random forceload
% 2. Crete constant forceload
flag=2;
DemoForceLoad(flag)

function DemoForceLoad(flag)
switch flag
    case 1
        inputStruct1.Time=0:1e-3:5;
        inputStruct1.Fx=rand(1,length(inputStruct1.Time));
        paramsStruct1=struct();
        obj=signal.ForceLoad(paramsStruct1, inputStruct1);
        obj=obj.solve();
        Plot(obj);
    case 2
        inputStruct1.Time=0:1e-3:5;
        inputStruct1.Fx=ones(1,length(inputStruct1.Time));
        paramsStruct1=struct();
        obj=signal.ForceLoad(paramsStruct1, inputStruct1);
        obj=obj.solve();
        Plot(obj);

end
end
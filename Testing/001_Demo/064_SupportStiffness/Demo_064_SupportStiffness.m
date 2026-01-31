clc
clear
close all
% Demo SupportStiffness
% 1. Create SupportStiffness

flag=1;
DemoSupportStiffness(flag);

function DemoSupportStiffness(flag)
switch flag
    case 1
        N=3;
        inputSupport.ka= 3e5/N;
        inputSupport.ks= 1e5/N;
        inputSupport.N= N;
        inputSupport.Dp= 1984;
        paramSupport.Ang=0;
        obj1=method.SupportStiffness(paramSupport, inputSupport);
        obj1=obj1.solve();
        PlotBendingStiffness(obj1);
end

end
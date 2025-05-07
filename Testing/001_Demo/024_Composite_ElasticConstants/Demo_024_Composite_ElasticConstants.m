clc
clear
close all
plotflag=true;
% Demo_CompositeElasticConstants
flag=1;
DemoCompositeElasticConstants(flag);

function DemoCompositeElasticConstants(flag)
switch flag
    case 1
        S=RMaterial('Composite');
        mat=GetMat(S,5);
        inputStruct.Ply=mat{1,1};
        inputStruct.theta =45;
        paramsStruct=struct();
        obj = method.Composite.ElasticConstants(paramsStruct, inputStruct);
        obj = obj.solve();
        Plot(obj);
end
end

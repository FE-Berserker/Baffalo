clc
clear
close all
% Demo_CompositeMicromechanics
% 1. Stand-alone micromechanics effective properties
% 2. Stand-alone micromechanics effective properties using GMC
% 3. Plot Local field
% 4. SiC-SiC with interface BN_Coating using GMC RUCid=105
% 5. Stand-alone micromechanics effective properties using HFGMC
% 6. HFGMC vs FEA
% 7. Progressive damage response using HFGMC and max stress criterion

flag=3;
DemoCompositeMicromechanics(flag);

function DemoCompositeMicromechanics(flag)
switch flag
    case 1
        S=RMaterial('Composite');
        mat=GetMat(S,[3,4]');
        inputStruct.Vf=0.55;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        paramsStruct.Theory='All';
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        Plot(Ply);
        PlotAlpha(Ply);
    case 2
        S=RMaterial('Composite');
        mat=GetMat(S,[3,4]');
        inputStruct.Vf=0.55;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        paramsStruct.Theory='GMC';
        paramsStruct.RUCid=26;% 2,7,26
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        Plot(Ply);
        PlotAlpha(Ply);
    case 3
        S=RMaterial('Composite');
        mat=GetMat(S,[3,4]');
        inputStruct.Vf=0.55;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        inputStruct.Load.Type=[2,2,2,2,2,2];% 2-Stress 1-Strain
        inputStruct.Load.Value=[0,1,0,0,0,0];
        paramsStruct.Theory='MT';% 'Voigt' 'Reuss' 'MT' 'MOC' 'MOCu'
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        PlotMicroField(Ply);
    case 4
        S=RMaterial('Composite');
        mat=GetMat(S,[29,30,31]');
        inputStruct.Vf=0.28;
        inputStruct.Vi=0.13;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        inputStruct.Interface=mat{3,1};
        paramsStruct.Theory='GMC';
        paramsStruct.RUCid=105;
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        Plot(Ply);
        PlotAlpha(Ply);
    case 5
        S=RMaterial('Composite');
        mat=GetMat(S,[29,30,31]');
        inputStruct.Vf=0.28;
        inputStruct.Vi=0.13;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        inputStruct.Interface=mat{3,1};
        paramsStruct.Theory='HFGMC';
        paramsStruct.RUCid=105;
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        Plot(Ply);
        PlotAlpha(Ply);
    case 6
        S=RMaterial('Composite');
        mat=GetMat(S,[1,2]');
        inputStruct.Vf=0.5;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        inputStruct.Load.Type=[2,2,1,2,2,2];% 2-Stress 1-Strain
        inputStruct.Load.Value=[0,0,0.02,0,0,0];
        paramsStruct.RUCid=99;
        paramsStruct.Theory='HFGMC';
        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        PlotMicroField(Ply);
    case 7
        S=RMaterial('Composite');
        mat=GetMat(S,[1,2]');
        inputStruct.Vf=0.55;
        inputStruct.Fiber=mat{1,1};
        inputStruct.Matrix=mat{2,1};
        inputStruct.Load.Type=[2,2,2,1,2,2];% 2-Stress 1-Strain
        inputStruct.Load.Value=[0,0,0,0.02,0,0];
        inputStruct.Load.NINC=400;
        paramsStruct.RUCid=200;
        paramsStruct.Theory='HFGMC';
        paramsStruct.Damage=1;% Progressive damage analysis
        paramsStruct.Criterion=1; % Failure criterion

        Ply= method.Composite.Micromechanics(paramsStruct, inputStruct);
        Ply=Ply.solve();
        PlotMicroField(Ply);

end
end

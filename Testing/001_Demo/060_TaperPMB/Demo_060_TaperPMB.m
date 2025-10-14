clc
clear
close all
% Demo RadialPMB
% 1. Single row taper PMB
% 2. Multi row taper PMB
% 3. 45° Taper PMB

flag=3;
DemoTaperPMB(flag);

function DemoTaperPMB(flag)
switch flag
    case 1
        S=RMaterial('Magnetic');
        Mat=GetMat(S,36);
        Mat{1,1}.Mux=1.124;
        Mat{1,1}.Muy=1.124;
        Mat{1,1}.Hc=800000;

        inputStruct1.StatorR=[20,26];
        inputStruct1.RotorR=[13,19];
        inputStruct1.Height=[0,12];
        inputStruct1.StatorDir=180;
        inputStruct1.RotorDir=0;
        paramsStruct1.Material=Mat{1,1};
        paramsStruct1.TaperAngle=90;

        Mag= bearing.TaperPMB(paramsStruct1, inputStruct1);
        Mag= Mag.solve();
        Plot2D(Mag);
        Plot3D(Mag);

        Mag=CalMagneticField(Mag);
        Mag = CalStiffnessX(Mag,'Displacement',0.5);
        Mag = CalStiffnessY(Mag);
        PlotStiffnessX(Mag)
        PlotStiffnessY(Mag)

    case 2
        S=RMaterial('Magnetic');
        Mat=GetMat(S,36);
        Mat{1,1}.Mux=1.124;
        Mat{1,1}.Muy=1.124;
        Mat{1,1}.Hc=800000;

        inputStruct1.StatorR=[70,76];
        inputStruct1.RotorR=[63,69];
        inputStruct1.Height=[0,12,24,36,48,60,72,84,96];
        inputStruct1.StatorDir=[180,0,180,0,180,0,180,0];
        inputStruct1.RotorDir=[0,180,0,180,0,180,0,180];
        paramsStruct1.Material=Mat{1,1};
        paramsStruct1.TaperAngle=90;

        Mag= bearing.TaperPMB(paramsStruct1, inputStruct1);
        Mag= Mag.solve();
        Plot2D(Mag);
        Plot3D(Mag);

        Mag=CalMagneticField(Mag);
        Mag = CalStiffnessX(Mag,'Displacement',0.5);
        Mag = CalStiffnessY(Mag);
        PlotStiffnessX(Mag)
        PlotStiffnessY(Mag)

    case 3
        S=RMaterial('Magnetic');
        Mat=GetMat(S,36);
        Mat{1,1}.Mux=1.124;
        Mat{1,1}.Muy=1.124;
        Mat{1,1}.Hc=800000;

        inputStruct1.StatorR=[70,76];
        inputStruct1.RotorR=[63,69];
        inputStruct1.Height=[0,12,24,36,48,60,72,84,96];
        inputStruct1.StatorDir=[180,0,180,0,180,0,180,0];
        inputStruct1.RotorDir=[0,180,0,180,0,180,0,180];
        paramsStruct1.Material=Mat{1,1};
        paramsStruct1.TaperAngle=45;

        Mag= bearing.TaperPMB(paramsStruct1, inputStruct1);
        Mag= Mag.solve();
        Plot2D(Mag);
        Plot3D(Mag);

        Mag=CalMagneticField(Mag);
        Mag = CalStiffnessX(Mag,'Displacement',0.5);
        Mag = CalStiffnessY(Mag);
        PlotStiffnessX(Mag)
        PlotStiffnessY(Mag)

end
end
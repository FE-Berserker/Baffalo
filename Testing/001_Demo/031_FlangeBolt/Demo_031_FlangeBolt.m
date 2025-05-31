clc
clear
close all
% Demo FlangeBolt
% 1. Flange connections (VDI2230 example2)

flag=1;
DemoFlangeBolt(flag);

function DemoFlangeBolt(flag)
switch flag
    case 1
        inputStruct1.d=16;
        inputStruct1.l=80;
        inputStruct1.lk=60;
        inputStruct1.dh=17;
        paramsStruct1.ThreadType=1;
        paramsStruct1.alphaA=1.6;
        paramsStruct1.MuG=0.12;
        paramsStruct1.MuK=0.12;
        paramsStruct1.Nut=1;
        paramsStruct1.NutWasher=0;
        paramsStruct1.Washer=0;
        M16Bolt= bolt.Bolt(paramsStruct1, inputStruct1);
        M16Bolt= M16Bolt.solve();
        Plot2D(M16Bolt);
        Plot3D(M16Bolt);

        MT=13000000;%Nmm
        S=RMaterial('Basic');
        Mat=GetMat(S,57);

        inputStruct2.Bolt=M16Bolt;
        inputStruct2.MT=MT;
        inputStruct2.nB=12;
        inputStruct2.FAmax=0;
        inputStruct2.Geom=[258,338,178];
        inputStruct2.Clamping=[30,1;30,1];
        % paramsStruct2.ConShear=1;
        paramsStruct2.Material=Mat;
        BoltJoint=bolt.FlangeBolt(paramsStruct2, inputStruct2);
        BoltJoint= BoltJoint.solve();
        disp(BoltJoint.capacity.SF);
        disp(BoltJoint.capacity.SG);
        PlotCapacity(BoltJoint)
end
end
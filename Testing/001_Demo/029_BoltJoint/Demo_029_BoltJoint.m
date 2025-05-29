clc
clear
close all
% Demo BoltJoint
% 1. BoltJoint with axial force (VDI2230 example1)
% 2. BoltJoint with shearing force (VDI2230 example3)
flag=2;
DemoBoltJoint(flag);

function DemoBoltJoint(flag)
switch flag
    case 1
        inputStruct1.d=12;
        inputStruct1.l=60;
        inputStruct1.lk=42;
        inputStruct1.dh=13.5;
        paramsStruct1.ThreadType=1;
        paramsStruct1.alphaA=1.8;
        paramsStruct1.MuG=0.1;
        paramsStruct1.MuK=0.1;
        paramsStruct1.Nut=0;
        paramsStruct1.NutWasher=0;
        paramsStruct1.Washer=0;
        M12Bolt= bolt.Bolt(paramsStruct1, inputStruct1);
        M12Bolt= M12Bolt.solve();
        Plot2D(M12Bolt);
        Plot3D(M12Bolt);
        disp(M12Bolt.output.deltas)

        inputStruct2.Bolt=M12Bolt;
        inputStruct2.DA=40;
        inputStruct2.DA1=40;
        inputStruct2.FAmax=24900;
        % inputStruct2.DA=80;
        % inputStruct2.DA1=80;
        inputStruct2.Clamping=[42,1];
        inputStruct2.lA=4.2;
        paramsStruct2.JointType='SV4';
        BoltJoint=bolt.BoltJoint(paramsStruct2, inputStruct2);
        BoltJoint= BoltJoint.solve();
        disp(BoltJoint.output.deltap)
        PlotCapacity(BoltJoint)
    case 2
        inputStruct1.d=27;
        inputStruct1.l=36;
        inputStruct1.lk=7;
        inputStruct1.dh=29;
        inputStruct1.d0=16;
        paramsStruct1.ThreadType=2;
        paramsStruct1.alphaA=1.6;
        paramsStruct1.MuG=0.1;
        paramsStruct1.MuK=0.1;
        paramsStruct1.Nut=0;
        paramsStruct1.NutWasher=0;
        paramsStruct1.Washer=1;
        paramsStruct1.BoltType=0;
        paramsStruct1.Strength='8.8';
        M27Bolt= bolt.Bolt(paramsStruct1, inputStruct1);
        M27Bolt= M27Bolt.solve();
        Plot2D(M27Bolt);
        Plot3D(M27Bolt);

        S=RMaterial('Basic');
        Mat=GetMat(S,38);

        inputStruct2.Bolt=M27Bolt;
        inputStruct2.DA=48;
        inputStruct2.DA1=72;
        inputStruct2.FAmax=0;
        inputStruct2.FAmin=0;
        inputStruct2.Clamping=[7,1];
        inputStruct2.MT=110000;
        inputStruct2.ra=19.5;
        paramsStruct2.MuT=0.1;
        paramsStruct2.Material=Mat;
        paramsStruct2.JointType='SV1';
        BoltJoint=bolt.BoltJoint(paramsStruct2, inputStruct2);
        BoltJoint= BoltJoint.solve();
        disp(BoltJoint.capacity.SF)
        disp(BoltJoint.capacity.SG)
        PlotCapacity(BoltJoint)

end
end
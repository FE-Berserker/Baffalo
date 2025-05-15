clc
clear
close all
% Demo Bolt
% 1. Create Bolt with Nut
% 2. Create Bolt without Nut
% 3. Create Bolt with Nut and NutWasher
flag=3;
DemoBolt(flag);

function DemoBolt(flag)
switch flag
    case 1
        inputStruct.d=12;
        inputStruct.l=60;
        inputStruct.lk=42;
        paramsStruct.ThreadType=1;
        paramsStruct.MuG=0.1;
        paramsStruct.MuK=0.1;
        paramsStruct.Nut=1;
        obj= bolt.Bolt(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);
    case 2
        inputStruct.d=16;
        inputStruct.l=80;
        inputStruct.lk=42;
        paramsStruct.ThreadType=1;
        paramsStruct.MuG=0.1;
        paramsStruct.MuK=0.1;
        paramsStruct.Nut=0;
        obj= bolt.Bolt(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);
    case 3
        inputStruct.d=16;
        inputStruct.l=80;
        inputStruct.lk=50;
        paramsStruct.ThreadType=1;
        paramsStruct.MuG=0.1;
        paramsStruct.MuK=0.1;
        paramsStruct.Nut=1;
        paramsStruct.NutWasher=1;
        obj= bolt.Bolt(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
        ANSYS_Output(obj.output.Assembly);

end
end
clc
clear
close all
% Demo InterferenceFit
% 1. InterferenceFit Calculation and output to ANSYS
% 2. Consider temperature influence in ANSYS
% 3. Safety Factor

flag=3;
testInterferenceFit(flag);

function testInterferenceFit(flag)
switch flag
    case 1
        S=RMaterial('Basic');
        Mat=GetMat(S,22);
        inputStruct.Hub_Mat=Mat{1,1};
        inputStruct.Shaft_Mat=Mat{1,1};
        inputStruct.DaA=440;
        inputStruct.DF=240;
        inputStruct.Dil=0;
        inputStruct.LF=280;
        inputStruct.Umin=0.094;
        inputStruct.Umax=0.169;
        paramsStruct.RzA=32;
        paramsStruct.Rzl=32;
        baselineStruct=struct();
        Con1=connection.InterferenceFit(paramsStruct, inputStruct,baselineStruct);
        Con1=Con1.solve;
        Con1=OutputAss(Con1);
        disp(Con1.output.P);
        disp(Con1.output.Torque);  
        Plot(Con1.output.Assembly);
        ANSYS_Output(Con1.output.Assembly);

    case 2
        S=RMaterial('Basic');
        Mat=GetMat(S,22);
        inputStruct.Hub_Mat=Mat{1,1};
        inputStruct.Shaft_Mat=Mat{1,1};
        inputStruct.DaA=440;
        inputStruct.DF=240;
        inputStruct.Dil=0;
        inputStruct.LF=280;
        inputStruct.Umin=0.094;
        inputStruct.Umax=0.169;
        paramsStruct.RzA=32;
        paramsStruct.Rzl=32;
        paramsStruct.Temperature=[40,20];
        baselineStruct=struct();
        Con1=connection.InterferenceFit(paramsStruct, inputStruct,baselineStruct);
        Con1=Con1.solve;
        Con1=OutputAss(Con1);
        ANSYS_Output(Con1.output.Assembly);
    case 3
        S=RMaterial('Basic');
        Mat=GetMat(S,22);
        inputStruct.Hub_Mat=Mat{1,1};
        inputStruct.Shaft_Mat=Mat{1,1};
        inputStruct.DaA=440;
        inputStruct.DF=240;
        inputStruct.Dil=0;
        inputStruct.LF=280;
        inputStruct.Umin=0.094;
        inputStruct.Umax=0.169;
        inputStruct.Tn=400000;
        inputStruct.Shaft_Rm=590;
        inputStruct.Shaft_Rp=345;
        inputStruct.Hub_Rm=590;
        inputStruct.Hub_Rp=325;
        paramsStruct.RzA=32;
        paramsStruct.Rzl=32;
        baselineStruct=struct();
        Con1=connection.InterferenceFit(paramsStruct, inputStruct,baselineStruct);
        Con1=Con1.solve;
        Con1=OutputAss(Con1);
        disp(Con1.capacity);
end


end
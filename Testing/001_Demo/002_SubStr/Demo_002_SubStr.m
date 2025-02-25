% Demo SubStr
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1. Shaft1 compare (Rigid connection)
% 2. Shaft1 compare (flexibe connection)
flag=1;
DemoSubStr(flag);

function DemoSubStr(flag)
switch flag
    case 1
        % Shaft 1
        inputshaft1.Length = 500;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [50,50];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        SubAss=obj1.output.Assembly;
        %% Define Element Types
        ET1.name='21';ET1.opt=[3,0];ET1.R=[0,0,0,0,0,0];
        SubAss=AddET(SubAss,ET1);
        Acc_ET=GetNET(SubAss);
        %% Define Connections
        SubAss=AddCnode(SubAss,-0.001,0,0);
        SubAss=AddMaster(SubAss,0,1);
        SubAss=AddSlaver(SubAss,1,'face',301);
        SubAss=SetCnode(SubAss,1,Acc_ET);
        SubAss=SetRbe2(SubAss,1,1);

        SubAss=AddCnode(SubAss,500.001,0,0);
        SubAss=AddMaster(SubAss,0,2);
        SubAss=AddSlaver(SubAss,1,'face',302);
        SubAss=SetCnode(SubAss,2,Acc_ET);
        SubAss=SetRbe2(SubAss,2,2);

        NodeNum=[1;2];
        Type={'All';'All'};
        PartNum=[0;0];
        Master=table(PartNum,NodeNum,Type);
        inputSubStr.SubStr=SubAss;
        inputSubStr.Master=Master;
        paramsSubStr.Name="Shaft1";
        Sub = solve.SubStr(paramsSubStr,inputSubStr);
        Sub = Sub.solve();
        Plot3D(Sub)
        FbiGenerate(Sub)

        Multi=MultiBody('Shaft1 Test');
        Multi=AddBody(Multi,Sub);
        Simpack_Output(Multi);
    case 2
        % Shaft 1
        inputshaft1.Length = 500;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [50,50];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        SubAss=obj1.output.Assembly;

        mat1.table=["MU",0.15];
        SubAss=AddMaterial(SubAss,mat1);
        Acc_Mat=GetNMaterial(SubAss);

        %% Define Element Types
        ET1.name='173';ET1.opt=[2,2;4,1;12,5];ET1.R=[];
        SubAss=AddET(SubAss,ET1);
        ET2.name='170';ET2.opt=[2,1;4,111111];ET2.R=[];
        SubAss=AddET(SubAss,ET2);
        ET3.name='21';ET3.opt=[3,0];ET3.R=[0,0,0,0,0,0];
        SubAss=AddET(SubAss,ET3);
        Acc_ET=GetNET(SubAss);
        %% Define Contacts
        SubAss=AddCnode(SubAss,0,0,0);
        SubAss=AddCnode(SubAss,500,0,0);
        SubAss=SetCnode(SubAss,1,Acc_ET);
        SubAss=SetCnode(SubAss,2,Acc_ET);

        SubAss=AddCon(SubAss,1,301);
        SubAss=AddTar(SubAss,1,0,1);
        SubAss=SetConMaterial(SubAss,1,Acc_Mat);
        SubAss=SetConET(SubAss,1,Acc_ET-2);
        SubAss=SetTarET(SubAss,1,Acc_ET-1);

        SubAss=AddCon(SubAss,1,302);
        SubAss=AddTar(SubAss,2,0,2);
        SubAss=SetConMaterial(SubAss,2,Acc_Mat);
        SubAss=SetConET(SubAss,2,Acc_ET-2);
        SubAss=SetTarET(SubAss,2,Acc_ET-1);

        NodeNum=[1;2];
        Type={'All';'All'};
        PartNum=[0;0];
        Master=table(PartNum,NodeNum,Type);
        inputSubStr.SubStr=SubAss;
        inputSubStr.Master=Master;
        paramsSubStr.Name="Shaft1";
        Sub = solve.SubStr(paramsSubStr,inputSubStr);
        Sub = Sub.solve();
        Plot3D(Sub)
        FbiGenerate(Sub)

        Multi=MultiBody('Shaft1 Test');
        Multi=AddBody(Multi,Sub);
        Simpack_Output(Multi);
end
end
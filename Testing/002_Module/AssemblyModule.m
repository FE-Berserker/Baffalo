clc
clear
close all
% Assembly module main programme
% Author : Xie Yu

ComponentPlotFlag=0; % Component plot
AssemblyPlotFlag=1; % Assembly plot
ContactPlotFlag=0; % Contact plot
OutputFlag=1; % Output cdb file to ANSYS
SensorOutputFlag=1; % Result output

%% Parameter
% load Params Params % Load Params

%% Component
% 1. Component1
% Component1=load('.\Component1\Component1.mat').Component1;

%% Component plot
if ComponentPlotFlag==1 % Plot Component
    % Plot3D(Component1) 
end

%% Assembly
Ass=Assembly('New_Assembly');
% 1. Add Component1
% position=[0,0,0,0,0,0];
% Ass=AddAssembly(Ass,Component1.output.Assembly,'position',position);

%% Define Element Types
ET1.name='185';ET1.opt=[];ET1.R=[];
Ass=AddET(Ass,ET1);
ET2.name='21';ET2.opt=[3,0];ET2.R=[0,0,0,0,0,0];
Ass=AddET(Ass,ET2);
ET3.name='173';ET3.opt=[5,3;9,1;10,2;12,5];ET3.R=[]; % Bonded contact
Ass=AddET(Ass,ET3);
ET4.name='173';ET4.opt=[2,2;5,3;9,1;10,2;12,5];ET4.R=[]; % Bonded (MPC) contact
Ass=AddET(Ass,ET4);
ET5.name='173';ET5.opt=[5,3;9,1;10,2];ET5.R=[]; % Standard contact
Ass=AddET(Ass,ET5);
ET6.name='170';ET6.opt=[];ET6.R=[];
Ass=AddET(Ass,ET6);

Acc_ET=GetNET(Ass);
mat1.table=["MU",0.15];
Ass=AddMaterial(Ass,mat1);
% mat2.TBlab=["CZM",1,0,"CBDE"];
% mat2.TBtable=[20,0.35,40,1,5e-4,1]; % Composite steel glue
% Ass=AddMaterial(Ass,mat2);
% mat3.TBlab=["CZM",1,0,"CBDE"];
% mat3.TBtable=[30,0.35,60,1,5e-4,1]; % Composite composite glue
% Ass=AddMaterial(Ass,mat3);
Acc_Mat=GetNMaterial(Ass);

%% Define Contacts
% 1. Component1 - Component2
% ConNum=GetNContactPair(Ass)+1;
% Ass=AddCon(Ass,Component1_Assembly_Num1,1);
% Ass=AddTar(Ass,ConNum,repmat(ReinforcedRing_Assembly_Num1,2,1),[103;104]);
% Ass=SetConMaterial(Ass,ConNum,Acc_Mat);
% Ass=SetConET(Ass,ConNum,Acc_ET-1);
% Ass=SetTarET(Ass,ConNum,Acc_ET);

%% Plot Contacts
if ContactPlotFlag==1
    for i=1:GetNContactPair(Ass)
        PlotCon(Ass,i);
    end
end
%% Define Connections
% 1. Connection1
% Acc_Cnode=GetNCnode(Ass);
% Acc_Mas=GetNMaster(Ass);
% Acc_Sla=GetNSlaver(Ass);
% Ass=AddCnode(Ass,0,0,Params.Component1_Couple_Height1);
% Ass=AddMaster(Ass,0,Acc_Cnode+1);
% Ass=AddSlaver(Ass,Component1_Assembly_Num,'face',1);
% Ass=SetRbe3(Ass,Acc_Mas+1,Acc_Sla+1);
% Ass=SetCnode(Ass,Acc_Cnode+1,Acc_ET-5);
% 
% Acc_Cnode=GetNCnode(Ass);
% Acc_Mas=GetNMaster(Ass);
% Acc_Sla=GetNSlaver(Ass);
% Ass=AddCnode(Ass,0,0,Params.Component1_Couple_Height2);
% Ass=AddMaster(Ass,0,Acc_Cnode+1);
% Ass=AddSlaver(Ass,Component_Assembly_Num,'face',2);
% Ass=SetRbe3(Ass,Acc_Mas+1,Acc_Sla+1);
% Ass=SetCnode(Ass,1+Acc_Cnode,Acc_ET-5);
% Ass=SetSpring(Ass,Acc_Mas,Acc_Mas+1,[100,100,0,0,0,0]);

%% Boundary
% BoundNum=GetNBoundary(Ass);
% Bound1=[1,1,1,0,0,0];
% Ass=AddBoundary(Ass,Component1_Assembly_Num,'No',1);
% Ass=SetBoundaryType(Ass,BoundNum,Bound1);

%% Assembly Plot
if AssemblyPlotFlag==1 % Plot Assembly
    % Plot(Ass,'connection',1,'boundary',1);
    % sec.pos=[0,0,0];
    % sec.vec=[1,0,0];
    % Plot(Ass,'section',sec);
end
%% Solution
% opt.ANTYPE=0;
% opt.NSUBST=20;
% opt.AUTOTS="OFF";
% opt.NLGEOM=1;
% opt.ARCLEN=1;
% opt.OUTRES=["ALL","ALL"];
% opt.OMEGA=[0,0,w];
% Ass=AddSolu(Ass,opt);
% Ass=AddSensor(Ass,'U',1);

% opt1.ANTYPE=2;
% opt1.MODOPT=["LANB",ModeNum];
% opt1.MXPAND=[ModeNum,0,0,0];
% AddSolu(Ass,opt1);

%% Output to ANSYS
if OutputFlag==1
    ANSYS_Output(Ass);
end
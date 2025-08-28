clc
clear
close all
% Disc coupling assembly main programme
% Author : Xie Yu
ComponentPlotFlag=0;
ContactPlotFlag=0;
OutputFlag=1;
SensorOutputFlag=1;

%% Parameter
load Params Params

%% component
% 1. Shaft1
Shaft1_Assembly_Num=1;
Shaft1=load('.\Shaft1\Shaft1.mat').Shaft1;

% 2.Shaft2
Shaft2_Assembly_Num=Shaft1_Assembly_Num+1;
Shaft2=load('.\Shaft2\Shaft2.mat').Shaft2;

% 3.Flange1
Flange1_Assembly_Num=Shaft2_Assembly_Num+1;
Flange1=load('.\Flange1\Flange1.mat').Flange1;

% 3.Flange2
Flange2_Assembly_Num=Flange1_Assembly_Num+1;
Flange2=load('.\Flange2\Flange2.mat').Flange2;

% 4.Tube
Tube_Assembly_Num=Flange2_Assembly_Num+1;
Tube=load('.\Tube\Tube.mat').Tube;

% 5. Membrane
Membrane_Assembly_Num1=Tube_Assembly_Num+1;
Membrane_Assembly_Num2=Membrane_Assembly_Num1+Params.Membrane_Num;
Membrane=load('.\Membrane\Membrane.mat').Membrane;

% 6. Washer1
Washer1_Assembly_Num1=Membrane_Assembly_Num2+Params.Membrane_Num;
Washer1_Assembly_Num2=Washer1_Assembly_Num1+Params.Washer1_Num1;
Washer1=load('.\Washer1\Washer1.mat').Washer1;

% 7. Washer2
Washer2_Assembly_Num1=Washer1_Assembly_Num2+Params.Washer1_Num2;
Washer2_Assembly_Num2=Washer2_Assembly_Num1+Params.Washer2_Num1;
Washer2=load('.\Washer2\Washer2.mat').Washer2;

% 8. Bush1
Bush1_Assembly_Num1=Washer2_Assembly_Num2+Params.Washer2_Num2;
Bush1_Assembly_Num2=Bush1_Assembly_Num1+Params.Bush1_Num1;
Bush1=load('.\Bush1\Bush1.mat').Bush1;

% 9. Bush2
Bush2_Assembly_Num1=Bush1_Assembly_Num2+Params.Bush1_Num2;
Bush2_Assembly_Num2=Bush2_Assembly_Num1+Params.Bush2_Num1;
Bush2=load('.\Bush2\Bush2.mat').Bush2;

% 10. Bolt1
Bolt1=load('.\Bolt1\Bolt1.mat').Bolt1;
Bolt1_Assembly_Num1=Bush2_Assembly_Num2+Params.Bush2_Num2;
Bolt1_Assembly_Num2=Bolt1_Assembly_Num1+Params.Bolt1_Num1*size(Bolt1.output.Assembly.Part,1);


% 11. Bolt2
Bolt2=load('.\Bolt2\Bolt2.mat').Bolt2;
Bolt2_Assembly_Num1=Bolt1_Assembly_Num2+Params.Bolt1_Num2*size(Bolt1.output.Assembly.Part,1);
Bolt2_Assembly_Num2=Bolt2_Assembly_Num1+Params.Bolt2_Num1*size(Bolt2.output.Assembly.Part,1);


%% Figure plot
if ComponentPlotFlag==1
    Plot3D(Shaft1);
    Plot3D(Shaft2);
    Plot3D(Flange1);
    Plot3D(Flange2);
    Plot3D(Tube);
    Plot3D(Membrane);
    Plot3D(Washer1);
    Plot3D(Washer2);
    Plot3D(Bush1);
    Plot3D(Bush2);
    Plot3D(Bolt1);
    Plot3D(Bolt2);
end
%% Assembly
Ass=Assembly('Disc_Coupling_Assembly');

% 1. Add Shaft1
position=[Params.Shaft1_Assembly_X,0,0,0,0,180];
Ass=AddAssembly(Ass,Shaft1.output.Assembly,'position',position);

% 2. Add Shaft2
position=[Params.Shaft2_Assembly_X,0,0,0,0,0];
Ass=AddAssembly(Ass,Shaft2.output.Assembly,'position',position);

% 3. Add Flange1
position=[Params.Flange1_Assembly_X,0,0,0,-90,0];
Ass=AddAssembly(Ass,Flange1.output.Assembly,'position',position);

% 4. Add Flange2
position=[Params.Flange2_Assembly_X,0,0,0,90,0];
Ass=AddAssembly(Ass,Flange2.output.Assembly,'position',position);

% 5. Add Tube
position=[Params.Tube_Assembly_X,0,0,135,0,0];
Ass=AddAssembly(Ass,Tube.output.Assembly,'position',position);

% 6. Add Membrane
Num=Params.Membrane_Num;
dis=Params.Membrane_Thickness;
for i=1:Num
    position=[Params.Membrane_Assembly_X1+dis*(i-1),0,0,0,-90,0];
    Ass=AddAssembly(Ass,Membrane.output.Assembly,'position',position);
end

for i=1:Num
    position=[Params.Membrane_Assembly_X2-dis*(i-1),0,0,0,90,0];
    Ass=AddAssembly(Ass,Membrane.output.Assembly,'position',position);
end

% 7. Add Washer1
Dp=Params.Washer1_Dp;
position=[Params.Washer1_Assembly_X1,0,Dp/2,0,-90,0];
Ass=AddAssembly(Ass,Washer1.output.Assembly,'position',position);
position=[Params.Washer1_Assembly_X1,0,-Dp/2,0,-90,0];
Ass=AddAssembly(Ass,Washer1.output.Assembly,'position',position);
position=[Params.Washer1_Assembly_X2,Dp/2,0,0,-90,0];
Ass=AddAssembly(Ass,Washer1.output.Assembly,'position',position);
position=[Params.Washer1_Assembly_X2,-Dp/2,0,0,-90,0];
Ass=AddAssembly(Ass,Washer1.output.Assembly,'position',position);

% 8. AddWasher2
Dp=Params.Washer2_Dp;
position=[Params.Washer2_Assembly_X1,Dp/2,0,0,90,0];
Ass=AddAssembly(Ass,Washer2.output.Assembly,'position',position);
position=[Params.Washer2_Assembly_X1,-Dp/2,0,0,90,0];
Ass=AddAssembly(Ass,Washer2.output.Assembly,'position',position);
position=[Params.Washer2_Assembly_X2,0,Dp/2,0,90,0];
Ass=AddAssembly(Ass,Washer2.output.Assembly,'position',position);
position=[Params.Washer2_Assembly_X2,0,-Dp/2,0,90,0];
Ass=AddAssembly(Ass,Washer2.output.Assembly,'position',position);

% 9. Add Bush1
Dp=Params.Bush1_Dp;
position=[Params.Bush1_Assembly_X1,Dp/2,0,0,-90,0];
Ass=AddAssembly(Ass,Bush1.output.Assembly,'position',position);
position=[Params.Bush1_Assembly_X1,-Dp/2,0,0,-90,0];
Ass=AddAssembly(Ass,Bush1.output.Assembly,'position',position);
position=[Params.Bush1_Assembly_X2,0,Dp/2,0,-90,0];
Ass=AddAssembly(Ass,Bush1.output.Assembly,'position',position);
position=[Params.Bush1_Assembly_X2,0,-Dp/2,0,-90,0];
Ass=AddAssembly(Ass,Bush1.output.Assembly,'position',position);

% 10. Add Bush2
Dp=Params.Bush2_Dp;
position=[Params.Bush2_Assembly_X1,0,Dp/2,0,90,0];
Ass=AddAssembly(Ass,Bush2.output.Assembly,'position',position);
position=[Params.Bush2_Assembly_X1,0,-Dp/2,0,90,0];
Ass=AddAssembly(Ass,Bush2.output.Assembly,'position',position);
position=[Params.Bush2_Assembly_X2,Dp/2,0,0,90,0];
Ass=AddAssembly(Ass,Bush2.output.Assembly,'position',position);
position=[Params.Bush2_Assembly_X2,-Dp/2,0,0,90,0];
Ass=AddAssembly(Ass,Bush2.output.Assembly,'position',position);

% 11. Add Bolt1
Dp=Params.Bolt1_Dp;
position=[Params.Bolt1_Assembly_X1,Dp/2,0,0,0,0];
Ass=AddAssembly(Ass,Bolt1.output.Assembly,'position',position);
position=[Params.Bolt1_Assembly_X1,-Dp/2,0,0,0,0];
Ass=AddAssembly(Ass,Bolt1.output.Assembly,'position',position);
position=[Params.Bolt1_Assembly_X2,0,Dp/2,0,0,180];
Ass=AddAssembly(Ass,Bolt1.output.Assembly,'position',position);
position=[Params.Bolt1_Assembly_X2,0,-Dp/2,0,0,180];
Ass=AddAssembly(Ass,Bolt1.output.Assembly,'position',position);

% 12. Add Bolt2
Dp=Params.Bolt2_Dp;
position=[Params.Bolt2_Assembly_X1,0,Dp/2,0,0,180];
Ass=AddAssembly(Ass,Bolt2.output.Assembly,'position',position);
position=[Params.Bolt2_Assembly_X1,0,-Dp/2,0,0,180];
Ass=AddAssembly(Ass,Bolt2.output.Assembly,'position',position);
position=[Params.Bolt2_Assembly_X2,Dp/2,0,0,0,0];
Ass=AddAssembly(Ass,Bolt2.output.Assembly,'position',position);
position=[Params.Bolt2_Assembly_X2,-Dp/2,0,0,0,0];
Ass=AddAssembly(Ass,Bolt2.output.Assembly,'position',position);

%% Define Element Types
ET1.name='21';ET1.opt=[3,0];ET1.R=[0,0,0,0,0,0];
Ass=AddET(Ass,ET1);
ET2.name='173';ET2.opt=[5,3;9,1;10,2;12,5];ET2.R=[]; % Bonded contact
Ass=AddET(Ass,ET2);
ET3.name='173';ET3.opt=[5,3;9,1;10,2];ET3.R=[]; % Standard contact
Ass=AddET(Ass,ET3);
ET4.name='170';ET4.opt=[];ET4.R=[];
Ass=AddET(Ass,ET4);
Acc_ET=GetNET(Ass);

mat1.table=["MU",0.12];
Ass=AddMaterial(Ass,mat1);
Acc_Mat=GetNMaterial(Ass);

%% Define Contacts

% 1. Flange1 - Shaft1
AccCon=GetNContactPair(Ass);
Ass=AddCon(Ass,Flange1_Assembly_Num,31);
Ass=AddTar(Ass,AccCon+1,Shaft1_Assembly_Num,101);
Ass=SetConMaterial(Ass,AccCon+1,Acc_Mat);
Ass=SetConET(Ass,AccCon+1,Acc_ET-2);
Ass=SetTarET(Ass,AccCon+1,Acc_ET);

% 2. Flange2 - Shaft2
AccCon=GetNContactPair(Ass);
Ass=AddCon(Ass,Flange2_Assembly_Num,31);
Ass=AddTar(Ass,AccCon+1,Shaft2_Assembly_Num,101);
Ass=SetConMaterial(Ass,AccCon+1,Acc_Mat);
Ass=SetConET(Ass,AccCon+1,Acc_ET-2);
Ass=SetTarET(Ass,AccCon+1,Acc_ET);

% 3. Membrane -  Membrane
AccCon=GetNContactPair(Ass);
Num=Params.Membrane_Num;
for i=1:Num-1
    Ass=AddCon(Ass,Membrane_Assembly_Num1+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num1+i,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-1);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end
AccCon=GetNContactPair(Ass);
for i=1:Num-1
    Ass=AddCon(Ass,Membrane_Assembly_Num2+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num2+i,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-1);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 4. Bolt1Head - Bush1
Gap=size(Bolt1.output.Assembly.Part,1);
BoltNum=Params.Bolt1_Num1;
AccCon=GetNContactPair(Ass);
Num1=Bolt1_Assembly_Num1+Bolt1.output.BoltHead_Assembly_Num-1;
Num2=Bush1_Assembly_Num1;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),3);
    Ass=AddTar(Ass,AccCon+i,Num2+i-1,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

BoltNum=Params.Bolt1_Num2;
AccCon=GetNContactPair(Ass);
Num1=Bolt1_Assembly_Num2+Bolt1.output.BoltHead_Assembly_Num-1;
Num2=Bush1_Assembly_Num2;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),3);
    Ass=AddTar(Ass,AccCon+i,Num2+i-1,3);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 5. Bolt2Head - Bush2
Gap=size(Bolt2.output.Assembly.Part,1);
BoltNum=Params.Bolt2_Num1;
AccCon=GetNContactPair(Ass);
Num1=Bolt2_Assembly_Num1+Bolt2.output.BoltHead_Assembly_Num-1;
Num2=Bush2_Assembly_Num1;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),3);
    Ass=AddTar(Ass,AccCon+i,Num2+i-1,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

BoltNum=Params.Bolt2_Num2;
AccCon=GetNContactPair(Ass);
Num1=Bolt2_Assembly_Num2+Bolt2.output.BoltHead_Assembly_Num-1;
Num2=Bush2_Assembly_Num2;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),3);
    Ass=AddTar(Ass,AccCon+i,Num2+i-1,3);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 6. Bush1 - Membrane
Num=Params.Bush1_Num1;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Bush1_Assembly_Num1+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num1,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

Num=Params.Bush1_Num2;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Bush1_Assembly_Num2+i-1,2);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num1+Params.Membrane_Num-1,3);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 7. Bush2 - Membrane
Num=Params.Bush2_Num1;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Bush2_Assembly_Num1+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num2,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

Num=Params.Bush2_Num2;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Bush2_Assembly_Num2+i-1,2);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num2+Params.Membrane_Num-1,3);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 8. Washer1 - Membrane
Num=Params.Washer1_Num1;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer1_Assembly_Num1+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num1,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

Num=Params.Washer1_Num2;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer1_Assembly_Num2+i-1,2);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num1+Params.Membrane_Num-1,3);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 9. Washer2 - Membrane
Num=Params.Washer2_Num1;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer2_Assembly_Num1+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num2,2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

Num=Params.Washer2_Num2;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer2_Assembly_Num2+i-1,2);
    Ass=AddTar(Ass,AccCon+i,Membrane_Assembly_Num2+Params.Membrane_Num-1,3);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 9. Washer1 - Flange1
Num=Params.Washer1_Num1;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer1_Assembly_Num1+i-1,2);
    Ass=AddTar(Ass,AccCon+i,Flange1_Assembly_Num,11);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 10. Washer1 - Tube
Num=Params.Washer1_Num2;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer1_Assembly_Num2+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Tube_Assembly_Num,1000+i*2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 11. Washer2 - Flange2
Num=Params.Washer2_Num1;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer2_Assembly_Num1+i-1,2);
    Ass=AddTar(Ass,AccCon+i,Flange2_Assembly_Num,11);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 12. Washer2 - Tube
Num=Params.Washer2_Num2;
AccCon=GetNContactPair(Ass);
for i=1:Num
    Ass=AddCon(Ass,Washer2_Assembly_Num2+i-1,3);
    Ass=AddTar(Ass,AccCon+i,Tube_Assembly_Num,1013-i*2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end


% 13. Bolt1Nut - Tube
Gap=size(Bolt1.output.Assembly.Part,1);
BoltNum=Params.Bolt1_Num1;
AccCon=GetNContactPair(Ass);
Num1=Bolt1_Assembly_Num1+Bolt1.output.Nut_Assembly_Num-1;
Num2=Tube_Assembly_Num;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),2);
    Ass=AddTar(Ass,AccCon+i,Num2,1004+i*2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 14. Bolt1Nut - Flange1
BoltNum=Params.Bolt1_Num2;
AccCon=GetNContactPair(Ass);
Num1=Bolt1_Assembly_Num2+Bolt1.output.Nut_Assembly_Num-1;
Num2=Flange1_Assembly_Num;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),2);
    Ass=AddTar(Ass,AccCon+i,Num2,12);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 15. Bolt2Nut - Tube
Gap=size(Bolt2.output.Assembly.Part,1);
BoltNum=Params.Bolt2_Num1;
AccCon=GetNContactPair(Ass);
Num1=Bolt2_Assembly_Num1+Bolt2.output.Nut_Assembly_Num-1;
Num2=Tube_Assembly_Num;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),2);
    Ass=AddTar(Ass,AccCon+i,Num2,1017-i*2);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end

% 16. Bolt2Nut - Flange2
BoltNum=Params.Bolt2_Num2;
AccCon=GetNContactPair(Ass);
Num1=Bolt2_Assembly_Num2+Bolt2.output.Nut_Assembly_Num-1;
Num2=Flange2_Assembly_Num;
for i=1:BoltNum
    Ass=AddCon(Ass,Num1+Gap*(i-1),2);
    Ass=AddTar(Ass,AccCon+i,Num2,12);
    Ass=SetConMaterial(Ass,AccCon+i,Acc_Mat);
    Ass=SetConET(Ass,AccCon+i,Acc_ET-2);
    Ass=SetTarET(Ass,AccCon+i,Acc_ET);
end


%% Plot Contacts
if ContactPlotFlag==1
    for i=1:GetNContactPair(Ass)
        PlotCon(Ass,i);
    end
end
%% Define Connections
Acc_Mas=GetNMaster(Ass);
Acc_Sla=GetNSlaver(Ass);
Acc_Cnode=GetNCnode(Ass);
Ass=AddCnode(Ass,Params.Shaft2_Assembly_X+Params.Shaft2_l,0,0);
Ass=AddMaster(Ass,0,Acc_Cnode+1);
Ass=SetCnode(Ass,Acc_Cnode+1,Acc_ET-3);
AddSlaver(Ass,Shaft2_Assembly_Num,'face',302);
SetRbe2(Ass,Acc_Mas+1,Acc_Sla+1);
%% Displacement
Ass=AddDisplacement(Ass,0,'No',Acc_Cnode+1);
Ass=SetDisplacement(Ass,1,[0,0.1,0,0,0,0]);
%% Load
% Load=[0,0,-Params.Load*Params.IBeam_b*Params.IBeam_l,0,0,0];
% Ass=AddLoad(Ass,Flange1_Assembly_Num,'No',112);
% Ass=SetLoad(Ass,1,Load);
%% Boundary
Bound1=[1,1,1,0,0,0];
Ass=AddBoundary(Ass,Shaft1_Assembly_Num,'No',302);
Ass=SetBoundaryType(Ass,1,Bound1);
Bound1=[1,0,1,1,1,1];
Ass=AddBoundary(Ass,0,'No',Acc_Cnode+1);
Ass=SetBoundaryType(Ass,2,Bound1);
%% Assembly Plot
Plot(Ass)
Plot(Ass,'connection',1,'boundary',1);
sec.pos=[0,0,0];
sec.vec=[0,1,0];
Plot(Ass,'section',sec);
% PlotExplod(Ass,'Ratio',[3,1.5,1.5]);
%% Solution
opt.ANTYPE=0;
Ass=AddSolu(Ass,opt);

%% Output to ANSYS
if OutputFlag==1
    ANSYS_Output(Ass,'Warning',0);
end

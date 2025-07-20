function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
PairNum=obj.input.Pair;
Theta=360/PairNum;
Size1=obj.input.InnerMagnetSize;
Size2=obj.input.OuterMagnetSize;
Pos1=obj.params.Pos1;
Pos2=obj.params.Pos2;
R2=obj.input.B/2-Pos1*Size1(2);
R3=obj.input.C/2+Pos2*Size2(2);

Dx=obj.params.Dx;
Dy=obj.params.Dy;
Rot=obj.params.Rot;

Ass=Assembly(obj.params.Name,'Echo',0);
% Add InnerMagnet
for i=1:PairNum
    position=[R2*cos(Theta*(i-1)/180*pi+Rot/180*pi)+Dx,R2*sin(Theta*(i-1)/180*pi+Rot/180*pi)+Dy,0,0,0,90+Theta*(i-1)+Rot];
    Ass=AddPart(Ass,obj.output.SolidMesh{1,1}.Meshoutput,'position',position);
end
% Add OuterMagnet
for i=1:PairNum
    position=[R3*cos(Theta*(i-1)/180*pi),R3*sin(Theta*(i-1)/180*pi),0,0,0,90+Theta*(i-1)];
    Ass=AddPart(Ass,obj.output.SolidMesh{2,1}.Meshoutput,'position',position);
end
position=[Dx,Dy,0,0,0,Rot];
Ass=AddPart(Ass,obj.output.SolidMesh{3,1}.Meshoutput,'position',position);
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.SolidMesh{4,1}.Meshoutput,'position',position);

% ET
ET1.name='185';ET1.opt=[];ET1.R=[];
ET2.name='173';ET2.opt=[5,3;9,1;10,2;12,5];ET2.R=[]; % Bonded contact
Ass=AddET(Ass,ET2);
ET3.name='170';ET3.opt=[];ET3.R=[];
Ass=AddET(Ass,ET3);
Acc_ET=GetNET(Ass);

Ass=AddET(Ass,ET1);
for i=1:2*PairNum+2
    Ass=SetET(Ass,i,1);
end
%  Material
mat1.name=obj.params.Material{1,1}.Name;
mat1.table=["DENS",obj.params.Material{1,1}.Dens;"EX",obj.params.Material{1,1}.E;...
    "NUXY",obj.params.Material{1,1}.v];
Ass=AddMaterial(Ass,mat1);

for i=1:PairNum*2
    Ass=SetMaterial(Ass,1,1);
end

mat1.name=obj.params.Material{2,1}.Name;
mat1.table=["DENS",obj.params.Material{2,1}.Dens;"EX",obj.params.Material{2,1}.E;...
    "NUXY",obj.params.Material{2,1}.v];
Ass=AddMaterial(Ass,mat1);

Ass=SetMaterial(Ass,PairNum*2+1,2);

mat1.name=obj.params.Material{3,1}.Name;
mat1.table=["DENS",obj.params.Material{3,1}.Dens;"EX",obj.params.Material{3,1}.E;...
    "NUXY",obj.params.Material{3,1}.v];
Ass=AddMaterial(Ass,mat1);

Ass=SetMaterial(Ass,PairNum*2+2,3);

% Contact
%% Define Element Types
mat1.table=["MU",0.15];
Ass=AddMaterial(Ass,mat1);
Acc_Mat=GetNMaterial(Ass);
% 1. Magnet - Shaft
ConNum=GetNContactPair(Ass)+1;
Ass=AddCon(Ass,(1:PairNum)',ones(PairNum,1));
Ass=AddTar(Ass,ConNum,PairNum*2+1,1);
Ass=SetConMaterial(Ass,ConNum,Acc_Mat);
Ass=SetConET(Ass,ConNum,Acc_ET-1);
Ass=SetTarET(Ass,ConNum,Acc_ET);

% 2. Magnet - Housing
ConNum=GetNContactPair(Ass)+1;
Ass=AddCon(Ass,(PairNum+1:PairNum*2)',ones(PairNum,1));
Ass=AddTar(Ass,ConNum,PairNum*2+2,1);
Ass=SetConMaterial(Ass,ConNum,Acc_Mat);
Ass=SetConET(Ass,ConNum,Acc_ET-1);
Ass=SetTarET(Ass,ConNum,Acc_ET);

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end
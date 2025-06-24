function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
m=obj.output.SolidMesh;

Ass=Assembly(obj.input.FileName,'Echo',0);
% Create woven cell
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,m.Meshoutput,'position',position);

% ET
ET1.name='185';ET1.opt=[];ET1.R=[];
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);

mm=size(m.El(m.Meshoutput.elementMaterialID~=-1),1);
%  Material
Material=obj.input.Matrix;
mat.table=["DENS",Material.Dens;"EX",Material.E1;"EY",Material.E2;"EZ",Material.E3;...
    "PRXY",Material.v12;"PRYZ",Material.v23;"PRXZ",Material.v13;...
    "GXY",Material.G12;"GYZ",Material.G23;"GXZ",Material.G13];
Ass=AddMaterial(Ass,mat);
for i=1:mm
    Material=obj.output.Yarn;
    mat.table=["DENS",Material.Dens;"EX",Material.E1;"EY",Material.E2;"EZ",Material.E3;...
        "PRXY",Material.v12;"PRYZ",Material.v23;"PRXZ",Material.v13;...
        "GXY",Material.G12;"GYZ",Material.G23;"GXZ",Material.G13];
    Ass=AddMaterial(Ass,mat);
end

% Calculate theta
Ori=obj.output.Orientation(m.Meshoutput.elementMaterialID~=-1,:);
[THxy,THyz]=CalTheta(Ori);
% Coordinate
for i=1:mm
    opt=[0,0,0,THxy(i,1),THyz(i,1),0];
    Ass=AddCS(Ass,0,opt);
end
Temp=1:size(m.El,1);
TempEl1{1,1}=Temp(m.Meshoutput.elementMaterialID==-1)';
TempEl2=Temp(m.Meshoutput.elementMaterialID~=-1)';
matrix=[TempEl1;mat2cell(TempEl2,ones(1,mm))];

Ass=DividePart(Ass,1,matrix);

Ass=SetMaterial(Ass,1,1);
for i=1:mm
    Ass=SetESYS(Ass,i+1,10+i);
    Ass=SetMaterial(Ass,i+1,i+1);
end

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end

function [THxy,THyz]=CalTheta(Ori)

THxy=acos(Ori(:,1));
THyz=atan(Ori(:,3)./Ori(:,2));

THxy=THxy/pi*180;
THyz=real(THyz)/pi*180;
end
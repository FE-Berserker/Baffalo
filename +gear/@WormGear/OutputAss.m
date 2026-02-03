function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
gamma=obj.output.gamma;
d2=obj.output.d2;
b2H=obj.input.b2H;
beta=b2H*tan(gamma/180*pi)/d2*2/pi*180;
Z1=obj.input.Z1;

Ass=Assembly(obj.params.Name,'Echo',0);
% Ass wormgear
if Z1==1
    position=[0,0,0,180,0,0];
else
    position=[0,0,0,0,0,0];
end
Ass=AddPart(Ass,obj.output.WormSolidMesh.Meshoutput,'position',position);
position=[0,-obj.input.a,0,0,0,90-beta/2];
Ass=AddPart(Ass,obj.output.WheelSolidMesh.Meshoutput,'position',position);

% ET
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);
Ass=SetET(Ass,2,1);
%  Material
mat1.name=obj.params.Material{1,1}.Name;
mat1.table=["DENS",obj.params.Material{1,1}.Dens;"EX",obj.params.Material{1,1}.E;...
    "NUXY",obj.params.Material{1,1}.v;"ALPX",obj.params.Material{1,1}.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

mat1.name=obj.params.Material{2,1}.Name;
mat1.table=["DENS",obj.params.Material{2,1}.Dens;"EX",obj.params.Material{2,1}.E;...
    "NUXY",obj.params.Material{2,1}.v;"ALPX",obj.params.Material{2,1}.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,2,2);

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end
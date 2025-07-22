function obj = OutputAss1(obj)
% Output shellmesh to Assembly
% Author : Xie Yu

Ass=Assembly(obj.params.Name,'Echo',0);
% Create plate
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.ShellMesh.Meshoutput,'position',position);

%  Material
mat1.name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);
% Section
% ET
if obj.params.Order==2
    ET1.name='183';
    ET1.opt=[3,3];
    ET1.R=obj.input.b;
else
    ET1.name='182';
    ET1.opt=[3,3];
    ET1.R=obj.input.b;
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);
ET2.name='21';ET2.opt=[3,0];ET2.R=[0,0,0,0,0,0];
Ass=AddET(Ass,ET2);
% Cnode
Ass=AddCnode(Ass,0,0,0);
Ass=AddMaster(Ass,0,1);
Ass=SetCnode(Ass,1,2);
Ass=AddSlaver(Ass,1,'face',1);
Ass=SetRbe2(Ass,1,1);

%% Parse
obj.output.Assembly1=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh assembly .\n');
end
end
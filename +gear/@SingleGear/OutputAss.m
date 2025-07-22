function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

Ass=Assembly(obj.params.Name,'Echo',0);
% Create Shaft
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput,'position',position);

% ET
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);
%  Material
mat1.name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

ET2.name='21';ET2.opt=[3,0];ET2.R=[0,0,0,0,0,0];
Ass=AddET(Ass,ET2);
% Cnode
delta=obj.input.b/obj.params.NMaster;
for i=1:obj.params.NMaster
    Ass=AddCnode(Ass,0,0,-obj.input.b/2+delta/2+delta*(i-1));
    Ass=AddMaster(Ass,0,i);
    Ass=SetCnode(Ass,i,2);
    Ass=AddSlaver(Ass,1,'face',1000+i);
    Ass=SetRbe2(Ass,i,i);
    obj.output.MasterPoint.Pos(i,:)=[-obj.input.b/2+delta*(i-1),-obj.input.b/2+delta*i];
end

%% Parse
obj.output.MasterPoint.Num=(Ass.Summary.Total_Node+1:Ass.Summary.Total_Node+obj.params.NMaster)';
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end
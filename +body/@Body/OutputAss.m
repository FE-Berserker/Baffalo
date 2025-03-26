function obj = OutputAss(obj)
% Output assembly
% Author : Xie Yu
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

Ass=Assembly(obj.params.Name);
% Create Housing
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput,position);

%ET
ET1.name='185';ET1.opt=[];ET1.R=[];
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);
%  Material
mat1.name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

obj.output.Assembly=Ass;

%% Print
if obj.params.Echo
    fprintf('Successfully output assembly .\n');
end
end


function obj = OutputAss(obj)
% Output Assembly file
% Author : Xie Yu
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

Ass=Assembly(obj.params.Name,'Echo',0);
% Create Housing
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput);

% ET
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
end

Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);
%  Material
mat1.Name=obj.params.Material.Name;

if isfield(obj.params.Material,"E1")
    mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E1;"EY",obj.params.Material.E2;"EZ",obj.params.Material.E3;...
        "PRXY",obj.params.Material.v12;"PRYZ",obj.params.Material.v23;"PRXZ",obj.params.Material.v13;...
        "GXY",obj.params.Material.G12;"GYZ",obj.params.Material.G23;"GXZ",obj.params.Material.G13];
else
    mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
        "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
end

Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid assembly .\n');
end
end


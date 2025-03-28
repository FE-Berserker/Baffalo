function obj = OutputAss(obj)
% Output shellmesh to Assembly
% Author : Xie Yu
if isempty(obj.output.ShellMesh)
    obj=OutputShellModel(obj);
end

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
% DividePart
Ass=DividePart(Ass,1,obj.output.Matrix);
% Section
Sec.type="shell";
Sec.offset=obj.params.Offset;
for i=1:size(obj.input.Thickness,1)
    Sec.data=[obj.input.Thickness(i,1),1,0,3];
    Ass=AddSection(Ass,Sec);
    Ass=SetSection(Ass,i,i);
end

% ET
if obj.params.Order==2
    ET1.name='281';ET1.opt=[];ET1.R=[];
else
    ET1.name='181';ET1.opt=[];ET1.R=[];
end
Ass=AddET(Ass,ET1);
for i=1:size(obj.input.Thickness,1)
    Ass=SetET(Ass,i,1);
end

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh assembly .\n');
end
end
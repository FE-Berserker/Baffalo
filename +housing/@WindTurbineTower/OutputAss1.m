function obj=OutputAss1(obj)
% Output Beam assembly
% Author : Xie Yu
Ass=Assembly(obj.params.Name,'Echo',0);
% Create Shaft
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.BeamMesh.Meshoutput,'position',position);
% ET
ET.name='188';ET.opt=[3,2];ET.R=[];
Ass=AddET(Ass,ET);
Ass=SetET(Ass,1,1);
Ass=BeamK(Ass,1);
% Material
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);
% Section
Section=obj.output.BeamMesh.Section;
Ass=DividePart(Ass,1,mat2cell((1:size(Section,1))',ones(1,size(Section,1))));
for i=1:size(Section,1)
    Ass=AddSection(Ass,Section{i,1});
    Ass=SetSection(Ass,i,i);
end
%% Parse
obj.output.Assembly1=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output beam assembly .\n');
end
end


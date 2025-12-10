function obj=OutputAss(obj)
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

% Material
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);
% Section
Section=obj.params.Section;
Ass=DividePart(Ass,1,obj.output.Matrix);
for i=1:size(obj.input.SectionNum,1)
    Ass=AddSection(Ass,Section{obj.input.SectionNum(i),1});
    Ass=SetSection(Ass,i,i);
end

for i=1:size(obj.output.Matrix)
    Ass=BeamK(Ass,i,'rot',obj.input.Rotate(i,1));
end

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output beam model .\n');
end
end


function obj=OutputAss(obj)
% Output Assembly
% Author : Xie Yu
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
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);
% Set Stiffness
if or(~isempty(obj.output.StiffnessX),~isempty(obj.output.StiffnessY))
    warning('Bearing stiffness is not set in the Assrmbly !')
end
%% Parse
obj.output.Assembly=Ass;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid assembly .\n');
end
end


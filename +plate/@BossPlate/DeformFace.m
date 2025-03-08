function obj=DeformFace(obj,fun,direction,varargin)
% Deform face node
% Direction 1. bottom face 2. upper face
% Author : Xie Yu
p=inputParser;
addParameter(p,'Plot',1);
parse(p,varargin{:});
opt=p.Results;
%% Main

Meshsize=obj.input.Meshsize;
Level=ceil(obj.input.PlateThickness/Meshsize)+1;
LevelNum=reshape(obj.output.PlateNode,[],Level);


switch direction
    case 1
        VV2=obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,end),:);
        r=sqrt(VV2(:,1).^2+VV2(:,2).^2);
        VV2(:,3)=fun(r);
        obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,end),:)=VV2;
        VV1=obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,1),:);

    case 2
        VV1=obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,1),:);
        r=sqrt(VV1(:,1).^2+VV1(:,2).^2);
        VV1(:,3)=fun(r);
        obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,1),:)=VV1;
        VV2=obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,end),:);
end

Gap=(VV2(:,3)-VV1(:,3))/(Level-1);

for i=2:Level-1
    obj.output.SolidMesh.Meshoutput.nodes(LevelNum(:,i),3)=VV1(:,3)+Gap*(i-1);
end



%% Parser
obj.output.SolidMesh.Vert=obj.output.SolidMesh.Meshoutput.nodes;

%% Update
if ~isempty(obj.output.Assembly)
    obj=OutputAss(obj);
end

%% Plot
if opt.Plot
    switch direction
        case 1
            Plot3D(obj,'faceno',11);
        case 2
            Plot3D(obj,'faceno',12);
    end
end
%% Print
if obj.params.Echo
    fprintf('Successfully deform face .\n');
end
end


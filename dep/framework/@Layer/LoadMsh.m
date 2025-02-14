function obj=LoadMsh(obj,name)
% Load Msh file to Layer
% Author : Xie Yu
% p=inputParser;
% addParameter(p,'grid',0);
% parse(p,varargin{:});
% opt=p.Results;
Num = GetNMeshes(obj);
geom = loadmsh(name);
obj.Meshes{Num+1,1}.Vert=geom.point.coord(:,1:3);
obj.Meshes{Num+1,1}.Face=geom.tria3.index(:,1:3);
obj.Meshes{Num+1,1}.Cb=(Num+1)*ones(size(geom.tria3.index(:,1:3),1),1);
[Eb,~,~]=patchBoundary(obj.Meshes{Num+1,1}.Face);
obj.Meshes{Num+1,1}.Boundary=Eb;

%% Print
if obj.Echo
    fprintf('Successfully load msh file .\n');
end
end


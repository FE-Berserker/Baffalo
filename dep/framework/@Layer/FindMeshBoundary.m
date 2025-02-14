function E=FindMeshBoundary(obj,MeshNum,varargin)
%FINDMESHBOUNDARY 此处显示有关此函数的摘要
p=inputParser;
addParameter(p,'color',[]);
parse(p,varargin{:});
opt=p.Results;

Face=obj.Meshes{MeshNum,1}.Face;
Vert=obj.Meshes{MeshNum,1}.Vert;
Cb=obj.Meshes{MeshNum,1}.Cb;

if isempty(opt.color)
    E=obj.Meshes{MeshNum,1}.Boundary;
else
    E=patchBoundary(Face(Cb==opt.color,:),Vert);
end
end


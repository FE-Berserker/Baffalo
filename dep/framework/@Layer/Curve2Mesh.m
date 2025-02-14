function obj=Curve2Mesh(obj,lineno,thickness,nCorners,varargin)
% Use curve to generate mesh
% Author : Xie Yu
p=inputParser;
addParameter(p,'close',0);

parse(p,varargin{:});
opt=p.Results;
% compute mesh
curve=obj.Lines{lineno,1}.P;
[v2, f2] = curveToMesh(curve, thickness, nCorners);

if opt.close==0
f2=f2(1:end-nCorners,:);
end

Num=GetNMeshes(obj);
obj.Meshes{Num+1,1}.Face=f2;
obj.Meshes{Num+1,1}.Vert=v2;
obj.Meshes{Num+1,1}.Cb=(Num+1)*ones(size(f2,1),1);
obj.Meshes{Num+1,1}.Boundary=Boundary(f2);
%% Print
if obj.Echo
    fprintf('Successfully generate mesh . \n');
end
end


function obj = Remesh(obj,MeshNo,opt)
% Remesh the mesh object
% defaultOptionStruct.nb_pts=size(V,1); %resample with same number of points
% defaultOptionStruct.anisotropy=0; %Use anisotropy (~=0) to capture geometry or favour isotropic triangles (=0)
% defaultOptionStruct.pre.max_hole_area=100; %Max hole area for pre-processing step
% defaultOptionStruct.pre.max_hole_edges=0; %Max number of hole edges for pre-processing step
% defaultOptionStruct.post.max_hole_area=100; %Max hole area for post-processing step
% defaultOptionStruct.post.max_hole_edges=0; %Max number of hole edges for post-processing step
% defaultOptionStruct.disp_on=0; %Turn on/off displaying of Geogram text

m=Mesh('Temp');
m.Face=obj.Meshes{MeshNo,1}.Face;
m.Vert=obj.Meshes{MeshNo,1}.Vert;

if nargin<3
    m=Remesh(m);
else
    m=Remesh(m,opt);
end
obj.Meshes{MeshNo,1}.Face=m.Face;
obj.Meshes{MeshNo,1}.Vert=m.Vert;
obj.Meshes{MeshNo,1}.Cb=m.Cb;

end


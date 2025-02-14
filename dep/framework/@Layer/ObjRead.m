function obj=ObjRead(obj,filename)
% Read obj file to Layer
% Author: Xie YU
Model = readObj(filename);
Num=GetNMeshes(obj);
obj.Meshes{Num+1,1}.Face=Model.f.v;
obj.Meshes{Num+1,1}.Vert=Model.v;
obj.Meshes{Num+1,1}.Boundary=Boundary(Model.f.v);
obj.Meshes{Num+1,1}.Cb=ones(size(Model.f.v,1),1);

%% Print
if obj.Echo
    fprintf('Successfully read obj . \n');
end
end

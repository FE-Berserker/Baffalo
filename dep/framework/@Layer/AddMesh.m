function obj=AddMesh(obj,meshinput)
% Add mesh to Layer
% Author : Xie Yu
Num=GetNMeshes(obj);
obj.Meshes{Num+1,1}.Face=meshinput.Face;
obj.Meshes{Num+1,1}.Vert=meshinput.Vert;
obj.Meshes{Num+1,1}.Boundary=Boundary(meshinput.Face);
obj.Meshes{Num+1,1}.Cb=meshinput.Cb;
%% Print
if obj.Echo
    fprintf('Successfully add Mesh .\n');
end
end


function obj=STLRead(obj,filename,varargin)
% Read STL file to Layer
% Author : Xie Yu
p=inputParser;
addParameter(p,'separate',1);
parse(p,varargin{:});
opt=p.Results;

[v, f, ~, ~] = stlRead(filename);
if opt.separate==1
    m=Mesh('Ass');
    m.Face=f;
    m.Vert=v;
    m.Cb=ones(size(f,1),1);
    [G,GroupSize]= GroupTest(m);
    for i=1:size(GroupSize,2)
        F=f(G==i,:); %Trim faces
        [Face,Vert]=patchCleanUnused(F,v); %Remove unused nodes

        Num=GetNMeshes(obj);
        obj.Meshes{Num+1,1}.Face=Face;
        obj.Meshes{Num+1,1}.Vert=Vert;
        obj.Meshes{Num+1,1}.Boundary=Boundary(Face);
        obj.Meshes{Num+1,1}.Cb=ones(size(Face,1),1)*i;
    end
else
    Num=GetNMeshes(obj);
    obj.Meshes{Num+1,1}.Face=f;
    obj.Meshes{Num+1,1}.Vert=v;
    obj.Meshes{Num+1,1}.Boundary=Boundary(f);
    obj.Meshes{Num+1,1}.Cb=ones(size(f,1),1);
end

%% Print
if obj.Echo
    fprintf('Successfully read stl file .\n');
end
end

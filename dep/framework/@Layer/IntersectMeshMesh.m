function [Slice,m1,m2]=IntersectMeshMesh(obj,meshno1,meshno2)
% Get intersection of mesh and mesh
% Author : Xie Yu

%% Parse input
v1 = obj.Meshes{meshno1,1}.Vert;
f1 = obj.Meshes{meshno1,1}.Face;
v2 = obj.Meshes{meshno2,1}.Vert;
f2 = obj.Meshes{meshno2,1}.Face;
[ Ind] = SurfacesIntersect( v1,f1,v2,f2 );

Num=GetNPoints(obj);
obj.Points{Num+1,1}.P=Ind(:,3:5);
obj.Points{Num+1,1}.PP{1,1}=Ind(:,3:5);

Slice=Layer('Slice','Echo',0);
m1=Mesh('Temp1','Echo',0);
m1.Face=f1;
m1.Vert=v1;
m1.Face(Ind(:,1),:)=[];
m1.Cb=ones(size(m1.Face,1),1);

m2=Mesh('Temp2','Echo',0);
m2.Face=f2;
m2.Vert=v2;
m2.Face(Ind(:,2),:)=[];
m2.Cb=ones(size(m2.Face,1),1)*2;
Slice=AddElement(Slice,m1);
Slice=AddElement(Slice,m2);

%% Print
if obj.Echo
    fprintf('Successfully intersect mesh and mesh . \n');
end
end


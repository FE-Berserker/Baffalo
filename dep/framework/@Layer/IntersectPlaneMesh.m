function obj=IntersectPlaneMesh(obj,planeno,meshno)
% Get intersection of plane and mesh
% Author : Xie Yu
%% Parse input
v = obj.Meshes{meshno,1}.Vert;
f = obj.Meshes{meshno,1}.Face;
plane=obj.Planes(planeno,:);
polys = intersectPlaneMesh(plane, v, f);
polys=cell2mat(polys);

Num=GetNPoints(obj);
obj.Points{Num+1,1}.P=polys;
obj.Points{Num+1,1}.PP{1,1}=polys;
%% Print
if obj.Echo
    fprintf('Successfully instersct plane and mesh . \n');
end
end


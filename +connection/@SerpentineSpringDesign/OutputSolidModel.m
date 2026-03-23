function obj=OutputSolidModel(obj)
% Output SolidModel of spring
% Author: Xie Yu


m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);
if isempty(obj.params.Meshsize)
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.params.Meshsize;
end

m=SetSize(m,Meshsize);
m=Mesh(m);
mm=Mesh('Mesh','Echo',0);
mm=Extrude2Solid(mm,m,obj.input.Thickness,obj.params.N_Slice);

obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

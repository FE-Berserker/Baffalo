function obj=OutputSolidModel(obj,varargin)
% Output SolidModel of Rod
% Author: Xie Yu
% p=inputParser;
% addParameter(p,'SubOutline',0);
% parse(p,varargin{:});
% opt=p.Results;

switch obj.params.Type
    case 1
        Thickness=obj.input.GeometryData(1,3);
    case 2
        Thickness=obj.input.GeometryData(1,2);
    case 3
        Thickness=obj.input.GeometryData(1,2);
end

m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);
if isempty(obj.input.Meshsize)
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.input.Meshsize;
end

m=SetSize(m,Meshsize);
m=Mesh(m);
mm=Mesh('Mesh','Echo',0);
mm=Extrude2Solid(mm,m,Thickness,obj.params.N_Slice);


if obj.params.Order==2
    mm = Convert2Order2(mm);
end
mm.Vert(:,3)=mm.Vert(:,3)-Thickness/2;
mm.Meshoutput.nodes(:,3)=mm.Meshoutput.nodes(:,3)-Thickness/2;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

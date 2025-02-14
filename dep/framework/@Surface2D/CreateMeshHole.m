function obj=CreateMeshHole(obj,Length,varargin)
% Add Mesh Hole
% Author : Xie Yu

p=inputParser;
addParameter(p,'scale',0.8);
parse(p,varargin{:});
opt=p.Results;

m=Mesh2D('Temp','Echo',0);
m=AddSurface(m,obj);
m=SetSize(m,Length);
m=Mesh(m);
Cell=ScaleMesh(m,opt.scale);

CellNum=size(Cell,1);

for i=1:CellNum
    a=Point2D('Temp Point','Echo',0);

    a=AddPoint(a,Cell{i,1}(:,1),Cell{i,1}(:,2));
    b=Line2D('Temp Line','Echo',0);
    b=AddCurve(b,a,1);
    obj=AddHole(obj,b);
end
%% Print
if obj.Echo
    fprintf('Successfully create mesh hole.\n');
end
end
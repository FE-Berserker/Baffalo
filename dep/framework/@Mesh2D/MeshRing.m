function obj=MeshRing(obj,IR,OR,varargin)
% Mesh ring
% Author : Xie Yu

%% Parse input 
k=inputParser;
addParameter(k,'Num',3);
addParameter(k,'Seg',16);
addParameter(k,'ElementType','quad');
parse(k,varargin{:});
opt=k.Results;
%% Main
a=Point2D('Temp','Echo',0);
a=AddPoint(a,0,0);
b=Line2D('Temp','Echo',0);
delta=(OR-IR)/opt.Num;
for i=1:opt.Num+1
b=AddCircle(b,IR+(i-1)*delta,a,1,'seg',opt.Seg);
end

obj.Vert=b.Point.P;
col1=(1:opt.Seg*opt.Num)';
col2=col1+opt.Seg;
col3=col2+1;
col3(opt.Seg:opt.Seg:end,:)=col3(opt.Seg:opt.Seg:end,:)-opt.Seg;
col4=col1+1;
col4(opt.Seg:opt.Seg:end,:)=col4(opt.Seg:opt.Seg:end,:)-opt.Seg;
obj=AddElements(obj,[col1,col2,col3,col4]);

obj.Cb=ones(size(obj.Face,1),1);
obj.Boundary=FindBoundary(obj);
%% Parse
obj.Meshoutput.nodes=[obj.Vert,zeros(size(obj.Vert,1),1)];
obj.Meshoutput.facesBoundary=obj.Boundary;
obj.Meshoutput.boundaryMarker=ones(size(obj.Boundary,1),1);
obj.Meshoutput.faces=[];
obj.Meshoutput.elements=obj.Face;
obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;

if opt.ElementType=="tri"
    obj = Quad2Tri(obj);
end

%% Print
if obj.Echo
    fprintf('Successfully mesh ring .\n');
end

end


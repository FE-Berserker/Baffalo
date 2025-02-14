function obj=Rot2Shell(obj,Line2D,varargin)
% Rotate line to shell
% Author : Xie Yu
% Axis x or y, type=1 Axis x,Type=2 Axis y
%% Parse parameters
p=inputParser;
addParameter(p,'Slice',36);
addParameter(p,'Type',1)
addParameter(p,'Degree',360)
parse(p,varargin{:});
opt=p.Results;

Degree=opt.Degree;
if Degree==360||Degree==-360
    Slice=opt.Slice;
else
    Slice=opt.Slice+1;
end

type=opt.Type;


V=Line2D.Point.P;

Num_node_2D=size(V,1);
V=repmat(V,Slice,1);

if Degree==360||Degree==-360
    deg=0:Degree/Slice:Degree-Degree/Slice;
else
    deg=0:Degree/Slice:Degree;
end

Temp=repmat(deg,Num_node_2D,1);
Temp=[V,reshape(Temp,Slice*Num_node_2D,1)];

switch type
    case 1
        x=Temp(:,1);
        y=Temp(:,2).*cos(Temp(:,3)/180*pi);
        z=Temp(:,2).*sin(Temp(:,3)/180*pi);
    case 2
        y=Temp(:,2);
        x=Temp(:,1).*cos(Temp(:,3)/180*pi);
        z=Temp(:,1).*sin(Temp(:,3)/180*pi);
end
obj.Vert=[x,y,z];

Node1=(1:Num_node_2D-1)';
Node2=(2:Num_node_2D)';
F=[Node1,Node2];
Temp=cell(Slice);
for i=1:Slice-1
    Temp{i}=[F+(i-1)*Num_node_2D,F(:,2)+i*Num_node_2D,...
        F(:,1)+Num_node_2D*i];
end
Temp{Slice}=[F+(Slice-1)*Num_node_2D,F(:,2),F(:,1)];

obj.Face=cell2mat(Temp);
obj.Boundary=FindBoundary(obj);
obj.Cb=ones(size(obj.Face,1),1);
obj.El=obj.Face;
%% Parse
obj.Meshoutput.nodes=obj.Vert;
obj.Meshoutput.facesBoundary=obj.Boundary;
obj.Meshoutput.boundaryMarker=ones(size(obj.Boundary,1),1);
obj.Meshoutput.faces=[];
obj.Meshoutput.elements=obj.Face;
obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;
%% Print
if obj.Echo
fprintf('Successfully rotate to shell .\n');
end
end
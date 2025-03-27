function obj=OutputShellModel(obj,varargin)
% Output ShellModel of Dome
% Author: Xie Yu
% p=inputParser;
% addParameter(p,'SubOutline',0);
% parse(p,varargin{:});
% opt=p.Results;

b=obj.input.Curve;
Radius=max(b.Point.P(:,1));

if isempty(obj.input.Meshsize)
    Meshsize=2*pi*mean(Radius)/obj.params.N_Slice;
else
    Meshsize=obj.input.Meshsize;
end

a=Point2D('PointAss','Echo',0);
b1=Line2D('LineAss','Echo',0);

if abs(min(b.Point.P(:,1)))>b.Dtol
    [m,Matrix]=OutputShellModel1(obj,a,b,b1,Meshsize);
elseif b.Point.PP{end, 1}(end,1)<=b.Dtol
    [m,Matrix]=OutputShellModel2(obj,a,b,b1,Meshsize);
elseif b.Point.PP{1, 1}(1,1)<=b.Dtol
    [m,Matrix]=OutputShellModel3(obj,a,b,b1,Meshsize);
else
    error('Curve self-intersection !')
end

% Order
if obj.params.Order==2
    m = Convert2Order2(m);
end
%% Parse
obj.output.Matrix=Matrix;
obj.output.ShellMesh=m;
%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh .\n');
end

end

function [m1,Matrix]=OutputShellModel1(obj,a,b,b1,Meshsize)
for i=1:size(b.Point.PP,1)
    a=AddPoint(a,b.Point.PP{i,1}(:,1),b.Point.PP{i,1}(:,2));
    b1=AddCurve(b1,a,i);
end

Length=b.CL;
Seg=ceil(Length/Meshsize);

for i=1:size(b.Point.PP,1)
b1=Convert2Nurb(b1,1,'seg',Seg(i));
b1=DeleteCurve(b1,1);
end

m1=Mesh(obj.params.Name);
m1=Rot2Shell(m1,b1,'Type',2,'Slice',obj.params.E_Revolve);
TempCb=[];
for i=1:size(b.Point.PP,1)
    TempCb=[TempCb;ones(Seg(i)-1,1)*i]; %#ok<AGROW>
end

TempCb=repmat(TempCb,obj.params.E_Revolve,1);
m1.Cb=TempCb;
Temp=m1.Vert;
m1.Vert=[Temp(:,1),Temp(:,3),Temp(:,2)];
m1.Meshoutput.nodes=m1.Vert;
node=(1:size(m1.Vert,1))';
for i=1:size(b.Point.PP,1)
    Matrix{i,1}=node(m1.Cb==i,:); %#ok<AGROW>
end


EdgeCb=m1.Meshoutput.boundaryMarker;
EdgeCb(1:2:end,:)=101;
EdgeCb(2:2:end,:)=102;
m1.Meshoutput.boundaryMarker=EdgeCb;
end


function [m1,Matrix]=OutputShellModel2(obj,a,b,b1,Meshsize)
for i=1:size(b.Point.PP,1)-1
    a=AddPoint(a,b.Point.PP{i,1}(:,1),b.Point.PP{i,1}(:,2));
    b1=AddCurve(b1,a,i);
end

Length=b.CL;
Seg=ceil(Length/Meshsize);

for i=1:size(b.Point.PP,1)-1
b1=Convert2Nurb(b1,1,'seg',Seg(i));
b1=DeleteCurve(b1,1);
end

m1=Mesh(obj.params.Name);
m1=Rot2Shell(m1,b1,'Type',2,'Slice',obj.params.E_Revolve);
TempCb=[];
for i=1:size(b.Point.PP,1)-1
    TempCb=[TempCb;ones(Seg(i)-1,1)*i]; %#ok<AGROW>
end

TempCb=repmat(TempCb,obj.params.E_Revolve,1);

m2=Mesh2D('Mesh1','Echo',0);
m2=MeshQuadCircle(m2,'n',obj.params.E_Revolve/4,'r',b.Point.PP{end,1}(1,1));
m2=SmoothFace(m2,100);

Vert=m2.Vert;
Face=m2.Face;
r=sqrt(Vert(:,1).^2+Vert(:,2).^2);
yy=interp1(b.Point.PP{end,1}(:,1),b.Point.PP{end,1}(:,2),r,"spline");
acc=size(m1.Vert,1);
m1.Vert=[m1.Vert;[Vert(:,1),yy,-Vert(:,2)]];
Temp=m1.Vert;
m1.Vert=[Temp(:,1),Temp(:,3),Temp(:,2)];
m1.Face=[m1.Face;Face+acc];
m1=MergeFaceNode(m1);

m1.Boundary=FindBoundary(m1);
m1.Cb=ones(size(m1.Face,1),1)*size(b.Point.PP,1);
m1.Cb(1:size(TempCb,1),:)=TempCb;
m1.El=m1.Face;
%% Parse
m1.Meshoutput.nodes=m1.Vert;
m1.Meshoutput.facesBoundary=m1.Boundary;
m1.Meshoutput.boundaryMarker=ones(size(m1.Boundary,1),1)*101;
m1.Meshoutput.faces=[];
m1.Meshoutput.elements=m1.Face;
m1.Meshoutput.elementMaterialID=ones(size(m1.Face,1),1);
m1.Meshoutput.faceMaterialID=[];
m1.Meshoutput.order=1;

node=(1:size(m1.Vert,1))';
for i=1:size(b.Point.PP,1)
    Matrix{i,1}=node(m1.Cb==i,:); %#ok<AGROW>
end

end

function [m1,Matrix]=OutputShellModel3(obj,a,b,b1,Meshsize)
for i=1:size(b.Point.PP,1)-1
    a=AddPoint(a,b.Point.PP{i+1,1}(:,1),b.Point.PP{i+1,1}(:,2));
    b1=AddCurve(b1,a,i);
end

Length=b.CL;
Seg=ceil(Length/Meshsize);

for i=1:size(b.Point.PP,1)-1
b1=Convert2Nurb(b1,1,'seg',Seg(i+1));
b1=DeleteCurve(b1,1);
end

m1=Mesh(obj.params.Name);
m1=Rot2Shell(m1,b1,'Type',2,'Slice',obj.params.E_Revolve);
TempCb=[];
for i=1:size(b.Point.PP,1)-1
    TempCb=[TempCb;ones(Seg(i+1)-1,1)*(i+1)]; %#ok<AGROW>
end

TempCb=repmat(TempCb,obj.params.E_Revolve,1);

m2=Mesh2D('Mesh1','Echo',0);
m2=MeshQuadCircle(m2,'n',obj.params.E_Revolve/4,'r',b.Point.PP{1,1}(end,1));
m2=SmoothFace(m2,100);

Vert=m2.Vert;
Face=m2.Face;
r=sqrt(Vert(:,1).^2+Vert(:,2).^2);
yy=interp1(b.Point.PP{1,1}(:,1),b.Point.PP{1,1}(:,2),r,"spline");
acc=size(m1.Vert,1);
m1.Vert=[m1.Vert(:,1),m1.Vert(:,2),-m1.Vert(:,3);[Vert(:,1),yy,-Vert(:,2)]];
Temp=m1.Vert;
m1.Vert=[Temp(:,1),Temp(:,3),Temp(:,2)];
m1.Face=[m1.Face;Face+acc];
m1=MergeFaceNode(m1);

m1.Boundary=FindBoundary(m1);
m1.Cb=ones(size(m1.Face,1),1);
m1.Cb(1:size(TempCb,1),:)=TempCb;
m1.El=m1.Face;
%% Parse
m1.Meshoutput.nodes=m1.Vert;
m1.Meshoutput.facesBoundary=m1.Boundary;
m1.Meshoutput.boundaryMarker=ones(size(m1.Boundary,1),1)*101;
m1.Meshoutput.faces=[];
m1.Meshoutput.elements=m1.Face;
m1.Meshoutput.elementMaterialID=ones(size(m1.Face,1),1);
m1.Meshoutput.faceMaterialID=[];
m1.Meshoutput.order=1;

node=(1:size(m1.Vert,1))';
for i=1:size(b.Point.PP,1)
    Matrix{i,1}=node(m1.Cb==i,:); %#ok<AGROW>
end

end
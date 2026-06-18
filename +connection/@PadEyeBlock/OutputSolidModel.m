function obj=OutputSolidModel(obj)
% Output SolidModel of common plate
% Author: Xie Yu

w=obj.input.w;
h=obj.input.h;
R=obj.input.HoleDia/2;
b=obj.input.b;
l=obj.input.l;
T=obj.input.Thickness;

m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);

if isempty(obj.input.Meshsize)
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.input.Meshsize;
end

m=SetSize(m,Meshsize);

CNum=ceil(2*b/Meshsize);
% Set constrants
Cnode = [(-R-w+h)*ones(CNum+1,1),(-b:2*b/CNum:b)'];
Cedge = [1:CNum;2:CNum+1]' ;
m=AddCNode(m,Cnode);
m=AddCEdge(m,Cedge);

m=Mesh(m);
% Cb calculation
Cb=m.Cb;
Vm=CenterCal(m);
Cb(Vm(:,1)<=-R-w+h)=2;

m.Cb=Cb;
m.Meshoutput.boundaryMarker=Cb;

mm=Mesh('Mesh','Echo',0);
mm=Extrude2Solid(mm,m,-T,obj.params.N_Slice);
mm=Extrude2Solid(mm,m,l/2-T,ceil(T/Meshsize)/2,'Cb',2);

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);
Cb(Vm(:,3)==l/2-T)=4;

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
% Move elements
mm.Vert(:,3)=mm.Vert(:,3)-l/2+T;
mm.Meshoutput.nodes=mm.Vert;
% Reflect elements
RVert=mm.Vert; 
NNode=size(RVert,1);
TempNode=mm.Vert(mm.Vert(:,3)==0,:);
NTempNode=size(TempNode,1);

RVert(:,3)=-RVert(:,3);
FVert=[mm.Vert;RVert];
FVert=FVert(1:end-NTempNode,:);

mm.El=[mm.El;mm.El+NNode];

% Merge element nodes
mm.El(mm.El>size(FVert,1))=mm.El(mm.El>size(FVert,1))-NNode;
mm.Meshoutput.nodes=FVert;
mm.Vert=FVert;
mm.Meshoutput.elements=mm.El;
Tempfaces=[mm.Meshoutput.faces;mm.Meshoutput.faces+NNode];
Tempfaces(Tempfaces>size(FVert,1))=Tempfaces(Tempfaces>size(FVert,1))-NNode;
mm.Meshoutput.faces=Tempfaces;

TempfacesBoundary=mm.Meshoutput.facesBoundary(mm.Cb~=4,:);
TempfacesBoundary=[TempfacesBoundary;TempfacesBoundary+NNode];
TempfacesBoundary(TempfacesBoundary>size(FVert,1))=TempfacesBoundary(TempfacesBoundary>size(FVert,1))-NNode;
mm.Meshoutput.facesBoundary=TempfacesBoundary;
mm.Face=TempfacesBoundary;

Cb=mm.Cb(mm.Cb~=4,:);
mm.Cb=[Cb;Cb];
mm.Meshoutput.boundaryMarker=mm.Cb;
mm.Meshoutput.elementMaterialID=[mm.Meshoutput.elementMaterialID;mm.Meshoutput.elementMaterialID];
mm.Meshoutput.faceMaterialID=[mm.Meshoutput.faceMaterialID;mm.Meshoutput.faceMaterialID];

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);
Rm=sqrt(Vm(:,1).^2+Vm(:,2).^2);
Cb(and(Vm(:,3)>0,Cb==2))=12;
Cb(and(Vm(:,3)>0,Cb==3))=13;
Cb(Vm(:,1)==-R-w)=11;
Cb(and(Vm(:,3)<0,Rm<=R))=21;
Cb(and(Vm(:,3)>0,Rm<=R))=22;
mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=mm.Cb;

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

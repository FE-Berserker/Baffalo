function mm = CreateMesh3D1(obj,mm,r1,r2)
% Create shaft 3D mesh 1
% Author : Xie Yu
deg=360/obj.params.E_Revolve;
% Add shell
x1=zeros(obj.params.E_Revolve,1);
y1=cos((0:deg:360-deg)'/180*pi)*r1;
z1=sin((0:deg:360-deg)'/180*pi)*r1;
V1=[x1 y1 z1];
x2=repmat(obj.input.Length(1),obj.params.E_Revolve,1);
y2=cos((0:deg:360-deg)'/180*pi)*r2;
z2=sin((0:deg:360-deg)'/180*pi)*r2;
V2=[x2 y2 z2];
Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
    ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
numSteps=max(Temp);

a=Point2D('Bottom Verts','Echo',0);
a=AddPoint(a,y1,z1);

a1=Point2D('Top Verts','Echo',0);
a1=AddPoint(a1,y2,z2);

% Layer
l=Layer('Layer','Echo',0);
l=AddElement(l,a,'transform',[0,0,0,0,90,0]);
l=AddElement(l,a1,'transform',[obj.input.Length(1),0,0,0,90,0]);
l=LoftLinear(l,1,2,'patchType','tri_slash','numSteps',numSteps,'closeLoopOpt',1);

mm.Vert=l.Meshes{1,1}.Vert;
mm.Face=l.Meshes{1,1}.Face;
mm.Cb=l.Meshes{1,1}.Cb*101;


%% Creat Base mesh
m1=Mesh2D('Mesh1','Echo',0);
m1=MeshQuadCircle(m1,'n',obj.params.E_Revolve/4,'r',r1);
m1=Quad2Tri(m1);

Temp=[zeros(size(m1.Vert,1),1),m1.Vert(:,1),m1.Vert(:,2)];
numVert=size(mm.Vert,1);
mm.Vert=[mm.Vert;Temp];
mm.Face=[mm.Face;m1.Face+numVert.*ones(size(m1.Face,1),3)];
mm.Cb=[mm.Cb;ones(size(m1.Face,1),1)*301];

m2=Mesh2D('Mesh2','Echo',0);
m2=MeshQuadCircle(m2,'n',obj.params.E_Revolve/4,'r',r2);
m2=Quad2Tri(m2);
% Reverse face normal
TempFace=[m2.Face(:,1),m2.Face(:,3),m2.Face(:,2)];
m2.Face=TempFace;

Temp=[obj.input.Length(1)*ones(size(m2.Vert,1),1),m2.Vert(:,1),m2.Vert(:,2)];
numVert=size(mm.Vert,1);
mm.Vert=[mm.Vert;Temp];
mm.Face=[mm.Face;m2.Face+numVert.*ones(size(m2.Face,1),3)];
mm.Cb=[mm.Cb;ones(size(m2.Face,1),1)*302];
mm=MergeFaceNode(mm);
end


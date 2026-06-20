function obj=OutputSolidModel(obj)
% Output SolidModel of common plate
% Author: Xie Yu

w=obj.input.w;
h=obj.input.h;
R=obj.input.HoleDia/2;
a=obj.input.a;
b=obj.input.b;
l=obj.input.l;
T=obj.input.Thickness;
R2=obj.input.Dia2/2;
N_Slice=obj.params.N_Slice;

Meshsize=obj.input.Meshsize;

aa=Point2D('Point','Echo',0);
aa=AddPoint(aa,0,0);
aa=AddPoint(aa,[-R-w+h;0],[-b;-b]);
aa=AddPoint(aa,[0;-R-w+h],[b;b]);
aa=AddPoint(aa,[-R-w+h;-R-w+h],[b;-b]);

b1=Line2D('Line1','Echo',0);
b1=AddLine(b1,aa,4);
Curve1=RebuildCurve(b1,1,ceil(2*b/Meshsize));

Curve1=[Curve1,ones(size(Curve1,1),1)*-T/2];
TT=T/N_Slice*(1:N_Slice-1);
TempCurve=repmat(Curve1(end,:),N_Slice-1,1);
TempCurve(:,3)=TempCurve(:,3)+TT';
Curve1=[Curve1;TempCurve;[flip(Curve1(:,1:2)),-Curve1(:,3)]];
TempCurve=repmat(Curve1(end,:),N_Slice-1,1);
TempCurve(:,3)=TempCurve(:,3)-TT';
Curve1=[Curve1;TempCurve];
Curve1=flip(Curve1);
Curve1=[Curve1(N_Slice/2:end,:);Curve1(1:N_Slice/2-1,:)];

b2=Line2D('Line2','Echo',0);
b2=AddCircle(b2,R2,aa,1,'seg',size(Curve1,1));
TempP=b2.Point.P;
Curve2=[ones(size(Curve1,1),1)*(-R-w),TempP];

Curve3=[ones(size(Curve1,1),1)*(-R-w-l),TempP];

S1=Surface2D(b2);
m1=Mesh2D('Face1','Echo',1);
m1=AddSurface(m1,S1);
m1=SetSize(m1,Meshsize);
m1=Mesh(m1,'ref1','preserve');

b3=Line2D('Line3','Echo',0);
b3=AddLine(b3,aa,2);
b3=AddEllipse(b3,a,b,aa,1,'sang',-90,'ang',180);
b3=AddLine(b3,aa,3);

b4=Line2D('Line4','Echo',0);
b4=AddCircle(b4,R,aa,1,'Seg',ceil(2*pi*R/Meshsize));

LL=Layer('Temp','Echo',0);
LL=AddPoint(LL,Curve1);
LL=AddPoint(LL,Curve2);
LL=AddPoint(LL,Curve3);

LL=AddElement(LL,m1,'Transform',[-R-w-l,0,0,90,90,0]);
LL=LoftLinear(LL,1,2,'closeLoopOpt',1,'patchType','tri_slash');
LL=LoftLinear(LL,2,3,'closeLoopOpt',1,'patchType','tri_slash');

LL=AddElement(LL,b3,'Transform',[0,0,-T/2,0,0,0]);
[L,~,~,~] = CalculateCurvature(LL,1);
LL=RebuildCurve(LL,1,ceil(L(end)/Meshsize));
LL=Move(LL,[0,0,T],'Lines',2,'new',1);

LL=AddPoint(LL,LL.Lines{2,1}.P);
LL=AddPoint(LL,LL.Lines{3,1}.P);
LL=LoftLinear(LL,4,5,'closeLoopOpt',0,'patchType','tri_slash','numSteps',N_Slice+1);

LL=AddElement(LL,b4,'Transform',[0,0,-T/2,0,0,0]);
LL=Move(LL,[0,0,T],'Lines',4,'new',1);

LL=AddPoint(LL,LL.Lines{4,1}.P);
LL=AddPoint(LL,LL.Lines{5,1}.P);
LL=LoftLinear(LL,6,7,'closeLoopOpt',1,'patchType','tri_slash','numSteps',N_Slice+1);

Curve1=RebuildCurve(b1,1,ceil(2*b/Meshsize));
aa=AddPoint(aa,Curve1(:,1),Curve1(:,2));
aa=AddPoint(aa,LL.Points{5,1}.P(:,1),LL.Points{5,1}.P(:,2));
aa=AddPoint(aa,LL.Points{7,1}.P(:,1),LL.Points{7,1}.P(:,2));
b5=Line2D('Line5','Echo',0);
b5=AddCurve(b5,aa,5);
b5=AddCurve(b5,aa,6);
b6=Line2D('Line6','Echo',0);
b6=AddCurve(b6,aa,7);
S2=Surface2D(b5);
S2=AddHole(S2,b6);
m2=Mesh2D('Temp','Echo',0);
m2=AddSurface(m2,S2);
m2=SetSize(m2,Meshsize);
m2=Mesh(m2);

LL=AddElement(LL,m2,'Transform',[0,0,-T/2,0,0,0]);
LL=AddElement(LL,m2,'Transform',[0,0,T/2,0,0,0]);

% Merge element nodes
mm=Mesh(obj.params.Name,'Echo',0);

VV=[];
FF=[];
Cb=[];
acc=0;
for i=1:7
    VV=[VV;LL.Meshes{i,1}.Vert];
    FF=[FF;LL.Meshes{i,1}.Face+acc];
    Cb=[Cb;ones(size(LL.Meshes{i,1}.Face,1),1)*i];
    mm.Vert=VV;
    mm.Face=FF;
    mm.Cb=Cb;
    [mm]=MergeFaceNode(mm,1);
    VV=mm.Vert;
    FF=mm.Face;
    acc=size(VV,1);
end

mm = ReverseNormals(mm,'Cb',1);
mm = ReverseNormals(mm,'Cb',2);
mm = ReverseNormals(mm,'Cb',3);
mm = ReverseNormals(mm,'Cb',5);
mm = ReverseNormals(mm,'Cb',6);
mm=Mesh3D(mm);
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

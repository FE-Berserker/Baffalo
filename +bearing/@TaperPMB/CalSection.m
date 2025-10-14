function obj=CalSection(obj)
% Calculate section of RadialPMB
% Author : Xie Yu
MeshNum=obj.params.MeshNum;
TaperAngle=obj.params.TaperAngle;

StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;

Num=size(Height,2);

m1=Mesh2D(obj.params.Name,'Echo',0);
m1=MeshQuadPlate(m1,[StatorR(2)-StatorR(1),Height(end)-Height(1)],[MeshNum(1),MeshNum(2)*(Num-1)]);

m2=Mesh2D('Mesh2','Echo',0);
m2=MeshQuadPlate(m2,[RotorR(2)-RotorR(1),Height(end)-Height(1)],[MeshNum(1),MeshNum(2)*(Num-1)]);

% Parse Node
TempDelta=(StatorR(2)-StatorR(1))/MeshNum(1);
TempR=StatorR(1):TempDelta:StatorR(2);
TempR=repmat(TempR,MeshNum(2)*(Num-1)+1,1);
x1=reshape(TempR,[],1);

TempDelta=(Height(2:end)-Height(1:end-1))/MeshNum(2);
TempDelta=(0:MeshNum(2)-1)'*TempDelta;
TempH=Height(1:end-1);
TempH=repmat(TempH,MeshNum(2),1)+TempDelta;
TempH=[reshape(TempH,[],1);Height(end)];
y1=repmat(TempH,MeshNum(1)+1,1);

TempDelta=(RotorR(2)-RotorR(1))/MeshNum(1);
TempR=RotorR(1):TempDelta:RotorR(2);
TempR=repmat(TempR,MeshNum(2)*(Num-1)+1,1);
x2=reshape(TempR,[],1);

TempDelta=(Height(2:end)-Height(1:end-1))/MeshNum(2);
TempDelta=(0:MeshNum(2)-1)'*TempDelta;
TempH=Height(1:end-1);
TempH=repmat(TempH,MeshNum(2),1)+TempDelta;
TempH=[reshape(TempH,[],1);Height(end)];
y2=repmat(TempH,MeshNum(1)+1,1);

m1.Meshoutput.nodes=[x1,y1,zeros(size(x1,1),1);x2,y2,zeros(size(x2,1),1)];
m1.Meshoutput.facesBoundary=[m1.Meshoutput.facesBoundary;m2.Meshoutput.facesBoundary+size(x1,1)];
m1.Meshoutput.boundaryMarker=[m1.Meshoutput.boundaryMarker;m2.Meshoutput.boundaryMarker*2];
m1.Meshoutput.elements=[m1.Meshoutput.elements;m2.Meshoutput.elements+size(x1,1)];
m1.Meshoutput.elementMaterialID=[m1.Meshoutput.elementMaterialID;m2.Meshoutput.elementMaterialID];

m1.Face=m1.Meshoutput.elements;
m1.Vert=m1.Meshoutput.nodes(:,1:2);
m1.Boundary=m1.Meshoutput.facesBoundary;

TempCb1=1:Num-1;
TempCb1=repmat(TempCb1,MeshNum(2),1);
TempCb1=reshape(TempCb1,[],1);
TempCb1=repmat(TempCb1,MeshNum(1),1);
TempCb2=1:Num-1;
TempCb2=repmat(TempCb2,MeshNum(2),1);
TempCb2=reshape(TempCb2,[],1);
TempCb2=repmat(TempCb2,MeshNum(1),1);
TempCb=[TempCb1;TempCb2+Num-1];
m1.Cb=TempCb;

% Rotate angle
P1=[m1.Vert,zeros(size(m1.Vert,1),1)];
T=Transform(P1);
TempR1=max(StatorR(1),RotorR(1));
TempR2=min(StatorR(end),RotorR(end));
T=Rotate(T,0,0,TaperAngle,'Ori',[(TempR1+TempR2)/2,(Height(1)+Height(end))/2,0]);
P2=Solve(T);
m1.Vert=P2(:,1:2);
m1.Meshoutput.nodes=P2;


% Parse
obj.output.ShellMesh=m1;

end
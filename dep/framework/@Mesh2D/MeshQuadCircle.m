function obj= MeshQuadCircle(obj,varargin)
% Mesh a circle using quadrilaterial elements
% Author : Xie Yu
%% Parse input 
p=inputParser;
addParameter(p,'n',8);
addParameter(p,'r',1);
addParameter(p,'f',0.5);
parse(p,varargin{:});
opt=p.Results;
n=opt.n;
r=opt.r;
f=opt.f;
%% Creating central regular quad mesh
nElements=n+~iseven(n);%Force even
[X_centralMesh,Y_centralMesh]=meshgrid(linspace(-1,1,nElements+1));
[F_centralMesh,V_centralMesh] = surf2patch(X_centralMesh,Y_centralMesh,zeros(size(X_centralMesh)));
V_centralMesh=V_centralMesh(:,1:2);

%Edge of central mesh
logicCentralMeshEdge=(X_centralMesh==1)|(Y_centralMesh==1)|(X_centralMesh==-1)|(Y_centralMesh==-1);
nEdge=(nElements*4);

% Scaling radius
[ThetaMesh,RadiusMesh]=cart2pol(V_centralMesh(:,1),V_centralMesh(:,2));
RadiusMesh=f*(1/2)*sqrt(2)*RadiusMesh;
[V_centralMesh(:,1),V_centralMesh(:,2)]=pol2cart(ThetaMesh,RadiusMesh);

%% Creating outer mesh

RadiusOuterEdge=ones(1,nEdge);
ThetaOuterEdge=linspace(0,pi*2,nEdge+1); 
ThetaOuterEdge=ThetaOuterEdge(2:end)-pi;

[xOuterEdge,yOuterEdge]=pol2cart(ThetaOuterEdge,RadiusOuterEdge);
V_outerEdge=[xOuterEdge(:) yOuterEdge(:)];

V_innerEdge=V_centralMesh(logicCentralMeshEdge,:);
[ThetaEdge,RadiusEdge]=cart2pol(V_innerEdge(:,1),V_innerEdge(:,2));
[ThetaEdge,sortInd]=sort(ThetaEdge);
RadiusEdge=RadiusEdge(sortInd);
[V_innerEdge(:,1),V_innerEdge(:,2)]=pol2cart(ThetaEdge,RadiusEdge);

[Xr]=linspacen(V_innerEdge(:,1),V_outerEdge(:,1),nElements/2+1); Xr(end+1,:)=Xr(1,:);
[Yr]=linspacen(V_innerEdge(:,2),V_outerEdge(:,2),nElements/2+1); Yr(end+1,:)=Yr(1,:);

[Fs2,Vs2] = surf2patch(Xr,Yr,zeros(size(Xr)));
Vs2=Vs2(:,1:2);

V=[V_centralMesh;Vs2];
F=[F_centralMesh;Fs2+size(V_centralMesh,1)];

%% Removing double points
[F,V,~,~]=MergeVertices(F,V);

%Scaling radius
[ThetaMesh,RadiusMesh]=cart2pol(V(:,1),V(:,2));
RadiusMesh=r*RadiusMesh;
[V(:,1),V(:,2)]=pol2cart(ThetaMesh,RadiusMesh);

%% Parse 
obj.Face=F;
obj.Vert=V;
obj.Cb=ones(size(F,1),1);
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
%% Print
if obj.Echo
    fprintf('Successfully mesh quad circle .\n');
end
end






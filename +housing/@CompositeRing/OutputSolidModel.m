function obj=OutputSolidModel(obj)
% Output solid model of Composite ring
% Author : Xie Yu

Di=obj.input.Di;
Thickness=obj.input.Thickness;
Height=obj.input.Height;
TotalThickness=obj.output.TotalThickness;
%% Deifine element size
numElementsWidth=size(Thickness,2);
numElementsThickness=obj.params.NRot;
numElementsHeight=obj.params.NHeight;
Temp=tril(ones(size(Thickness,2),size(Thickness,2)))*Thickness';
R=[Di/2,Di/2+Temp'];
TotalLayers=size(R,2)-1;

%% Define the geometry
m=Mesh(obj.params.Name);
sampleWidth=TotalThickness; %Width
sampleThickness=Height; %Thickness
sampleHeight=Height; %Height

%% Create a box with hexahedral elements
cubeDimensions=[sampleWidth sampleThickness sampleHeight]; %Dimensions
cubeElementNumbers=[numElementsWidth numElementsThickness-1 numElementsHeight]; %Number of elements
m=MeshCube(m,cubeDimensions,cubeElementNumbers);

nn=(numElementsThickness+1)*(TotalLayers+1)*numElementsHeight/2+numElementsThickness/2+1;
Temp=1:TotalLayers;
Temp=(Temp'-1)*(numElementsThickness+1);
nb=nn+Temp;
nt=nb+numElementsThickness+1;
%% Reflect the coordinate
delta=360/numElementsThickness;
degree=0:delta:360-delta;

x=R'*cos(degree/180*pi);
xx=reshape(x',size(x,1)*size(x,2),1);
xx=repmat(xx,numElementsHeight+1,1);
y=R'*sin(degree/180*pi);
yy=reshape(y',size(y,1)*size(y,2),1);
yy=repmat(yy,numElementsHeight+1,1);
m.Meshoutput.nodes(:,1)=xx;
m.Meshoutput.nodes(:,2)=yy;
m.Vert=m.Meshoutput.nodes;
Temp=m.Meshoutput.elements(:,[1,4,8,5,2,3,7,6]);

% El relfect
Temp=reshape(Temp',(numElementsThickness-1)*8,numElementsHeight*numElementsWidth);
% Temp1=[144,1,1153,1296,288,145,1297,1440];
Temp1=[numElementsThickness,1,...
    numElementsThickness*(numElementsWidth+1)+1,numElementsThickness*(numElementsWidth+1)+numElementsThickness,...
    numElementsThickness*2,1+numElementsThickness,...
    numElementsThickness*(numElementsWidth+1)+numElementsThickness+1,numElementsThickness*(numElementsWidth+1)+numElementsThickness*2];
Temp1=repmat(Temp1,numElementsHeight*numElementsWidth,1);
Temp2=[0,Temp(1,2:end)-1];
Temp2=repmat(Temp2',1,8);
Temp1=Temp1+Temp2;
Temp=[Temp;Temp1'];
Temp=reshape(Temp,8,numElementsHeight*numElementsWidth*numElementsThickness);
m.Meshoutput.elements=Temp';

%Convert elements to faces
[F,~]=element2patch(Temp',[],'hex8');

%Find boundary faces
[indFree]=freeBoundaryPatch(F);
Fb=F(indFree,:);

m.Meshoutput.faces=F;
m.Meshoutput.facesBoundary=Fb;
NumEl=size(m.Meshoutput.elements,1);
NumFace=size(F,1);
m.Meshoutput.elementMaterialID=ones(NumEl,1);
m.Meshoutput.faceMaterialID=ones(NumFace,1);

m.Face=Fb;
m.El=m.Meshoutput.elements;

%Create faceBoundaryMarkers based on normals
[N]=patchNormal(Fb,m.Meshoutput.nodes); %N.B. Change of convention changes meaning of front, top etc.

faceBoundaryMarker=ones(size(Fb,1),1);
faceBoundaryMarker(abs(N(:,3)+1)<=1e-3)=2; %Bottom
faceBoundaryMarker(abs(N(:,3)-1)<=1e-3)=3; %Top

Vm = PatchCenter(m);
R=sqrt(Vm(:,1).^2+Vm(:,2).^2);
Rmiddle=(R(1)+R(end))/2;
faceBoundaryMarker(and(R<Rmiddle,abs(N(:,3))<=1e-3))=4; %Inside
faceBoundaryMarker(and(R>Rmiddle,abs(N(:,3))<=1e-3))=5; %Outside

m.Meshoutput.boundaryMarker=faceBoundaryMarker;
m.Cb=faceBoundaryMarker;

%% Prase
obj.output.SolidMesh=m;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end
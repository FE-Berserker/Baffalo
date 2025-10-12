function obj=OutputSolidModel(obj)
% Output solid model of Composite polygon ring
% Author : Xie Yu

Di=obj.input.Di;
Thickness=obj.input.Thickness;
Height=obj.input.Height;
TotalThickness=obj.output.TotalThickness;

%% Calculate polygon
Rref=Di/2;
r=obj.input.r;
EdgeNum=obj.input.EdgeNum;
Ang=360/EdgeNum/2;

b=Line2D('Round Polygon','Echo',0);
b=AddRoundPolygon(b,Rref/cos(Ang/180*pi),EdgeNum,r);

Point=b.Point.P;

NumSeg=size(Point,1);

rr=sqrt(Point(:,1).^2+Point(:,2).^2);

Angle = calculateAngle(Point(1:NumSeg/EdgeNum,:),zeros(NumSeg/EdgeNum,2),Point(2:NumSeg/EdgeNum+1,:));

% Check Angle
SumAng=sum(Angle);
Delta=(360/EdgeNum-SumAng)/(NumSeg/EdgeNum);
Slice=obj.params.NRot;
Angle=Angle+Delta;

TempAng=(Angle(1,1)+Angle(2,1))/Slice;
FixAngle=sum(Angle(3:end,:))/2;
Angle=[repmat(TempAng,Slice,1);Angle(3:end,:)];

Num1=size(Angle,1);
Ratio=ones(Num1,1);
acc=-sum(TempAng)*Slice/2;
for i=1:Num1
    if i<=Slice
        acc=acc+Angle(i,1);
        Ratio(i,1)=1/cos(acc/180*pi);
    else
        acc=acc+Angle(i,1);
        Ratio(i,1)=rr(i-Slice+3,1)/Rref;
    end
end

Ratio=[Ratio(end,1);Ratio(1:end-1,:)];

Angle=repmat(Angle,EdgeNum,1);
Ratio=repmat(Ratio,EdgeNum,1);

%% Deifine element size
numElementsWidth=size(Thickness,2);
numElementsThickness=size(Angle,1);
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
acc=tril(ones(numElementsThickness,numElementsThickness))*Angle;
degree=[0,acc(1:end-1,1)'];

x=R'*cos(degree/180*pi);
x=x.*(repmat(Ratio',size(x,1),1));
xx=reshape(x',size(x,1)*size(x,2),1);

xx=repmat(xx,numElementsHeight+1,1);
y=R'*sin(degree/180*pi);
y=y.*(repmat(Ratio',size(y,1),1));
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

T=Transform(m.Vert);
T=Rotate(T,0,0,FixAngle);
P2=Solve(T);

m.Vert=P2;
m.Meshoutput.nodes=m.Vert;

%% Prase
obj.output.SolidMesh=m;
obj.output.NRot=size(Angle,1);
%% Print
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end

function angle = calculateAngle(A, B, C) 
    % 计算向量BA和BC
    BA = A - B;
    BC = C - B;
    
    % 计算点积
    dotProduct = dot(BA, BC,2);
    
    % 计算向量的模
    normBA = vecnorm(BA')';
    normBC = vecnorm(BC')';
        
    % 计算夹角的余弦值
    cosTheta = dotProduct ./ (normBA .* normBC);
    
    % 确保余弦值在[-1, 1]范围内（由于浮点误差可能超出）
    cosTheta = max(min(cosTheta, 1), -1);
    
    % 计算弧度并转换为角度
    angle = rad2deg(acos(cosTheta));
end


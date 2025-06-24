function obj=LoadElement(obj)
% Load element of WovenCell
% Author : Xie Yu
FileName=obj.input.FileName;
currentPath = pwd;
Dim=obj.input.Dimension;

FileName=strcat(currentPath,'\',FileName,'.vtu');
[Point,Cell,YarnIndex,YarnTangent,Location,SurfaceDistance,Orientation] = importVTU(FileName);

if Dim(1)*Dim(2)*Dim(3)~=size(Cell,1)
    error('Element number is not match with dimension ! ')
end

m=Mesh(obj.params.Name,'Echo',0);
% m=MeshTensorGrid(m,0:Dim(1),0:Dim(2),0:Dim(3));
cubeDimensions=[10 10 10]; %Dimensions
cubeElementNumbers=Dim; %Number of elements

m=MeshCube(m,cubeDimensions,cubeElementNumbers);
m.Vert=Point;
m.El=Cell;

m.G.nodes.coords=Point;

m.Meshoutput.nodes=Point;
m.Meshoutput.elements=Cell;
m.Meshoutput.elementMaterialID=YarnIndex;

YarnVolumeRatio=size(YarnIndex(YarnIndex~=-1),1)/size(Cell,1);
% Parse
obj.output.YarnIndex=YarnIndex;
obj.output.YarnTangent=YarnTangent;
obj.output.Location=Location;
obj.output.SurfaceDistance=SurfaceDistance;
obj.output.Orientation=Orientation;
obj.output.SolidMesh=m;
obj.output.YarnVolumeRatio=YarnVolumeRatio;

%% Print
if obj.params.Echo
    fprintf('Successfully load elements !.\n');
end
end
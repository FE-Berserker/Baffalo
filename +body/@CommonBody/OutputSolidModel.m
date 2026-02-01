function obj=OutputSolidModel(obj,varargin)
% Output SolidModel of CommonBody
% Author: Xie Yu
% p=inputParser;
% addParameter(p,'SubOutline',0);
% parse(p,varargin{:});
% opt=p.Results;

if isempty(obj.input.Meshsize)
    Meshsize=min(obj.input.GeometryData)/10;
else
    Meshsize=obj.input.Meshsize;
end

m=Mesh('Mesh1','Echo',0);
switch obj.params.Type
    case 1
        cubeDimensions=obj.input.GeometryData; %Dimensions
        x=obj.input.GeometryData(1,1);
        y=obj.input.GeometryData(1,2);
        z=obj.input.GeometryData(1,3);
        cubeElementNumbers=ceil([x y z]./Meshsize); %Number of elements
        m=MeshCube(m,cubeDimensions,cubeElementNumbers);
    case 2
        m=MeshCylinder(m,Meshsize,obj.input.GeometryData(1,1),obj.input.GeometryData(1,2));
        m=Mesh3D(m);
    case 3
        numRefineStepsSphere=3;
        sphereRadius=obj.input.GeometryData(1,1);
        m=MeshSphere(m,numRefineStepsSphere,sphereRadius);
    case 4
        n=obj.input.GeometryData(1,1);
        l=obj.input.GeometryData(1,2);
        height=obj.input.GeometryData(1,3);
        m=MeshPrism(m,n,l,height,'Meshsize',Meshsize);
        m.Vert(:,3)=m.Vert(:,3)-height/2;
        m.Meshoutput.nodes(:,3)=m.Meshoutput.nodes(:,3)-height/3;
    case 5
        n=obj.input.GeometryData(1,1);
        l=obj.input.GeometryData(1,2);
        height=obj.input.GeometryData(1,3);
        m=MeshPyramid(m,n,l,height,'Meshsize',Meshsize);
        m=Mesh3D(m);
        m.Vert(:,3)=m.Vert(:,3)-height/3;
        m.Meshoutput.nodes(:,3)=m.Meshoutput.nodes(:,3)-height/3;
       
end

if obj.params.Order==2
    m = Convert2Order2(m);
end

obj.output.SolidMesh=m;
obj.input.Meshsize=Meshsize;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

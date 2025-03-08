function obj=OutputSolidModel(obj)
% Output SolidModel of boss plate
% Author: Xie Yu

% Inner part surface
m1=Mesh2D('Mesh1','Echo',0);
m2=Mesh2D('Mesh2','Echo',0);
S1=Surface2D(obj.input.OutLine,'Echo',0);
S1=AddHole(S1,obj.input.MidLine);
if ~isempty(obj.input.OuterHole)
    for i=1:size(obj.input.OuterHole,1)
        S1=AddHole(S1,obj.input.OuterHole(i,1));
    end
end

% Outer part surface
S2=Surface2D(obj.input.MidLine,'Echo',0);
if ~isempty(obj.input.InnerLine)
    S2=AddHole(S2,obj.input.InnerLine);
end

if ~isempty(obj.input.InnerHole)
    for i=1:size(obj.input.InnerHole,1)
        S2=AddHole(S2,obj.input.InnerHole(i,1));
    end
end


m1=AddSurface(m1,S1);
m2=AddSurface(m2,S2);
if isempty(obj.input.Meshsize)
    Meshsize=sqrt((max(S2.N(:,1)))^2+(max(S2.N(:,2)))^2)/20;
    obj.input.Meshsize=Meshsize;
else
    Meshsize=obj.input.Meshsize;
end

m1=SetSize(m1,Meshsize);
m1=Mesh(m1);
m2=SetSize(m2,Meshsize);
m2=Mesh(m2);

accNode=size(m1.Vert,1);
m1.Vert=[m1.Vert;m2.Vert];
m1.Face=[m1.Face;m2.Face+accNode];
m1.Cb=[m1.Cb;m2.Cb./m2.Cb*2];

m1=MergeNode(m1);


mm=Mesh('Mesh','Echo',0);
mm=Extrude2Solid(mm,m1,-obj.input.PlateThickness,ceil(obj.input.PlateThickness/Meshsize));
switch obj.params.Type
    case 1
        mm=Extrude2Solid(mm,m1,obj.input.BossHeight,ceil(obj.input.BossHeight/Meshsize),'Cb',2);
    case 2
        mm=Extrude2Solid(mm,m1,obj.input.BossHeight,ceil(obj.input.BossHeight/Meshsize),'Cb',1);
end

obj.output.PlateNode=(1:size(m1.Vert,1)*(ceil(obj.input.PlateThickness/Meshsize)+1))';

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% Prase
Cb=mm.Meshoutput.boundaryMarker;

mm.Meshoutput.nodes(:,3)=mm.Meshoutput.nodes(:,3)+obj.input.PlateThickness;
Vm = PatchCenter(mm);

Cb(Vm(:,3)==0,:)=11;
Cb(Vm(:,3)==obj.input.PlateThickness,:)=12;
Cb(Vm(:,3)==obj.input.PlateThickness+obj.input.BossHeight,:)=13;
Cb(and(Vm(:,3)>0,Vm(:,3)<obj.input.PlateThickness),:)=21;
Cb(and(Vm(:,3)>obj.input.PlateThickness,Vm(:,3)<obj.input.PlateThickness+obj.input.BossHeight),:)=22;

mm.Face=mm.Meshoutput.facesBoundary;
mm.Vert=mm.Meshoutput.nodes;
mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end


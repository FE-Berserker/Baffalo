function obj = DrillHole(obj,radius,depth,position,faceno,varargin)
% Drill holes of obj
% +x,-x,+y,-y,+z,-z, type=1,2,3,4,5,6
% Author: Xie Yu
p=inputParser;
addParameter(p,'type',6);
addParameter(p,'slice',8);
addParameter(p,'holetype',1);
parse(p,varargin{:});
opt=p.Results;

opt.slice=(ceil(opt.slice/8))*8;
%% Find face boundary
V=obj.Vert;
F=obj.Face;
Cb1=obj.Cb;
F1=F((Cb1~=faceno),:);
Cb1=obj.Cb((Cb1~=faceno),:);
%% Clean unused node
[obj.Face,obj.Vert]=patchCleanUnused(F1,V); %Remove unused nodes

Boundary=FindBoundary(obj);
faceposition=V(Boundary(1,1),:);
%Get boundary faces
% [indBoundary]=tesBoundary(Face,Vert); %Get boundary face indices
% Fb=Face(indBoundary,:); %Boundary faces
% patch('Faces',Face,'Vertices',Vert,'FaceColor','red')
% Boundary=patchEdges(Face);
Vert1=obj.Vert;
FF1=obj.Face;
%% Create new face
m=Mesh2D('Face new');
switch opt.type
    case 1
        VV=Vert1(:,2:3);
        faceposition=faceposition(1,1);
    case 2
        VV=Vert1(:,2:3);
        faceposition=faceposition(1,1);
    case 3
        VV=[Vert1(:,1);Vert1(:,3)];
        faceposition=faceposition(1,2);
    case 4
        VV=[Vert1(:,1);Vert1(:,3)];
        faceposition=faceposition(1,2);
    case 5
        VV=Vert1(:,1:2);
        faceposition=faceposition(1,3);
    case 6
        VV=Vert1(:,1:2);
        faceposition=faceposition(1,3);
end
[m.N,m.E]=CompressNode(VV,Boundary);
a=Point2D('Point ass1');
a=AddPoint(a,position(1,1),position(1,2));
b=Line2D('Line ass1');
b=AddCircle(b,radius(1,1),a,1,'seg',opt.slice);
Point=b.Point.P;
EE=[(1:opt.slice)',[2:opt.slice,1]'];
EE=size(m.N,1)+EE;
m.N=[m.N;Point];
m.E=[m.E;EE];
m=Mesh(m);
switch opt.type
    case 1
        NN=size(Vert1,1);
        F2=m.Face+NN;
        Vert2=[ones(size(m.Vert,1),1)*faceposition,m.Vert];
        Cb2=ones(size(m.Face,1),1)*faceno;
    case 2
        NN=size(Vert1,1);
        F2=m.Face+NN;
        Vert2=[ones(size(m.Vert,1),1)*faceposition,m.Vert];
        Cb2=ones(size(m.Face,1),1)*faceno;
    case 3
        NN=size(Vert1,1);
        F2=m.Face+NN;
        Vert2=[m.Vert(:,1),ones(size(m.Vert,1),1)*faceposition,m.Vert(:,3)];
        Cb2=ones(size(m.Face,1),1)*faceno;
    case 4
        NN=size(Vert1,1);
        F2=m.Face+NN;
        Vert2=[m.Vert(:,1),ones(size(m.Vert,1),1)*faceposition,m.Vert(:,3)];
        Cb2=ones(size(m.Face,1),1)*faceno;
    case 5
        NN=size(Vert1,1);
        F2=m.Face+NN;
        Vert2=[m.Vert,ones(size(m.Vert,1),1)*faceposition];
        Cb2=ones(size(m.Face,1),1)*faceno;
    case 6
        NN=size(Vert1,1);
        F2=m.Face+NN;
        Vert2=[m.Vert,ones(size(m.Vert,1),1)*faceposition];
        Cb2=ones(size(m.Face,1),1)*faceno;
end

maxCb=max(Cb1);
[F3,Vert3,Cb3]=CreateHole(Point,radius,depth,maxCb,opt.type);
switch opt.type
    case 1
        Vert3=[Vert3(:,3)+faceposition,Vert3(:,1:2)];
    case 2
        Vert3=[Vert3(:,3)+faceposition,Vert3(:,1:2)];
    case 3
        Vert3=[Vert3(:,1),Vert3(:,3)+faceposition,Vert3(:,2)];
    case 4
        Vert3=[Vert3(:,1),Vert3(:,3)+faceposition,Vert3(:,2)];
    case 5
        Vert3=[Vert3(:,1:2),Vert3(:,3)+faceposition];
    case 6
        Vert3=[Vert3(:,1:2),Vert3(:,3)+faceposition];

end
Temp_Num=size([Vert1;Vert2],1);
F3=F3+Temp_Num;
% mm=Mesh('New Mesh');
% mm.Face=[FF1;F2;F3];
% mm.Face=[FF1;F2];
% mm.Vert=[Vert1;Vert2;
% mm.Vert=[Vert1;Vert2;Vert3];
% mm.Cb=[Cb1;Cb2];
% mm.Cb=[Cb1;Cb2;Cb3];
% mm=MergeFaceNode(mm);
% PlotFace(mm);
% mm=Mesh(mm);
obj.Vert=[Vert1;Vert2;Vert3];
obj.Face=[FF1;F2;F3];
% obj.Face=[FF1;F2];
obj.Cb=[Cb1;Cb2;Cb3];
% obj.Cb=[Cb1;Cb2];
obj=MergeFaceNode(obj);
% obj=Mesh3D(obj);
% obj.Meshoutput=mm.Meshoutput;


end
function [VV,EE]=CompressNode(V,Boundary)
Temp=unique(Boundary,"sorted");
VV=V(Temp,:);
% dev=Temp-(1:size(Temp,1))';
EE=Boundary;
for i=1:size(Temp,1)
    dev=Boundary-Temp(i,1);
    EE(dev(:,1)==0,1)=i;
    EE(dev(:,2)==0,2)=i;
end
end

function [Face,Vert,Cb]=CreateHole(basenode,radius,depth,maxCb,type)

if maxCb<1000
    acc_Cb=1000;
else
    acc_Cb=maxCb;
end

Num=size(depth,1);
a1=Point2D('Top Verts');
a1=AddPoint(a1,basenode(:,1),basenode(:,2));
l=Layer('Layer');
l=AddElement(l,a1);

switch type
    case 2
        depth=-depth;

    case 4
        depth=-depth;

    case 6
        depth=-depth;
end
Nmeshes=0;
acc_depth=0;
Vert=[];
Face=[];
Cb=[];
if Num==1
    l=AddElement(l,a1,'transform',[0,0,depth(1,1),0,0,0]);
    numSteps=ceil((depth(1,1)-acc_depth)/radius(1,1))*2;
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
    Nmeshes=Nmeshes+1;
    NN=size(Vert,1);
    Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
    Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
    acc_Cb=acc_Cb+1;
    NNN=size(l.Meshes{Nmeshes,1}.Face,1);
    Cb=[Cb;ones(NNN,1)*acc_Cb];
%     acc_depth=depth(1,1);
else
    for i=1:Num-1
        AddElement(l,a1,'transform',[0,0,depth(i,1),0,0,0]);
        numSteps=ceil((depth(i,1)-acc_depth)/radius(1,1))*2;
        l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
        Nmeshes=Nmeshes+1;
        NN=size(Vert,1);
        Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
        Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
        acc_Cb=acc_Cb+1;
        NNN=size(l.Meshes{Nmeshes,1}.Face,1);
        Cb=[Cb;ones(NNN,1)*acc_Cb];
        acc_depth=depth(i,1);
        if radius(i+1,1)==radius(i,1)
            continue
        else
            a1=Point2D('Top Verts');
            ratio=radius(i+1,1)/radius(i,1);
            a1=AddPoint(a1,basenode(:,1)*ratio,basenode(:,2)*ratio);
            l=AddElement(l,a1,'transform',[0,0,depth(i,1),0,0,0]);
            numSteps=ceil(radius(i+1,1)/radius(1,1))*2;
            l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
            Nmeshes=Nmeshes+1;
            NN=size(Vert,1);
            Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
            Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
            acc_Cb=acc_Cb+1;
            NNN=size(l.Meshes{Nmeshes,1}.Face,1);
            Cb=[Cb;ones(NNN,1)*acc_Cb];
        end
    end
    l=AddElement(l,a1,'transform',[0,0,depth(Num,1),0,0,0]);
    numSteps=ceil((depth(Num,1)-acc_depth)/radius(1,1))*2;
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
    Nmeshes=Nmeshes+1;
    NN=size(Vert,1);
    Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
    Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
    acc_Cb=acc_Cb+1;
    NNN=size(l.Meshes{Nmeshes,1}.Face,1);
    Cb=[Cb;ones(NNN,1)*acc_Cb];
%     acc_depth=depth(end,1);
end
% Create bottom surface
r1=radius(end,1);
m1=Mesh2D('Mesh1');
m1=MeshQuadCircle(m1,'n',size(basenode,1)/4,'r',r1);
m1=Quad2Tri(m1);

Temp=[m1.Vert(:,1),m1.Vert(:,2),ones(size(m1.Vert,1),1)*depth(end,1)];
NN=size(Vert,1);
Vert=[Vert;Temp];
Face=[Face;m1.Face+NN];
NNN=size(m1.Face,1);
acc_Cb=acc_Cb+1;
Cb=[Cb;ones(NNN,1)*acc_Cb];
end
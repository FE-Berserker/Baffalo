function obj = DrillThroughHole(obj,radius,depth,position,faceno,varargin)
% Drill holes of obj
% +x,-x,+y,-y,+z,-z, type=1,2,3,4,5,6
% Author: Xie Yu
p=inputParser;
addParameter(p,'type',6);
addParameter(p,'slice',8);
addParameter(p,'holetype',1);
addParameter(p,'reverse',0);
parse(p,varargin{:});
opt=p.Results;

opt.slice=(ceil(opt.slice/8))*8;
faceno1=faceno(1,1);
faceno2=faceno(2,1);
%% Find face boundary1
V=obj.Vert;
F=obj.Face;
Cb=obj.Cb;
F1=F(and((Cb~=faceno1),(Cb~=faceno2)),:);
Cb1=obj.Cb(and((Cb~=faceno1),(Cb~=faceno2)),:);
if size(F1,2)==4
    F1=[F1(:,1:3);F1(:,[1,3,4])];
    Cb1=[Cb1;Cb1];
end
Cb1(F1(:,1)==F1(:,2),:)=[];
F1(F1(:,1)==F1(:,2),:)=[];
Cb1(F1(:,2)==F1(:,3),:)=[];
F1(F1(:,2)==F1(:,3),:)=[];
%% Clean unused node
[obj.Face,obj.Vert]=patchCleanUnused(F1,V); %Remove unused nodes
 obj.Cb=Cb1;

Boundary=FindBoundary(obj);
groupOptStruct.outputType='label';
[G,~,GroupSize]=tesgroup(Boundary,groupOptStruct); %Group connected faces

V=obj.Vert;
switch size(GroupSize,2)
    case 2
        Boundary1=Boundary(G==1,:);
        Boundary2=Boundary(G==2,:);

    case 4
        Boundary1=Boundary(or(G==1,G==2),:);
        Boundary2=Boundary(or(G==3,G==4),:);
end
faceposition1=V(Boundary1(1,1),:);
faceposition2=V(Boundary2(1,1),:);
Vert1=obj.Vert;
FF1=obj.Face;
Cb1=obj.Cb;
%% Create new face
switch opt.type
    case 1
        VV=Vert1(:,2:3);
        faceposition1=faceposition1(1,1);
        faceposition2=faceposition2(1,1);
    case 2
        VV=Vert1(:,2:3);
        faceposition1=faceposition1(1,1);
        faceposition2=faceposition2(1,1);
    case 3
        VV=[Vert1(:,1),Vert1(:,3)];
        faceposition1=faceposition1(1,2);
        faceposition2=faceposition2(1,2);
    case 4
        VV=[Vert1(:,1),Vert1(:,3)];
        faceposition1=faceposition1(1,2);
        faceposition2=faceposition2(1,2);
    case 5
        VV=Vert1(:,1:2);
        faceposition1=faceposition1(1,3);
        faceposition2=faceposition2(1,3);
    case 6
        VV=Vert1(:,1:2);
        faceposition1=faceposition1(1,3);
        faceposition2=faceposition2(1,3);
end

m1=Mesh2D('Face new');
[m1.N,m1.E]=CompressNode(VV,Boundary1);
a=Point2D('Point ass1');
b1=Line2D('Line ass1');
for i=1:size(position,1)
    a=AddPoint(a,position(i,1),position(i,2));
    b1=AddCircle(b1,radius(1,1),a,i,'seg',opt.slice);
end
Point1=b1.Point.P;
EE=[(1:opt.slice)',[2:opt.slice,1]'];
EE=repmat(EE,size(position,1),1);

TempEE=0:size(position,1)-1;
TempEE=repmat(TempEE,opt.slice,1)*opt.slice;
TempEE=reshape(TempEE,[],1);

EE=EE+[TempEE,TempEE];

EE=size(m1.N,1)+EE;
m1.N=[m1.N;Point1];
m1.E=[m1.E;EE];
m1=Mesh(m1,'ref2','refine','ref1','preserve');
if opt.reverse
    m1.Face=[m1.Face(:,1),m1.Face(:,3),m1.Face(:,2)];
end

m2=Mesh2D('Face new');
[m2.N,m2.E]=CompressNode(VV,Boundary2);
b2=Line2D('Line ass1');
for i=1:size(position,1)
    b2=AddCircle(b2,radius(end,1),a,i,'seg',opt.slice);
end
Point2=b2.Point.P;
EE=[(1:opt.slice)',[2:opt.slice,1]'];
EE=repmat(EE,size(position,1),1);

TempEE=0:size(position,1)-1;
TempEE=repmat(TempEE,opt.slice,1)*opt.slice;
TempEE=reshape(TempEE,[],1);

EE=EE+[TempEE,TempEE];
EE=size(m2.N,1)+EE;
m2.N=[m2.N;Point2];
m2.E=[m2.E;EE];
m2=Mesh(m2,'ref2','refine','ref1','preserve');
if ~opt.reverse
    m2.Face=[m2.Face(:,1),m2.Face(:,3),m2.Face(:,2)];
end

switch opt.type
    case 1
        NN1=size(Vert1,1);
        F2=m1.Face+NN1;
        Vert2=[ones(size(m1.Vert,1),1)*faceposition1,m1.Vert];
        Cb2=ones(size(m1.Face,1),1)*faceno1;

        NN2=size(Vert2,1);
        F3=m2.Face+NN1+NN2;
        Vert3=[ones(size(m2.Vert,1),1)*faceposition2,m2.Vert];
        Cb3=ones(size(m2.Face,1),1)*faceno2;

    case 2
        NN1=size(Vert1,1);
        F2=m1.Face+NN1;
        Vert2=[ones(size(m1.Vert,1),1)*faceposition1,m1.Vert];
        Cb2=ones(size(m1.Face,1),1)*faceno1;

        NN2=size(Vert2,1);
        F3=m2.Face+NN1+NN2;
        Vert3=[ones(size(m2.Vert,1),1)*faceposition2,m2.Vert];
        Cb3=ones(size(m2.Face,1),1)*faceno2;
    case 3
        NN1=size(Vert1,1);
        F2=m1.Face+NN1;
        Vert2=[m1.Vert(:,1),ones(size(m1.Vert,1),1)*faceposition1,m1.Vert(:,2)];
        Cb2=ones(size(m1.Face,1),1)*faceno1;

        NN2=size(Vert2,1);
        F3=m2.Face+NN1+NN2;
        Vert3=[m2.Vert(:,1),ones(size(m2.Vert,1),1)*faceposition2,m2.Vert(:,2)];
        Cb3=ones(size(m2.Face,1),1)*faceno2;
    case 4
        NN1=size(Vert1,1);
        F2=m1.Face+NN1;
        Vert2=[m1.Vert(:,1),ones(size(m1.Vert,1),1)*faceposition1,m1.Vert(:,2)];
        Cb2=ones(size(m1.Face,1),1)*faceno1;

        NN2=size(Vert2,1);
        F3=m2.Face+NN1+NN2;
        Vert3=[m2.Vert(:,1),ones(size(m2.Vert,1),1)*faceposition2,m2.Vert(:,2)];
        Cb3=ones(size(m2.Face,1),1)*faceno2;
    case 5
        NN1=size(Vert1,1);
        F2=m1.Face+NN1;
        Vert2=[m1.Vert,ones(size(m1.Vert,1),1)*faceposition1];
        Cb2=ones(size(m1.Face,1),1)*faceno1;

        NN2=size(Vert2,1);
        F3=m2.Face+NN2+NN1;
        Vert3=[m2.Vert,ones(size(m2.Vert,1),1)*faceposition2];
        Cb3=ones(size(m2.Face,1),1)*faceno2;
    case 6
        NN1=size(Vert1,1);
        F2=m1.Face+NN1;
        Vert2=[m1.Vert,ones(size(m1.Vert,1),1)*faceposition1];
        Cb2=ones(size(m1.Face,1),1)*faceno1;

        NN2=size(Vert2,1);
        F3=m2.Face+NN1+NN2;
        Vert3=[m2.Vert,ones(size(m2.Vert,1),1)*faceposition2];
        Cb3=ones(size(m2.Face,1),1)*faceno2;
end

maxCb=max(Cb1);
[F4,Vert4,Cb4]=CreateHole(Point1,radius,depth,maxCb,opt.type,size(position,1));
if opt.reverse
    F4=[F4(:,1),F4(:,3),F4(:,2)];
end
switch opt.type
    case 1
        Vert4=[Vert4(:,3)+faceposition1,Vert4(:,1:2)];
    case 2
        Vert4=[Vert4(:,3)+faceposition1,Vert4(:,1:2)];
    case 3
        Vert4=[Vert4(:,1),Vert4(:,3)+faceposition1,Vert4(:,2)];
    case 4
        Vert4=[Vert4(:,1),Vert4(:,3)+faceposition1,Vert4(:,2)];
    case 5
        Vert4=[Vert4(:,1:2),Vert4(:,3)+faceposition1];
    case 6
        Vert4=[Vert4(:,1:2),Vert4(:,3)+faceposition1];

end
Temp_Num=size([Vert1;Vert2;Vert3],1);
F4=F4+Temp_Num;
obj.Vert=[Vert1;Vert2;Vert3;Vert4];
obj.Face=[FF1;F2;F3;F4];
obj.Cb=[Cb1;Cb2;Cb3;Cb4];
obj=MergeFaceNode(obj,3);



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

function [Face,Vert,Cb]=CreateHole(basenode,radius,depth,maxCb,type,HoleNum)

if maxCb<1000
    acc_Cb=1000;
else
    acc_Cb=maxCb;
end

Num=size(depth,1);

l=Layer('Layer');
Slice=size(basenode,1)/HoleNum;
% for i=1:HoleNum
%     a1=Point2D('Top Verts');
%     a1=AddPoint(a1,basenode(1+(i-1)*Slice:Slice+(i-1)*Slice,1),basenode(1+(i-1)*Slice:Slice+(i-1)*Slice,2));
%     l=AddElement(l,a1);
% end

switch type
    case 2
        depth=-depth;

    case 4
        depth=-depth;

    case 6
        depth=-depth;
end
Nmeshes=0;
AccMesh=0;
acc_depth=0;
Vert=[];
Face=[];
Cb=[];
if Num==1
    for j=1:HoleNum
        a1=Point2D('Top Verts');
        a1=AddPoint(a1,basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2));
        l=AddElement(l,a1);
        l=AddElement(l,a1,'transform',[0,0,depth(1,1),0,0,0]);
        numSteps=ceil(abs((depth(1,1)-acc_depth))/radius(1,1))*2;
        l=LoftLinear(l,2*Nmeshes+1,2*Nmeshes+2,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
        Nmeshes=Nmeshes+1;
        NN=size(Vert,1);
        Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
        Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
        acc_Cb=acc_Cb+1;
        NNN=size(l.Meshes{Nmeshes,1}.Face,1);
        Cb=[Cb;ones(NNN,1)*acc_Cb];
    end
%     acc_depth=depth(1,1);
else
    for j=1:HoleNum
        a1=Point2D('Top Verts');
        a1=AddPoint(a1,basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2));
        l=AddElement(l,a1);
    end
    numSteps=ceil(abs((depth(1,1)-acc_depth))/radius(1,1))*2;
    for j=1:HoleNum
        a1=Point2D('Top Verts');
        a1=AddPoint(a1,basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2));
        l=AddElement(l,a1,'transform',[0,0,depth(1,1),0,0,0]);              
        l=LoftLinear(l,j,HoleNum+j,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
        NN=size(Vert,1);
        Nmeshes=Nmeshes+1;
        Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
        Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
        acc_Cb=acc_Cb+1;
        NNN=size(l.Meshes{Nmeshes,1}.Face,1);
        Cb=[Cb;ones(NNN,1)*acc_Cb];
    end

    if radius(2,1)~=radius(1,1)
        ratio=radius(2,1)/radius(1,1);
        for j=1:HoleNum
            a1=Point2D('Top Verts');
            TempPoint=[basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2)];
            center=mean(TempPoint);
            a1=AddPoint(a1,(TempPoint(:,1)-center(1))*ratio+center(1),(TempPoint(:,2)-center(2))*ratio+center(2));
            l=AddElement(l,a1,'transform',[0,0,depth(1,1),0,0,0]);
            numSteps=ceil(abs(radius(2,1)/radius(1,1)))*2;
            l=LoftLinear(l,HoleNum+j,HoleNum*2+j,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
            Nmeshes=Nmeshes+1;
            NN=size(Vert,1);
            Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
            Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
            acc_Cb=acc_Cb+1;
            NNN=size(l.Meshes{Nmeshes,1}.Face,1);
            Cb=[Cb;ones(NNN,1)*acc_Cb];
        end
    end

    AccMesh=Nmeshes;
    acc_depth=depth(1,1);

    if Num>2
        for i=2:Num-1
            for j=1:HoleNum
                a1=Point2D('Top Verts');
                TempPoint=[basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2)];
                center=mean(TempPoint);
                a1=AddPoint(a1,(TempPoint(:,1)-center(1))*ratio+center(1),(TempPoint(:,2)-center(2))*ratio+center(2));
                l=AddElement(l,a1,'transform',[0,0,depth(i,1),0,0,0]);
                numSteps=ceil(abs((depth(i,1)-acc_depth))/radius(1,1))*2;
                l=LoftLinear(l,AccMesh+j,AccMesh+HoleNum+j,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
                NN=size(Vert,1);
                Nmeshes=Nmeshes+1;
                Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
                Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
                acc_Cb=acc_Cb+1;
                NNN=size(l.Meshes{Nmeshes,1}.Face,1);
                Cb=[Cb;ones(NNN,1)*acc_Cb];
            end
            AccMesh=Nmeshes;
            acc_depth=depth(i,1);
            if radius(i+1,1)==radius(i,1)
                continue
            else
                ratio=radius(i+1,1)/radius(1,1);
                for j=1:HoleNum
                    a1=Point2D('Top Verts');

                    TempPoint=[basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2)];
                    center=mean(TempPoint);
                    a1=AddPoint(a1,(TempPoint(:,1)-center(1))*ratio+center(1),(TempPoint(:,2)-center(2))*ratio+center(2));
                    l=AddElement(l,a1,'transform',[0,0,depth(i,1),0,0,0]);
                    numSteps=ceil(abs(radius(i+1,1)/radius(1,1)))*2;
                    l=LoftLinear(l,AccMesh+j,AccMesh+HoleNum+j,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
                    Nmeshes=Nmeshes+1;
                    NN=size(Vert,1);
                    Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
                    Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
                    acc_Cb=acc_Cb+1;
                    NNN=size(l.Meshes{Nmeshes,1}.Face,1);
                    Cb=[Cb;ones(NNN,1)*acc_Cb];
                end
                AccMesh=Nmeshes;
            end
        end
    end
    
    ratio=radius(Num,1)/radius(1,1);
    for j=1:HoleNum
        TempPoint=[basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,1),basenode(1+(j-1)*Slice:Slice+(j-1)*Slice,2)];
        center=mean(TempPoint);
        a1=Point2D('Top Verts');
        a1=AddPoint(a1,(TempPoint(:,1)-center(1))*ratio+center(1),(TempPoint(:,2)-center(2))*ratio+center(2));
        l=AddElement(l,a1,'transform',[0,0,depth(Num,1),0,0,0]);
        numSteps=ceil(abs((depth(Num,1)-acc_depth))/radius(1,1))*2;
        l=LoftLinear(l,AccMesh+j,AccMesh+HoleNum+j,'closeLoopOpt',1,'patchType','tri_slash','numSteps',numSteps);
        Nmeshes=Nmeshes+1;
        NN=size(Vert,1);
        Vert=[Vert;l.Meshes{Nmeshes,1}.Vert];
        Face=[Face;l.Meshes{Nmeshes,1}.Face+NN];
        acc_Cb=acc_Cb+1;
        NNN=size(l.Meshes{Nmeshes,1}.Face,1);
        Cb=[Cb;ones(NNN,1)*acc_Cb];
    end

end

end
function mm = CreateMesh3D4(obj,mm,r1,row)
% Create shaft 3D mesh 4
% Author : Xie Yu

deg=360/obj.params.E_Revolve;
x1=obj.input.Length(row-1)*ones(obj.params.E_Revolve,1);
y1=cos((0:deg:360-deg)'/180*pi)*r1;
z1=sin((0:deg:360-deg)'/180*pi)*r1;
V1=[x1 y1 z1];
a=Point2D('Bottom Verts','Echo',0);
a=AddPoint(a,y1,z1);
l=Layer('Layer','Echo',0);
l=AddElement(l,a,'transform',[x1(1,1),0,0,0,90,0]);
Nmeshes=0;
Nsec=301;
patchType='tri_slash';
for i=row:-1:2
    if i==2
        x2=zeros(obj.params.E_Revolve,1);
    else
        x2=repmat(obj.input.Length(i-2),obj.params.E_Revolve,1);
    end

    r2=obj.input.ID(i-1,1)/2;
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];
    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);
    % Layer
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

    mm.Cb=mm.Cb*(200+i-1)./Nmeshes.*(mm.Cb==Nmeshes)+mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;

    if i==2
        break
    elseif obj.input.ID(i-2,2)/2==r2
        continue
    end

    r2=obj.input.ID(i-2,2)/2;
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];
    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    AddPoint(a1,y2,z2)
    % Layer
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
    Nsec=Nsec+1;
    mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)...
        +mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;
end
x2=zeros(obj.params.E_Revolve,1);
r2=obj.input.OD(1,1)/2;
y2=cos((0:deg:360-deg)'/180*pi)*r2;
z2=sin((0:deg:360-deg)'/180*pi)*r2;
V2=[x2 y2 z2];
Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
    ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
numSteps=max(Temp);

a1=Point2D('Top Verts','Echo',0);
a1=AddPoint(a1,y2,z2);
% Layer
l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
NN=size(mm.Vert,1);
Nmeshes=Nmeshes+1;
mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
Nsec=Nsec+1;
mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)+mm.Cb.*(mm.Cb~=Nmeshes);
V1=V2;r1=r2;

for i=1:size(obj.input.Length,1)-1
    x2=repmat(obj.input.Length(i),obj.params.E_Revolve,1);
    r2=obj.input.OD(i,2)/2;
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];
    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);
    % Layer
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

    mm.Cb=mm.Cb*(100+i)./Nmeshes.*(mm.Cb==Nmeshes)+mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;

    if obj.input.OD(i+1,1)/2==r2
        continue
    end

    r2=obj.input.OD(i+1,1)/2;
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];
    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
   numSteps=max(Temp);


    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);
    % Layer
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

    Nsec=Nsec+1;
    mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)...
        +mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;
end

x2=repmat(obj.input.Length(end),obj.params.E_Revolve,1);
r2=obj.input.OD(end,2)/2;
y2=cos((0:deg:360-deg)'/180*pi)*r2;
z2=sin((0:deg:360-deg)'/180*pi)*r2;
V2=[x2 y2 z2];
Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
    ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
numSteps=max(Temp);

a1=Point2D('Top Verts','Echo',0);
a1=AddPoint(a1,y2,z2);
% Layer
l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
NN=size(mm.Vert,1);
Nmeshes=Nmeshes+1;
mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

mm.Cb=mm.Cb*(100+size(obj.input.Length,1))./Nmeshes.*(mm.Cb==Nmeshes)...
    +mm.Cb.*(mm.Cb~=Nmeshes);
V1=V2;r1=r2;


r2=obj.input.ID(end,2)/2;
if r2~=0
    x2=repmat(obj.input.Length(end),obj.params.E_Revolve,1);
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];
    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);
    % Layer
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
    Nsec=Nsec+1;
    mm.Cb=mm.Cb*Nsec/Nmeshes.*(mm.Cb==Nmeshes)...
        +mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;
    for i=size(obj.input.Length,1):-1:1
        r2=obj.input.ID(i,1)/2;
        x2=repmat(obj.input.Length(i-1),obj.params.E_Revolve,1);
        y2=cos((0:deg:360-deg)'/180*pi)*r2;
        z2=sin((0:deg:360-deg)'/180*pi)*r2;
        V2=[x2 y2 z2];
        Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
            ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
        numSteps=max(Temp);

        a1=Point2D('Top Verts','Echo',0);
        a1=AddPoint(a1,y2,z2);
        % Layer
        l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
        l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
        NN=size(mm.Vert,1);
        Nmeshes=Nmeshes+1;
        mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
        mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
        mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

        mm.Cb=mm.Cb*(200+i)./Nmeshes.*(mm.Cb==Nmeshes)...
            +mm.Cb.*(mm.Cb~=Nmeshes);
        V1=V2;r1=r2;

        r2=obj.input.ID(i-1,2)/2;
        if r2==0
            break
        elseif r2==obj.input.ID(i,1)/2
            continue
        end
        y2=cos((0:deg:360-deg)'/180*pi)*r2;
        z2=sin((0:deg:360-deg)'/180*pi)*r2;
        V2=[x2 y2 z2];
        Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
            ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
        numSteps=max(Temp);

        a1=Point2D('Top Verts','Echo',0);
        a1=AddPoint(a1,y2,z2);
        % Layer
        l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
        l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);
        NN=size(mm.Vert,1);
        Nmeshes=Nmeshes+1;
        mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
        mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
        mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
        Nsec=Nsec+1;
        mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)...
            +mm.Cb.*(mm.Cb~=Nmeshes);
        V1=V2;r1=r2;

    end
end

% Creat Base mesh
r2=r1;
r1=obj.input.ID(row-1,2)/2;
if r1~=0

    m1=Mesh2D('Mesh1','Echo',0);
    m1=MeshQuadCircle(m1,'n',obj.params.E_Revolve/4,'r',r1);
    m1=Quad2Tri(m1);
    Temp=[obj.input.Length(row-1)*ones(size(m1.Vert,1),1),m1.Vert(:,1),m1.Vert(:,2)];
    numVert=size(mm.Vert,1);
    mm.Vert=[mm.Vert;Temp];
    mm.Face=[mm.Face;m1.Face+numVert.*ones(size(m1.Face,1),3)];
    mm.Cb=[mm.Cb;ones(size(m1.Face,1),1)*301];
end
if r2~=0

    m2=Mesh2D('Mesh2','Echo',0);
    m2=MeshQuadCircle(m2,'n',obj.params.E_Revolve/4,'r',r2);
    m2=Quad2Tri(m2);
    % Reverse face normal
    TempFace=[m2.Face(:,1),m2.Face(:,3),m2.Face(:,2)];
    m2.Face=TempFace;

    Temp=[V2(1,1)*ones(size(m2.Vert,1),1),m2.Vert(:,1),m2.Vert(:,2)];

    numVert=size(mm.Vert,1);
    mm.Vert=[mm.Vert;Temp];
    mm.Face=[mm.Face;m2.Face+numVert.*ones(size(m2.Face,1),3)];
    Nsec=Nsec+1;
    mm.Cb=[mm.Cb;ones(size(m2.Face,1),1)*Nsec];

end
mm=MergeFaceNode(mm);
end


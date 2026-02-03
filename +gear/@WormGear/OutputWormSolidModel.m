function obj=OutputWormSolidModel(obj)
% Output SolidModel of Worm
% Author: Xie Yu
WormCurve=obj.output.WormCurve;
Z1=obj.input.Z1;
pz=obj.output.pz;
d1=obj.output.d1;
Lsize=obj.params.Lsize1;

Ang=360/Z1;
Delta=WormCurve.Point.P(1,2)-WormCurve.Point.P(end,2);
Temp=Ang/Delta;
PP=[];

for i=1:4
    if i==1
        seg=1;

        TP=WormCurve.Point.PP{i,1};
        gap1=(TP(2,1)-TP(1,1))/seg;
        gap2=(TP(2,2)-TP(1,2))/seg;

        TP=[TP(1,1)+(0:seg)'*gap1,TP(1,2)+(0:seg)'*gap2];
        TP(:,1)=-TP(:,1)+d1/2;
        TP(:,2)=TP(:,2)+Delta/2;
    elseif i==2
        seg=Lsize(2)-1;
        TP=WormCurve.Point.PP{i,1};

        a=Point2D('Temp','Echo',0);
        b=Line2D('Temp','Echo',0);
        a=AddPoint(a,TP(:,1),TP(:,2));
        b=AddCurve(b,a,1);
        TP = RebuildCurve(b,1,seg+1);

        TP(:,1)=-TP(:,1)+d1/2;
        TP(:,2)=TP(:,2)+Delta/2;

        TP=TP(2:end,:);
    elseif i==3
        seg=Lsize(1);
        TP=WormCurve.Point.PP{i,1};

        a=Point2D('Temp','Echo',0);
        b=Line2D('Temp','Echo',0);
        a=AddPoint(a,TP(:,1),TP(:,2));
        b=AddCurve(b,a,1);
        TP = RebuildCurve(b,1,seg+1);

        TP(:,1)=-TP(:,1)+d1/2;
        TP(:,2)=TP(:,2)+Delta/2;

        TP=TP(2:end,:);
    elseif i==4
        seg=Lsize(3);
        TP=WormCurve.Point.PP{i,1};

        a=Point2D('Temp','Echo',0);
        b=Line2D('Temp','Echo',0);
        a=AddPoint(a,TP(:,1),TP(:,2));
        b=AddCurve(b,a,1);
        TP = RebuildCurve(b,1,seg+1);

        TP(:,1)=-TP(:,1)+d1/2;
        TP(:,2)=TP(:,2)+Delta/2;

        TP=TP(2:end,:);


    end
    r=TP(:,1);
    theta=Temp*TP(:,2);

    if i==3
        theta1=theta(1,1);
        theta2=theta(end,1);
    end

    PP=[PP;r.*cos(theta/180*pi),r.*sin(theta/180*pi)];

end

% Build shellmesh
rf=min(-WormCurve.Point.P(:,1))+d1/2;

if isempty(obj.input.ID1)
    obj.input.ID1=rf;
end


    x1=PP(1:Lsize(2)+1,1);
    y1=PP(1:Lsize(2)+1,2);

    x2=PP(Lsize(2)+1:Lsize(2)+Lsize(1)+1,1);
    y2=PP(Lsize(2)+1:Lsize(2)+Lsize(1)+1,2);

    x3=PP(Lsize(2)+Lsize(1)+1:Lsize(2)+Lsize(1)+Lsize(3)+1,1);
    y3=PP(Lsize(2)+Lsize(1)+1:Lsize(2)+Lsize(1)+Lsize(3)+1,2);

if Z1~=1
    gap=rf-obj.input.ID1/2;
    x4=[(rf-gap/3)*cos(Ang/2/180*pi);x3(end,1)];
    y4=[(rf-gap/3)*sin(Ang/2/180*pi);y3(end,1)];


    x5=[x2(1,1);(rf-gap/3)*cos(Ang/2/180*pi)];
    y5=[y2(1,1);(rf-gap/3)*sin(Ang/2/180*pi)];

    x6=[x1(1,1);(rf-gap/3)*cos(Ang/180*pi)];
    y6=[y1(1,1);(rf-gap/3)*sin(Ang/180*pi)];

    x7=[(rf-gap/3)*cos(Ang/2/180*pi);(rf-gap/3)*cos(Ang/180*pi)];
    y7=[(rf-gap/3)*sin(Ang/2/180*pi);(rf-gap/3)*sin(Ang/180*pi)];

    a=Point2D('PointAss','Echo',0);
    a=AddPoint(a,0,0);
    a=AddPoint(a,x1,y1);
    a=AddPoint(a,x2,y2);
    a=AddPoint(a,x3,y3);
    a=AddPoint(a,x4,y4);
    a=AddPoint(a,x5,y5);
    a=AddPoint(a,x6,y6);
    a=AddPoint(a,x7,y7);

    b1=Line2D('LineAss','Echo',0);
    for i=2:6
        b1=AddCurve(b1,a,i);
    end

    b1=AddCurve(b1,a,8);
    b1=AddCurve(b1,a,7);
    b1=AddCircle(b1,rf-gap,a,1,'sang',Ang/2,'ang',Ang/2);

    m1=Mesh2D('Mesh1','Echo',0);
    m1=MeshQuadPlate(m1,[10,10],[Lsize(1,1)+Lsize(2,1),Lsize(3,1)]);

    % Parse node
    l1=b1.Point.PP{3, 1};
    l2=b1.Point.PP{2, 1};
    l2=l2(end:-1:1,:);
    l3=RebuildCurve(b1,4,Lsize(1,1)+1);
    l3=l3(end:-1:1,:);

    l5=RebuildCurve(b1,1,Lsize(2,1)+1);
    l5=l5(end-1:-1:1,:);

    l6=RebuildCurve(b1,6,Lsize(2,1)+1);
    l6=l6(2:end,:);

    delta=l3-l2;
    deltax=delta(:,1)/Lsize(3,1);
    deltay=delta(:,2)/Lsize(3,1);
    XX1=repmat(l2(:,1)',Lsize(3,1)+1,1);
    YY1=repmat(l2(:,2)',Lsize(3,1)+1,1);
    Temp=0:Lsize(3,1);
    DDx=Temp'*deltax';
    DDy=Temp'*deltay';

    XX1=XX1+DDx;
    YY1=YY1+DDy;

    delta=l6-l5;
    deltax=delta(:,1)/Lsize(3,1);
    deltay=delta(:,2)/Lsize(3,1);
    XX2=repmat(l5(:,1)',Lsize(3,1)+1,1);
    YY2=repmat(l5(:,2)',Lsize(3,1)+1,1);
    Temp=0:Lsize(3,1);
    DDx=Temp'*deltax';
    DDy=Temp'*deltay';
    XX2=XX2+DDx;
    YY2=YY2+DDy;

    XX=[XX1,XX2];
    YY=[YY1,YY2];
    m1.Vert=[reshape(XX,[],1),reshape(YY,[],1)];
    m1.Vert(1:Lsize(3,1)+1,:)=l1;

    m2=Mesh2D('Mesh2','Echo',0);
    m2=MeshQuadPlate(m2,[10,10],[Lsize(2,1),3]);

    l7=RebuildCurve(b1,6,Lsize(2,1)+1);
    l7=l7(end:-1:1,:);
    l8=RebuildCurve(b1,8,Lsize(2,1)+1);
    l8=l8(end:-1:1,:);

    delta=l8-l7;
    deltax=delta(:,1)/3;
    deltay=delta(:,2)/3;
    XX3=repmat(l7(:,1)',4,1);
    YY3=repmat(l7(:,2)',4,1);
    Temp=0:3;
    DDx=Temp'*deltax';
    DDy=Temp'*deltay';
    XX3=XX3+DDx;
    YY3=YY3+DDy;

    m2.Vert=[reshape(XX3,[],1),reshape(YY3,[],1)];

    % m1.Face=[m1.Face;m2.Face+size(m1.Vert,1)];
    m1.Face=[m1.Face;[m2.Face(:,1),m2.Face(:,4),m2.Face(:,3),m2.Face(:,2)]+size(m1.Vert,1)];
    m1.Vert=[m1.Vert;m2.Vert];
    m1.Cb=[m1.Cb;m2.Cb];

else
    a=Point2D('PointAss','Echo',0);
    a=AddPoint(a,0,0);
    a=AddPoint(a,x1,y1);
    a=AddPoint(a,x2,y2);
    a=AddPoint(a,x3,y3);

    b1=Line2D('LineAss','Echo',0);
    for i=2:4
        b1=AddCurve(b1,a,i);
    end
    b1=AddCircle(b1,obj.input.ID1/2,a,1,'sang',0,'ang',theta1-360,'seg',Lsize(2));
    b1=AddCircle(b1,obj.input.ID1/2,a,1,'sang',theta1,'ang',theta2-theta1,'seg',Lsize(1));
    b1=AddCircle(b1,obj.input.ID1/2,a,1,'sang',theta2,'ang',180-theta2,'seg',Lsize(3));

    m1=Mesh2D('Mesh1','Echo',0);
    m1=MeshQuadPlate(m1,[10,10],[Lsize(1,1)+Lsize(2,1)+Lsize(3,1),8]);

    % Parse node
    l1=RebuildCurve(b1,1,Lsize(2)+1);
    l2=RebuildCurve(b1,2,Lsize(1)+1);
    l3=RebuildCurve(b1,3,Lsize(3)+1);
    l4=b1.Point.PP{4, 1};
    l5=b1.Point.PP{5, 1};
    l6=b1.Point.PP{6, 1};

    delta1=(l1-l4)/8;
    delta2=(l2-l5)/8;
    delta3=(l3-l6)/8;
    Temp=0:8;
    xx1=reshape((repmat(l4(:,1),1,9)+delta1(:,1)*Temp)',[],1);
    yy1=reshape((repmat(l4(:,2),1,9)+delta1(:,2)*Temp)',[],1);
    xx2=reshape((repmat(l5(:,1),1,9)+delta2(:,1)*Temp)',[],1);
    yy2=reshape((repmat(l5(:,2),1,9)+delta2(:,2)*Temp)',[],1);
    xx3=reshape((repmat(l6(:,1),1,9)+delta3(:,1)*Temp)',[],1);
    yy3=reshape((repmat(l6(:,2),1,9)+delta3(:,2)*Temp)',[],1);

    XX=[xx1(1:end-9,:);xx2(1:end-9,:);xx3];
    YY=[yy1(1:end-9,:);yy2(1:end-9,:);yy3];
    m1.Vert=[XX,YY];
end

% Reflect mesh
m1.Face=[m1.Face;[m1.Face(:,4),m1.Face(:,3),m1.Face(:,2),m1.Face(:,1)]+size(m1.Vert,1)];

Matrix=[cos(-Ang/2/180*pi),sin(-Ang/2/180*pi);-sin(-Ang/2/180*pi),cos(-Ang/2/180*pi)];
VV=Matrix*m1.Vert';

VV(2,:)=-VV(2,:);

Matrix=[cos(Ang/2/180*pi),sin(Ang/2/180*pi);-sin(Ang/2/180*pi),cos(Ang/2/180*pi)];
VV=Matrix*VV;

m1.Vert=[m1.Vert;[VV(1,:)',VV(2,:)']];
m1.Cb=[m1.Cb;m1.Cb];

m1=MergeNode(m1);

% Rotate mesh
if Z1~=1
    Face=m1.Face;
    Cb=m1.Cb;
    Vert=m1.Vert;
    Angle=Ang/180*pi;
    acc=size(m1.Vert,1);
    for i=1:Z1-1
        Matrix=[cos(Angle*i),sin(Angle*i);-sin(Angle*i),cos(Angle*i)];
        VV=Matrix*Vert';
        m1.Face=[m1.Face;Face+acc];
        m1.Vert=[m1.Vert;VV'];
        m1.Cb=[m1.Cb;Cb];
        acc=size(m1.Vert,1);
    end
    m1=MergeNode(m1);
end
m1.Boundary=FindBoundary(m1);

% Parse
m1.Meshoutput.nodes=[m1.Vert,zeros(size(m1.Vert,1),1)];
m1.Meshoutput.facesBoundary=m1.Boundary;
m1.Meshoutput.boundaryMarker=ones(size(m1.Boundary,1),1);
m1.Meshoutput.faces=[];
m1.Meshoutput.elements=m1.Face;
m1.Meshoutput.elementMaterialID=ones(size(m1.Face,1),1);
m1.Meshoutput.faceMaterialID=[];
m1.Meshoutput.order=1;

Layer=obj.params.NWidth1;

% ra=obj.output.da/2;
% Z=obj.input.Z;
% P=obj.output.GearCurve.Point.PP;
b=obj.input.b1;

mm=Mesh(obj.params.Name,'Echo',0);
mm=Extrude2Solid(mm,m1,b,Layer);

% Cb calculation
Vm=PatchCenter(mm);
Cb=mm.Cb;
[theta,Rm] =cart2pol(Vm(:,1),Vm(:,2));

theta(theta<0,:)=2*pi+theta(theta<0,:);
theta=theta/pi*180;

Cb(and(Cb==1,Rm<=rf),:)=11;
r1=WormCurve.Point.PP{3,1}(1,1)+d1/2;
r2=WormCurve.Point.PP{3,1}(end,1)+d1/2;

for i=1:Z1
    Cb(and(Cb==1,and(theta>=Ang*(i-1),theta<Ang/2+Ang*(i-1))),:)=20+i;
    Cb(and(Cb==1,and(theta>=Ang/2+Ang*(i-1),theta<Ang*i)),:)=30+i;

    Cb(and(Cb==20+i,and(Rm>=r2,Rm<=r1)),:)=100+i;
    Cb(and(Cb==30+i,and(Rm>=r2,Rm<=r1)),:)=200+i;
end

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;

Beta=((0:Layer)./Layer.*b-b/2)*Ang/Delta;
Num1=size(m1.Vert,1);
switch obj.params.Helix
    case 'Left'
        for i=1:Layer+1
            Matrix=[cos(Beta(i)/180*pi),sin(Beta(i)/180*pi);-sin(Beta(i)/180*pi),cos(Beta(i)/180*pi)];
            mm.Vert(Num1*(i-1)+1:Num1*i,1:2)=(Matrix* mm.Vert(Num1*(i-1)+1:Num1*i,1:2)')';
        end

    case 'Right'
        for i=1:Layer+1
            Matrix=[cos(-Beta(i)/180*pi),sin(-Beta(i)/180*pi);-sin(-Beta(i)/180*pi),cos(-Beta(i)/180*pi)];
            mm.Vert(Num1*(i-1)+1:Num1*i,1:2)=(Matrix* mm.Vert(Num1*(i-1)+1:Num1*i,1:2)')';
        end
end

xx=mm.Vert(:,3)-b/2;
yy=mm.Vert(:,1);
zz=mm.Vert(:,2);
mm.Vert=[xx,yy,zz];
mm.Meshoutput.nodes=mm.Vert;

obj.output.WormSolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end
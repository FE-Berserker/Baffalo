function m1=OutputShellModel(obj,Lsize)
% Output ShellModel of Singlegear
% Author: Xie Yu

rf=obj.output.df/2;
ra=obj.output.da/2;
Z=obj.input.Z;

b=obj.output.GearCurve;

x1=[b.Point.PP{1,1}(1,1);b.Point.PP{2,1}(:,1)]+rf*cos(pi/Z);
y1=[b.Point.PP{1,1}(1,2);b.Point.PP{2,1}(:,2)];

x2=b.Point.PP{3,1}(:,1)+rf*cos(pi/Z);
y2=b.Point.PP{3,1}(:,2);

x3=b.Point.PP{4,1}(:,1)+rf*cos(pi/Z);
y3=b.Point.PP{4,1}(:,2);

gap=rf-obj.input.ID/2;
x4=[rf-gap/3;ra];
y4=[0;0];


x5=[x2(1,1);rf-gap/3];
y5=[y2(1,1);0];

x6=[x1(1,1);(rf-gap/3)*cos(pi/Z)];
y6=[y1(1,1);(rf-gap/3)*sin(pi/Z)];

a=Point2D('PointAss','Echo',0);
a=AddPoint(a,0,0);
a=AddPoint(a,x1,y1);
a=AddPoint(a,x2,y2);
a=AddPoint(a,x3,y3);
a=AddPoint(a,x4,y4);
a=AddPoint(a,x5,y5);
a=AddPoint(a,x6,y6);

b1=Line2D('LineAss','Echo',0);
for i=2:6
    b1=AddCurve(b1,a,i);
end
b1=AddCircle(b1,rf-gap/3,a,1,'sang',0,'ang',180/Z);
b1=AddCurve(b1,a,7);
b1=AddCircle(b1,rf-gap,a,1,'sang',0,'ang',180/Z);

m1=Mesh2D('Mesh1','Echo',0);
m1=MeshQuadPlate(m1,[10,10],[Lsize(1,1)+Lsize(2,1),Lsize(3,1)]);
% Parse node
l1=RebuildCurve(b1,3,Lsize(3,1)+1);
l2=RebuildCurve(b1,2,Lsize(1,1)+1);
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

% Reflect mesh
m1.Face=[m1.Face;[m1.Face(:,4),m1.Face(:,3),m1.Face(:,2),m1.Face(:,1)]+size(m1.Vert,1)];
m1.Vert=[m1.Vert;[m1.Vert(:,1),-m1.Vert(:,2)]];
m1.Cb=[m1.Cb;m1.Cb];

m1=MergeNode(m1);

% Rotate mesh
Face=m1.Face;
Cb=m1.Cb;
Vert=m1.Vert;
Angle=2*pi/Z;
acc=size(m1.Vert,1);
for i=1:obj.params.MeshNTooth-1
    Matrix=[cos(Angle*i),sin(Angle*i);-sin(Angle*i),cos(Angle*i)];
    VV=Matrix*Vert';
    m1.Face=[m1.Face;Face+acc];
    m1.Vert=[m1.Vert;VV'];
    m1.Cb=[m1.Cb;Cb];
    acc=size(m1.Vert,1);
end
m1=MergeNode(m1);

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

% Parse boundary marker

if obj.params.MeshNTooth~=Z
    row1=1;
    row2=row1+Lsize(3,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=105;

    row1=row2+1;
    row2=row2+Lsize(1,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=101;

    row1=row2+1;
    row2=row2+Lsize(2,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=102;

    row1=row2+1;
    row2=row2+Lsize(3,1)+3;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=11;

    row1=row2+Lsize(2,1)+1;
    row2=row2+Lsize(2,1)+1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=103;

    row1=row2+1;
    row2=row2+Lsize(3,1)-1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=105;

    row1=row2+1;
    row2=row2+Lsize(1,1)-1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=103;

    row1=row2+1;
    row2=row2+Lsize(2,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=104;


    if obj.params.MeshNTooth==1
        row1=row2+1;
        row2=row2+Lsize(3,1)+3;
        m1.Meshoutput.boundaryMarker(row1:row2,:)=12;
    else
        for i=2:obj.params.MeshNTooth
            row1=row2+1;
            row2=row2+1;
            m1.Meshoutput.boundaryMarker(row1:row2)=102+10*(i-1);

            row1=row2+1+Lsize(2,1);
            row2=row2+1+Lsize(2,1)+Lsize(3,1);
            m1.Meshoutput.boundaryMarker(row1:row2)=105+10*(i-1);

            row1=row2+1;
            row2=row2+Lsize(1,1);
            m1.Meshoutput.boundaryMarker(row1:row2,:)=101+10*(i-1);

            row1=row2+1;
            row2=row2+Lsize(2,1)-1;
            m1.Meshoutput.boundaryMarker(row1:row2,:)=102+10*(i-1);

            row1=row2+Lsize(2,1)+1;
            row2=row2+Lsize(2,1)+1;
            m1.Meshoutput.boundaryMarker(row1:row2,:)=103+10*(i-1);

            row1=row2+1;
            row2=row2+Lsize(3,1)-1;
            m1.Meshoutput.boundaryMarker(row1:row2,:)=105+10*(i-1);

            row1=row2+1;
            row2=row2+Lsize(1,1)-1;
            m1.Meshoutput.boundaryMarker(row1:row2)=103+10*(i-1);

            row1=row2+1;
            row2=row2+Lsize(2,1);
            m1.Meshoutput.boundaryMarker(row1:row2)=104+10*(i-1);
        end

        row1=row2+1;
        row2=row2+Lsize(3,1)+3;
        m1.Meshoutput.boundaryMarker(row1:row2,:)=12;
    end
else
    row1=1;
    row2=row1+Lsize(3,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=105;

    row1=row2+1;
    row2=row2+Lsize(1,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=101;

    row1=row2+1;
    row2=row2+Lsize(2,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=102;

    row1=row2+Lsize(2,1)+1;
    row2=row2+Lsize(2,1)+1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=1;

    row1=row2+1;
    row2=row2+1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=103;

    row1=row2+1;
    row2=row2+Lsize(3,1)-1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=105;

    row1=row2+1;
    row2=row2+Lsize(1,1)-1;
    m1.Meshoutput.boundaryMarker(row1:row2,:)=103;

    row1=row2+1;
    row2=row2+Lsize(2,1);
    m1.Meshoutput.boundaryMarker(row1:row2,:)=104;


    for i=2:obj.params.MeshNTooth
        row1=row2+1;
        row2=row2+1;
        m1.Meshoutput.boundaryMarker(row1:row2)=102+10*(i-1);

        row1=row2+Lsize(2,1)+1;
        row2=row2+Lsize(2,1)+Lsize(3,1)+1;
        m1.Meshoutput.boundaryMarker(row1:row2)=105+10*(i-1);

        row1=row2+1;
        row2=row2+Lsize(1,1);
        m1.Meshoutput.boundaryMarker(row1:row2,:)=101+10*(i-1);

        row1=row2+1;
        row2=row2+Lsize(2,1)-1;
        m1.Meshoutput.boundaryMarker(row1:row2,:)=102+10*(i-1);



        row1=row2+1+Lsize(2,1);
        row2=row2+1+Lsize(2,1);
        m1.Meshoutput.boundaryMarker(row1:row2,:)=103+10*(i-1);

        row1=row2+1;
        row2=row2+Lsize(3,1)-1;
        m1.Meshoutput.boundaryMarker(row1:row2,:)=105+10*(i-1);

        row1=row2+1;
        row2=row2+Lsize(1,1)-1;
        m1.Meshoutput.boundaryMarker(row1:row2,:)=103+10*(i-1);

        row1=row2+1;
        row2=row2+Lsize(2,1);
        m1.Meshoutput.boundaryMarker(row1:row2,:)=104+10*(i-1);
    end
end

if obj.params.Order==2
    m1 = Convert2Order2(m1);
end

%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh .\n');
end

end
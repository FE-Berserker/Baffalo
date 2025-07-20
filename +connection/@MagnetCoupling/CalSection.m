function obj=CalSection(obj)
% Calculate section of MagnetCoupling
% Author : Xie Yu
MeshNum=obj.params.MeshNum;
Size1=obj.input.InnerMagnetSize;
Size2=obj.input.OuterMagnetSize;
Pos1=obj.params.Pos1;
Pos2=obj.params.Pos2;
R1=obj.input.A/2;
R2=obj.input.B/2-Pos1*Size1(2);
R3=obj.input.C/2+Pos2*Size2(2);
R4=obj.input.D/2;
PairNum=obj.input.Pair;

% Inner magnet
m1=Mesh2D('InnerMagnetBlock','Echo',0);
m1=MeshQuadPlate(m1,Size1,MeshNum);

% Outer magnet
m2=Mesh2D('OuterMagnetBlock','Echo',0);
m2=MeshQuadPlate(m2,Size2,MeshNum);

% Shaft
Angle1=atan(Size1(1)/2/R2)*180/pi;
TempR1=R2/cos(Angle1/180*pi);

a1=Point2D('Point','Echo',0);
a1=AddPoint(a1,0,0);
b1=Line2D('Line1','Echo',0);
b1=AddCircle(b1,R1,a1,1);

P1=[R2,-Size1(1)/2,0;...
    R2-Size1(2)*(1-Pos1),-Size1(1)/2,0;...
    R2-Size1(2)*(1-Pos1),Size1(1)/2,0;...
    R2,Size1(1)/2,0];
T=Transform(P1);
theta=360/PairNum;
T=Rotate(T,0,0,-theta);


b2=Line2D('Line2','Echo',0);

for i=1:PairNum    
    T=Rotate(T,0,0,theta);
    P2=Solve(T);
    a1=AddPoint(a1,P2(1:2,1),P2(1:2,2));
    a1=AddPoint(a1,P2(2:3,1),P2(2:3,2));
    a1=AddPoint(a1,P2(3:4,1),P2(3:4,2));

    b2=AddLine(b2,a1,2+(i-1)*3);
    b2=AddLine(b2,a1,3+(i-1)*3);
    b2=AddLine(b2,a1,4+(i-1)*3);
    b2=AddCircle(b2,TempR1,a1,1,'ang',theta-Angle1*2,'sang',Angle1+theta*(i-1));
end

S1=Surface2D(b2,'Echo',0);
S1=AddHole(S1,b1);

m3=Mesh2D('Shaft','Echo',0);
m3=AddSurface(m3,S1);
m3=SetSize(m3,Size1(1)/4);
m3=Mesh(m3);

% Housing
Angle2=atan(Size2(1)/2/R3)*180/pi;
TempR2=R3/cos(Angle2/180*pi);

a2=Point2D('Point','Echo',0);
a2=AddPoint(a2,0,0);
b3=Line2D('Line3','Echo',0);
b3=AddCircle(b3,R4,a2,1);

P1=[R3,-Size2(1)/2,0;...
    R3+Size2(2)*(1-Pos2),-Size2(1)/2,0;...
    R3+Size2(2)*(1-Pos2),Size2(1)/2,0;...
    R3,Size2(1)/2,0];
T=Transform(P1);
T=Rotate(T,0,0,-theta);

b4=Line2D('Line4','Echo',0);

for i=1:PairNum    
    T=Rotate(T,0,0,theta);
    P2=Solve(T);
    a2=AddPoint(a2,P2(1:2,1),P2(1:2,2));
    a2=AddPoint(a2,P2(2:3,1),P2(2:3,2));
    a2=AddPoint(a2,P2(3:4,1),P2(3:4,2));

    b4=AddLine(b4,a2,2+(i-1)*3);
    b4=AddLine(b4,a2,3+(i-1)*3);
    b4=AddLine(b4,a2,4+(i-1)*3);
    b4=AddCircle(b4,TempR2,a2,1,'ang',theta-Angle2*2,'sang',Angle2+theta*(i-1));
end

S2=Surface2D(b3,'Echo',0);
S2=AddHole(S2,b4);

m4=Mesh2D('Housing','Echo',0);
m4=AddSurface(m4,S2);
m4=SetSize(m4,Size2(1)/4);
m4=Mesh(m4);

% Section
L=Layer(obj.params.Name,'Echo',0);
Dx=obj.params.Dx;
Dy=obj.params.Dy;
Rot=obj.params.Rot;

for i=1:PairNum
    L=AddElement(L,m1,'Transform',[R2*cos(theta*(i-1)/180*pi+Rot/180*pi)+Dx,R2*sin(theta*(i-1)/180*pi+Rot/180*pi)+Dy,0,0,0,90+theta*(i-1)+Rot]);
end

for i=1:PairNum
    L=AddElement(L,m2,'Transform',[R3*cos(theta*(i-1)/180*pi),R3*sin(theta*(i-1)/180*pi),0,0,0,90+theta*(i-1)]);
end
L=AddElement(L,m3,'Transform',[Dx,Dy,0,0,0,Rot]);
L=AddElement(L,m4);

% Parse
obj.output.ShellMesh{1,1}=m1;
obj.output.ShellMesh{2,1}=m2;
obj.output.ShellMesh{3,1}=m3;
obj.output.ShellMesh{4,1}=m4;
obj.output.Section=L;
obj.output.Surface{1,1}=S1;
obj.output.Surface{2,1}=S2;

end
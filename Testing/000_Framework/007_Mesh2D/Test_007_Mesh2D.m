clc
clear
close all
% Test object Mesh2D
% 1 Create gear obj
% 2 Create quad circle
% 3 Create quad plate
% 4 Add Elements
% 5 Convhull
% 6 Convcave1
% 7 Convcave2
% 8 Covert quad to tri
% 9 Mesh 2D Tensor Grid
% 10 Mesh 2D Grid
% 11 Compute MRST G
% 12 Load msh file
% 13 MeshDual
% 14 Plot Dual center and area
% 15 Calculate geometry information
% 16 Plot Mesh2D in paraview
% 17 Plot Mesh2D G and celldata in paraview
% 18 Mesh edge
% 19 Mesh ring
% 20 Mesh edge layer
% 21 Baffalo logo

flag=1;
testMesh2D(flag);
function testMesh2D(flag)
switch flag
    case 1
        a=Point2D('Point Ass1');
        neg=8;
        OR1=2.5;OR2=2;IR=1;
        D_theta=3/180*pi;
        a=AddPoint(a,0,0);
        for i=1:neg
            x1=OR1*cos(pi/neg/2-D_theta-pi/neg*2*(i-1));
            y1=OR1*sin(pi/neg/2-D_theta-pi/neg*2*(i-1));
            x2=OR1*cos(-pi/neg/2+D_theta-pi/neg*2*(i-1));
            y2=OR1*sin(-pi/neg/2+D_theta-pi/neg*2*(i-1));
            x3=OR2*cos(-pi/neg/2-pi/neg*2*(i-1));
            y3=OR2*sin(-pi/neg/2-pi/neg*2*(i-1));
            x4=OR2*cos(-pi/neg/2*3-pi/neg*2*(i-1));
            y4=OR2*sin(-pi/neg/2*3-pi/neg*2*(i-1));
            x5=OR1*cos(pi/neg/2-D_theta-pi/neg*2*i);
            y5=OR1*sin(pi/neg/2-D_theta-pi/neg*2*i);
            xx=[x1;x2];yy=[y1;y2];
            a=AddPoint(a,xx,yy);
            xx=[x2;x3];yy=[y2;y3];
            a=AddPoint(a,xx,yy);
            xx=[x3;x4];yy=[y3;y4];
            a=AddPoint(a,xx,yy);
            xx=[x4;x5];yy=[y4;y5];
            a=AddPoint(a,xx,yy);
        end
        b=Line2D('Line Ass1');
        for i=1:neg
            b=AddLine(b,a,2+(i-1)*4);
            b=AddLine(b,a,3+(i-1)*4);
            b=AddCircle(b,OR2,a,1,'sang',-180/neg/2-180/neg*2*(i-1),'ang',-180/neg);
            b=AddLine(b,a,5+(i-1)*4);
        end

        S=Surface2D(b);
        a1=Point2D('Point Group2');
        a1=AddPoint(a1,0,0);
        h=Line2D('Hole Group1');
        h=AddCircle(h,IR,a1,1);
        S= AddHole(S,h);
        m=Mesh2D('Mesh1');
        m=AddSurface(m,S);
        m=SetSize(m,0.2);
        m=Mesh(m);
        Plot(m);
    case 2
        m=Mesh2D('Mesh1');
        m=MeshQuadCircle(m,'n',4);
        Plot(m);
        m=SmoothFace(m,100);
        Plot(m);

    case 3
        m=Mesh2D('Mesh1');
        m=MeshQuadPlate(m,[10,10]);
        Plot(m);
    case 4
        m=Mesh2D('Mesh1');
        P=[0,0;0,1;1,1;1,0;0,2;1,2];
        m.Vert=P;
        m=AddElements(m,[1,2,3,4;2,5,6,3]);
        Plot(m);
    case 5
        [X,Y]=meshgrid(0:0.1:1);
        points1=[X(:),Y(:)];
        a=Point2D('Point Ass1');
        a=AddPoint(a, points1(:,1), points1(:,2));
        f=@(x,y)(x>0.5 &y>0.2 & y<0.8);
        a=DeletePoint(a,1,'fun',f);
        Plot(a);
        m=Mesh2D('Mesh1');
        m=Convhull(m,a,'keep',0,'simplity',true);
        Plot(m);
    case 6
        [X,Y]=meshgrid(0:0.1:1);
        points1=[X(:),Y(:)];
        a=Point2D('Point Ass1');
        a=AddPoint(a, points1(:,1), points1(:,2));
        logic=points1(:,1)>0.5 & points1(:,2)>0.2 & points1(:,2)<0.8;
        m=Mesh2D('Mesh1');
        m=Convcave(m,a,'logic',logic);
        Plot(m);
    case 7
        points1=rand(100,2);
        a=Point2D('Point Ass1');
        a=AddPoint(a, points1(:,1), points1(:,2));
        logic=points1(:,1)>0.5 & points1(:,2)>0.2 & points1(:,2)<0.8;
        m=Mesh2D('Mesh1');
        m=Convcave(m,a,'logic',logic);
        Plot(m);
    case 8
        m=Mesh2D('Mesh1');
        m=MeshQuadCircle(m,'n',8);
        Plot(m);
        m=Quad2Tri(m);
        Plot(m);
    case 9
        m=Mesh2D('Mesh1');
        dx = 1-0.5*cos((-1:0.1:1)*pi);
        x = -1.15+0.1*cumsum(dx);
        y = 0:0.05:1;
        m=MeshTensorGrid(m,x,sqrt(y));
        Plot(m);
    case 10
        m=Mesh2D('Mesh1');
        nx=6;ny=12;
        lx=6;ly=12;
        m=MeshGrid(m,[nx, ny],[lx,ly],'twist',0.03);
        Plot(m);
        c = m.Vert;
        I = any(c==0,2) | any(c(:,1)==nx,2) | any(c(:,2)==ny,2);
        m.Vert(~I,:) = c(~I,:) + 0.6*rand(sum(~I),2)-0.3;
        Plot(m);
    case 11
        m=Mesh2D('Mesh1');
        nx=30;ny=20;
        lx=30;ly=20;
        m=MeshGrid(m,[nx, ny],[lx,ly],'twist',0.05);
        Plot(m);
        m= ComputeGeometryG(m);
        PlotG(m,'volume',1);
    case 12
        m=Mesh2D('Mesh1');
        m=LoadMsh(m,'airfoil.msh');
        Plot(m);
    case 13
        m=Mesh2D('Mesh1');
        m=LoadMsh(m,'airfoil.msh');
        Plot(m,'xlim',[-0.2,1.1],'ylim',[-0.2,1.1]);
        m=MeshDual(m);
        PlotDual(m,'xlim',[-0.2,1.1],'ylim',[-0.2,1.1]);
    case 14
        m=Mesh2D('Mesh1');
        m=LoadMsh(m,'airfoil.msh');
        m=MeshDual(m);
        [pc,ac]=ComputeGeometryDual(m); %#ok<ASGLU>
        PlotDual(m,'xlim',[-0.2,1.1],'ylim',[-0.2,1.1],'area',1,'center',1);
    case 15
        % Semi circle
        a=Point2D('Circle center');
        a=AddPoint(a,0,0);
        a=AddPoint(a,[-5;5],[0;0]);
        b=Line2D('Semi circle');
        b=AddCircle(b,5,a,1,'ang',180);
        b=AddLine(b,a,2);
        S=Surface2D(b);
        Plot(S);
        m=Mesh2D('Mesh1');
        m=AddSurface(m,S);
        m=SetSize(m,0.5);
        m=Mesh(m);
        Plot(m);
        [Area,Center,Ixx,Iyy,Ixy]= CalculateGeometry(m); %#ok<ASGLU>
    case 16
        m=Mesh2D('Mesh1');
        m=LoadMsh(m,'airfoil.msh');
        Plot2(m);
    case 17
        m=Mesh2D('Mesh1');
        nx=30;ny=20;
        lx=30;ly=20;
        m=MeshGrid(m,[nx, ny],[lx,ly],'twist',0.05);
        m= ComputeGeometryG(m);
        volume=m.G.cells.volumes;
        m=AddCellData(m,volume);
        PlotG2(m);
    case 18
        a=Point2D('Temp');
        a=AddPoint(a,0,0);
        % Add outline
        b1=Line2D('Out');
        b1=AddCircle(b1,14,a,1);
        % Add innerline
        b2=Line2D('Inner');
        b2=AddCircle(b2,5,a,1,'seg',40);
        % Add assembly hole
        h=Line2D('Hole');
        h=AddCircle(h,3.5/2,a,1,'seg',16);

        S=Surface2D(b1);
        S=AddHole(S,b2);

        for i=1:4
            S=AddHole(S,h,'dis',[10*cos(pi/2*(i-1)),10*sin(pi/2*(i-1))]);
        end
        m=Mesh2D('Temp');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m)

        % Mesh edge
        m=MeshEdge(m,2);
        Plot(m)

        m=MeshEdge(m,2);
        Plot(m)

        m=MeshEdge(m,2);
        Plot(m)

        m=MeshEdge(m,2);
        Plot(m)
    case 19
        m1=Mesh2D('Mesh1');
        m1=MeshRing(m1,4,5);
        m2=Mesh2D('Mesh2');
        m2=MeshRing(m2,4,5,'ElementType','tri');
        Plot(m1);
        Plot(m2);
    case 20
        a=Point2D('Temp');
        a=AddPoint(a,0,0);
        % Add outline
        b1=Line2D('Out');
        b1=AddCircle(b1,14,a,1);
        % Add innerline
        b2=Line2D('Inner');
        b2=AddCircle(b2,5,a,1,'seg',40);
        % Add assembly hole
        h=Line2D('Hole');
        h=AddCircle(h,3.5/2,a,1,'seg',16);

        S=Surface2D(b1);
        S=AddHole(S,b2);

        for i=1:4
            S=AddHole(S,h,'dis',[10*cos(pi/2*(i-1)),10*sin(pi/2*(i-1))]);
        end
        m=Mesh2D('Temp');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m)

        % Mesh Layer edge
        m=MeshLayerEdge(m,2,2);
        Plot(m)

        % Mesh Layer edge
        m=MeshLayerEdge(m,3,1);
        Plot(m)
    case 21
        Data=load('Data.mat').Data;
        a=Point2D('Temp');
        a=AddPoint(a,Data(:,1),Data(:,2));
        % Add outline
        b=Line2D('Out');
        b=AddCurve(b,a,1);
        S=Surface2D(b);
        m=Mesh2D('Temp');
        m=AddSurface(m,S);
        m=SetSize(m,20);
        m=Mesh(m);
        Center = CenterCal(m);
        m=AddCellData(m,Center(:,1).^2+Center(:,2).^2);
        Plot2(m)



end
end
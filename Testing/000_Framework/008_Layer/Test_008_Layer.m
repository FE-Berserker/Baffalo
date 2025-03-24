clc
clear
close all
% Test object Layer
% 1 LoftLinear
% 2 Extrude to face
% 3 Helical Line
% 4 Add Mesh
% 5 Add Curve and calculate curvature
% 6 Add thickness of a plate
% 7 Bounding Box
% 8 Sweep loft
% 9 Read STL file
% 10 Read msh file
% 11 Tri to Dual
% 12 Plane Mesh intersections
% 13 Mesh Mesh intersections
% 14 Combine Mesh pair
% 15 Curve to Mesh
% 16 Line Mesh intersections
% 17 Project points to plane
% 18 Project curves to plane
% 19 Line Plane intersections
% 20 Scale
% 21 Add Grid
% 22 Add ShellGrid
% 23 Add Line
flag=8;
testLayer(flag);
function testLayer(flag)
switch flag
    case 1
        %% Bottom verts
        ns=75;
        t=linspace(0,2*pi,ns);
        t=t(1:end-1);
        r=5;
        x=r*cos(t);
        y=r*sin(t);
        a=Point2D('Bottom Verts');
        a=AddPoint(a,x',y');
        Plot(a);
        %% Top verts
        t=linspace(0,2*pi,ns);
        t=t(1:end-1);
        r=6+2.*sin(5*t);
        [x,y] = pol2cart(t,r);
        a1=Point2D('Top Verts');
        a1=AddPoint(a1,x',y');
        Plot(a1);
        %% Layer
        l1=Layer('Layer');
        l1=AddElement(l1,a);
        l1=AddElement(l1,a1,'transform',[6,3,12,0,0,90]);
        Plot(l1);
 
        l1=LoftLinear(l1,1,2,'closeLoopOpt',1,'patchType','tri_slash');
        l1=LoftLinear(l1,1,2,'closeLoopOpt',1,'patchType','tri');
        l1=Move(l1,[20,0,0],'Meshes',1);
        Plot(l1);
    case 2
        %% Creating an example polygon (or sketch)
        ns=150;
        t=linspace(0,2*pi,ns);
        t=t(1:end-1);
        r=6+2.*sin(5*t);
        [x,y] = pol2cart(t,r);
        a=Point2D('Point1');
        a=AddPoint(a,x',y');

        %% Extruding polygon to obtain the surface model
        l1=Layer('Layer1');
        l1=AddElement(l1,a);
        l1=Extrude2Face(l1,1,7,'numSteps',7);
        Plot(l1);
        Plot(l1,'face_normal',1);
    case 3
        %% Creat circle
        a=Point2D('Point');
        a=AddPoint(a,0,0);
        b=Line2D('Line');
        b=AddCircle(b,10,a,1,'seg',80);
        l1=Layer('Layer1');
        l1=AddElement(l1,b);
        Plot(l1);
        l1=Move(l1,[zeros(80,1),zeros(80,1),0.1*(0:79)'],'Lines',1);
        Plot(l1);
        for i=1:9
            l1=Move(l1,[0,0,0.1*80*i],'Lines',1,'new',1);
        end
        Plot(l1);
    case 4
        %% Creat circle
        a=Point2D('Point');
        a=AddPoint(a,0,0);
        b=Line2D('Line');
        b=AddEllipse(b,20,20,a,1,'ang',80);
        mm=Mesh('Shell Mesh');
        mm=Rot2Shell(mm,b,'Slice',72,'Type',2);
        mm=ReverseNormals(mm);
        l1=Layer('Layer1');
        l1=AddElement(l1,mm,'Transform',[0,0,0,-90,0,0]);
        Plot(l1);
        m1=Mesh2D('Mesh1');
        m1=MeshQuadPlate(m1,[50,50]);
        Plot(m1);
        l1=AddElement(l1,m1,'Transform',[0,0,0,-80,0,0]);
        l1=AddElement(l1,m1,'Transform',[0,0,0,-60,0,0]);
        l1=AddElement(l1,m1,'Transform',[0,0,0,-40,0,0]);
        l1=AddElement(l1,m1,'Transform',[0,0,0,-20,0,0]);

%         l1=AddElement(l,m1,'Transform',[0,0,0,-80,0,0]);
%         l1=AddElement(l,m1,'Transform',[0,5,0,-80,0,0]);
%         l1=AddElement(l,m1,'Transform',[0,10,0,-80,0,0]);
%         l1=AddElement(l,m1,'Transform',[0,15,0,-80,0,0]);

%          l1=AddElement(l,m1,'Transform',[0,0,0,0,0,0]);
%          l1=AddElement(l,m1,'Transform',[0,0,5,0,0,0]);
%          l1=AddElement(l,m1,'Transform',[0,0,10,0,0,0]);
%          l1=AddElement(l,m1,'Transform',[0,0,15,0,0,0]);
        Plot(l1);
    case 5
        N = 101;
        theta = linspace(0,pi,N);
        x = sin(2*theta);
        y = cos(4*theta);
        z = cos(6*theta);
        P = [x',y',z'];
        l1=Layer('Layer1');
        l1=AddCurve(l1,P);
        Plot(l1);
        [L,R,K,~] = CalculateCurvature(l1,1);
        figure;
        plot(L,1./R)
        xlabel L
        ylabel R
        title('Curvature vs. cumulative curve length')
        figure;
        h = plot3(P(:,1),P(:,2),P(:,3));
        grid on;
        axis equal
        set(h,'marker','.');
        xlabel x
        ylabel y
        zlabel z
        title('3D curve with curvature vectors')
        hold on
        quiver3(P(:,1),P(:,2),P(:,3),K(:,1),K(:,2),K(:,3));
        hold off
    case 6
        m=Mesh2D('Mesh1');
        m=MeshQuadPlate(m,[10,10],[100,100]);
        l1=Layer('Layer1');
        l1=AddElement(l1,m);
        f=@(x,y,z)and(x>0,y>0);
        l1=AddHeight(l1,1,1,'fun',f);
        f=@(x,y,z)and(x>2,y>2);
        l1=AddHeight(l1,1,1,'fun',f);
        Plot(l1)
    case 7
        points=rand(100,3);
        l1=Layer('Layer1');
        l1=AddPoint(l1,points);
        l1=BoundingBox(l1,1);
        Plot(l1,'face_alpha',0.3);
    case 8
        %% Load data as structure
        dataStruct=load('Concannon_aorta_segmentation.mat');
        %Define smoothing Parameters
        pointSpacing=1.7;
        smoothFactorCentreLine=0.01; %Cubic smooth spline parameter [0-1] use empty to turn off
        smoothFactorSegments=0.01; %Cubic smooth spline parameter [0-1], 0=straight line, 1=cubic
        %% Access data structure components
        V_cent=dataStruct.Cent; %Centroid list
        segmentCell=dataStruct.Points; %Lumen boundary coordinates
        %Define thickness information
        dataStruct.WallThickness=[1.425	0.9	1	1.025	0.833333333	0.891666667	0.95	0.975	0.9	0.825];
        wallThickness=dataStruct.WallThickness; %Raw data for wall thickness as a function of location

        %% Resampling aorta section contours
        %Resample boundary points so each plane has same number of points for lofting
        %Find number of points to use based on biggest circumference
        d=zeros(size(segmentCell,2),1);
        SegNum=size(segmentCell,2);
        l1=Layer('Layer1');% Original Curve

        for indNow=1:1:SegNum
            l1=AddCurve(l1,segmentCell{1,indNow}');
            [Length,~,~,~] = CalculateCurvature(l1,indNow);
            d(indNow)=max(Length);
        end
        nSegment=round(max(d)/pointSpacing);
        %Resample
        segmentCellSmooth=segmentCell;
        segmentCellMean=segmentCell;
        w=ones(size(V_cent,1),1); %Cubic smoothing spline weights
        indexPlanePoints_V_cent=zeros(1,size(segmentCell,2)); %Indices of centre line points at sections

        for indNow=1:1:SegNum
            %Resample section contour
            l1=RebuildCurve(l1,indNow,nSegment,'interpPar',smoothFactorSegments,'closeLoopOpt',1);
            Num=GetNLines(l1);
            Vs_1_mean=mean(l1.Lines{Num,1}.P,1);
            segmentCellSmooth{1,indNow}=l1.Lines{Num,1}.P';
            segmentCellMean{1,indNow}=Vs_1_mean;
            %Prepare for center line smoothing by setting weight vector
            [~,indVertex_1]=min(sqrt(sum((V_cent-Vs_1_mean(ones(size(V_cent,1),1),:)).^2,2))); %Index closest to section
            w(indVertex_1)=1e9; %Heigh weight at contour sections
            indexPlanePoints_V_cent(indNow)=indVertex_1; %Store index of closets
        end
        %% Smooth center line
        %Fit smoothing spline through centreline points for loft
        l2=Layer('Layer2');
        if ~isempty(smoothFactorCentreLine)
            V_cent_original=V_cent;
            l2=AddCurve(l2,V_cent_original);
            [d,~,~,~] = CalculateCurvature(l2,1);
            V_cent = csaps(d,V_cent_original',smoothFactorCentreLine,d,w)'; %Smoothed
            l2=AddPoint(l2,V_cent);
            l2=AddPoint(l2,V_cent(w==max(w),:));
            Plot(l2)
        end
        %% Offsetting section curves outward if thickening is inward
        for q=1:SegNum
            l1=CurveOffset(l1,SegNum+q,wallThickness(q));
            Num=GetNLines(l1);
            segmentCellSmooth{1,q}=l1.Lines{Num,1}.P';
        end
        %% Visualize offset curves
        Plot(l1,'lineson',1,'group',(SegNum+1:SegNum*3)')
        %% Perform main trunk loft
        % Initialize figure with center line
        l1=AddCurve(l1,V_cent);
        controlParameter.n=100;
        controlParameter.Method='HC';
        l1=SweepLoft(l1,(SegNum*2+1:SegNum*3)',GetNLines(l1),'PointSpacing',pointSpacing,'Smooth',controlParameter);
        Plot(l1,'Lineson',0)
    case 9
        l1=Layer('Layer1');
        l1=STLRead(l1,'femur_binary.stl');
        Plot(l1);
        l2=Layer('Layer2');
        l2=STLRead(l2,'sphere_ascii.stl');
%         STLRead(l2,'pallet_montado.stl');
        Plot(l2);
    case 10
        l1=Layer('Layer1');
        l1=LoadMsh(l1,'bunny.msh');
        Plot(l1)
    case 11
        l1=Layer('Layer1');
        l1=LoadMsh(l1,'bunny.msh');
        l1=Tri2Dual(l1,1);
        Plot(l1,'mesheson',0);

        m=Mesh2D('Mesh1');
        m=LoadMsh(m,'airfoil.msh');
        m=MeshDual(m);
        l1=AddElement(l1,m);
        l1=LoadMsh(l1,'thinker.msh');
        l1=Tri2Dual(l1,3);
        Plot(l1,'mesheson',0,'xlim',[-0.5,1],'ylim',[-1,1]);
    case 12
        %Sphere parameters
        numRefineStepsSphere=3;
        sphereRadius=2;
        mm=Mesh('Demo Sphere Mesh');
        mm=MeshSphere(mm,numRefineStepsSphere,sphereRadius);
        mm=Mesh3D(mm);
        l1=Layer('Layer1');
        l1=AddElement(l1,mm);
        
        pos=[0,0,0];
        vec=[1,1,1];
        l1=AddPlane(l1,pos,vec);
        l1=IntersectPlaneMesh(l1,1,1);
        Plot(l1,'face_alpha',0.2,'planescale',3);
    case 13
        %Sphere parameters
        numRefineStepsSphere=3;
        sphereRadius=2;
        mm=Mesh('Demo Sphere Mesh');
        mm=MeshSphere(mm,numRefineStepsSphere,sphereRadius);
        mm=Mesh3D(mm);
        l1=Layer('Layer1');
        l1=AddElement(l1,mm);
        l1=AddElement(l1,mm,'Transform',[2,0,0,0,0,0]);
        Plot(l1)
        [Slice,~,~]=IntersectMeshMesh(l1,1,2);
        Plot(l1,'face_alpha',0.1);
        Plot(Slice);
    case 14
        %Sphere parameters
        numRefineStepsSphere=3;
        sphereRadius=2;
        mm=Mesh('Demo Sphere Mesh');
        mm=MeshSphere(mm,numRefineStepsSphere,sphereRadius);
        mm=Mesh3D(mm);
        l1=Layer('Layer1');
        l1=AddElement(l1,mm);
        l1=AddElement(l1,mm,'Transform',[2,0,0,0,0,0]);
        [~,m1,m2]=IntersectMeshMesh(l1,1,2);
        m1=KeepGroup(m1,1);
        m2=KeepGroup(m2,2);
        PlotFace(m1);
        PlotFace(m2);
        l2=Layer('Layer2');
        l2=AddElement(l2,m1);AddElement(l2,m2);
        Plot(l2);
        l2=CombineMeshPair(l2,1,2,'reverse',1);
        l2=Move(l2,[10,0,0],'Meshes',3);
        Plot(l2);
        l2=CombineMeshPair(l2,1,2,'remesh',0.2,'reverse',1);
        l2=Move(l2,[20,0,0],'Meshes',4);
        Plot(l2);
        l2=Tri2Dual(l2,4);
        l2=Move(l2,[10,0,0],'Duals',1);
        Plot(l2);
    case 15
        %% Constants
        % number of vertices of trefoil curve
        nPoints = 200;
        % thickness of the 3D mesh
        thickness = .5;
        % number of corners around each curve vertex
        nCorners = 16;
        %% Create trefoil curve
        % parameterisation variable
        t = linspace(0, 2*pi, nPoints + 1);
        t(end) = [];
        % trefoil curve coordinates
        curve(:,1) = sin(t) + 2 * sin(2 * t);
        curve(:,2) = cos(t) - 2 * cos(2 * t);
        curve(:,3) = -sin(3 * t);
        l1=Layer('Layer1');
        l1=AddCurve(l1,curve);
        Plot(l1);
        l1=Curve2Mesh(l1,1,thickness,nCorners);
        Plot(l1);
    case 16
        % Sphere Mesh
        numRefineStepsSphere=3;
        sphereRadius=2;
        mm=Mesh('Demo Sphere Mesh');
        mm=MeshSphere(mm,numRefineStepsSphere,sphereRadius);
        mm=Mesh3D(mm);
        l1=Layer('Layer1');
        l1=AddElement(l1,mm);
        Plot(l1);
        % Curve
        curve(:,1)=[-10;-1;1;10];
        curve(:,2)=[-10;-1;1;10];
        curve(:,3)=[-10;-1;1;10];
        l1=AddCurve(l1,curve);
        t = linspace(-2*pi, 2*pi, 200);
        curve1(:,1) = t';
        curve1(:,2)=sin(t');
        curve1(:,3)=zeros(200,1);
        l1=AddCurve(l1,curve1);
        Plot(l1);
        l1=IntersectCurveMesh(l1,[1;2],1);
        Plot(l1,'face_alpha',0.1,'edge_alpha',0.1);
    case 17
        l1=Layer('Layer1');
        pos=[0,0,0];
        vec=[1,0,0];
        l1=AddPlane(l1,pos,vec);
        pos=[0,0,0];
        vec=[1,1,0];
        l1=AddPlane(l1,pos,vec);
        P=-5+10*rand(10,3);
        l1=AddPoint(l1,P);
        Plot(l1,'planescale',5);
        l1=ProjectPointPlane(l1,1,1);
        l1=ProjectPointPlane(l1,1,2);
        Plot(l1,'planescale',5);
    case 18
        l1=Layer('Layer1');
        pos=[0,0,0];
        vec=[1,0,1];
        l1=AddPlane(l1,pos,vec);
        pos=[0,0,0];
        vec=[1,1,1];
        l1=AddPlane(l1,pos,vec);
        t = linspace(-2*pi, 2*pi, 200);
        curve1(:,1) = t';
        curve1(:,2)=sin(t');
        curve1(:,3)=zeros(200,1);
        l1=AddCurve(l1,curve1);
        Plot(l1,'planescale',5);
        l1=ProjectCurvePlane(l1,1,1);
        l1=ProjectCurvePlane(l1,1,2);
        Plot(l1,'planescale',5);
    case 19
        l1=Layer('Layer1');
        pos=[0,0,0];
        vec=[1,0,1];
        l1=AddPlane(l1,pos,vec);
        pos=[1,0,0];
        vec=[1,1,1];
        l1=AddPlane(l1,pos,vec);
        t = linspace(-2*pi, 2*pi, 200);
        curve1(:,1) = t';
        curve1(:,2)=sin(t');
        curve1(:,3)=zeros(200,1);
        l1=AddCurve(l1,curve1);
        Plot(l1,'planescale',5);
        l1=IntersectCurvePlane(l1,1,1);
        l1=IntersectCurvePlane(l1,1,2);
        Plot(l1,'planescale',5);
    case 20
        l1=Layer('Layer1');
        l1=LoadMsh(l1,'bunny.msh');
        Plot(l1);
        l1=Scale(l1,0.5,'Meshes',1,'new',1);
        Plot(l1,'face_alpha',0.5);
    case 21
        l1=Layer('Layer1');
        l1=AddGrid(l1,1000,1000,7,8);
        Plot(l1);
        l2=Layer('Layer2');
        l2=AddGrid(l2,1000,1000,7,8,'Type',2);
        Plot(l2);
        l3=Layer('Layer3');
        l3=AddGrid(l3,1000,1000,7,8,'Type',4);
        Plot(l3);
    case 22
        l1=Layer('Layer1');
        l1=AddShellGrid(l1,6800,30000,24,6);
        Plot(l1);
        l2=Layer('Layer2');
        l2=AddShellGrid(l2,6800,30000,24,6,'Type',2);
        Plot(l2);
        l3=Layer('Layer3');
        l3=AddShellGrid(l3,6800,30000,24,6,'Type',3);
        Plot(l3);
        l4=Layer('Layer4');
        l4=AddShellGrid(l4,6800,30000,6,6,'Type',4);
        Plot(l4);
    case 23
        %% AddLine
        a=Point('Point Ass1');
        a=AddPoint(a,[0;5],[0;4],[0;2]);
        b=Line('Line Ass1');
        b=AddLine(b,a,1);
        %% AddCurve
        P = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5;
            0.0 0.0 0.0 0.0 0.0 0.0 0.0];
        a=AddPoint(a,P(1,:)',P(2,:)',P(3,:)');
        b=AddCurve(b,a,2);
        %% AddCircle
        a=AddPoint(a,0,0,5);
        b=AddCircle(b,2.5,a,3);
        b=AddCircle(b,3,a,3,'rot',[45,45,45]);
        %% AddEllipse
        b=AddEllipse(b,6,3,a,3,'rot',[0,-90,0],'sang',-90,'ang',180);
        Plot(b,'clabel',1,'styles',{'-'});
        l1=Layer('Layer1');
        l1=AddElement(l1,b);
        Plot(l1);
end
end      
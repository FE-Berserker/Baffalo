%% Automated Test Runner for Mesh
% This script runs all 35 test cases for Mesh and generates a test report

clc
clear
close all

% Add framework to path
addpath(genpath('../../dep/framework'));

% Test configuration
total_tests = 35;
results = struct('id', [], 'name', [], 'status', [], 'time', [], 'error', []);
report_path = 'Test_Report_Mesh.txt';

fprintf('========================================\n');
fprintf('Mesh Test Suite\n');
fprintf('========================================\n\n');

% Run all tests
for test_id = 1:total_tests
    fprintf('[Test %d/%d] Running test case %d...\n', test_id, total_tests, test_id);

    % Get test name from Test_009_Mesh.m
    test_name = getTestName(test_id);
    fprintf('  Name: %s\n', test_name);

    % Close all figures before each test
    close all;

    try
        % Record start time
        tic;

        % Run the test
        runTest(test_id);

        % Record elapsed time
        elapsed = toc;

        % Test passed
        results(test_id).id = test_id;
        results(test_id).name = test_name;
        results(test_id).status = 'PASSED';
        results(test_id).time = elapsed;
        results(test_id).error = '';

        fprintf('  Status: PASSED\n');
        fprintf('  Time: %.3f seconds\n', elapsed);

    catch ME
        % Test failed
        elapsed = toc;

        results(test_id).id = test_id;
        results(test_id).name = test_name;
        results(test_id).status = 'FAILED';
        results(test_id).time = elapsed;
        results(test_id).error = ME.message;

        fprintf('  Status: FAILED\n');
        fprintf('  Time: %.3f seconds\n', elapsed);
        fprintf('  Error: %s\n', ME.message);
    end

    fprintf('\n');
end

% Generate summary
fprintf('========================================\n');
fprintf('Test Summary\n');
fprintf('========================================\n');

passed_count = sum(strcmp({results.status}, 'PASSED'));
failed_count = sum(strcmp({results.status}, 'FAILED'));
total_time = sum([results.time]);

fprintf('Total Tests: %d\n', total_tests);
fprintf('Passed: %d\n', passed_count);
fprintf('Failed: %d\n', failed_count);
fprintf('Success Rate: %.2f%%\n', passed_count/total_tests*100);
fprintf('Total Time: %.3f seconds\n', total_time);
fprintf('\n');

% Write detailed report to file
writeReport(report_path, results, passed_count, failed_count, total_time);

fprintf('Report saved to: %s\n', report_path);

%% Helper Functions
function name = getTestName(id)
    % Get test name based on ID
    names = {
        'Create cube mesh';
        'Create cylinder mesh';
        'Create sphere mesh';
        'Hex20 Plot';
        'MeshHemiSphere';
        'Mesh plate1';
        'Mesh plate2';
        'Mesh TriplyPeriodicMinimalSurface';
        'Mesh StochasticMicroStructure';
        'Mesh Spinodoid';
        'Group Test';
        'Remesh';
        'Drill holes';
        'MeshQuadSphere';
        'Mesh TensorGrid';
        'PlotG';
        'Simple sculpture Mesh';
        'Check G center inner mesh';
        'MeshOctahedron';
        'Image read';
        'Plot Face in ParaView';
        'Plot Element in ParaView';
        'Plot G and cell data in ParaView';
        'Tri3 to voronoi';
        'Nurb4Surf';
        'Nurb Surface';
        'NurbRuled';
        'Extrude2Solid';
        'Rotate to shell';
        'Drill through holes';
        'Mesh prism';
        'Mesh Geosphere';
        'Mesh pyramid';
        'Add internal points';
        'Input STP file'
    };
    if id >= 1 && id <= length(names)
        name = names{id};
    else
        name = 'Unknown Test';
    end
end

function runTest(flag)
    % Extract test code from Test_009_Mesh.m and run it
    % Read the test file
    fid = fopen('Test_009_Mesh.m', 'r');
    content = fread(fid, '*char')';
    fclose(fid);

    % Find the test code for the specific flag
    pattern = sprintf('case %d', flag);
    start_pos = strfind(content, pattern);

    if isempty(start_pos)
        error('Test case %d not found', flag);
    end

    % Execute the test code (wrapped in try-catch for specific test)
    testMesh(flag);
end

function testMesh(flag)
    % Test function from Test_009_Mesh.m
    switch flag
        case 1
            %% Specifying dimensions and number of elements
            m=Mesh('Mesh');
            %% Create a box with hexahedral elements
            cubeDimensions=[10 10 10]; %Dimensions
            cubeElementNumbers=[5 5 5]; %Number of elements
            m=MeshCube(m,cubeDimensions,cubeElementNumbers);
            %% Plot elements
            PlotFace(m,'face_alpha',1);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(m,'section',sec);
            sec.vec=[1,1,-1];
            PlotElement(m,'section',sec);
        case 2
            %Specifying dimensions and number of elements
            mm=Mesh('Cylinder Mesh');
            mm=MeshCylinder(mm,1,30,50,'ElementType','quad');
            PlotFace(mm);
            % The cyclinder is meshed using tetrahedral elements using tetgen
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            PlotElement(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 3
            %Sphere parameters
            numRefineStepsSphere=3;
            sphereRadius=2;

            mm=Mesh('Demo Sphere Mesh');
            mm=MeshSphere(mm,numRefineStepsSphere,sphereRadius);
            PlotFace(mm);

            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 4
            %% Specifying dimensions and number of elements
            m=Mesh('Mesh');
            %% Create a box with hexahedral elements
            beamDimensions=[10 40 10]; %Dimensions
            beamElementNumbers=[4 20 4]; %Number of elements
            m=MeshCube(m,beamDimensions,beamElementNumbers,'ElementType','hex20');
            PlotFace(m,'marker',1);
            PlotFace2(m);
        case 5
            %Control settings
            sphereRadius=1;
            numElementsMantel=6;
            m=Mesh('Mesh');
            m=MeshHemiSphere(m,sphereRadius, numElementsMantel);
            PlotFace(m);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(m,'section',sec);
        case 6
            %         IR=211/2;
            %         OR=801/2;
            %         radius1=300/2;
            %         radius2=600/2;
            %         num=6;
            %         par1=100;
            %         Thickness=15;
            IR=80/2;
            OR=650/2;
            radius1=420/2;
            radius2=520/2;
            num=6;
            par1=100;
            Thickness=20;
            ang1=360/num-asin(par1/2/radius1)/pi*180*2;
            ang2=360/num-asin(par1/2/radius2)/pi*180*2;

            a=Point2D('Point Ass1');
            b=Line2D('Line Ass1');
            a=AddPoint(a,0,0);
            a=AddPoint(a,par1,0);
            a=AddPoint(a,[radius1*cos(ang1/2/180*pi);radius2*cos(ang2/2/180*pi)],...
                [radius1*sin(ang1/2/180*pi);radius2*sin(ang2/2/180*pi)]);
            a=AddPoint(a,[radius2*cos(-ang2/2/180*pi);radius1*cos(-ang1/2/180*pi)],...
                [radius2*sin(-ang2/2/180*pi);radius1*sin(-ang1/2/180*pi)]);
            b=AddCircle(b,OR,a,1);
            S=Surface2D(b);

            h1=Line2D('Hole Group1');
            h1=AddCircle(h1,IR,a,1);
            S=AddHole(S,h1);

            h2=Line2D('Hole Group2','Dtol',0.1);
            h2=AddCircle(h2,radius1,a,1,'sang',-ang1/2,'ang',ang1);
            h2=AddLine(h2,a,3);
            h2=AddCircle(h2,radius2,a,1,'sang',ang2/2,'ang',-ang2);
            h2=AddLine(h2,a,4);
            h2=CreateRadius(h2,1,10);
            h2=CreateRadius(h2,3,10);
            h2=CreateRadius(h2,5,10);
            h2=CreateRadius(h2,7,10);

            for i=1:num
                S=AddHole(S,h2,'rot',360/num*(i-1));
            end
            m=Mesh2D('Mesh1');
            m=AddSurface(m,S);
            m=SetSize(m,20);
            m=Mesh(m);
            Plot(m);
            mm=Mesh('Mesh');
            mm=Extrude2Solid(mm,m,Thickness,3);
            PlotFace(mm);
        case 7
            % Parameter
            IR=640/2;
            OR=768/2;
            par=442;
            radius=70;
            R=116/2;
            num=6;
            Rp=460;
            t=30;
            hd=17.5;

            sang=asin(R/OR)/pi*180;
            ang=360/num-2*sang;
            a=Point2D('Point Ass1');
            b=Line2D('Line Ass1','Dtol',1);
            a=AddPoint(a,0,0);

            for i=1:num
                b=AddCircle(b,OR,a,1,'sang',sang+ang-360/num*(i-1),'ang',-ang);
                theta=-360/num/180*pi*(i-1);
                mat=[cos(theta),-sin(theta);sin(theta),cos(theta)];
                p1=mat*[sqrt(OR^2-R^2),par;R,R];
                p1=p1';
                a=AddPoint(a,p1(:,1),p1(:,2));
                b=AddLine(b,a,2+3*(i-1));
                p2=mat*[par;0];
                p2=p2';
                a=AddPoint(a,p2(1,1),p2(1,2));
                b=AddCircle(b,R,a,3+3*(i-1),'sang',90+theta/pi*180,'ang',-180);
                p3=mat*[par,sqrt(OR^2-R^2);-R,-R];
                p3=p3';
                a=AddPoint(a,p3(:,1),p3(:,2));
                b=AddLine(b,a,4+3*(i-1));
            end
            for i=1:num
                b=CreateRadius(b,1+6*(i-1),radius);
                b=CreateRadius(b,5+6*(i-1),radius);
            end

            Plot(b,'clabel',1,'equal',1)
            S=Surface2D(b);

            h1=Line2D('Hole Group1');
            h1=AddCircle(h1,IR,a,1);
            S=AddHole(S,h1);

            a1=Point2D('Point Ass2');
            a1=AddPoint(a1,Rp,0);
            h2=Line2D('Hole Group2');
            h2=AddCircle(h2,hd/2,a1,1);
            for i=1:num
                S=AddHole(S,h2,'rot',360/num*(i-1));
            end

            m=Mesh2D('Mesh1');
            m=AddSurface(m,S);
            m=SetSize(m,20);
            m=Mesh(m);
            Plot(m);
            mm=Mesh('Mesh');
            mm=Extrude2Solid(mm,m,t,3);
            PlotFace(mm);
        case 8
            %Gyroid
            Length=10; % Length of the sample
            mm=Mesh('Demo Gyroid Mesh');
            mm=MeshTriplyPeriodicMinimalSurface(mm,Length);
            PlotFace(mm);
        case 9
            %Stochastic structure
            Length=10; % Length of the sample
            paticleLength=1;
            mm=Mesh('Demo Stochastic structure Mesh');
            mm=MeshStochasticMicroStructure(mm,Length,paticleLength);
            PlotFace(mm);
        case 10
            %spinodoid
            Length=10; % Length of the sample
            paticleLength=1;
            mm=Mesh('Demo spinodoid Mesh');
            mm=MeshSpinodoid(mm,Length,paticleLength);
            PlotFace(mm);
        case 11
            %Stochastic structure
            Length=10; % Length of the sample
            paticleLength=1;
            mm=Mesh('Demo Stochastic structure Mesh');
            mm=MeshStochasticMicroStructure(mm,Length,paticleLength);
            PlotFace(mm);
            [G,~]=GroupTest(mm);
            disp(G);
            mm=KeepGroup(mm,1);
            PlotFace(mm);
        case 12
            %Gyroid
            Length=10; % Length of the sample
            mm=Mesh('Demo Gyroid Mesh');
            mm=MeshTriplyPeriodicMinimalSurface(mm,Length);
            PlotFace(mm);
            mm=Remesh(mm,0.5);
            PlotFace(mm);
        case 13
            % Derive patch data for a cylinder
            mm=Mesh('Cylinder Mesh');
            mm=MeshCylinder(mm,3,30,50);
            PlotFace(mm);
            % The cyclinder is meshed using tetrahedral elements using tetgen
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
            mm=DrillHole(mm,[10;5],[10;15],[0,0],3,'type',5,'slice',8);
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            PlotFace(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 14
            %Sphere parameters
            numRefineStepsSphere=4;
            sphereRadius=4;
            mm=Mesh('Demo Quad Sphere Mesh');
            mm=MeshQuadSphere(mm,numRefineStepsSphere,sphereRadius);
            PlotFace(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
            mm1=Mesh('Demo Quad hollow Sphere Mesh');
            mm1=MeshQuadSphere(mm1,numRefineStepsSphere,sphereRadius,'hollow',1,'coreRadius',sphereRadius/4);
            PlotFace(mm1);
            PlotElement(mm1,'section',sec);
        case 15
            x = linspace(-2,2,21);
            mm=Mesh('Demo TensorGrid');
            mm=MeshTensorGrid(mm,x,x,x);
            PlotFace(mm);
            mm= ComputeGeometryG(mm);
            c = mm.G.cells.centroids;
            r = c(:,1).^2 + 0.25*c(:,2).^2+0.25*c(:,3).^2;
            mm = RemoveCells(mm, r>1);
            PlotFace(mm);
        case 16
            x=-1:0.05:1;
            xx=x-1/2/pi.*sin(pi.*x);
            yy=-1:0.05:1;
            zz=-1:0.05:1;
            mm=Mesh('Demo TensorGrid');
            mm=MeshTensorGrid(mm,xx,yy,zz);
            PlotFace(mm);
            mm= ComputeGeometryG(mm);
            PlotG(mm,'volume',1);
        case 17
            x = linspace(-2,2,21);
            mm=Mesh('Demo TensorGrid');
            mm=MeshTensorGrid(mm,x,x,x);
            PlotFace(mm);
            mm= ComputeGeometryG(mm);
            c = mm.G.cells.centroids;
            r = c(:,1).^2 + 0.25*c(:,2).^2+0.25*c(:,3).^2;
            mm = RemoveCells(mm, r>1);
            PlotFace(mm);
            mm=Remesh(mm,0.2);
            PlotFace(mm);
            mm= Smoothface(mm,10);
            mm=Mesh3D(mm);
            PlotFace(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 18
            % Original geometry
            x = linspace(-400,400,200);
            y=linspace(-400,400,200);
            z=linspace(-10,30,40);

            mm=Mesh('Demo TensorGrid');
            mm=MeshTensorGrid(mm,x,y,z);
            mm= ComputeGeometryG(mm);
            PlotFace(mm);

            % Plate
            IR=80/2;
            OR=650/2;
            radius1=420/2;
            radius2=520/2;
            num=6;
            par1=100;
            Thickness=20;
            ang1=360/num-asin(par1/2/radius1)/pi*180*2;
            ang2=360/num-asin(par1/2/radius2)/pi*180*2;

            a=Point2D('Point Ass1');
            b=Line2D('Line Ass1');
            a=AddPoint(a,0,0);
            a=AddPoint(a,par1,0);
            a=AddPoint(a,[radius1*cos(ang1/2/180*pi);radius2*cos(ang2/2/180*pi)],...
                [radius1*sin(ang1/2/180*pi);radius2*sin(ang2/2/180*pi)]);
            a=AddPoint(a,[radius2*cos(-ang2/2/180*pi);radius1*cos(-ang1/2/180*pi)],...
                [radius2*sin(-ang2/2/180*pi);radius1*sin(-ang1/2/180*pi)]);
            b=AddCircle(b,OR,a,1);
            S=Surface2D(b);

            h1=Line2D('Hole Group1');
            h1=AddCircle(h1,IR,a,1);
            S=AddHole(S,h1);

            h2=Line2D('Hole Group2','Dtol',0.1);
            h2=AddCircle(h2,radius1,a,1,'sang',-ang1/2,'ang',ang1);
            h2=AddLine(h2,a,3);
            h2=AddCircle(h2,radius2,a,1,'sang',ang2/2,'ang',-ang2);
            h2=AddLine(h2,a,4);
            h2=CreateRadius(h2,1,10);
            h2=CreateRadius(h2,3,10);
            h2=CreateRadius(h2,5,10);
            h2=CreateRadius(h2,7,10);

            for i=1:num
                S=AddHole(S,h2,'rot',360/num*(i-1));
            end
            m=Mesh2D('Mesh1');
            m=AddSurface(m,S);
            m=SetSize(m,20);
            m=Mesh(m);
            Plot(m);
            mm1=Mesh('Mesh');
            mm1=Extrude2Solid(mm1,m,Thickness,3);
            PlotFace(mm1);
            % Check inner
            in = IsInMesh(mm,mm1);
            mm = RemoveCells(mm,~in);
            PlotFace(mm);
            mm=Remesh(mm,10);
            PlotFace(mm);
            mm= Smoothface(mm,10);
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            PlotFace(mm);
            mm=Remesh(mm,10);
            PlotFace(mm);
        case 19
            dimension=[2,2,2];
            mm1=Mesh('Mesh');
            mm1=MeshOctahedron(mm1,dimension);
            PlotFace(mm1);
        case 20
            hw=logical(imread('helloworld.png'));
            imshow(hw);
            m=Mesh2D('Mesh1');
            nx=size(hw,2);ny=size(hw,1);
            lx=size(hw,2)-1;ly=size(hw,1)-1;
            m=MeshGrid(m,[nx, ny],[lx,ly]);
            m= ComputeGeometryG(m);
            PlotG(m);
            m = RemoveCells(m,fliplr(hw'));
            m = Quad2Tri(m);
            PlotG(m);
            mm=Mesh('Demo Hello World');
            mm=Extrude2Solid(mm,m,10,3);
            mm=Remesh(mm,5);
            PlotFace(mm);
        case 21
            %% Specifying dimensions and number of elements
            m=Mesh('Mesh');
            %% Create a box with hexahedral elements
            cubeDimensions=[10 10 10]; %Dimensions
            cubeElementNumbers=[5 5 5]; %Number of elements
            m=MeshCube(m,cubeDimensions,cubeElementNumbers);
            %% Plot Face
            PlotFace2(m);
        case 22
            %% Specifying dimensions and number of elements
            m=Mesh('Mesh');
            %% Create a box with hexahedral elements
            cubeDimensions=[10 10 10]; %Dimensions
            cubeElementNumbers=[5 5 5]; %Number of elements
            m=MeshCube(m,cubeDimensions,cubeElementNumbers);
            %% Plot Element
            PlotElement2(m)
        case 23
            x=-1:0.05:1;
            xx=x-1/2/pi.*sin(pi.*x);
            yy=-1:0.05:1;
            zz=-1:0.05:1;
            mm=Mesh('Demo TensorGrid');
            mm=MeshTensorGrid(mm,xx,yy,zz);
            PlotFace(mm);
            mm= ComputeGeometryG(mm);
            mm=AddCellData(mm,mm.G.cells.volumes);
            PlotG2(mm);
        case 24
            %Specifying dimensions and number of elements
            mm=Mesh('Cylinder Mesh');
            mm=MeshCylinder(mm,5,30,50);
            PlotFace(mm);
            % The cyclinder is meshed using tetrahedral elements using tetgen
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            mm=Tri2Voronoi(mm);
            mm=AddPointData(mm,mm.Voronoi.Nodes(:,2));
            PlotVoronoi(mm);
            PlotVoronoi2(mm);
        case 25
            % Define 4 corner points of surface
            mm=Mesh('Nurb surface');
            Points=[0,0,0.5;1,0,-0.5;0,1,-0.5;1,1,0.5];
            mm = Nurb4Surf(mm,Points,'subd',[11,10]);
            PlotFace(mm);
        case 26
            % allocate multi-dimensional array of control points
            pnts = zeros(3,5,5);

            % define a grid of control points
            % in this case a regular grid of u,v points
            % pnts(3,u,v)
            %
            pnts(:,:,1) = [ 0.0  3.0  5.0  8.0 10.0;
                0.0  0.0  0.0  0.0  0.0;
                2.0  2.0  7.0  7.0  8.0];
            pnts(:,:,2) = [ 0.0  3.0  5.0  8.0 10.0;
                3.0  3.0  3.0  3.0  3.0;
                0.0  0.0  5.0  5.0  7.0];
            pnts(:,:,3) = [ 0.0  3.0  5.0  8.0 10.0;
                5.0  5.0  5.0  5.0  5.0;
                0.0  0.0  5.0  5.0  7.0];
            pnts(:,:,4) = [ 0.0  3.0  5.0  8.0 10.0;
                8.0  8.0  8.0  8.0  8.0;
                5.0  5.0  8.0  8.0 10.0];
            pnts(:,:,5) = [ 0.0  3.0  5.0  8.0 10.0;
                10.0 10.0 10.0 10.0 10.0;
                5.0  5.0  8.0  8.0 10.0];

            % knots
            knots{1} = [0 0 0 1/3 2/3 1 1 1]; % knots along u
            knots{2} = [0 0 0 1/3 2/3 1 1 1]; % knots along v
            mm=Mesh('Nurb surface');
            mm = NurbSurf(mm,pnts,knots);
            PlotFace(mm);
        case 27
            coefs = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
                3.0 5.5 5.5 1.5 1.5 4.0 4.5;
                0.0 0.0 0.0 0.0 0.0 0.0 0.0]';
            knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
            b=Line('Line Ass1');
            b=AddNurb(b,coefs,knots);
            b=Move(b,1,[0,0,5],'new',1);
            b=Scale(b,2,[0.5,0.5,1]);
            mm=Mesh('Nurb surface');
            mm = NurbRuled(mm,b,1,2);
            PlotFace(mm);
        case 28
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

            % Mesh Layer edge
            for i=3:6
                m=MeshLayerEdge(m,2,1);
            end
            Plot(m)

            mm=Mesh('Mesh1');
            mm=Extrude2Solid(mm,m,-10,6);
            PlotFace(mm);
            mm=Extrude2Solid(mm,m,10,6,'Cb',2);
            PlotFace(mm);
        case 29
            Points = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
                3.0 5.5 5.5 1.5 1.5 4.0 4.5]';
            Knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
            b=Line2D('Nurb Test');
            b=AddNurb(b,Points,Knots);
            Plot(b);
            m1=Mesh('Mesh1');
            m1=Rot2Shell(m1,b,'Type',2);
            PlotFace(m1);
            m2=Mesh('Mesh2');
            m2=Rot2Shell(m2,b,'Type',1);
            PlotFace(m2);
        case 30
            % Derive patch data for a cylinder
            mm=Mesh('Cylinder Mesh');
            mm=MeshCylinder(mm,3,30,50);
            PlotFace(mm);
            % The cyclinder is meshed using tetrahedral elements using tetgen
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
            mm=DrillThroughHole(mm,[10;5],[20;50],[0,0],[3;2],'type',5,'slice',8);
            mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
            PlotFace(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 31
            mm=Mesh('Prism Mesh');
            mm=MeshPrism(mm,5,10,50);
            PlotFace(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 32
            mm=Mesh('Geosohere Mesh');
            mm=MeshGeoSphere(mm,4,5,'Type',1);
            PlotFace(mm);
            mm=Mesh3D(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 33
            mm=Mesh('Pyramid Mesh');
            mm=MeshPyramid(mm,5,10,20);
            PlotFace(mm);
            mm=Mesh3D(mm);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 34
            mm=Mesh('Pyramid Mesh');
            mm=MeshPyramid(mm,5,10,20);
            PlotFace(mm);
            mm=Mesh3D(mm,'AddedNodes',[0,0,2;0,0,4;0,0,6;0,0,8;0,0,10]);
            sec.pos=[0,0,0];
            sec.vec=[1,0,0];
            PlotElement(mm,'section',sec);
        case 35
            mm=Mesh('Gear');
            mm=InputSTP(mm,'Gear.step','Size',0.01);
            PlotFace(mm)
    end
end

function writeReport(filename, results, passed, failed, total_time)
    % Write test report to file
    fid = fopen(filename, 'w');

    fprintf(fid, '========================================\n');
    fprintf(fid, 'Mesh Test Report\n');
    fprintf(fid, '========================================\n\n');

    fprintf(fid, 'Test Date: %s\n\n', datestr(now));

    fprintf(fid, 'Summary\n');
    fprintf(fid, '-------\n');
    fprintf(fid, 'Total Tests: %d\n', length(results));
    fprintf(fid, 'Passed: %d\n', passed);
    fprintf(fid, 'Failed: %d\n', failed);
    fprintf(fid, 'Success Rate: %.2f%%\n', passed/length(results)*100);
    fprintf(fid, 'Total Execution Time: %.3f seconds\n\n', total_time);

    fprintf(fid, '========================================\n');
    fprintf(fid, 'Detailed Results\n');
    fprintf(fid, '========================================\n\n');

    for i = 1:length(results)
        fprintf(fid, '[Test %d] %s\n', results(i).id, results(i).name);
        fprintf(fid, 'Status: %s\n', results(i).status);
        fprintf(fid, 'Time: %.3f seconds\n', results(i).time);
        if ~isempty(results(i).error)
            fprintf(fid, 'Error: %s\n', results(i).error);
        end
        fprintf(fid, '\n');
    end

    fclose(fid);
end

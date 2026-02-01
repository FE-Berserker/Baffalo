%% Automated Test Runner for Mesh2D
% This script runs all 22 test cases for Mesh2D and generates a test report

clc
clear
close all

% Add framework to path
addpath(genpath('../../dep/framework'));

% Test configuration
total_tests = 22;
results = struct('id', [], 'name', [], 'status', [], 'time', [], 'error', []);
report_path = 'Test_Report_Mesh2D.txt';

fprintf('========================================\n');
fprintf('Mesh2D Test Suite\n');
fprintf('========================================\n\n');

% Run all tests
for test_id = 1:total_tests
    fprintf('[Test %d/%d] Running test case %d...\n', test_id, total_tests, test_id);

    % Get test name from Test_007_Mesh2D.m
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
        'Create gear obj';
        'Create quad circle';
        'Create quad plate';
        'Add Elements';
        'Convhull';
        'Convcave1';
        'Convcave2';
        'Convert quad to tri';
        'Mesh 2D Tensor Grid';
        'Mesh 2D Grid';
        'Compute MRST G';
        'Load msh file';
        'MeshDual';
        'Plot Dual center and area';
        'Calculate geometry information';
        'Plot Mesh2D in paraview';
        'Plot Mesh2D G and celldata in paraview';
        'Mesh edge';
        'Mesh ring';
        'Mesh edge layer';
        'Baffalo logo';
        'Mesh with constraints'
    };
    if id >= 1 && id <= length(names)
        name = names{id};
    else
        name = 'Unknown Test';
    end
end

function runTest(flag)
    % Extract test code from Test_007_Mesh2D.m and run it
    % Read the test file
    fid = fopen('Test_007_Mesh2D.m', 'r');
    content = fread(fid, '*char')';
    fclose(fid);

    % Find the test code for the specific flag
    pattern = sprintf('case %d', flag);
    start_pos = strfind(content, pattern);

    if isempty(start_pos)
        error('Test case %d not found', flag);
    end

    % Find the end of the case (next case or function end)
    next_case = find(strcmp(regexp(content(start_pos(1)+1:end), 'case\s+\d+', 'match'), ...
        regexp(content(start_pos(1)+1:end), 'case\s+\d+', 'match', 'once'))) - 1;

    % Execute the test code (wrapped in try-catch for specific test)
    testMesh2D(flag);
end

function testMesh2D(flag)
    % Test function from Test_007_Mesh2D.m
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
            [pc,ac]=ComputeGeometryDual(m);
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
            [Area,Center,Ixx,Iyy,Ixy]= CalculateGeometry(m);
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

        case 22
            a=Point2D('Temp');
            a=AddPoint(a,[1,1,-1,-1,1]',[1,-1,-1,1,1]');
            % Add outline
            b=Line2D('Out');
            b=AddCurve(b,a,1);
            Plot(b)
            S=Surface2D(b);
            m=Mesh2D('Temp');
            m=AddSurface(m,S);
            m=SetSize(m,0.1);
            Cnode = [
                +.0, +.0; +.2, +.7
                +.6, +.2; +.4, +.8
                +0., +.5; -.7, +.3
                -.1, +.1; -.6, +.5
                -.9, -.8; -.6, -.7
                -.3, -.6; +.0, -.5
                +.3, -.4; -.3, +.4
                -.1, +.3
                ] ;
            Cedge = [
                1 ,  2 ;  1 ,  3
                1 ,  4 ;  1 ,  5
                1 , 6 ; 1 , 7
                1 , 8 ; 1 , 9
                1 , 10 ; 1 , 11
                1 , 12 ; 1 , 13
                1 , 14 ; 1 , 15
                ] ;
            m=AddCNode(m,Cnode);
            m=AddCEdge(m,Cedge);
            m=Mesh(m);
            Plot(m)
    end
end

function writeReport(filename, results, passed, failed, total_time)
    % Write test report to file
    fid = fopen(filename, 'w');

    fprintf(fid, '========================================\n');
    fprintf(fid, 'Mesh2D Test Report\n');
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

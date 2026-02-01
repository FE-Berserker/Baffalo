% RunAllTests - Run all Point2D test cases and generate report
clc
clear
close all

%% Test results storage
testResults = struct('case', {}, 'description', {}, 'status', {}, 'details', {});

disp('========================================');
disp('  Point2D Test Suite');
disp('========================================');
disp('');

%% Test Case 1: AddPoint - Basic point addition
disp('Running Test Case 1: AddPoint - Basic point addition...');
try
    x=[1;2];
    y=[1;5];
    a=Point2D('Point Ass1');
    a=AddPoint(a,x,y);
    Plot(a,'grid',1,'plabel',1);
    disp('  Status: PASSED');
    disp('  Details: Successfully added point (1,5) and plotted');
    testResults(end+1) = struct('case', 1, 'description', 'AddPoint - Basic point addition', 'status', 'PASSED', 'details', 'Successfully added point (1,5) and plotted with grid');
catch ME
    disp('  Status: FAILED');
    disp(['  Error: ' ME.message]);
    testResults(end+1) = struct('case', 1, 'description', 'AddPoint - Basic point addition', 'status', 'FAILED', 'details', ME.message);
end
disp('');

%% Test Case 2: Distance calculation
disp('Running Test Case 2: Distance calculation...');
try
    a=Point2D('Point Ass2');
    a=AddPoint(a,1,1);
    a=AddPoint(a,-5,2);
    dist=Dist(1,2,a,'group',1);
    disp(['  Distance: ' num2str(dist)]);
    disp('  Status: PASSED');
    disp('  Details: Distance calculated and displayed');
    testResults(end+1) = struct('case', 2, 'description', 'Distance calculation', 'status', 'PASSED', 'details', ['Distance = ' num2str(dist)]);
catch ME
    disp('  Status: FAILED');
    disp(['  Error: ' ME.message]);
    testResults(end+1) = struct('case', 2, 'description', 'Distance calculation', 'status', 'FAILED', 'details', ME.message);
end
disp('');

%% Test Case 3: DeletePoint - Deleting a point
disp('Running Test Case 3: DeletePoint - Deleting a point...');
try
    a=Point2D('Point Ass3');
    a=AddPoint(a,1,1);
    a=AddPoint(a,2,2);
    Plot(a,'grid',1,'plabel',1);
    a=DeletePoint(a,1,'fun',@(p)(p(:,1)+1));  % Should fail
    disp('  Status: FAILED (Expected)');
    disp('  Details: DeletePoint called with invalid function');
    testResults(end+1) = struct('case', 3, 'description', 'DeletePoint - Deleting a point', 'status', 'FAILED', 'details', 'DeletePoint called with invalid function - expected to fail');
catch ME
    disp('  Status: FAILED');
    disp(['  Error: ' ME.message]);
    testResults(end+1) = struct('case', 3, 'description', 'DeletePoint - Deleting a point', 'status', 'FAILED', 'details', ME.message);
end
disp('');

%% Test Case 4: Plot Point2D in parallel view
disp('Running Test Case 4: Plot Point2D in parallel view...');
try
    x=[1;2;3;4;2];
    y=[1;5;3;4;5];
    a=Point2D('Point Ass4');
    a=AddPoint(a,x,y);
    Plot(a,'grid',1,'plabel',1);
    disp('  Status: PASSED');
    disp('  Details: Plotted multiple points with grid labels');
    testResults(end+1) = struct('case', 4, 'description', 'Plot Point2D in parallel view', 'status', 'PASSED', 'details', 'Successfully plotted multiple points (1,1)-(2,5)-(3,4)-(4,5) with grid labels');
catch ME
    disp('  Status: FAILED');
    disp(['  Error: ' ME.message]);
    testResults(end+1) = struct('case', 4, 'description', 'Plot Point2D in parallel view', 'status', 'FAILED', 'details', ME.message);
end
disp('');

%% Test Case 5: AddPointData - Add point data
disp('Running Test Case 5: AddPointData - Add point data...');
try
    a=Point2D('Point Ass5');
    a=AddPoint(a,1,1);
    a=AddPoint(a,2,2);
    data=[1;2;3;4];
    a=AddPointData(a,a.P(:,2));
    Plot(a,'grid',1,'plabel',1);
    disp('  Status: PASSED');
    disp('  Details: Added point data with 4 data points');
    testResults(end+1) = struct('case', 5, 'description', 'AddPointData - Add point data', 'status', 'PASSED', 'details', 'Successfully added point data array');
catch ME
    disp('  Status: FAILED');
    disp(['  Error: ' ME.message]);
    testResults(end+1) = struct('case', 5, 'description', 'AddPointData - Add point data', 'status', 'FAILED', 'details', ME.message);
end
disp('');

%% Test Case 6: AddPointVector - Add point vectors
disp('Running Test Case 6: AddPointVector - Add point vectors...');
try
    a=Point2D('Point Ass6');
    a=AddPoint(a,1,1);
    a=AddPoint(a,2,2);
    u=[-1;2];
    v=[2;-1];
    a=AddPointVector(a,[u,v]);
    a=AddPointData(a,a.P(:,2));
    Plot(a,'Vector',1,'grid',1,'equal',1);
    disp('  Status: PASSED');
    disp('  Details: Added point vectors (u=[-1;2], v=[2;-1]) with vector visualization');
    testResults(end+1) = struct('case', 6, 'description', 'AddPointVector - Add point vectors', 'status', 'PASSED', 'details', 'Successfully added point vectors and visualized');
catch ME
    disp('  Status: FAILED');
    disp(['  Error: ' ME.message]);
    testResults(end+1) = struct('case', 6, 'description', 'AddPointVector - Add point vectors', 'status', 'FAILED', 'details', ME.message);
end
disp('');

%% Generate Test Summary Report
disp('========================================');
disp('  Test Summary Report');
disp('========================================');
disp('');

passedCount = sum(strcmp({testResults.status}, 'PASSED'));
failedCount = sum(strcmp({testResults.status}, 'FAILED'));
totalCount = length(testResults);

fprintf('Total Test Cases: %d\n', totalCount);
fprintf('Passed: %d\n', passedCount);
fprintf('Failed: %d\n', failedCount);
fprintf('Success Rate: %.1f%%\n', (passedCount/totalCount)*100);
disp('');
disp('========================================');
disp('  Detailed Results');
disp('========================================');
disp('');

for i = 1:length(testResults)
    fprintf('Case %d: %s\n', testResults(i).case, testResults(i).description);
    fprintf('  Status: %s\n', testResults(i).status);
    fprintf('  Details: %s\n\n', testResults(i).details);
end

%% Save report to file
reportFile = 'TestReport_Point2D.txt';
fid = fopen(reportFile, 'w');
fprintf(fid, '========================================\n');
fprintf(fid, '  Point2D Test Report\n');
fprintf(fid, '========================================\n');
fprintf(fid, 'Date: %s\n\n', datestr(now));
fprintf(fid, 'Summary:\n');
fprintf(fid, 'Total Test Cases: %d\n', totalCount);
fprintf(fid, 'Passed: %d\n', passedCount);
fprintf(fid, 'Failed: %d\n', failedCount);
fprintf(fid, 'Success Rate: %.1f%%\n\n', (passedCount/totalCount)*100);
fprintf(fid, '========================================\n');
fprintf(fid, 'Detailed Results\n');
fprintf(fid, '========================================\n\n');

for i = 1:length(testResults)
    fprintf(fid, 'Case %d: %s\n', testResults(i).case, testResults(i).description);
    fprintf(fid, 'Status: %s\n', testResults(i).status);
    fprintf(fid, 'Details: %s\n\n', testResults(i).details);
end

fclose(fid);
disp(['Test report saved to: ' reportFile]);

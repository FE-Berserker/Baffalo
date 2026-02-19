% Test script for PlotStruct and PlotCapacity save image functionality
% Author: Claude Sonnet 4.5

clear; clc;

fprintf('=== Testing Component PlotStruct and PlotCapacity Save Function ===\n\n');

% Create test output directory
outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
fprintf('Output directory: %s\n\n', outputDir);

%% Test 1: Create ComponentModule and set some capacity values
fprintf('Test 1: Creating ComponentModule with test data...\n');

% Define parameters
paramsStruct = struct();
paramsStruct.Name = 'TestComponent';
paramsStruct.Echo = 0;
paramsStruct.Material = 'Steel';

% Define inputs
inputStruct = struct();
inputStruct.Input1 = 100;
inputStruct.Input2 = 200;

% Define baseline
baselineStruct = struct();
baselineStruct.Baseline1 = 1;

% Create component
comp = ComponentModule(paramsStruct, inputStruct, baselineStruct);

% Set some capacity values for testing
comp.capacity.Baseline1 = 0.85;  % This will show as 0.85/1.0 = 0.85 in the plot

fprintf('Component created with capacity ratio: %.2f\n\n', comp.capacity.Baseline1);

%% Test 2: Test PlotStruct without saving (default behavior)
fprintf('Test 2: PlotStruct without saving (display only)...\n');
comp.PlotStruct();
fprintf('PlotStruct displayed. Press any key to continue...\n');
pause(2);
close(gcf);

%% Test 3: Test PlotStruct with PNG save
fprintf('\nTest 3: PlotStruct with PNG save...\n');
pngFile = fullfile(outputDir, 'PlotStruct.png');
comp.PlotStruct('filename', pngFile, 'format', 'png', 'resolution', '300');
if exist(pngFile, 'file')
    fprintf('  Successfully saved: %s\n', pngFile);
else
    fprintf('  ERROR: Failed to save %s\n', pngFile);
end
pause(1);
close(gcf);

%% Test 4: Test PlotStruct with PDF save (high resolution)
fprintf('\nTest 4: PlotStruct with PDF save (600 DPI)...\n');
pdfFile = fullfile(outputDir, 'PlotStruct.pdf');
comp.PlotStruct('filename', pdfFile, 'format', 'pdf', 'resolution', '600');
if exist(pdfFile, 'file')
    fprintf('  Successfully saved: %s\n', pdfFile);
else
    fprintf('  ERROR: Failed to save %s\n', pdfFile);
end
pause(1);
close(gcf);

%% Test 5: Test PlotCapacity without saving (default behavior)
fprintf('\nTest 5: PlotCapacity without saving (display only)...\n');
comp.PlotCapacity('ylim', [0, 1]);
fprintf('PlotCapacity displayed. Press any key to continue...\n');
pause(2);
close(gcf);

%% Test 6: Test PlotCapacity with JPG save
fprintf('\nTest 6: PlotCapacity with JPG save...\n');
jpgFile = fullfile(outputDir, 'PlotCapacity.jpg');
comp.PlotCapacity('ylim', [0, 1], 'filename', jpgFile, 'format', 'jpg', 'resolution', '300');
if exist(jpgFile, 'file')
    fprintf('  Successfully saved: %s\n', jpgFile);
else
    fprintf('  ERROR: Failed to save %s\n', jpgFile);
end
pause(1);
close(gcf);

%% Test 7: Test PlotCapacity with EPS save (vector format)
fprintf('\nTest 7: PlotCapacity with EPS save...\n');
epsFile = fullfile(outputDir, 'PlotCapacity.eps');
comp.PlotCapacity('ylim', [0, 1], 'filename', epsFile, 'format', 'eps');
if exist(epsFile, 'file')
    fprintf('  Successfully saved: %s\n', epsFile);
else
    fprintf('  ERROR: Failed to save %s\n', epsFile);
end
pause(1);
close(gcf);

%% Summary
fprintf('\n=== Test Summary ===\n');
fprintf('Output directory: %s\n', outputDir);
fprintf('Saved files:\n');
files = dir(fullfile(outputDir, '*.*'));
for i = 1:length(files)
    if ~files(i).isdir
        fprintf('  - %s (%.2f KB)\n', files(i).name, files(i).bytes/1024);
    end
end
fprintf('\nAll tests completed!\n');

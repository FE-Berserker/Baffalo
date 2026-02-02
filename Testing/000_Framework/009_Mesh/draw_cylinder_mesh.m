%% Draw Cylinder Mesh
% This script demonstrates how to create a 3D cylinder mesh using the Mesh class

clc
clear
close all

% Add framework to path
addpath(genpath('../../dep/framework'));

fprintf('Creating 3D Cylinder Mesh\n');
fprintf('============================\n\n');

%% Create a cylinder mesh
% Parameters
esize = 1.0;      % Element size
Radius = 10;        % Cylinder radius
Height = 30;        % Cylinder height
elementType = 'quad'; % Face element type: 'tri' or 'quad'

fprintf('Parameters:\n');
fprintf('  Element size: %.2f\n', esize);
fprintf('  Radius: %.2f\n', Radius);
fprintf('  Height: %.2f\n', Height);
fprintf('  Face type: %s\n', elementType);
fprintf('\n');

% Create Mesh object
mesh = Mesh('CylinderMesh', 'Echo', 1);

% Generate cylinder surface
mesh = MeshCylinder(mesh, esize, Radius, Height, 'ElementType', elementType);

%% Plot the cylinder surface
fprintf('Plotting cylinder surface...\n');
PlotFace(mesh);

%% Generate 3D tetrahedral mesh using TetGen
fprintf('\nGenerating 3D tetrahedral mesh using TetGen...\n');
mesh = Mesh3D(mesh);

%% Plot the 3D mesh elements
fprintf('Plotting 3D mesh elements...\n');
PlotElement(mesh);

%% Display mesh statistics
fprintf('\n========================================\n');
fprintf('Mesh Statistics\n');
fprintf('========================================\n');
fprintf('Nodes: %d\n', size(mesh.Vert, 1));
fprintf('Faces: %d\n', size(mesh.Face, 1));
fprintf('Elements: %d\n', size(mesh.El, 1));
fprintf('\n');

%% Export to VTK
fprintf('Exporting to VTK...\n');
VTKWriteElement(mesh);

fprintf('\nCylinder mesh creation complete!\n');
fprintf('VTK file saved: CylinderMesh.vtk\n');

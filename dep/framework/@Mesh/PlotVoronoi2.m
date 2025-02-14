function PlotVoronoi2(obj,varargin)
% Plot Mesh Voronoi object in ParaView
% Author : Xie Yu
VTKWriteVoronoi(obj);
% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ParaViewPath = readmatrix("ParaViewPath.txt", opts);
command= strcat('"',ParaViewPath,'"',' --data="',obj.Name,'.vtk"');
system(command);
end


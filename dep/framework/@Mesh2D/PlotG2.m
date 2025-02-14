function PlotG2(obj,varargin)
% Plot Mesh2D object in ParaView
% Author : Xie Yu
VTKWriteG(obj);
% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ParaViewPath = readmatrix("ParaViewPath.txt", opts);
command= strcat('"',ParaViewPath,'"',' --data="',obj.Name,'.vtk"');
system(command);
end


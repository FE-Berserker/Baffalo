function Plot2(obj,varargin)
% Plot Point2D object in ParaView
% Author : Xie Yu
VTKWrite(obj);
% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ParaViewPath = readmatrix("ParaViewPath.txt", opts);
command= strcat('"',ParaViewPath,'"',' --data="','Surface2D','.vtk"');
system(command);
end


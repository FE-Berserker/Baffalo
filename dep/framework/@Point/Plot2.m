function Plot2(obj,varargin)
% Plot Point2D object in ParaView
% Author : Xie Yu

p=inputParser;
addParameter(p,'Normal',0);
addParameter(p,'NormNormal',0);
parse(p,varargin{:});
opt=p.Results;

VTKWrite(obj,'Normal',opt.Normal,'NormNormal',opt.NormNormal);
% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ParaViewPath = readmatrix("ParaViewPath.txt", opts);
command= strcat('"',ParaViewPath,'"',' --data="',obj.Name,'.vtk"');
system(command);
end


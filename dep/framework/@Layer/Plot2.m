function Plot2(obj,varargin)
% Plot Layer object in ParaView
% Author : Xie Yu
VTKWritePoints(obj);
VTKWriteLines(obj);
VTKWriteMeshes(obj);
n1=size(obj.Points,1);
n2=size(obj.Lines,1);
n3=size(obj.Meshes,1);

% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ParaViewPath = readmatrix("ParaViewPath.txt", opts);



filename=strcat('.\',obj.Name,'.bat');
fid=fopen(filename,'w');
sen= strcat('"',ParaViewPath,'"'," ^");
fprintf(fid, '%s\n',sen);
if n1>0
    for i=1:n1
        sen= strcat('--data="Points',num2str(i),'.vtk" ^');
        fprintf(fid, '%s\n',sen);
    end
end

if n2>0
    for i=1:n2
        sen= strcat('--data="Lines',num2str(i),'.vtk" ^');
        fprintf(fid, '%s\n',sen);
    end
end

if n3>0
    for i=1:n3
        sen= strcat('--data="Meshes',num2str(i),'.vtk" ^');
        fprintf(fid, '%s\n',sen);
    end
end
fclose(fid);


command= strcat(obj.Name,'.bat');
system(command);
end


function Plot2(obj,varargin)
% Plot Assembly in Paraview
% Author : Xie Yu
p=inputParser;
addParameter(p,'seperate',0);
parse(p,varargin{:});
opt=p.Results;

if opt.seperate==0
    VTKWriteParts(obj);
    % Load path
    opts = delimitedTextImportOptions("NumVariables", 1);
    opts.DataLines = [1, 2];
    opts.VariableTypes = "string";
    ParaViewPath = readmatrix("ParaViewPath.txt", opts);
    command= strcat('"',ParaViewPath,'"',' --data="','Parts','.vtk"');
    system(command);
else
    PartNumber=VTKWriteParts2(obj);
    n=size(PartNumber,1);
    % Load path
    opts = delimitedTextImportOptions("NumVariables", 1);
    opts.DataLines = [1, 2];
    opts.VariableTypes = "string";
    ParaViewPath = readmatrix("ParaViewPath.txt", opts);

    filename=strcat('.\',obj.Name,'.bat');
    fid=fopen(filename,'w');
    sen= strcat('"',ParaViewPath,'"'," ^");
    fprintf(fid, '%s\n',sen);

    for i=1:n
        sen= strcat('--data="Part',num2str(PartNumber(i,1)),'.vtk" ^');
        fprintf(fid, '%s\n',sen);
    end

    fclose(fid);

    command= strcat(obj.Name,'.bat');
    system(command);
end



end
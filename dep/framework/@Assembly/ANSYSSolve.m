function ANSYSSolve(obj,varargin)
% ANSYS solve
% Author : Xie Yu
p=inputParser;
addParameter(p,'Name',[]);
parse(p,varargin{:});
opt=p.Results;


filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');
if isempty(opt.Name)
    fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.Name,'.cdb'));
else
    fprintf(fid, '%s\n',strcat('CDREAD,db,',opt.Name,'.cdb'));
end
fclose(fid);

% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ANSYSPath = readmatrix("ANSYSPath.txt", opts);

filename=strcat('.\','ANSYS_batch.bat');
fid=fopen(filename,'w');
sen=strcat('"',ANSYSPath,'" -b -i ANSYSSolve.txt -o output.txt');
fprintf(fid, '%s\n',sen);
fclose(fid);

delete('file.lock')
dos('SET KMP_STACKSIZE=2048k & ANSYS_batch');
delete('file.lock')
end

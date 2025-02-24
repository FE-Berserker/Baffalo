function FbiGenerate(obj,varargin)
% Generate simpack flex file
% Author : Xie Yu
% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
SimpackPath = readmatrix("SimpackPath.txt", opts);
sen=strcat('"',SimpackPath,'\simpack-flx.exe" --tool convert-flexbody');
Name=obj.params.Name;
sen=strcat(sen," --file ",Name,'.sub');
sen=strcat(sen," --file ",Name,'.cdb');
sen=strcat(sen," --file ",Name,'.rst');
sen=strcat(sen," --file ",Name,'.tcms');
sen=strcat(sen," --length=0.001 --mass=1000 --time=1 --rec-rot-dof");
sen=strcat(sen," --output-file ",Name,'.fbi');

filename=strcat('.\','Fbi_batch.bat');
fid=fopen(filename,'w');
fprintf(fid, '%s\n',sen);
fclose(fid);
dos('Fbi_batch');
end
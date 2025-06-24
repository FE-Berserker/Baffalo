function obj=CalProperties(obj)
% Calculate effective properties of cell
% Author : Xie Yu

% Output Model
Ass=obj.output.Assembly;
ANSYS_Output(Ass,'Warning',0);

% Calculate dimension
m=obj.output.SolidMesh;

xmin=min(m.Vert(:,1));
xmax=max(m.Vert(:,1));
ymin=min(m.Vert(:,2));
ymax=max(m.Vert(:,2));
zmin=min(m.Vert(:,3));
zmax=max(m.Vert(:,3));


% Calculate E1
filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');

fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.input.FileName,'.cdb'));
fprintf(fid, '%s\n','/SOLU');
fprintf(fid, '%s\n','ANTYPE,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmin)));
fprintf(fid, '%s\n','D,ALL,UX,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n',strcat('D,ALL,UX,',num2str(1/(xmax-xmin))));

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymin)));
fprintf(fid, '%s\n','D,ALL,UY,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n','D,ALL,UY,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmin)));
fprintf(fid, '%s\n','D,ALL,UZ,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n','D,ALL,UZ,0');

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','SET,LAST');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_E1,txt'));
fprintf(fid, '%s\n','PRRSOL,FX');
fprintf(fid, '%s\n','/OUTPUT');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_v12,txt'));
fprintf(fid, '%s\n','PRRSOL,FY');
fprintf(fid, '%s\n','/OUTPUT');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_v13,txt'));
fprintf(fid, '%s\n','PRRSOL,FZ');
fprintf(fid, '%s\n','/OUTPUT');
fclose(fid);
SolveANSYS

% Calculate E2
filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');

fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.input.FileName,'.cdb'));
fprintf(fid, '%s\n','/SOLU');
fprintf(fid, '%s\n','ANTYPE,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymin)));
fprintf(fid, '%s\n','D,ALL,UY,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n',strcat('D,ALL,UY,',num2str(1/(ymax-ymin))));

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmin)));
fprintf(fid, '%s\n','D,ALL,UX,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n','D,ALL,UX,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmin)));
fprintf(fid, '%s\n','D,ALL,UZ,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n','D,ALL,UZ,0');

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','SET,LAST');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_E2,txt'));
fprintf(fid, '%s\n','PRRSOL,FY');
fprintf(fid, '%s\n','/OUTPUT');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_v23,txt'));
fprintf(fid, '%s\n','PRRSOL,FZ');
fprintf(fid, '%s\n','/OUTPUT');

fclose(fid);
SolveANSYS

% Calculate E3
filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');

fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.input.FileName,'.cdb'));
fprintf(fid, '%s\n','/SOLU');
fprintf(fid, '%s\n','ANTYPE,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmin)));
fprintf(fid, '%s\n','D,ALL,UZ,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n',strcat('D,ALL,UZ,',num2str(1/(zmax-zmin))));

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmin)));
fprintf(fid, '%s\n','D,ALL,UX,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n','D,ALL,UX,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymin)));
fprintf(fid, '%s\n','D,ALL,UY,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n','D,ALL,UY,0');

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','SET,LAST');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_E3,txt'));
fprintf(fid, '%s\n','PRRSOL,FZ');
fprintf(fid, '%s\n','/OUTPUT');
fclose(fid);
SolveANSYS

% Calculate G12
filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');

fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.input.FileName,'.cdb'));
fprintf(fid, '%s\n','/SOLU');
fprintf(fid, '%s\n','ANTYPE,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmin)));
fprintf(fid, '%s\n','D,ALL,UY,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n',strcat('D,ALL,UY,',num2str(1/(xmax-xmin))));

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymin)));
fprintf(fid, '%s\n','D,ALL,UX,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n','D,ALL,UX,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmin)));
fprintf(fid, '%s\n','D,ALL,UZ,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n','D,ALL,UZ,0');

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','SET,LAST');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_G12,txt'));
fprintf(fid, '%s\n','PRRSOL,FY');
fprintf(fid, '%s\n','/OUTPUT');
fclose(fid);
SolveANSYS

% Calculate G13
filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');

fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.input.FileName,'.cdb'));
fprintf(fid, '%s\n','/SOLU');
fprintf(fid, '%s\n','ANTYPE,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmin)));
fprintf(fid, '%s\n','D,ALL,UZ,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n',strcat('D,ALL,UZ,',num2str(1/(xmax-xmin))));

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymin)));
fprintf(fid, '%s\n','D,ALL,UY,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n','D,ALL,UY,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmin)));
fprintf(fid, '%s\n','D,ALL,UX,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n','D,ALL,UX,0');

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','SET,LAST');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_G13,txt'));
fprintf(fid, '%s\n','PRRSOL,FZ');
fprintf(fid, '%s\n','/OUTPUT');
fclose(fid);
SolveANSYS

% Calculate G23
filename=strcat('.\','ANSYSSolve.txt');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','finish');
fprintf(fid, '%s\n','/CLEAR');

fprintf(fid, '%s\n',strcat('CDREAD,db,',obj.input.FileName,'.cdb'));
fprintf(fid, '%s\n','/SOLU');
fprintf(fid, '%s\n','ANTYPE,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymin)));
fprintf(fid, '%s\n','D,ALL,UZ,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n',strcat('D,ALL,UZ,',num2str(1/(ymax-ymin))));

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmin)));
fprintf(fid, '%s\n','D,ALL,UX,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,X,',num2str(xmax)));
fprintf(fid, '%s\n','D,ALL,UX,0');

fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmin)));
fprintf(fid, '%s\n','D,ALL,UY,0');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Z,',num2str(zmax)));
fprintf(fid, '%s\n','D,ALL,UY,0');

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','SET,LAST');
fprintf(fid, '%s\n',strcat('NSEL,S,LOC,Y,',num2str(ymax)));
fprintf(fid, '%s\n',strcat('/OUTPUT,RF_G23,txt'));
fprintf(fid, '%s\n','PRRSOL,FZ');
fprintf(fid, '%s\n','/OUTPUT');
fclose(fid);
SolveANSYS

% Parse
obj.output.Property.Name=obj.params.Name;
E1=LoadResult(strcat('RF_E',num2str(1),'.txt'))/(ymax-ymin)/(zmax-zmin)*(xmax-xmin)^2;
E2=LoadResult(strcat('RF_E',num2str(2),'.txt'))/(xmax-xmin)/(zmax-zmin)*(ymax-ymin)^2;
E3=LoadResult(strcat('RF_E',num2str(3),'.txt'))/(xmax-xmin)/(ymax-ymin)*(zmax-zmin)^2;
G12=LoadResult(strcat('RF_G',num2str(12),'.txt'))/(ymax-ymin)/(zmax-zmin)*(xmax-xmin)^2;
G13=LoadResult(strcat('RF_G',num2str(13),'.txt'))/(ymax-ymin)/(zmax-zmin)*(xmax-xmin)^2;
G23=LoadResult(strcat('RF_G',num2str(23),'.txt'))/(xmax-xmin)/(zmax-zmin)*(ymax-ymin)^2;
obj.output.Property.E1=E1;
obj.output.Property.E2=E2;
obj.output.Property.E3=E3;
obj.output.Property.G12=G12;
obj.output.Property.G13=G13;
obj.output.Property.G23=G23;
obj.output.Property.v12=LoadResult(strcat('RF_v',num2str(12),'.txt'))/(ymax-ymin)/(zmax-zmin)/E2/...
    (LoadResult(strcat('RF_E',num2str(1),'.txt'))/(ymax-ymin)/(zmax-zmin))*E1;
obj.output.Property.v13=LoadResult(strcat('RF_v',num2str(13),'.txt'))/(xmax-xmin)/(ymax-ymin)/E3/...
    (LoadResult(strcat('RF_E',num2str(1),'.txt'))/(ymax-ymin)/(zmax-zmin))*E1;
obj.output.Property.v23=LoadResult(strcat('RF_v',num2str(23),'.txt'))/(xmax-xmin)/(ymax-ymin)/E3/...
    (LoadResult(strcat('RF_E',num2str(2),'.txt'))/(xmax-xmin)/(zmax-zmin))*E2;
end

function SolveANSYS

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

function Value=LoadResult(FileName)
Data = textscan(fopen(FileName,'r'),'%s','Delimiter','\n');
Data = Data{1,1};
Value=Data{end,1}(10:end);
Value=str2double(Value);
end
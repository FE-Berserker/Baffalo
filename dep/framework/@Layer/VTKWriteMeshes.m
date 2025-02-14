function VTKWriteMeshes(obj,varargin)
% Print VTK file
% Author : Xie Yu

% p=inputParser;
% addParameter(p,'facecolor',1);
% parse(p,varargin{:});
% opt=p.Results;
fprintf('Start output to VTK\n');
for i=1:size(obj.Meshes,1)
%% Parameter
NumNode=size(obj.Meshes{i,1}.Face,2);
NumPoint=size(obj.Meshes{i,1}.Vert,1);
NumFace=size(obj.Meshes{i,1}.Face,1);

%% VTK output

filename=strcat('.\Meshes',num2str(i),'.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');
% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
Temp=obj.Meshes{i,1}.Vert;
fprintf(fid,'%16.9e\t%16.9e\t%16.9e\n',Temp');
switch NumNode
    case 3
        % Cells output
        fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumFace)," ",num2str(NumFace*4)));
        Temp=[ones(NumFace,1)*3,obj.Meshes{i,1}.Face-1];
        fprintf(fid,'%8i%8i%8i%8i\n',Temp');
        % Cells types
        fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumFace)));
        Temp=ones(NumFace,1)*5;
        fprintf(fid,'%8i\n',Temp');
    case 4
        % Cells output
        fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumFace)," ",num2str(NumFace*5)));
        Temp=[ones(NumFace,1)*4,obj.Meshes{i,1}.Face-1];
        fprintf(fid,'%8i%8i%8i%8i%8i\n',Temp');
        % Cells types
        fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumFace)));
        Temp=ones(NumFace,1)*9;
        fprintf(fid,'%8i\n',Temp');
    case 8
        % Cells output
        fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumFace)," ",num2str(NumFace*9)));
        F=obj.Meshes{i,1}.Face-1;
        Temp=[ones(NumFace,1)*8,F(:,1:2:7),F(:,2:2:8)];
        fprintf(fid,'%8i%8i%8i%8i%8i\n',Temp');
        % Cells types
        fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumFace)));
        Temp=ones(NumFace,1)*23;
        fprintf(fid,'%8i\n',Temp');
end

fclose(fid);
end
fprintf('Successfully output to VTK\n');
end
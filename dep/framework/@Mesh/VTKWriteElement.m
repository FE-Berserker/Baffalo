function VTKWriteElement(obj,varargin)
% Print VTK file
% Author : Xie Yu

p=inputParser;
% addParameter(p,'facecolor',1);
parse(p,varargin{:});
opt=p.Results;
%% Parameter
NumNode=size(obj.Meshoutput.elements,2);
NumPoint=size(obj.Meshoutput.nodes,1);
% NumFace=size(obj.Face,1);
NumEl=size(obj.Meshoutput.elements,1);
%% VTK output
fprintf('Start output to VTK\n');
filename=strcat('.\',obj.Name,'.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');
% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
Temp=obj.Vert;
fprintf(fid,'%16.9e\t%16.9e\t%16.9e\n',Temp');
switch NumNode
    case 4
        % Cells output
        fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumEl)," ",num2str(NumEl*5)));
        Temp=[ones(NumEl,1)*4,obj.Meshoutput.elements-1];
        fprintf(fid,'%8i%8i%8i%8i%8i\n',Temp');
        % Cells types
        fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumEl)));
        Temp=ones(NumEl,1)*10;
        fprintf(fid,'%8i\n',Temp');
    case 8
        % Cells output
        fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumEl)," ",num2str(NumEl*9)));
        Temp=[ones(NumEl,1)*8,obj.Meshoutput.elements-1];
        fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp');
        % Cells types
        fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumEl)));
        Temp=ones(NumEl,1)*12;
        fprintf(fid,'%8i\n',Temp');
end
% Cells Data
if ~isempty(obj.Cell_Data)
    fprintf(fid, '%s\n',strcat("CELL_DATA ",num2str(NumEl)));
    fprintf(fid, '%s\n','SCALARS cell_data float');
    fprintf(fid, '%s\n','LOOKUP_TABLE default');
    Temp=obj.Cell_Data;
    fprintf(fid,'%16.9e\n',Temp');
end
if or(~isempty(obj.Point_Data),~isempty(obj.Point_Vector))
    fprintf(fid, '%s\n',strcat("Point_DATA ",num2str(NumPoint)));
    % Point Data
    if ~isempty(obj.Point_Data)
        fprintf(fid, '%s\n','SCALARS Point_Data float');
        fprintf(fid, '%s\n','LOOKUP_TABLE default');
        fprintf(fid,'%16.9e\n',obj.Point_Data');
    end
    % Point Vector
    if ~isempty(obj.Point_Vector)
        fprintf(fid, '%s\n','VECTORS Point_Vector float');
        fprintf(fid,'%16.9e%16.9e%16.9e\n',obj.Point_Vector');
    end
end

fclose(fid);
fprintf('Successfully output to VTK\n');
end
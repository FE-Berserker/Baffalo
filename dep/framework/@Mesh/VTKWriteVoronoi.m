function VTKWriteVoronoi(obj,varargin)
% Print VTK file
% Author : Xie Yu

p=inputParser;
% addParameter(p,'facecolor',1);
parse(p,varargin{:});
opt=p.Results;
%% Parameter
nodes = obj.Voronoi.Nodes;
faces=obj.Voronoi.Faces;
NumPoint=size(nodes,1);
NumFace=size(faces,1);
NumFaceNode=cellfun(@(x)size(x,2),faces,'UniformOutput',false);
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
Temp=nodes;
fprintf(fid,'%16.9e\t%16.9e\t%16.9e\n',Temp');

% Cells output
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumFace)," ",num2str(sum(cell2mat(NumFaceNode))+NumFace)));
cellfun(@(x)size(x,2),faces,'UniformOutput',false);
for i=1:NumFace
Temp=[NumFaceNode{i,1},faces{i,1}-1];
% Num=size(Temp,2);
fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp);
end
% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumFace)));
Temp=ones(NumFace,1)*7;
fprintf(fid,'%8i\n',Temp');

% Cells Data
if ~isempty(obj.Cell_Data)
    fprintf(fid, '%s\n',strcat("CELL_DATA ",num2str(NumFace)));
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
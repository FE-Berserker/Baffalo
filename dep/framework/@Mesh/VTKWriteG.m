function VTKWriteG(obj,varargin)
% Print VTK file
% Author : Xie Yu

p=inputParser;
% addParameter(p,'facecolor',1);
parse(p,varargin{:});
opt=p.Results;
%% Parameter
G=obj.G;
nodes = obj.Meshoutput.nodes;
Temp1=G.cells.faces(:,1);
Temp1=reshape(Temp1,[6,size(Temp1,1)/6]);
Temp1=Temp1';
Temp2=G.faces.nodes;
Temp2=reshape(Temp2,[4,size(Temp2,1)/4]);
Temp2=Temp2';
elements=[Temp2(Temp1(:,1),:),Temp2(Temp1(:,2),:)];
% faces=element2patch(elements,[],'hex8');

% NumNode=size(faces,2);
NumPoint=size(nodes,1);
NumEl=size(elements,1);
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
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumEl)," ",num2str(NumEl*9)));
Temp=[ones(NumEl,1)*8,elements-1];
fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp');
% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumEl)));
Temp=ones(NumEl,1)*12;
fprintf(fid,'%8i\n',Temp');

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
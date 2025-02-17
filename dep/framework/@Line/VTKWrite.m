function VTKWrite(obj)
% Print VTK file
% Author : Xie Yu

%% Parameter
% convert the number of subdivisions in number of points
PP=cellfun(@(x,y)nrbeval(x,linspace(0.0,1.0,y+1)),obj.Nurbs,obj.Subd,'UniformOutput',false);
PP=cellfun(@(x)x',PP,'UniformOutput',false);
P=cell2mat(PP);

NumPoint=size(P,1);
NumLine=GetNcrv(obj);

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
Temp=P;
fprintf(fid,'%16.9e%16.9e%16.9e\n',Temp');
% Cells output
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumLine)," ",num2str(NumPoint+NumLine)));
acc=0;
for i=1:NumLine
Temp=[size(PP{i,1},1),acc+(0:size(PP{i,1},1)-1)];
style=repmat('%8i',1,size(PP{i,1},1));
style=strcat(style,'\n');
fprintf(fid,style,Temp);
acc=acc+size(PP{i,1},1);
end
% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumLine)));
Temp=ones(NumLine,1)*4;
fprintf(fid,'%8i\n',Temp');
% Cell data
if ~isempty(obj.Cell_Data)
    fprintf(fid, '%s\n',strcat("CELL_DATA ",num2str(NumLine)));
    fprintf(fid, '%s\n','SCALARS cell_data float');
    fprintf(fid, '%s\n','LOOKUP_TABLE default');
    Temp=obj.Cell_Data;
    fprintf(fid,'%16.9e\n',Temp');
end

fclose(fid);
%% Print
if obj.Echo
    fprintf('Successfully output to VTK .\n');
    tic
end
end
function VTKWriteLines(obj)
% Print VTK file
% Author : Xie Yu
fprintf('Start output to VTK\n');
%% Parameter
for i=1:size(obj.Lines,1)
xx=obj.Lines{i,1}.P(:,1);
yy=obj.Lines{i,1}.P(:,2);
NumPoint=size(xx,1);
NumLine=1;

%% VTK output
filename=strcat('.\Lines',num2str(i),'.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');
% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
Temp=[xx,yy,zeros(NumPoint,1)];
fprintf(fid,'%16.9e%16.9e%16.9e\n',Temp');
% Cells output
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumLine)," ",num2str(NumPoint+NumLine)));
Temp=[size(xx,1),(0:size(xx,1)-1)];
style=repmat('%8i',1,size(xx,1));
style=strcat(style,'\n');
fprintf(fid,style,Temp);
% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumLine)));
Temp=ones(NumLine,1)*4;
fprintf(fid,'%8i\n',Temp');

fclose(fid);
end
fprintf('Successfully output to VTK\n');
end
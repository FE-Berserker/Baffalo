function VTKWrite(obj)
% Print VTK file
% Author : Xie Yu

%% Parameter
FN=1:GetNface(obj); % Face Num
Node=obj.Node(FN',1);

% close polygon
X=cellfun(@(x)x(:,1)',Node,'UniformOutput',0);
Y=cellfun(@(y)y(:,2)',Node,'UniformOutput',0);

xx=cell2mat(X')';
yy=cell2mat(Y')';
NumPoint=size(xx,1);
NumFace=GetNface(obj);

%% VTK output
fprintf('Start output to VTK\n');
filename=strcat('.\','Surface2D','.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n','Surface2D');
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');
% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
Temp=[xx,yy,zeros(NumPoint,1)];
fprintf(fid,'%16.9e%16.9e%16.9e\n',Temp');
% Cells output
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumFace)," ",num2str(NumPoint+NumFace)));
acc=0;
for i=1:NumFace
Temp=[size(X{i,1},2),acc+(0:size(X{i,1},2)-1)];
style=repmat('%8i',1,size(X{i,1},2));
style=strcat(style,'\n');
fprintf(fid,style,Temp);
acc=acc+size(X{i,1},2);
end
% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumFace)));
Temp=ones(NumFace,1)*7;
fprintf(fid,'%8i\n',Temp');
fclose(fid);
fprintf('Successfully output to VTK\n');
end
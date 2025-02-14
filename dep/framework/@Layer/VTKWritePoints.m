function VTKWritePoints(obj,varargin)
% Print VTK file
% Author : Xie Yu

p=inputParser;
addParameter(p,'Echo',0);
parse(p,varargin{:});
opt=p.Results;

if opt.Echo==1
    fprintf('Start output to VTK Layer Points\n');
end

for i=1:size(obj.Points,1)
P=obj.Points{i,1}.P;
NumPoints=size(P,1);
%% VTK output
filename=strcat('.\Points',num2str(i),'.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');
% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoints),' float'));
fprintf(fid,'%16.9e%16.9e%16.9e\n',P');

% Cells output
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumPoints)," ",num2str(2*NumPoints)));
Temp=[ones(NumPoints,1),(0:NumPoints-1)'];
fprintf(fid,'%8i%8i\n',Temp');
% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumPoints)));
Temp=ones(NumPoints,1);
fprintf(fid,'%8i\n',Temp');
fclose(fid);
end
if opt.Echo==1
    fprintf('Successfully output to VTK\n');
end
end
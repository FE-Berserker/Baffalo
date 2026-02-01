function VTKWrite(obj,varargin)
% Print VTK file
% Author : Xie Yu

p=inputParser;
addParameter(p,'Echo',0);
addParameter(p,'Normal',0);
addParameter(p,'NormNormal',0);
parse(p,varargin{:});
opt=p.Results;

if opt.Echo==1
    fprintf('Start output to VTK\n');
end

%% Parameter
P=obj.P;
NumPoints=size(P,1);
PointData=obj.Point_Data;

if opt.Normal==1
    PointVector=obj.Normal;
elseif opt.NormNormal==1
    PointVector=obj.NormNormal;
else
    PointVector=obj.Point_Vector;
end

if size(P,2)==2
    P(:,3)=zeros(size(P,1),1);
end

if size(PointVector,2)==2
    PointVector(:,3)=zeros(size(PointVector,1),1);
end

%% VTK output
filename=strcat('.\',obj.Name,'.vtk');
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


if or(~isempty(obj.Point_Data),~isempty(obj.Point_Vector))
    fprintf(fid, '%s\n',strcat("Point_DATA ",num2str(NumPoints)));
    % Point Data
    if ~isempty(obj.Point_Data)
        fprintf(fid, '%s\n','SCALARS Point_Data float');
        fprintf(fid, '%s\n','LOOKUP_TABLE default');
        fprintf(fid,'%16.9e\n',PointData');
    end
    % Point Vector
    if ~isempty(PointVector)
        fprintf(fid, '%s\n','VECTORS Point_Vector float');
        fprintf(fid,'%16.9e%16.9e%16.9e\n',PointVector');
    end
end


fclose(fid);
if opt.Echo==1
    fprintf('Successfully output to VTK\n');
end
end
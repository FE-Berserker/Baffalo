function VTKWriteSensor(obj,Num,varargin)
% Print VTK file
% Author : Xie Yu
p=inputParser;
addParameter(p,'PointData',[]);
addParameter(p,'PointVector',[]);
addParameter(p,'CellData',[]);
addParameter(p,'Cnode',0);
parse(p,varargin{:});
opt=p.Results;

if obj.Echo
fprintf('Start output to VTK ...\n');
end

Corner=0;
switch obj.Sensor{Num,1}.Type
    case "Stress"
        Corner=1;
    case "Strain"
        Corner=1;
    case "U"
        Corner=1;
end

%% Parameter
VV=[obj.V;obj.Cnode];
NumPoint=size(VV,1);
if ~isfield(obj.Sensor{Num,1},'Part')
    m=size(obj.Part,1);
    Part=obj.Part;
else
    m=size(obj.Sensor{Num,1}.Part,1);
    Part=obj.Part(obj.Sensor{Num,1}.Part,1);
    % VV=cellfun(@(x)x.mesh.nodes,Part,'UniformOutput',false);
    % VV=cell2mat(VV);
    % NumPoint=size(VV,1);
end

%% VTK output
filename=strcat('.\',obj.Name,'_Sensor',num2str(Num),'.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');

VTK.VTK3=[];
VTK.VTK5=[];
VTK.VTK9=[];
VTK.VTK10=[];
VTK.VTK12=[];
VTK.VTK22=[];
VTK.VTK23=[];
VTK.VTK24=[];
VTK.VTK25=[];
Cell_Part.VTK3=[];
Cell_Part.VTK5=[];
Cell_Part.VTK9=[];
Cell_Part.VTK10=[];
Cell_Part.VTK12=[];
Cell_Part.VTK22=[];
Cell_Part.VTK23=[];
Cell_Part.VTK24=[];
Cell_Part.VTK25=[];
Cell_Mat.VTK3=[];
Cell_Mat.VTK5=[];
Cell_Mat.VTK9=[];
Cell_Mat.VTK10=[];
Cell_Mat.VTK12=[];
Cell_Mat.VTK22=[];
Cell_Mat.VTK23=[];
Cell_Mat.VTK24=[];
Cell_Mat.VTK25=[];
Cell_ET.VTK3=[];
Cell_ET.VTK5=[];
Cell_ET.VTK9=[];
Cell_ET.VTK10=[];
Cell_ET.VTK12=[];
Cell_ET.VTK22=[];
Cell_ET.VTK23=[];
Cell_ET.VTK24=[];
Cell_ET.VTK25=[];
for i=1:m
    if isempty(Part{i,1}.mesh.facesBoundary)% Beam boolean
        BoundaryNum=0;
        MatNum=Part{i, 1}.mesh.elementMaterialID;
        ETNum=Part{i, 1}.ET;
        [VTK,Cell_Part,Cell_Mat,Cell_ET]=CellFind(VTK,...
            Part{i,1}.mesh.elements+Part{i, 1}.acc_node-1,...
            1,...
            BoundaryNum,...
            Cell_Part,...
            i,...
            Cell_Mat,...
            MatNum,...
            Cell_ET,...
            ETNum);
    else
        BoundaryNum=size(Part{i,1}.mesh.facesBoundary,2);
        MatNum=Part{i, 1}.mesh.elementMaterialID;
        ETNum=Part{i, 1}.ET;
        [VTK,Cell_Part,Cell_Mat,Cell_ET]=CellFind(VTK,...
            Part{i,1}.mesh.elements+Part{i, 1}.acc_node-1,...
            0,...
            BoundaryNum,...
            Cell_Part,...
            i,...
            Cell_Mat,...
            MatNum,...
            Cell_ET,...
            ETNum);
    end
end

% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
fprintf(fid,'%16.9e\t%16.9e\t%16.9e\n',VV');
% Cells output
if Corner
    if ~isempty(VTK.VTK22)
        Temp=VTK.VTK22(:,1:4);
        Temp(:,1)=Temp(:,1)./6.*3;
        VTK.VTK5=[VTK.VTK5;Temp];
        VTK.VTK22=[];
    end

    if ~isempty(VTK.VTK25)
        Temp=VTK.VTK25(:,1:9);
        Temp(:,1)=Temp(:,1)./20.*8;
        VTK.VTK12=[VTK.VTK12;Temp];
        VTK.VTK25=[];
    end

    if ~isempty(VTK.VTK23)
        Temp=VTK.VTK23(:,1:5);
        Temp(:,1)=Temp(:,1)./8.*4;
        VTK.VTK9=[VTK.VTK9;Temp];
        VTK.VTK23=[];
    end

    if ~isempty(VTK.VTK24)
        Temp=VTK.VTK24(:,1:5);
        Temp(:,1)=Temp(:,1)./10.*4;
        VTK.VTK10=[VTK.VTK10;Temp];
        VTK.VTK24=[];
    end
end
TempNum=sum(structfun(@numel,VTK));
NumEL=sum(structfun(@(x)size(x,1),VTK));
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumEL)," ",num2str(TempNum)));
if ~isempty(VTK.VTK3)
    fprintf(fid,'%8i%8i%8i\n',VTK.VTK3');
end

if ~isempty(VTK.VTK5)
    fprintf(fid,'%8i%8i%8i%8i\n',VTK.VTK5');
end

if ~isempty(VTK.VTK9)
    fprintf(fid,'%8i%8i%8i%8i%8i\n',VTK.VTK9');
end

if ~isempty(VTK.VTK10)
    fprintf(fid,'%8i%8i%8i%8i%8i\n',VTK.VTK10');
end

if ~isempty(VTK.VTK12)
    fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',VTK.VTK12');
end

if ~isempty(VTK.VTK22)
        fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i\n',VTK.VTK22');
end

if ~isempty(VTK.VTK23)
    fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',VTK.VTK23');
end

if ~isempty(VTK.VTK24)
    fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',VTK.VTK24');
end

if ~isempty(VTK.VTK25)
    fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',VTK.VTK25');
end

% Cells types
fprintf(fid, '%s\n',strcat("CELL_TYPES ",num2str(NumEL)));
Temp=CellTypeFind(VTK);
fprintf(fid,'%8i\n',Temp');
if ~isempty(opt.CellData)
    fprintf(fid, '%s\n',strcat("CELL_DATA ",num2str(NumEL)));
    fprintf(fid, '%s\n',strcat('SCALARS Sensor_',num2str(Num),' float'));
    fprintf(fid, '%s\n','LOOKUP_TABLE default');
    CellData=opt.CellData(:,2);
    fprintf(fid,'%16.9e\n',CellData');
end

if or(~isempty(opt.PointData),~isempty(opt.PointVector))
    fprintf(fid, '%s\n',strcat("Point_DATA ",num2str(NumPoint)));
    % Get Used node
    NodeNum=GetUsedNode(VV,VTK,GetNNode(obj),opt.Cnode);
    Name=fieldnames(opt.PointData);

    % Point Data
    if ~isempty(opt.PointData)
        for i=1:size(Name,1)
            fprintf(fid, '%s\n',strcat("SCALARS ",Name{i,1},' float'));
            fprintf(fid, '%s\n','LOOKUP_TABLE default');
            Temp=zeros(NumPoint,1);
            Tempdata=getfield(opt.PointData,Name{i,1});
            Temp(NodeNum,:)=Tempdata;
            fprintf(fid,'%16.9e\n',Temp');
        end
    end
    % Point Vector
    if ~isempty(opt.PointVector)
        Name=fieldnames(opt.PointVector);
        for i=1:size(Name,1)
            fprintf(fid, '%s\n',strcat("VECTORS ",Name{i,1},' float'));
            Temp=zeros(NumPoint,3);
            Tempdata=getfield(opt.PointVector,Name{i,1});
            Temp(NodeNum,:)=Tempdata;
            fprintf(fid,'%16.9e%16.9e%16.9e\n',Temp');
        end
    end
end

if obj.Echo
    fprintf('Successfully output to VTK .\n');
end
end

function [VTK,Cell_Part,Cell_Mat,Cell_ET]=CellFind(VTK,elements,BooleanBeam,Bound,Cell_Part,PartNum,Cell_Mat,MatNum,Cell_ET,ETNum)
NumNode=size(elements,2);
switch NumNode
    case 2
        elements=[ones(size(elements,1),1)*2,elements(:,1:2)];
        VTK.VTK3=[VTK.VTK3;elements];
        Cell_Part.VTK3=[Cell_Part.VTK3;ones(size(elements,1),1)*PartNum];
        Cell_Mat.VTK3=[Cell_Mat.VTK3;MatNum];
        Cell_ET.VTK3=[Cell_ET.VTK3;ones(size(elements,1),1)*ETNum];

    case 3
        if BooleanBeam==1
            elements=[ones(size(elements,1),1)*2,elements(:,1:2)];
            VTK.VTK3=[VTK.VTK3;elements];
            Cell_Part.VTK3=[Cell_Part.VTK3;ones(size(elements,1),1)*PartNum];
            Cell_Mat.VTK3=[Cell_Mat.VTK3;MatNum];
            Cell_ET.VTK3=[Cell_ET.VTK3;ones(size(elements,1),1)*ETNum];
        else
            elements=[ones(size(elements,1),1)*3,elements];
            VTK.VTK5=[VTK.VTK5;elements];
            Cell_Part.VTK5=[Cell_Part.VTK5;ones(size(elements,1),1)*PartNum];
            Cell_Mat.VTK5=[Cell_Mat.VTK5;MatNum];
            Cell_ET.VTK5=[Cell_ET.VTK5;ones(size(elements,1),1)*ETNum];
        end
    case 4
        if Bound==2
            elements=[ones(size(elements,1),1)*4,elements];
            VTK.VTK9=[VTK.VTK9;elements];
            Cell_Part.VTK9=[Cell_Part.VTK9;ones(size(elements,1),1)*PartNum];
            Cell_Mat.VTK9=[Cell_Mat.VTK9;MatNum];
            Cell_ET.VTK9=[Cell_ET.VTK9;ones(size(elements,1),1)*ETNum];
        elseif Bound==3
            elements=[ones(size(elements,1),1)*4,elements];
            VTK.VTK10=[VTK.VTK10;elements];
            Cell_Part.VTK10=[Cell_Part.VTK10;ones(size(elements,1),1)*PartNum];
            Cell_Mat.VTK10=[Cell_Mat.VTK10;MatNum];
            Cell_ET.VTK10=[Cell_ET.VTK10;ones(size(elements,1),1)*ETNum];
        end
    case 6
        elements=[ones(size(elements,1),1)*6,elements];
        VTK.VTK22=[VTK.VTK22;elements];
        Cell_Part.VTK22=[Cell_Part.VTK22;ones(size(elements,1),1)*PartNum];
        Cell_Mat.VTK22=[Cell_Mat.VTK22;MatNum];
        Cell_ET.VTK22=[Cell_ET.VTK22;ones(size(elements,1),1)*ETNum];
    case 8
        if Bound==4
            elements=[ones(size(elements,1),1)*8,elements];
            VTK.VTK12=[VTK.VTK12;elements];
            Cell_Part.VTK12=[Cell_Part.VTK12;ones(size(elements,1),1)*PartNum];
            Cell_Mat.VTK12=[Cell_Mat.VTK12;MatNum];
            Cell_ET.VTK12=[Cell_ET.VTK12;ones(size(elements,1),1)*ETNum];
        elseif Bound==3
            elements=[ones(size(elements,1),1)*8,elements];
            VTK.VTK23=[VTK.VTK23;elements];
            Cell_Part.VTK23=[Cell_Part.VTK23;ones(size(elements,1),1)*PartNum];
            Cell_Mat.VTK23=[Cell_Mat.VTK23;MatNum];
            Cell_ET.VTK23=[Cell_ET.VTK23;ones(size(elements,1),1)*ETNum];
        end
    case 10
        elements=[ones(size(elements,1),1)*10,elements];
        VTK.VTK24=[VTK.VTK24;elements];
        Cell_Part.VTK24=[Cell_Part.VTK24;ones(size(elements,1),1)*PartNum];
        Cell_Mat.VTK24=[Cell_Mat.VTK24;MatNum];
        Cell_ET.VTK24=[Cell_ET.VTK24;ones(size(elements,1),1)*ETNum];
    case 20
        elements=[ones(size(elements,1),1)*20,elements];
        VTK.VTK25=[VTK.VTK25;elements];
        Cell_Part.VTK25=[Cell_Part.VTK25;ones(size(elements,1),1)*PartNum];
        Cell_Mat.VTK25=[Cell_Mat.VTK25;MatNum];
        Cell_ET.VTK25=[Cell_ET.VTK25;ones(size(elements,1),1)*ETNum];
end
end

function CellType=CellTypeFind(VTK)
Num=structfun(@(x)size(x,1),VTK);
CellType=[];
if Num(1,1)~=0
    CellType=[CellType;ones(Num(1,1),1)*3];
end

if Num(2,1)~=0
    CellType=[CellType;ones(Num(2,1),1)*5];
end

if Num(3,1)~=0
    CellType=[CellType;ones(Num(3,1),1)*9];
end

if Num(4,1)~=0
    CellType=[CellType;ones(Num(4,1),1)*10];
end

if Num(5,1)~=0
    CellType=[CellType;ones(Num(5,1),1)*12];
end

if Num(6,1)~=0
    CellType=[CellType;ones(Num(6,1),1)*22];

end

if Num(7,1)~=0
    CellType=[CellType;ones(Num(7,1),1)*23];
end

if Num(8,1)~=0
    CellType=[CellType;ones(Num(8,1),1)*24];
end

if Num(9,1)~=0
    CellType=[CellType;ones(Num(9,1),1)*25];
end
end

function NodeNum=GetUsedNode(VV,VTK,totalNum,Cnode)
Node=structfun(@(x)unique(x(:,2:end),'sorted'),VTK,'UniformOutput', false);
Node=struct2cell(Node);
Node=cell2mat(Node);
Node=unique(Node,'sorted')+1;
NodeNum=(1:size(VV,1))';
NodeNum=NodeNum(Node,:);

if totalNum<size(VV,1)
    if Cnode
        Temp=totalNum+1:1:size(VV,1);
        NodeNum=[NodeNum;Temp'];
    end
end
end

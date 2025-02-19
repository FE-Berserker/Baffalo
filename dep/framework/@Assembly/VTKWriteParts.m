function VTKWriteParts(obj,varargin)
% Print VTK file
% Author : Xie Yu
% p=inputParser;
% addParameter(p,'seperate',0);
% parse(p,varargin{:});
% opt=p.Results;

fprintf('Start output to VTK\n');

%% Parameter
VV=[obj.V;obj.Cnode];
NumPoint=size(VV,1);
[m,~]=size(obj.Part);

%% VTK output
filename=strcat('.\Parts.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');
% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
fprintf(fid,'%16.9e\t%16.9e\t%16.9e\n',VV');

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
    if isempty(obj.Part{i,1}.mesh.facesBoundary)% Beam boolean
        BoundaryNum=0;
        MatNum=obj.Part{i, 1}.mesh.elementMaterialID;
        ETNum=obj.Part{i, 1}.ET;
        [VTK,Cell_Part,Cell_Mat,Cell_ET]=CellFind(VTK,...
            obj.Part{i,1}.mesh.elements+obj.Part{i, 1}.acc_node-1,...
            1,...
            BoundaryNum,...
            Cell_Part,...
            i,...
            Cell_Mat,...
            MatNum,...
            Cell_ET,...
            ETNum);
    else
        BoundaryNum=size(obj.Part{i,1}.mesh.facesBoundary,2);
        MatNum=obj.Part{i, 1}.mesh.elementMaterialID;
        ETNum=obj.Part{i, 1}.ET;
        [VTK,Cell_Part,Cell_Mat,Cell_ET]=CellFind(VTK,...
            obj.Part{i,1}.mesh.elements+obj.Part{i, 1}.acc_node-1,...
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

% Cells output
Num=sum(structfun(@numel,VTK));
NumEL=sum(structfun(@(x)size(x,1),VTK));
fprintf(fid, '%s\n',strcat("CELLS ",num2str(NumEL)," ",num2str(Num)));
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
% Cell data
fprintf(fid, '%s\n',strcat("CELL_DATA ",num2str(NumEL)));
fprintf(fid, '%s\n','SCALARS Part_Num float');
fprintf(fid, '%s\n','LOOKUP_TABLE default');
Cell_Part=struct2cell(Cell_Part);
Cell_Part=cell2mat(Cell_Part);
fprintf(fid,'%16.9e\n',Cell_Part');

fprintf(fid, '%s\n','SCALARS Mat_Num float');
fprintf(fid, '%s\n','LOOKUP_TABLE default');
Cell_Mat=struct2cell(Cell_Mat);
Cell_Mat=cell2mat(Cell_Mat);
fprintf(fid,'%16.9e\n',Cell_Mat');

fprintf(fid, '%s\n','SCALARS ET_Num float');
fprintf(fid, '%s\n','LOOKUP_TABLE default');
Cell_ET=struct2cell(Cell_ET);
Cell_ET=cell2mat(Cell_ET);
fprintf(fid,'%16.9e\n',Cell_ET');
fclose(fid);
fprintf('Successfully output to VTK\n');
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
    CellType=[CellType;ones(Num(1,1),1)*24];
end

if Num(9,1)~=0
    CellType=[CellType;ones(Num(1,1),1)*25];
end
end
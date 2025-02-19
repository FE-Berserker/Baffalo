function PartNumber=VTKWriteParts2(obj,varargin)
% Print seperated VTK file
% Author : Xie Yu

% p=inputParser;
% addParameter(p,'seperate',0);
% parse(p,varargin{:});
% opt=p.Results;

fprintf('Start output to VTK\n');
%% Parameter
PartNumber=[];
pre=0;
for i=1:size(obj.Part,1)
    post=obj.Part{i,1}.New;
    if post==0
        [VTK,fid]=IntialPart(obj,i);
        pre=post;
        PartNumber=[PartNumber;i]; %#ok<AGROW>

        if isempty(obj.Part{i,1}.mesh.facesBoundary)% Beam boolean
            BoundaryNum=0;
            VTK=CellFind(VTK,...
                obj.Part{i,1}.mesh.elements-1,...
                1,...
                BoundaryNum);
        else
            BoundaryNum=size(obj.Part{i,1}.mesh.facesBoundary,2);
            VTK=CellFind(VTK,...
                obj.Part{i,1}.mesh.elements-1,...
                0,...
                BoundaryNum);
        end

        Celloutput(VTK,fid);

    elseif and(pre==0,post==1)
        [VTK,fid]=IntialPart(obj,i);
        pre=post;
        PartNumber=[PartNumber;i]; %#ok<AGROW>
    elseif and(pre==1,post==1)
        pre=post;
        pre_acc=obj.Part{i-1,1}.acc_node;
        post_acc=obj.Part{i,1}.acc_node;

        if pre_acc~=post_acc
            Celloutput(VTK,fid);
            [VTK,fid]=IntialPart(obj,i);
            PartNumber=[PartNumber;i]; %#ok<AGROW>
        end

        if isempty(obj.Part{i,1}.mesh.facesBoundary)% Beam boolean
            BoundaryNum=0;
            VTK=CellFind(VTK,...
                obj.Part{i,1}.mesh.elements-1,...
                1,...
                BoundaryNum);
        else
            BoundaryNum=size(obj.Part{i,1}.mesh.facesBoundary,2);
            VTK=CellFind(VTK,...
                obj.Part{i,1}.mesh.elements-1,...
                0,...
                BoundaryNum);
        end

        if i==size(obj.Part,1)
            Celloutput(VTK,fid);
        else
            PPost=obj.Part{i+1,1}.New;
            if PPost==0
                Celloutput(VTK,fid);
            end
        end
    end
end
fprintf('Successfully output to VTK\n');
end

function VTK=CellFind(VTK,elements,BooleanBeam,Bound)
NumNode=size(elements,2);
switch NumNode
    case 2
        elements=[ones(size(elements,1),1)*2,elements(:,1:2)];
        VTK.VTK3=[VTK.VTK3;elements];
    case 3
        if BooleanBeam==1
            elements=[ones(size(elements,1),1)*2,elements(:,1:2)];
            VTK.VTK3=[VTK.VTK3;elements];
        else
            elements=[ones(size(elements,1),1)*3,elements];
            VTK.VTK5=[VTK.VTK5;elements];
        end
    case 4
        if Bound==2
            elements=[ones(size(elements,1),1)*4,elements];
            VTK.VTK9=[VTK.VTK9;elements];
        elseif Bound==3
            elements=[ones(size(elements,1),1)*4,elements];
            VTK.VTK10=[VTK.VTK10;elements];
        end
    case 6
        elements=[ones(size(elements,1),1)*6,elements];
        VTK.VTK22=[VTK.VTK22;elements];
    case 8
        if Bound==4
            elements=[ones(size(elements,1),1)*8,elements];
            VTK.VTK12=[VTK.VTK12;elements];
        elseif Bound==3
            elements=[ones(size(elements,1),1)*8,elements];
            VTK.VTK23=[VTK.VTK23;elements];
        end
    case 10
        elements=[ones(size(elements,1),1)*10,elements];
        VTK.VTK24=[VTK.VTK24;elements];
    case 20
        elements=[ones(size(elements,1),1)*20,elements];
        VTK.VTK25=[VTK.VTK25;elements];
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

function Celloutput(VTK,fid)
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
end

function [VTK,fid]=IntialPart(obj,Num)
VTK.VTK3=[];
VTK.VTK5=[];
VTK.VTK9=[];
VTK.VTK10=[];
VTK.VTK12=[];
VTK.VTK22=[];
VTK.VTK23=[];
VTK.VTK24=[];
VTK.VTK25=[];
filename=strcat('.\Part',num2str(Num),'.vtk');
fid=fopen(filename,'w');
fprintf(fid, '%s\n','# vtk DataFile Version 2.0');
fprintf(fid, '%s\n',obj.Name);
fprintf(fid, '%s\n','ASCII');
fprintf(fid, '%s\n','DATASET UNSTRUCTURED_GRID');

VV=obj.Part{Num, 1}.mesh.nodes;
NumPoint=size(VV,1);

% Points output
fprintf(fid, '%s\n',strcat("POINTS ",num2str(NumPoint),' float'));
fprintf(fid,'%16.9e\t%16.9e\t%16.9e\n',VV');
end
function obj=OutputAss(obj)
% Output Beam assembly
% Author : Xie Yu
ny=obj.input.ny;
nx=obj.input.nx;

Seq1=1:nx;
Temp=0:ny-1;
Seq1=repmat(Seq1,ny,1);
Temp=repmat(Temp',1,nx);
Seq1=Seq1+Temp*nx;


% Author : Xie Yu
Ass=Assembly(obj.params.Name,'Echo',0);
% Create Shaft
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.BeamMesh.Meshoutput,'position',position);
% Material
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);
% Section
Section=obj.params.Section;
switch obj.params.Type
    case 1
        Section{5,1}=Section{4,1};
    case 2
        Section{5,1}=Section{4,1};
    case 3
        Section{4,1}=Section{3,1};
    case 4
        Section{4,1}=Section{3,1};
end
% ET
switch obj.params.JointType
    case 0
        Ass=DividePart(Ass,1,obj.output.Matrix);
        for i=1:size(obj.output.Matrix,1)
            Ass=AddSection(Ass,Section{i,1});
            Area=GetSectionData(Ass,i);
            ET.name='180';
            ET.opt=[];
            ET.R=Area;
            Ass=AddET(Ass,ET);
            Ass=SetET(Ass,i,i);
        end
    case 1
        ET.name='188';ET.opt=[3,2];ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Ass=BeamK(Ass,1);
        Ass=DividePart(Ass,1,obj.output.Matrix);
        for i=1:size(obj.output.Matrix,1)
            Ass=AddSection(Ass,Section{i,1});
            Ass=SetSection(Ass,i,i);
        end
end



% Load
if ~isempty(obj.input.VLoad)
    Load=[0,0,-obj.input.VLoad,0,0,0];
    switch obj.params.LoadPosition
        case 1
            Temp=Ass.Part{1, 1}.mesh.elements(:,1:2);
            TempNo=unique(Temp);
            Ass=AddLoad(Ass,1,'No',TempNo);
            Ass=SetLoad(Ass,1,Load);
        case 2
            Temp=Ass.Part{2, 1}.mesh.elements(:,1:2);
            TempNo=unique(Temp);
            Ass=AddLoad(Ass,1,'No',TempNo);
            Ass=SetLoad(Ass,1,Load);
    end
end

if ~isempty(obj.input.PLoad)
    p=obj.input.PLoad;
    switch obj.params.LoadPosition
        case 1
            Temp=Ass.Part{1, 1}.mesh.elements(:,1:2);
            TempNo=unique(Temp);
            for j=1:size(TempNo,1)
                Ass=AddNodeMass(Ass,1,TempNo(j,1),[p,p,p,0,0,0]/9800);
            end
        case 2
            Temp=Ass.Part{2, 1}.mesh.elements(:,1:2);
            TempNo=unique(Temp);
            for j=1:size(TempNo,1)
                Ass=AddNodeMass(Ass,1,TempNo(j,1),[p,p,p,0,0,0]/9800);
            end
    end
end

% Boundary
if ~isempty(obj.params.Boundary)
    for i=1:size(obj.params.Boundary,1)
        switch obj.params.BoundaryType
            case 0
                Bound=[1,1,1,0,0,0];
            case 1
                Bound=[1,1,1,1,1,1];
        end
        if obj.params.Boundary(i,1)==1
            TempSeq=Seq1([1,end],:);
            Ass=AddBoundary(Ass,1,'No',reshape(TempSeq',[],1));
            Ass=SetBoundaryType(Ass,i,Bound);
        end
        if obj.params.Boundary(i,1)==2
            TempSeq=Seq1(:,[1,end]);
            Ass=AddBoundary(Ass,1,'No',reshape(TempSeq,[],1));
            Ass=SetBoundaryType(Ass,i,Bound);
        end
    end
end

% Solution
opt.ANTYPE=0;
if obj.params.Gravity
    opt.ACEL=[0,0,9800];
end
AddSolu(Ass,opt);

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output grid mesh assembly .\n');
end
end


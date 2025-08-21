function obj=OutputAss(obj)
% Output Beam assembly
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



% Variable load
if ~isempty(obj.input.VP)
    f=obj.input.f;
    L=obj.input.span;
    nx=obj.input.nx;
    kn=obj.input.kn;
    p=obj.input.VP;
    R=(f^2+L^2/4)/2/f;
    
    alpha=asin(L/2/R)/nx;
    alpha=nx*alpha:-alpha:alpha;
    x=R.*sin(alpha);
    switch obj.params.Type
        case 1
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                Load=[0,0,-p*A,0,0,0];
                TempNo=kn*(i-1)+1:kn*i;
                Ass=AddLoad(Ass,1,'No',TempNo');
                Ass=SetLoad(Ass,i,Load);
            end
            A=pi*r2^2;
            Load=[0,0,-p*A,0,0,0];
            TempNo=kn*nx+1;
            Ass=AddLoad(Ass,1,'No',TempNo');
            Ass=SetLoad(Ass,nx+1,Load);
        case 2
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                Load=[0,0,-p*A,0,0,0];
                TempNo=kn*(i-1)+1:kn*i;
                Ass=AddLoad(Ass,1,'No',TempNo');
                Ass=SetLoad(Ass,i,Load);
            end
            A=pi*r2^2;
            Load=[0,0,-p*A,0,0,0];
            TempNo=kn*nx+1;
            Ass=AddLoad(Ass,1,'No',TempNo');
            Ass=SetLoad(Ass,nx+1,Load);
        case 3
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                Load=[0,0,-p*A,0,0,0];
                TempNo=kn*(i-1)+1:kn*i;
                Ass=AddLoad(Ass,1,'No',TempNo');
                Ass=SetLoad(Ass,i,Load);
            end
            A=pi*r2^2;
            Load=[0,0,-p*A,0,0,0];
            TempNo=kn*nx+1;
            Ass=AddLoad(Ass,1,'No',TempNo');
            Ass=SetLoad(Ass,nx+1,Load);
        case 4
            acc=0;
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                Load=[0,0,-p*A,0,0,0];
                TempNo=acc+1:acc+kn*(nx-i+1);
                Ass=AddLoad(Ass,1,'No',TempNo');
                Ass=SetLoad(Ass,i,Load);
                acc=acc+kn*(nx-i+1);
            end
            A=pi*r2^2;
            Load=[0,0,-p*A,0,0,0];
            TempNo=acc+1;
            Ass=AddLoad(Ass,1,'No',TempNo');
            Ass=SetLoad(Ass,nx+1,Load);
    end
end
% Permanent load
if ~isempty(obj.input.PP)
    f=obj.input.f;
    L=obj.input.span;
    nx=obj.input.nx;
    kn=obj.input.kn;
    p=obj.input.PP;
    R=(f^2+L^2/4)/2/f;
    
    alpha=asin(L/2/R)/nx;
    alpha=nx*alpha:-alpha:alpha;
    x=R.*sin(alpha);
    switch obj.params.Type
        case 1
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                TempNo=kn*(i-1)+1:kn*i;
                for j=1:size(TempNo,2)
                    Ass=AddNodeMass(Ass,1,TempNo(j),[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
                end
            end
            A=pi*r2^2;
            TempNo=kn*nx+1;
            Ass=AddNodeMass(Ass,1,TempNo,[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
        case 2
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                TempNo=kn*(i-1)+1:kn*i;
                for j=1:size(TempNo,2)
                    Ass=AddNodeMass(Ass,1,TempNo(j),[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
                end
            end
            A=pi*r2^2;
            TempNo=kn*nx+1;
            Ass=AddNodeMass(Ass,1,TempNo,[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
        case 3
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                TempNo=kn*(i-1)+1:kn*i;
                for j=1:size(TempNo,2)
                    Ass=AddNodeMass(Ass,1,TempNo(j),[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
                end
            end
            A=pi*r2^2;
            TempNo=kn*nx+1;
            Ass=AddNodeMass(Ass,1,TempNo,[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
        case 4
            acc=0;
            for i=1:nx
                if i==1
                    r1=x(1);
                    r2=(x(2)+x(1))/2;
                elseif i==nx
                    r1=(x(nx)+x(nx-1))/2;
                    r2=x(nx)/2;
                else
                    r1=(x(i-1)+x(i))/2;
                    r2=(x(i)+x(i+1))/2;
                end
                A=pi*(r1^2-r2^2);
                TempNo=acc+1:acc+kn*(nx-i+1);
                for j=1:size(TempNo,2)
                    Ass=AddNodeMass(Ass,1,TempNo(j),[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
                end
                acc=acc+kn*(nx-i+1);
            end
            A=pi*r2^2;
            TempNo=acc+1;
            Ass=AddNodeMass(Ass,1,TempNo,[p*A/kn,p*A/kn,p*A/kn,0,0,0]/9800);
    end
end



% Boundary

switch obj.params.BoundaryType
    case 0
        Bound=[1,1,1,0,0,0];
    case 1
        Bound=[1,1,1,1,1,1];
end

switch obj.params.Type
    case 1
        NodeNum=(1:obj.input.kn)';
    case 2
        NodeNum=(1:obj.input.kn)';
    case 3
        NodeNum=(1:obj.input.kn)';
    case 4
        NodeNum=(1:obj.input.kn*obj.input.nx)';
end

Ass=AddBoundary(Ass,1,'No',NodeNum);
Ass=SetBoundaryType(Ass,1,Bound);


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
    fprintf('Successfully output shell grid mesh assembly .\n');
end
end



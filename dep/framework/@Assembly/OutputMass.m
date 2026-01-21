function MassTable = OutputMass(obj,varargin)
% Output mass
% Author : Xie Yu
p=inputParser;
addParameter(p,'Axis',[]);
addParameter(p,'Seg',100);
addParameter(p,'Scope',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.Axis)
    % Output mass by part
    PartNum=obj.Summary.Total_Part;
    PartName=[];
    PartMass=[];
    for i=1:PartNum
        ETNo=obj.Part{i, 1}.ET;
        if isempty(ETNo)
            warning(strcat("Part",num2str(i)," is not defined !"))
            continue
        end
        ETType=obj.ET{ETNo,1}.name;

        PartName=[PartName;strcat("Part",num2str(i))]; %#ok<AGROW>
        Mass=0;
        switch ETType
            case '45'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [V_hexa ,~,~] = MeshVolume(Node,El);
                    Mass=Dens*V_hexa;
                end

            case '181'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [A_tri ,~,~] = MeshArea(Node,El);
                    SecNo=obj.Part{i, 1}.Sec;
                    SecData=obj.Section{SecNo, 1}.data; 
                    Mass=Dens*A_tri*sum(SecData(:,1));
                end
            case '281'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [A_tri ,~,~] = MeshArea(Node,El);
                    SecNo=obj.Part{i, 1}.Sec;
                    SecData=obj.Section{SecNo, 1}.data;
                    Mass=Dens*A_tri*sum(SecData(:,1));
                end
            case '185'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [V_hexa ,~,~] = MeshVolume(Node,El);
                    Mass=Dens*V_hexa;
                end

            case '186'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{1, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [V_hexa ,~,~] = MeshVolume(Node,El);
                    Mass=Dens*V_hexa;
                end
            case '188'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [Length_beam ,~,~] = MeshLength(Node,El);
                    SecNo=obj.Part{i, 1}.Sec;
                    A_sec=GetSectionData(obj,SecNo);
                    Mass=Dens*A_sec*Length_beam;
                end

        end
        PartMass=[PartMass;Mass]; %#ok<AGROW>
    end
    % Cnode

    MassTable=table(PartName,PartMass);

else
    V=[obj.V;obj.Cnode];
    V(obj.BeamDirectionNode,:)=[];
    % Output mass by length

    if isempty(opt.Scope)
        switch opt.Axis
            case 'x'
                Scope=[min(V(:,1)),max(V(:,1))];
            case 'y'
                Scope=[min(V(:,2)),max(V(:,2))];
            case 'z'
                Scope=[min(V(:,3)),max(V(:,3))];
        end
    else
        Scope=opt.Scope;
    end

    Seg=opt.Seg;

    xx=linspace(Scope(1),Scope(2),Seg+1);

    PartNum=obj.Summary.Total_Part;
    PartName=(xx(2:end)/2+xx(1:end-1)/2)';
    ElMass=[];
    ElCenter=[];
    for i=1:PartNum
        ETNo=obj.Part{i, 1}.ET;
        if isempty(ETNo)
            warning(strcat("Part",num2str(i)," is not defined !"))
            continue
        end
        ETType=obj.ET{ETNo,1}.name;
        switch ETType
            case '45'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [~ ,Vc,Vel] = MeshVolume(Node,El);
                    ElMass=[ElMass;Dens*Vel]; %#ok<AGROW>
                    ElCenter=[ElCenter;Vc]; %#ok<AGROW>
                end
            case '181'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [~ ,Ac,Ael] = MeshArea(Node,El);
                    SecNo=obj.Part{i, 1}.Sec;
                    SecData=obj.Section{SecNo, 1}.data;
                    ElMass=[ElMass;Dens*Ael*sum(SecData(:,1))]; %#ok<AGROW>
                    ElCenter=[ElCenter;Ac]; %#ok<AGROW>
                end
            case '281'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [~ ,Ac,Ael] = MeshArea(Node,El);
                    SecNo=obj.Part{i, 1}.Sec;
                    SecData=obj.Section{SecNo, 1}.data;
                    ElMass=[ElMass;Dens*Ael*sum(SecData(:,1))]; %#ok<AGROW>
                    ElCenter=[ElCenter;Ac]; %#ok<AGROW>
                end
            case '185'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [~ ,Vc,Vel] = MeshVolume(Node,El);
                    ElMass=[ElMass;Dens*Vel]; %#ok<AGROW>
                    ElCenter=[ElCenter;Vc]; %#ok<AGROW>
                end

            case '186'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{1, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [~,Vc,Vel] = MeshVolume(Node,El);
                    ElMass=[ElMass;Dens*Vel]; %#ok<AGROW>
                    ElCenter=[ElCenter;Vc]; %#ok<AGROW>
                end
            case '188'
                MatNo=obj.Part{i, 1}.mesh.elementMaterialID(1,1);
                row=find(obj.Material{MatNo, 1}.table(:,1)=='DENS');
                if ~isempty(row)
                    Dens=str2double(obj.Material{MatNo, 1}.table(row,2));
                    Node=obj.Part{i, 1}.mesh.nodes;
                    El=obj.Part{i, 1}.mesh.elements;
                    [~,Lc,Lel] = MeshLength(Node,El);
                    SecNo=obj.Part{i, 1}.Sec;
                    A_sec=GetSectionData(obj,SecNo);
                    ElMass=[ElMass;Dens*Lel*A_sec]; %#ok<AGROW>
                    ElCenter=[ElCenter;Lc]; %#ok<AGROW>
                end

        end


    end

    % Cnode
    switch opt.Axis
        case 'x'
            ElCenter=ElCenter(:,1);
        case 'y'
            ElCenter=ElCenter(:,2);
        case 'z'
            ElCenter=ElCenter(:,3);
    end
    PartMass=SortMass(xx,ElMass,ElCenter);
    MassTable=table(PartName,PartMass);


end

end

function Mass=SortMass(xx,ElMass,ElCenter)
edges = xx;
[~,~,bins] = histcounts(ElCenter,edges);
Mass=zeros(size(xx,2)-1,1);
for i=1:size(xx,2)-1
    Mass(i,1)=sum(ElMass(bins==i,1));
end
end
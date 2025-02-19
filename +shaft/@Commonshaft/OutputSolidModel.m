function obj=OutputSolidModel(obj)
% Output solid model of commonshaft
% Author : Xie Yu

if isempty(obj.input.Meshsize)
    obj.input.Meshsize=min(min(obj.input.OD))/10;
end
%% ID ~= 0
if min(min(obj.input.ID))~=0
     mm=CreateMesh3D2(obj);
end
%% ID = 0
if min(min(obj.input.ID))==0
    Temp=sum(obj.input.ID,2);
    [row,~]=find(Temp==0,1);
    if size(obj.input.Length,1)~=1
        if row==1
            r1=obj.input.OD(row,1)/2;
        else
            r1=obj.input.ID(row-1,2)/2;
        end
    else
        r1=obj.input.OD(row,1)/2;
        r2=obj.input.OD(row,2)/2;
    end

    mm=Mesh('Mesh2','Echo',0);
    if size(obj.input.Length,1)~=1
        if row==1
            mm=CreateMesh3D3(obj,mm,r1);
        else
            mm=CreateMesh3D4(obj,mm,r1,row);
        end

    else
        mm=CreateMesh3D1(obj,mm,r1,r2);
    end
    mm=Mesh3D(mm); % Mesh model using tetrahedral elements using tetGen
end

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% Prase
mm.Cb=mm.Meshoutput.boundaryMarker;  
mm.Face=mm.Meshoutput.facesBoundary;
mm.Vert=mm.Meshoutput.nodes;
obj.output.SolidMesh=mm;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end
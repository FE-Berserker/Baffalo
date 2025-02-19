function obj=DividePart(obj,partnum,matrix)
% Divide one part to several parts
% Author : Xie Yu
mm=size(matrix,1);
Npart=GetNPart(obj);
Temp_part=cell(mm+Npart-1,1);

if partnum~=1
Temp_part=obj.Part(1:partnum-1,1);
end

acc=obj.Part{partnum,1}.acc_el;
for i=1:mm
    Temp=obj.Part{partnum,1};
    Temp.mesh.elements=Temp.mesh.elements(matrix{i,1}',:);
    [Faceboundary,~]=element2patch(Temp.mesh.elements);
    Temp.mesh.facesBoundary_new=Faceboundary;
    Temp.mesh.boundaryMarker_new=ones(size(Faceboundary,1),1); 
    Temp.NumElements=size(Temp.mesh.elements,1);
    Temp.mesh.elementMaterialID=ones(size(Temp.mesh.elements,1),1);
    Temp.acc_el=acc;
    Temp.New=1;
    Temp_part{partnum-1+i,1}=Temp;
    acc=acc+size(Temp.mesh.elements,1);
end

if partnum~=Npart
Temp_part(partnum+mm:Npart+mm-1,1)=obj.Part(partnum+1:Npart,1);
end

obj.Part=Temp_part;

%% Parse
obj.Summary.Total_Part=GetNPart(obj);

%% Print
if obj.Echo
    fprintf('Successfully divide part . \n');
end
end


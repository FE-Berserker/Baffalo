function obj = DelNullElement(obj)
% Delete Null elements
% Author : Xie Yu
%% Find Null Node
row1=isnan(sum(obj.Vert,2));
Nodenum=(1:size(obj.Vert,1))';
NullNode=Nodenum(row1,:);

NullEl=zeros(size(obj.El,1),1);

for i=1:numel(NullNode)
    [row2,~]=find(obj.El==NullNode(i,1));
    NullEl(row2,:)=1;
end
%% Calculate Node Num change
Nodechange=tril(ones(size(Nodenum,1)))*row1;
obj.Vert=obj.Vert(~row1,:);
obj.El=obj.El(~logical(NullEl),:);

row3=find(Nodechange>0,1);
Temp_change=zeros(size(obj.El,1),size(obj.El,2));

for i=row3:numel(Nodechange)
    [row4,col4]=find(obj.El==i);
    for j=1:numel(row4)
        Temp_change(row4(j,1),col4(j,1))=-Nodechange(i,1);
    end
end

obj.El=obj.El+Temp_change;

%% Calculate elements faces
obj.Meshoutput.nodes=obj.Vert;
obj.Meshoutput.elements=obj.El;
[obj.Meshoutput.faces,~]=element2patch(obj.Meshoutput.elements,...
    (1:1:size(obj.Meshoutput.elements,1))');
[indFree]=freeBoundaryPatch(obj.Meshoutput.faces);
obj.Meshoutput.facesBoundary=obj.Meshoutput.faces(indFree,:);

Temp=obj.Meshoutput.facesBoundary;
obj.Meshoutput.facesBoundary=obj.Meshoutput.facesBoundary(~and(Temp(:,1)==Temp(:,2),Temp(:,3)==Temp(:,4)),:);



faceBoundaryMarker=zeros(size(obj.Meshoutput.facesBoundary,1),1)+1;

obj.Meshoutput.boundaryMarker=faceBoundaryMarker;
obj.Meshoutput.elementMaterialID=ones(size(obj.Meshoutput.elements,1),1);
obj.Meshoutput.faceMaterialID=ones(size(obj.Meshoutput.faces,1),1);

obj.Face=obj.Meshoutput.facesBoundary; %The boundary faces
obj.Cb=obj.Meshoutput.boundaryMarker; %The "colors" or labels for the boundary faces

%% Print
if obj.Echo
    fprintf('Successfully delete null elements .\n');
end

end


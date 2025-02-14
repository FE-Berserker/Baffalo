function obj=Meshoutput(obj)
% Output line2D to Mesh
% Author : Xie Yu
P=obj.Point.P;
PP=obj.Point.PP;
nodes=[P,zeros(size(P,1),1)];
elements=[];
for i=1:size(PP,1)
    Temp=PP{i,1};
    Temp_elements=NaN(size(Temp,1)-1,2);
    for j=1:size(Temp,1)-1
        dis=nodes(:,1:2)-repmat(Temp(j,:),size(nodes,1),1);
        dis=sum(dis.^2,2);
        Temp_elements(j,1)=find(dis==0);
        dis=nodes(:,1:2)-repmat(Temp(j+1,:),size(nodes,1),1);
        dis=sum(dis.^2,2);
        Temp_elements(j,2)=find(dis==0);
    end
    elements=[elements;Temp_elements]; %#ok<AGROW> 
end
elementMaterialID=ones(size(elements,1),1);
% Assignment
obj.Meshoutput.nodes=nodes;
obj.Meshoutput.elements=elements;
obj.Meshoutput.elementMaterialID=elementMaterialID;
obj.Meshoutput.faces=[];
obj.Meshoutput.facesBoundary=[];
obj.Meshoutput.boundaryMarker=(1:size(nodes,1))';
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;
end


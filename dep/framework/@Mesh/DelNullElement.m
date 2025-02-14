function obj = DelNullElement(obj)
% Delete Null elements
% Author : Xie Yu
%% Find Null Node
row1=isnan(sum(obj.Vert,2));
Nodenum=(1:size(obj.Vert,1))';
NullNode=Nodenum(row1,:);
NullEl=zeros(size(obj.Face,1),1);

for i=1:numel(NullNode)
    [row2,~]=find(obj.Face==NullNode(i,1));
    NullEl(row2,:)=1;
end
%% Calculate Node Num change
Nodechange=tril(ones(size(Nodenum,1)))*row1;
obj.Vert=obj.Vert(~row1,:);
obj.Face=obj.Face(~logical(NullEl),:);
row3=find(Nodechange>0,1);
Temp_change=zeros(size(obj.Face,1),4);
for i=row3:numel(Nodechange)
    [row4,col4]=find(obj.Face==i);
    for j=1:numel(row4)
        Temp_change(row4(j,1),col4(j,1))=-Nodechange(i,1);
    end
end

obj.Face=obj.Face+Temp_change;
obj.Cb=ones(size(obj.Face,1),1);

%% Print
if obj.Echo
    fprintf('Successfully delete null elements .\n');
end

end


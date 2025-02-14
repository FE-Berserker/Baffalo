function Center = CenterCal(obj)
% calculate center of elements
% Author : Xie Yu
elements=obj.Face;
nodes=obj.Vert;
numel=size(elements,1);
Center=zeros(numel,2);
for i=1:numel
    Temp_n=elements(i,:);
    nn=nodes(Temp_n',:);
    Center(i,:)=mean(nn);
end

end

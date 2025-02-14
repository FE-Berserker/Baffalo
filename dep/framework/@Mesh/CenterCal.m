function Center = CenterCal(obj)
% Calculate center of elements
% Author : Xie Yu
elements=obj.Meshoutput.elements;
nodes=obj.Meshoutput.nodes;
numel=size(elements,1);
Center=zeros(numel,3);
for i=1:numel
    Temp_n=elements(i,:);
    nn=nodes(Temp_n',:);
    Center(i,:)=mean(nn);
end

end

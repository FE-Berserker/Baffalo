function Center =patchcenter(nodes,elements)
% Get center of elements
% Author : Xie Yu
numel=size(elements,1);
Center=zeros(numel,3);
for i=1:numel
    Temp_n=elements(i,:);
    nn=nodes(Temp_n',:);
    Center(i,:)=mean(nn);
end
end
function [LL ,Lc, Lel] = MeshLength(Node,El)
% Mesh area
% Author : Xie Yu

LL=0;
Length=size(El,2);
switch Length
    case 3
        El=El(:,1:2);
end

Lel=zeros(size(El,1),1);
Lc=zeros(size(El,1),3);

for i=1:size(El,1)
    nodes=Node(El(i,1:2)',:);
    x1=nodes(1,1);
    y1=nodes(1,2);
    z1=nodes(1,3);
    x2=nodes(2,1);
    y2=nodes(2,2);
    z2=nodes(2,3);
    l1=sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2);

    LL =LL+ l1;
    Lel(i,:)=l1;
    Lc(i,:)=(nodes(1,:)+nodes(2,:))/2;
end

end


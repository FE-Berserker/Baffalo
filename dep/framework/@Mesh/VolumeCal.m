function V = VolumeCal(obj)
% Calculate volume of mesh
% Author : Xie Yu
elements=obj.meshoutput.elements;
nodes=obj.meshoutput.nodes;
numel=size(elements,1);
V=zeros(numel,1);
NodeNum=size(elements,2);
switch NodeNum
    case 8
        for i=1:numel
            Temp_n=elements(i,:);
            nn=nodes(Temp_n',:);
            V1=volume(nn(1,:),nn(2,:),nn(4,:),nn(5,:));
            V2=volume(nn(2,:),nn(4,:),nn(5,:),nn(6,:));
            V3=volume(nn(4,:),nn(5,:),nn(6,:),nn(8,:));
            V4=volume(nn(2,:),nn(3,:),nn(4,:),nn(6,:));
            V5=volume(nn(3,:),nn(6,:),nn(7,:),nn(8,:));
            V6=volume(nn(4,:),nn(6,:),nn(7,:),nn(8,:));
            V(i,:)=V1+V2+V3+V4+V5+V6;
        end
    case 4
        for i=1:numel
            Temp_n=elements(i,:);
            nn=nodes(Temp_n',:);
            V1=volume(nn(1,:),nn(2,:),nn(3,:),nn(4,:));
            V(i,:)=V1;
        end
    case 6
        for i=1:numel
            Temp_n=elements(i,:);
            nn=nodes(Temp_n',:);
            V1=volume(nn(1,:),nn(2,:),nn(3,:),nn(4,:));
            V2=volume(nn(2,:),nn(3,:),nn(4,:),nn(5,:));
            V3=volume(nn(3,:),nn(4,:),nn(5,:),nn(6,:));
            V(i,:)=V1+V2+V3;
        end

end
end


function v = volume(a,b,c,d)
h = [b-a;c-a;d-a];
v = abs(det(h))/6;
end
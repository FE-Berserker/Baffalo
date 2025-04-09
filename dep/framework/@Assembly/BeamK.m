function obj=BeamK(obj,Numpart,varargin)
% Generate Nodes between original nodes
% Author : Xie Yu
p=inputParser;
addParameter(p,'rot',0);
addParameter(p,'factor',1);
parse(p,varargin{:});
opt=p.Results;

Node=obj.Part{Numpart,1}.mesh.nodes;
Mesh=obj.Part{Numpart,1}.mesh.elements;
Nodei=Node(Mesh(:,1)',:);
Nodej=Node(Mesh(:,2)',:);

% calculate the center
center=(Nodei+Nodej)/2;
delta=Nodei-Nodej;
length=sqrt(delta(:,1).^2+delta(:,2).^2+delta(:,3).^2);

% Generate K
V1=Nodej-Nodei;
z1=sum(V1.*center,2)./(V1(:,3));
z=z1;
z(or(isinf(z1),isnan(z1)),:)=opt.factor.*length(or(isinf(z1),isnan(z1)),:);
Nodek=[zeros(size(center,1),1),zeros(size(center,1),1),z];
Nodek(or(isinf(z1),isnan(z1)),1:2)=center(or(isinf(z1),isnan(z1)),1:2);
delta=Nodek-center;
y1=sum(V1.*center,2)./(V1(:,2));
y=y1;
y(isinf(y1),:)=opt.factor.*length(isinf(y1),:);
Temp=[zeros(size(center,1),1),y,zeros(size(center,1),1)];
Temp(isinf(y1),1)=center(isinf(y1),1);
Temp(isinf(y1),3)=center(isinf(y1),3);
Nodek(delta(:,3)==0,:)=Temp(delta(:,3)==0,:);
% Adjust length
V2=Nodek-center;
Temp_length=sqrt(V2(:,1).^2+V2(:,2).^2+V2(:,3).^2);
factor=Temp_length./length;
Nodek=repmat(factor,1,3).*V2+center;

Ori_node=obj.Part{Numpart,1}.NumNodes;
obj.Part{Numpart,1}.mesh.elements=[obj.Part{Numpart,1}.mesh.elements,...
    (obj.Part{Numpart,1}.NumNodes+1:obj.Part{Numpart,1}.NumNodes+obj.Part{Numpart,1}.NumElements)'];
obj.Part{Numpart,1}.mesh.nodes=[obj.Part{Numpart,1}.mesh.nodes;Nodek];
obj.Part{Numpart,1}.mesh.boundaryMarker=(1:size(obj.Part{Numpart,1}.mesh.nodes,1))';
obj.Part{Numpart,1}.NumNodes=obj.Part{Numpart,1}.NumNodes+obj.Part{Numpart,1}.NumElements;

if obj.Part{Numpart,1}.New==1
    for i=Numpart+1:size(obj.Part,1)
        if obj.Part{i,1}.New==0
            break
        else
            obj.Part{i,1}.mesh.nodes=obj.Part{Numpart,1}.mesh.nodes;
            obj.Part{i,1}.mesh.boundaryMarker=obj.Part{Numpart,1}.mesh.boundaryMarker;
            obj.Part{i,1}.NumNodes=obj.Part{Numpart,1}.NumNodes;
        end
    end
    for i=Numpart-1:1
        if i==0
            break
        end
        if obj.Part{i,1}.New==0
            break
        else
            obj.Part{i,1}.mesh.nodes=obj.Part{Numpart,1}.mesh.nodes;
            obj.Part{i,1}.mesh.boundaryMarker=obj.Part{Numpart,1}.mesh.boundaryMarker;
            obj.Part{i,1}.NumNodes=obj.Part{Numpart,1}.NumNodes;
        end
    end
end

Total_Part=GetNPart(obj);
obj.Summary.Total_Node=obj.Summary.Total_Node+obj.Part{Numpart,1}.NumElements;
if Numpart==Total_Part
    obj.BeamDirectionNode=[obj.BeamDirectionNode;(size(obj.V,1)+1:size(obj.V,1)+size(Nodek,1))'];
    obj.V=[obj.V;Nodek];  
else
    Temp1=obj.V(1:obj.Part{Numpart,1}.acc_node,:);
    Temp2=obj.Part{Numpart,1}.mesh.nodes;
    Temp3=obj.V(obj.Part{Numpart,1}.acc_node+Ori_node+1:end,:);
    judge=0;
    for i=Numpart+1:Total_Part       
        if obj.Part{i,1}.New==0
            judge=1;
        end
        if judge==1
        obj.Part{i,1}.acc_node=obj.Part{i,1}.acc_node+obj.Part{Numpart,1}.NumElements;
        end
        
    end
    obj.V=[Temp1;Temp2;Temp3];
    obj.BeamDirectionNode=[obj.BeamDirectionNode;(size(obj.V,1)-size(Temp3,1)+1:size(obj.V,1))'];
end


%% Print
if obj.Echo
    fprintf('Successfully generate beam direction node .\n');
    tic
end

end
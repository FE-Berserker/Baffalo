function obj=AddNodeMass(obj,Numpart,Nodenum,mass,varargin)
% Add NodeMass to Assembly
% Author : Xie Yu
% Numpart=0 nodes from cnode

p=inputParser;
addParameter(p,'near',[]);
parse(p,varargin{:});
opt=p.Results;

coor=opt.near;

if ~isempty(coor)
    FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
    Vert=obj.Part{Numpart,1}.mesh.Vert;
    row=unique(FFb);
    node=Vert(row,:);
    coor=repmat(coor,size(node,1),1);
    dis=(node(:,1)-coor(:,1)).^2+...
        (node(:,2)-coor(:,2)).^2+...
        (node(:,3)-coor(:,3)).^2;
    [row1,~]=find(dis==min(dis));
    Nodenum=row(row1);
end

Temp=[Numpart,Nodenum,mass];
obj.NodeMass=[obj.NodeMass;Temp];
obj.Summary.Total_NodeMass=GetNNodeMass(obj); % Total number of NodeMass
end
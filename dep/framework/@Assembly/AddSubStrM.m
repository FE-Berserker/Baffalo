function obj=AddSubStrM(obj,Numpart,Nodenum,varargin)
% Add substr master node to Assembly
% Numpart=0 nodes from cnode
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type','ALL');% UX,UY,UZ,ROTX,ROTY,ROTZ
addParameter(p,'near',[]);
parse(p,varargin{:});
opt=p.Results;

coor=opt.near;

if Numpart~=0
    acc=obj.Part{Numpart,1}.acc_node;
    Nodenum=Nodenum+acc;
end

if ~isempty(coor)
    FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
    acc=obj.Part{Numpart,1}.acc_node;
    Vert=obj.Part{Numpart,1}.mesh.Vert;
    row=unique(FFb);
    node=Vert(row,:);
    coor=repmat(coor,size(node,1),1);
    dis=(node(:,1)-coor(:,1)).^2+...
        (node(:,2)-coor(:,2)).^2+...
        (node(:,3)-coor(:,3)).^2;
    [row1,~]=find(dis==min(dis));
    Nodenum=row(row1);
    Nodenum=Nodenum+acc;
end

Temp=[Numpart,Nodenum];
obj.SubStrM.Node=[obj.SubStrM.Node;Temp];
obj.SubStrM.Type=[obj.SubStrM.Type;opt.Type];
end
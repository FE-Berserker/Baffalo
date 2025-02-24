function obj=AddRigidLink(obj,Numpart1,Nodenum1,Numpart2,Nodenum2)
% Add Rigid link to Assembly
% Author : Xie Yu

if size(Nodenum1,2)==1
    if Numpart~=0
        acc=obj.Part{Numpart,1}.acc_node;
        Nodenum1=Nodenum1+acc;
    end
end

if size(Nodenum1,2)==3
    FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
    acc=obj.Part{Numpart,1}.acc_node;
    Vert=obj.Part{Numpart,1}.mesh.Vert;
    row=unique(FFb);
    node=Vert(row,:);
    coor=repmat(Nodenum1,size(node,1),1);
    dis=(node(:,1)-coor(:,1)).^2+...
        (node(:,2)-coor(:,2)).^2+...
        (node(:,3)-coor(:,3)).^2;
    [row1,~]=find(dis==min(dis));
    Nodenum1=row(row1);
    Nodenum1=Nodenum1+acc;
end

if size(Nodenum2,2)==1
    if Numpart~=0
        acc=obj.Part{Numpart,1}.acc_node;
        Nodenum2=Nodenum2+acc;
    end
end

if size(Nodenum2,2)==3
    FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
    acc=obj.Part{Numpart,1}.acc_node;
    Vert=obj.Part{Numpart,1}.mesh.Vert;
    row=unique(FFb);
    node=Vert(row,:);
    coor=repmat(Nodenum2,size(node,1),1);
    dis=(node(:,1)-coor(:,1)).^2+...
        (node(:,2)-coor(:,2)).^2+...
        (node(:,3)-coor(:,3)).^2;
    [row1,~]=find(dis==min(dis));
    Nodenum2=row(row1);
    Nodenum2=Nodenum2+acc;
end

%% Parse
Id=GetNJoint(obj)+1;
obj.Summary.Total_Joint=Id;
obj.Joint{Id,1}.Node=[Numpart1,Nodenum1,Numpart2,Nodenum2];
obj.Joint{Id,1}.Option=[1,0;2,1];


%% Print
if obj.Echo
    fprintf('Successfully add rigid link .\n');
end
end
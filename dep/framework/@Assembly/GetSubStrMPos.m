function Pos=GetSubStrMPos(obj,num)
% Calculate Sub Structure Master Num of Assembly
% Author : Xie Yu
if obj.SubStrM.Node(num,1)==0
    Pos=obj.Cnode(obj.SubStrM.Node(num,2),:);
else
    Pos= obj.V(obj.SubStrM.Node(num,2),:);
end

end
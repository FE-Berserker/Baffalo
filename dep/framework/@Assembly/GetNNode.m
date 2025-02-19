function value=GetNNode(obj)
% Get Number of Node (exclude cnode)
% Author : Xie Yu
Num=GetNPart(obj);
value=obj.Part{Num,1}.acc_node+obj.Part{Num,1}.NumNodes;
end
function value=GetSubStrMNum(obj,num)
% Calculate Sub Structure Master Num of Assembly
% Author : Xie Yu
if obj.SubStrM.Node(num,1)==0
    value=obj.Summary.Total_Node+obj.SubStrM.Node(num,2);
else
    value= obj.SubStrM.Node(num,2);
end
end
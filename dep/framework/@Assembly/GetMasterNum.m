function value=GetMasterNum(obj,num)
% Calculate Master Num of Assembly
% Author : Xie Yu
if obj.Master(num,1)==0
    value=obj.Summary.Total_Node+obj.Master(num,2);
else
    value=obj.Master(num,2);
end
end
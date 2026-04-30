function value=GetSubStrMNum(obj,num)
% Calculate Sub Structure Master Num of Assembly
% Author : Xie Yu
if obj.SubStrM.Node(num,1)==0
    value=obj.Summary.Total_Node+obj.SubStrM.Node(num,2);
else
    value= obj.SubStrM.Node(num,2);
end

Total_Node=obj.Summary.Total_Node;
Ori=obj.SubStrM.Node(:,2);
Ori(obj.SubStrM.Node(:,1)==0,:)=Ori(obj.SubStrM.Node(:,1)==0,:)+Total_Node;
Rep=obj.SNN+(1:size(Ori,1))';

for i=1:size(Ori,1)
    value((value-Ori(i,1))==0)=Rep(i,1);
end

end
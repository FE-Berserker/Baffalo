function value=GetMasterNum(obj,num)
% Calculate Master Num of Assembly
% Author : Xie Yu
% Check substrM

if ~isempty(obj.SubStrM)
    ExistSubStrM=1;
    Total_Node=obj.Summary.Total_Node;
    Ori=obj.SubStrM.Node(:,2);
    Ori(obj.SubStrM.Node(:,1)==0,:)=Ori(obj.SubStrM.Node(:,1)==0,:)+Total_Node;
    Rep=obj.SNN+(1:size(Ori,1))';
else
    ExistSubStrM=0;
    Ori=[];
    Rep=[];
end

if obj.Master(num,1)==0
    value=obj.Summary.Total_Node+obj.Master(num,2);
else
    value=obj.Master(num,2);
end

if  ExistSubStrM==1
    for i=1:size(Ori,1)
        if value==Ori(i,1)
            value=Rep(i,1);
        end
    end
end
end
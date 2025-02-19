function value=GetNEl(obj)
% Get Number of Elements
% Author : Xie Yu
Num=GetNPart(obj);
value=obj.Part{Num,1}.acc_el+obj.Part{Num,1}.NumElements;
end
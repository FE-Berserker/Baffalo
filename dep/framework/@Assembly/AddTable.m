function obj=AddTable(obj,Table)
% Add Table to Assembly
% Author ：Xie Yu
Num=GetNTable(obj);
obj.Table{Num+1,1}=Table;
end

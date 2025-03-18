function obj=AddTable(obj,Table,Type)
% Add Table to Assembly
% Author ：Xie Yu

Num=GetNTable(obj);
obj.Table{Num+1,1}.Data=Table;
obj.Table{Num+1,1}.Type=Type;

end

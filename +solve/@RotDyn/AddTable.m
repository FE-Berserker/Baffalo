function obj= AddTable(obj,table)
% Add table to Shaft
% Author : Xie Yu
row=size(obj.input.Table,1);
obj.input.Table{row+1,1}=table;
end

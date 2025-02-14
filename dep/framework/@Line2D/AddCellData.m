function obj=AddCellData(obj,Data)
% Add Cell data
% Author : Xie Yu

%% Parse parameter
obj.Cell_Data= [obj.Cell_Data;Data];
%% Print
if obj.Echo
    fprintf('Successfully add cell data .\n');
    tic
end
end
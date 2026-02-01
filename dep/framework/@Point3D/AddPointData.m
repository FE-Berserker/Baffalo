function obj=AddPointData(obj,Data)
% Add Point data
% Author : Xie Yu

%% Parse parameter
obj.Point_Data= [obj.Point_Data;Data];

%% Print
if obj.Echo
    fprintf('Successfully add point data. \n');
end
end
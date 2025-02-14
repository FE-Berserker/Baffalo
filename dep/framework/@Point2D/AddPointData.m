function obj=AddPointData(obj,Data)
% Add Point data
% Author : Xie Yu

%% Parse parameter
obj.Point_Data= [obj.Point_Data;Data];

if obj.Echo
    fprintf('Successfully add point data. \n');
    tic
end
end
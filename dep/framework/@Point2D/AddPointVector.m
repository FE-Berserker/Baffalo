function obj=AddPointVector(obj,Vec)
% Add Point Vector
% Author : Xie Yu

%% Parse parameter
obj.Point_Vector= [obj.Point_Vector;Vec];
%% Print
if obj.Echo
    fprintf('Successfully add point vector. \n');
    tic
end
end
function obj=SetSize(obj,edgesize)
% Set mesh edge size
% Author : Xie Yu
obj.Size=edgesize;

%% Print
if obj.Echo
    fprintf('Successfully set edge size .\n');
end
end
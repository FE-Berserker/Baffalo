function obj=AddCS(obj,type,opt)
% Add coordinate system
% Author : Xie Yu
num=GetNCS(obj)+1;
obj.CS(num,:)=[type,opt];
obj.Summary.Total_CS=num;

%% Print
if obj.Echo
    fprintf('Successfully add coordinate system .\n');
end
end
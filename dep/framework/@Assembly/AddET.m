function obj=AddET(obj,opt)
% Add element type to Assembly
% Author : Xie Yu
num=GetNET(obj)+1;
obj.ET{num,1}=opt;

obj.Summary.Total_ET=GetNET(obj);
%% Print
if obj.Echo
    fprintf('Successfully add element type . \n');
end
end
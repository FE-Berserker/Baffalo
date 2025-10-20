function obj=AddCS(obj,type,opt)
% Add coordinate system
% Author : Xie Yu
num=GetNCS(obj)+1;

col=length(opt);
if col==6
    obj.CS(num,:)=[type,opt];
else
    obj.CS(num,:)=[type,opt,zeros(1,6-col)];
end

obj.Summary.Total_CS=num;

%% Print
if obj.Echo
    fprintf('Successfully add coordinate system .\n');
end
end
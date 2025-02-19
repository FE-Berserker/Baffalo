function obj=AddSection(obj,opt)
% Add section to Assembly
% Author : Xie Yu
obj.Summary.Total_Section=GetNSection(obj)+1;
obj.Section{obj.Summary.Total_Section,1}=opt;
%% Print
if obj.Echo
    fprintf('Successfully add section .\n');
end
end
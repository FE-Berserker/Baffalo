function obj=CreateTool(obj)
% Create tool
% Author : Xie Yu

Tool=obj.input.Tool;
Tool.Type=obj.params.Type;

switch Tool.Type
    case 1
        obj=CreateTool1(obj);
    case 2
    case 3
end

%% Print
if obj.params.Echo
    fprintf('Successfully create tool .\n');
end
end
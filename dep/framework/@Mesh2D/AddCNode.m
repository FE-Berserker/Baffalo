function obj=AddCNode(obj,Node)
% Add constraint node to Mesh2D
% Author : Xie Yu

obj.CNode=[obj.CNode;Node];

%% Print
if obj.Echo
    fprintf('Successfully add constraint node to Mesh2D  .\n');
end
end


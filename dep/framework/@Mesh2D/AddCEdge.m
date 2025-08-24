function obj=AddCEdge(obj,Edge,varargin)
% Add constraint edge to Mesh2D
% Author : Xie Yu

obj.CEdge=[obj.CEdge;Edge];

%% Print
if obj.Echo
    fprintf('Successfully add constraint edge to Mesh2D  .\n');
end
end


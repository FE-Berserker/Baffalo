function obj= ComputeGeometryG(obj)
% Compute Geometry G
% Author : Xie Yu

if isempty(obj.G)
    fprintf('Nothing to compute.\n');
end
obj.G = computeGeometry(obj.G);

%% Print
if obj.Echo
    fprintf('Successfully compute the geometry G .\n');
end
end


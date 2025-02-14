function obj= ComputeGeometryG(obj)
% Compute geometry informaion of MRST G

if isempty(obj.G)
    fprintf('Nothing to compute.\n');
end
obj.G = computeGeometry(obj.G);
end


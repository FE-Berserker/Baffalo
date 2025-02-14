function obj = NormalizeNormals(obj)
% Normalize normals

% Normal vectors
n = obj.Normal;

% Length of all normal vectors
l = sqrt(dot(n',n')');

% Normalization
obj.NormNormal=n./l;

end
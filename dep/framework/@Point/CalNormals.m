function obj=CalNormals(obj, searchRadius, varargin)
% Compute normal vectors of activated points.

p = inputParser;
p.addRequired( 'searchRadius'        , @(x) isscalar(x) && isnumeric(x) && x>0);
p.addParameter('MinNoNeighbours',   3, @(x) isscalar(x) && isnumeric(x) && x>0);
p.addParameter('MaxNoNeighbours', Inf, @(x) isscalar(x) && isnumeric(x) && x>0);
p.parse(searchRadius, varargin{:});
p = p.Results;
% Clear required inputs to avoid confusion
clear searchRadius

% Query points
qp = obj.P;

% Search of nn
idxNN = rangesearch(obj.P, qp, p.searchRadius); % result is cell array

% Initialization
n         = nan(size(qp,1),3);
roughness = nan(size(qp,1),1);

% PCA for each point
% parfor i = 1:size(qp,1)
for i = 1:size(qp,1)
    if numel(idxNN{i}) >= p.MinNoNeighbours

        if numel(idxNN{i}) > p.MaxNoNeighbours
            idxNN{i} = idxNN{i}(1:p.MaxNoNeighbours);
        end
            
        XNN = obj.P(idxNN{i},:); % includes neighbours AND query point!
        C = cov(XNN);

        % Solution 1 -> actual preference, as normal vector are primarily upwards
        try
            [P, lambda] = pcacov(C);
            n(i,:) = P(:,3)';
            roughness(i,1) = sqrt(lambda(3)); % third component is smallest eigenvalue
        catch ME 
            msg('I', {'POINTCLOUD' 'NORMALS' 'PCA'}, ...
                sprintf('Normal estimation failed for point %.6f/%.6f/%.6f', ...
                qp(i,1), qp(i,2), qp(i,3)));
        end
    end
end

% Parse Parameter
obj.Normal = n;
obj.Roughness = roughness;
obj = NormalizeNormals(obj);
%% Print
if obj.Echo
    fprintf('Successfully calculate normals. \n');
end

end
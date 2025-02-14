function obj=LoadMsh(obj,name)
% Load msh file to Mesh2D

% p=inputParser;
% addParameter(p,'grid',0);
% parse(p,varargin{:});
% opt=p.Results;

geom = loadmsh(name);
obj.Vert=geom.point.coord(:,1:2);
obj.Face=geom.tria3.index(:,1:3);

%% Print
if obj.Echo
    fprintf('Successfully load msh file .\n');
end

end


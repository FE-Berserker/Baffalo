function obj= MeshTensorGrid(obj,x,y,varargin)
% Mesh Tensor Grid
% Author : Xie Yu
p=inputParser;
addParameter(p,'twist',[]);
parse(p,varargin{:});
opt=p.Results;

G=tensorGrid(x,y);

if ~isempty(opt.twist)
     G  = twister(G,opt.twist);
end

nodes = getSortedCellNodes(G);
pos   = G.cells.facePos;
cells = (1 : G.cells.num) .';
[f, verts]= get_face_topo(nodes, pos, cells );
v= G.nodes.coords(verts, :);
obj.Vert=[obj.Vert;v];
obj.Face=[obj.Face;f];
obj.G=G;
%% Print
if obj.Echo
    fprintf('Successfully mesh tensor grid .\n');
end
end


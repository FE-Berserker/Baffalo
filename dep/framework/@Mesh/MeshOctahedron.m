function obj=MeshOctahedron(obj,dimension)
% p=inputParser;
% addParameter(p,'ElementType','hex8');
% parse(p,varargin{:});
% opt=p.Results;

l1=dimension(1);
l2=dimension(2);
l3=dimension(3);
nodes = [l1/2 0 0;0 l2/2 0;-l1/2 0 0;0 -l2/2 0;0 0 l3/2;0 0 -l3/2];
edges = [1 2;1 4;1 5; 1 6;2 3;2 5;2 6;3 4;3 5;3 6;4 5;4 6];
faces = [1 2 5;2 3 5;3 4 5;4 1 5;1 6 2;2 6 3;3 6 4;1 4 6];
% format output
nargout=2;
out= formatMeshOutput(nargout, nodes, edges, faces);
obj.Face=out{2,1};
obj.Vert=out{1,1};
obj.Cb=ones(8,1);
end
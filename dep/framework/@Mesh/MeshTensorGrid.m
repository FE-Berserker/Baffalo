function obj= MeshTensorGrid(obj,x,y,z,varargin)
% Mesh tensor grid
% p=inputParser;
% addParameter(p,'twist',[]);
% parse(p,varargin{:});
% opt=p.Results;

G=tensorGrid(x,y,z);

% if ~isempty(opt.twist)
%      G  = twister(G,opt.twist);
% end

nodes = G.faces.nodes;
pos   = G.faces.nodePos;
cells = (1 : G.cells.num) .';
f = boundaryFaces(G, cells);
[f, verts]= get_face_topo(nodes, pos, f );
v= G.nodes.coords(verts, :);

Meshoutput.nodes=G.nodes.coords;
Temp1=G.cells.faces(:,1);
Temp1=reshape(Temp1,[6,size(Temp1,1)/6]);
Temp1=Temp1';
Temp2=G.faces.nodes;
Temp2=reshape(Temp2,[4,size(Temp2,1)/4]);
Temp2=Temp2';
Meshoutput.elements=[Temp2(Temp1(:,1),:),Temp2(Temp1(:,2),:)];

Meshoutput.faces=element2patch(Meshoutput.elements,[],'hex8');

%Find boundary faces
[indFree]=freeBoundaryPatch(Meshoutput.faces);
Fb=Meshoutput.faces(indFree,:);
Meshoutput.facesBoundary=Fb;
Meshoutput.boundaryMarker=ones(size(f,1),1);
Meshoutput.elementMaterialID=ones(size(Meshoutput.elements,1),1);
Meshoutput.faceMaterialID=ones(size(Meshoutput.faces,1),1);

obj.Vert=[obj.Vert;v];
obj.Face=[obj.Face;f];
obj.Cb=[obj.Cb;ones(size(f,1),1)];
obj.G=G;
obj.Meshoutput=Meshoutput;
end


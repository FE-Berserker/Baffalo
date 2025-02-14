function obj= RemoveCells(obj,cells)
if isempty(obj.G)
    fprintf('Nothing to remove.\n');
end
[G, ~, ~, ~] = removeCells(obj.G, cells);
obj.G=G;
nodes = G.faces.nodes;
Meshoutput.nodes=nodes;
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
Meshoutput.boundaryMarker=ones(size(Fb,1),1);
Meshoutput.elementMaterialID=ones(size(Meshoutput.elements,1),1);
Meshoutput.faceMaterialID=ones(size(Meshoutput.faces,1),1);
obj.Meshoutput=Meshoutput;

pos   = G.faces.nodePos;
cells = (1 : G.cells.num) .';
f = boundaryFaces(G, cells);
[f, verts]= get_face_topo(nodes, pos, f );
v= G.nodes.coords(verts, :);
obj.Vert=v;
obj.Face=f;
obj.Cb=ones(size(f,1),1);
end


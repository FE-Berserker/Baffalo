function obj=Tri2Voronoi(obj)
% Create empty Voronoi
obj.Voronoi.Nodes = [];
obj.Voronoi.Faces = {};
obj.Voronoi.Voronois = {};
%% Parse input
obj = createVoronoi3dFromMesh(obj, obj.Meshoutput.nodes, obj.Meshoutput.elements);
end

function obj = createVoronoi3dFromMesh(obj, node, element)
[myNodes, polyhedronCell] = specialVoronoi3d(node, element);
[myNodes, voronoiCellOut, myFaceNormals, myCentroids, myVols] = simplifyVoronoi3d(myNodes,polyhedronCell,1e-12 );
nFace = zeros(size(voronoiCellOut));
nFaceMaxNN = zeros(size(voronoiCellOut));
for i = 1:1:numel(voronoiCellOut)
    nFace(i) = numel(voronoiCellOut{i});
    for j = 1:1:nFace(i)
        nFaceMaxNN(i) = max(nFaceMaxNN(i), numel(voronoiCellOut{i}{j}));
    end
end
nMaxEdge = max(nFaceMaxNN);
totFaces = zeros(sum(nFace), nMaxEdge);
totNormals = zeros(sum(nFace), 3);
nCount = 0;
for i = 1:1:numel(voronoiCellOut)
    for j = 1:1:nFace(i)
        nCount = nCount + 1;
        totFaces(nCount,:) = [voronoiCellOut{i}{j}', NaN(1,nMaxEdge-numel(voronoiCellOut{i}{j}))];
        totNormals(nCount,:) = myFaceNormals{i}(j,:);
    end
end
totFaces2 = sort(totFaces, 2);
[~, ia, ic] = unique(totFaces2,'rows'); %
myFaces = totFaces(ia,:);
myFaceNormals = totNormals(ia,:);
numFaces = size(myFaces,1);
nFacesArray = (1:1:numFaces)';
myVoronois = mat2cell(nFacesArray(ic,1),nFace(:)');
myFaces = mat2cell(myFaces,ones(1,numFaces));
for i = 1:numFaces
    myFaces{i}(isnan(myFaces{i})) = [];
end
obj.Voronoi.Nodes = myNodes;
obj.Voronoi.Faces = myFaces;
obj.Voronoi.Voronois = myVoronois;
obj.Voronoi.FaceNormals = myFaceNormals;
obj.Voronoi.Centroids = myCentroids;
obj.Voronoi.Volumes = myVols;
end


function in = IsInMesh(obj,mesh)
% Check geometry inner mesh face
G=obj.G;
pts=G.cells.centroids;
if size(mesh.Face,2)==4
    [Ft,Vt,~]=quad2tri(mesh.Face,mesh.Vert);
    fv.faces=Ft;
    fv.vertices=Vt;
elseif size(mesh.Face,2)==3
    fv.faces=mesh.Face;
    fv.vertices=mesh.Vert;
end
in = inpolyhedron(fv, pts);     % Test which are inside the patch
end


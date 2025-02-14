function [nodeOut, voronoiCellOut, faceNormal, voronoiCentroid, volumes] = simplifyVoronoi3d(nodeIn, voronoiCellIn, tol)
% reduce the surface of 3D triangulation to 3D polygon of each voronoi
% cell
%% input variables: 
% nodeIn: the node for all the voronoi cells
% voronoiCellIn:  a m-by-1 cell array, each cell contains all the nodes of
% a corresponding voronoi
% tol: tolerance for coplanar judge
%% outPut variables
% nodeOut the output n-by-3 coordinates of nodes
% voronoiCellOut: m-by-1 cell array, each cell contains all the faces of nodes of
% a corresponding voronoi 
% faceNormal: m-by-1 cell array, each cell contains a respective normal
% vector of face
% voronoiCentroid: coordinate of the centroid of voronoi
% volumes: the volume of voronoi
%% Author: Wan Ji, Wuhan University, Wuhan, China
% Any advice or questions, please contact me via E-mail:
% wanji@whu.edu.cn
% Date of this version 2021/06/28
voronoiCellOut = cell(size(voronoiCellIn));
faceNormal = cell(size(voronoiCellIn));
voronoiCentroid = zeros(numel(voronoiCellIn),3);
volumes = zeros(numel(voronoiCellIn),1);
for i = 1:1:numel(voronoiCellIn)
    n = voronoiCellIn{i,1};
    p = nodeIn(n,:);
    [k,~] = convhulln(p);
    mp = n(k);
    normalDir  = zeros(size(k,1),3);
    [vol, ~, Cx, Cy, Cz]=Polyhedron_VAC(p,k);
    voronoiCentroid(i,:) = [Cx,Cy,Cz];
    volumes(i,1) = vol;
    centro = [Cx,Cy,Cz];
    for j = 1:1:size(k,1)
        tri = k(j,:);
        x = p(tri,1);
        y = p(tri,2);
        z = p(tri,3);
        p1 = [x(1),y(1),z(1)];
        p2 = [x(2),y(2),z(2)];
        p3 = [x(3),y(3),z(3)];
        normalDir(j,:) = cross(p2-p1,p3-p1);
        normalDir(j,:) = normalDir(j,:)/norm(normalDir(j,:));
        if(((p1+p2+p3)/3-centro)*normalDir(j,:)'<0)
            normalDir(j,:) = -normalDir(j,:);
        end
    end
    [a,~,ic] = uniquetol(normalDir,tol,'ByRows',true); % find co-plane triangles
    faceNormal{i,1} = a;
    faces = cell(size(a,1),1);
    for j = 1:1:numel(ic)
        faces{ic(j),1} = [faces{ic(j),1}; mp(j,:)'];
    end
    for j = 1:1:numel(faces)
        faces{j,1} = unique(faces{j,1});
    end
    t = [2,3,1,2];
    for j = 1:1:numel(faces)
        p = faces{j,1};
        enode = nodeIn(p,:);
        mDim = find(max(abs(a(j,:)))==abs(a(j,:)));
        t0 = t(mDim(1):mDim(1)+1);
        pp = enode(:,t0);
        kk= convhull(pp);
        faces{j,1} = p(kk(1:end-1,1));
    end
    voronoiCellOut{i,1} = faces;
end
q = 0;
for i = 1:1:numel(voronoiCellOut)
    q = q + sum(arrayfun(@(j)numel(voronoiCellOut{i}{j}),(1:1:numel(voronoiCellOut{i}))'));
end
element = zeros(q,1);
ct = 0;
for i = 1:1:numel(voronoiCellOut)
    for j = 1:1:numel(voronoiCellOut{i})
       s = voronoiCellOut{i}{j};
       element(ct+1:ct+numel(s),1) = s; 
       ct = ct+numel(s);
    end
end
ka= (1:1:size(nodeIn,1))';
kb = ka;
eDif = setdiff((1:1:size(nodeIn,1))',element);
kb(eDif) = NaN;
flag = isnan(kb);
nodeIn(flag,:) = []; % delete Nodes
nodeOut = nodeIn;
kb(~flag) = 1:1:numel(flag)-sum(flag); % renumbering
element = kb(element); % replace the numbering
ct = 0;
for i = 1:1:numel(voronoiCellOut)
    for j = 1:1:numel(voronoiCellOut{i})
       s = voronoiCellOut{i}{j};
       voronoiCellOut{i}{j} = element(ct+1:ct+numel(s),1);
       ct = ct+numel(s);
    end
end
end
function [node, polyhedronCell] = specialVoronoi3d(node, element)
%% This function transfers C3D4 or C3D8 mesh to voronoi cells
% C3D4 or C3D8 mesh must not be abnormal, viz. quite tetrahedral
% input data is the mesh nodes and element matrix
% node-> n-by-3 matrix
% element-> m-by-10 or m-by-4 array
% Output data:
% node: the novel out put node coordinates r-by-3
% polyhedronCell: a cell array, each cell contains material convhull points
% of the voronoi
%% Author: Wan Ji, Wuhan University, Wuhan, China
% Any advice or questions, please contact me via E-mail:
% wanji@whu.edu.cn
% Date of this version 2021/06/28
if(size(element,2)==4)
    [node, element] = linear2quad(node, element, 'c3d4');
end
nelement = size(element,1);
nnode = size(node,1);
% find all the faces
all_faces = zeros(nelement * 4, 3);
faceNumberEachElement = 4;
for i = 1:1:nelement
   all_faces((i-1)*4+1,:) = element(i, [1,2,3]);
   all_faces((i-1)*4+2,:) = element(i, [1,2,4]);
   all_faces((i-1)*4+3,:) = element(i, [1,3,4]);
   all_faces((i-1)*4+4,:) = element(i, [2,3,4]);
end
all_faces = sort(all_faces, 2); % 获取唯一边，方便进行节点添加【即边的左边结点编号小于右边】
[all_faces,ia,ic] = unique(all_faces,'rows'); % 获取唯一边
midFaceNode = zeros(size(all_faces,1),3);
for i = 1:1:size(all_faces,1)
    face = all_faces(i,:);
    tr = triangulation(1:3,node(face,1),node(face,2),node(face,3));
    midFaceNode(i,:) = circumcenter(tr);
end
mNum = (nnode+1:1:nnode+numel(ia))'; % 中点的编号
midInterp = mNum(ic); % 根据编号得到每个单元的每条边上的结点编号
element = [element, (reshape(midInterp, faceNumberEachElement, nelement))']; % 所有的单元增加额外三个面的中心点
node = [node; midFaceNode]; % 补充每条边上的结点坐标
centroNode = zeros(nelement,3);
for i = 1:1:nelement
    face = element(i,1:4);
    tr = delaunayTriangulation(node(face,:));
    centroNode(i,:) = circumcenter(tr);
end
cNum = nnode+numel(ia)+1:nnode+numel(ia)+nelement;
element = [element, cNum'];
node = [node;centroNode]; 
novel_element = zeros(nelement*4, 8);
block = [1,5,11,7,8,12,15,13;2,6,11,5, 9,14,15,12; 3,7,11,6,10,13,15,14; 4,10,14,9, 8,13,15,12];
for i = 1:1:nelement
    q = element(i,:);
    novel_element(4*(i-1)+1:4*i,:) = q(block);
end
[node, novel_element] = renumber(node, novel_element);
[n,~,ic] = unique(novel_element(:,1));
polyhedronCell = cell(numel(n),1);
for i = 1:1:numel(ic)
   polyhedronCell{ ic(i),1} = [polyhedronCell{ ic(i),1}; novel_element(i,1:8)'];
end
for i = 1:1:numel(polyhedronCell)
  polyhedronCell{i,1} = unique(polyhedronCell{i,1});  
end
end
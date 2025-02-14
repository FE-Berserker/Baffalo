function [node, element] = linear2quad(node, element, etype)
% convert linear triangle element to quadratic one by adding supplemental
% nodes
% 将线性网格变成二次网格
switch etype
    case {'C2D3','c2d3'} % c2d3 -> c2d6
        sideNumberEachElement = 3;
        nelement = size(element, 1); % 单元数目
        nnode = size(node,1); % 结点数目
        nedge = nelement*sideNumberEachElement; % 所有单元的边数目
        edge = zeros(nedge,2); % 预定于所有单元的边的大小【p1,p2】
        for i = 1:1:nelement % 获取每一条边的结点
            edge(3*(i-1)+1,:) = element(i,[1,2]);
            edge(3*(i-1)+2,:) = element(i,[2,3]);
            edge(3*(i-1)+3,:) = element(i,[3,1]);
        end
    case {'C3D4','c3d4'} % c3d4 -> c3d10
        sideNumberEachElement = 6;
        nelement = size(element, 1); % 单元数目
        nnode = size(node,1); % 结点数目
        nedge = nelement*sideNumberEachElement; % 所有单元的边数目
        edge = zeros(nedge,2); % 预定于所有单元的边的大小【p1,p2】
        for i = 1:1:nelement % 获取每一条边的结点
            edge(6*(i-1)+1,:) = element(i,[1,2]);
            edge(6*(i-1)+2,:) = element(i,[2,3]);
            edge(6*(i-1)+3,:) = element(i,[3,1]);
            edge(6*(i-1)+4,:) = element(i,[1,4]);
            edge(6*(i-1)+5,:) = element(i,[2,4]);
            edge(6*(i-1)+6,:) = element(i,[3,4]);
        end
    case {'C2D4','c2d4'} % c2d4 -> c2d8
        sideNumberEachElement = 4;
        nelement = size(element, 1); % 单元数目
        nnode = size(node,1); % 结点数目
        nedge = nelement*sideNumberEachElement; % 所有单元的边数目
        edge = zeros(nedge,2); % 预定于所有单元的边的大小【p1,p2】
        for i = 1:1:nelement % 获取每一条边的结点
            edge(4*(i-1)+1,:) = element(i,[1,2]);
            edge(4*(i-1)+2,:) = element(i,[2,3]);
            edge(4*(i-1)+3,:) = element(i,[3,4]);
            edge(4*(i-1)+4,:) = element(i,[4,1]);
        end
    case {'C3D8','c3d8'} % c3d8 -> c3d20
        sideNumberEachElement = 12;
        nelement = size(element, 1); % 单元数目
        nnode = size(node,1); % 结点数目
        nedge = nelement*sideNumberEachElement; % 所有单元的边数目
        edge = zeros(nedge,2); % 预定于所有单元的边的大小【p1,p2】
        for i = 1:1:nelement % 获取每一条边的结点
            edge(12*(i-1)+1,:) = element(i,[1,2]);
            edge(12*(i-1)+2,:) = element(i,[2,3]);
            edge(12*(i-1)+3,:) = element(i,[3,4]);
            edge(12*(i-1)+4,:) = element(i,[4,1]);
            edge(12*(i-1)+5,:) = element(i,[5,6]);
            edge(12*(i-1)+6,:) = element(i,[6,7]);
            edge(12*(i-1)+7,:) = element(i,[7,8]);
            edge(12*(i-1)+8,:) = element(i,[8,5]);
            edge(12*(i-1)+9,:) = element(i,[1,5]);
            edge(12*(i-1)+10,:) = element(i,[2,6]);
            edge(12*(i-1)+11,:) = element(i,[3,7]);
            edge(12*(i-1)+12,:) = element(i,[4,8]);
        end
end
edge = sort(edge, 2); % 获取唯一边，方便进行节点添加【即边的左边结点编号小于右边】
[uedge,ia,ic] = unique(edge,'rows'); % 获取唯一边
midNode = (node(uedge(:,1),:)+node(uedge(:,2),:))/2;%获取边上的中点坐标
mNum = (nnode+1:1:nnode+numel(ia))'; % 中点的编号
midInterp = mNum(ic); % 根据编号得到每个单元的每条边上的结点编号
element = [element, (reshape(midInterp, sideNumberEachElement, nelement))']; % 所有的单元增加额外三个结点
node = [node; midNode]; % 补充每条边上的结点坐标
[node,idx ]= sortrows(node); % 对坐标进行重排先排x再排y从小到大
[~,idx2] = sortrows(idx); % 对实际原先的点进行编号排序
qNum = (1:1:numel(idx2))';
qNum = qNum(idx2)'; % 将排序策略记录
element = qNum(element); % 排序策略赋值给新的单元编号
end
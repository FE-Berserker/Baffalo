function [Area ,Ac, Ael] = MeshArea(Node,El)
% Mesh area
% Author : Xie Yu

Area=0;
Length=size(El,2);
switch Length
    case 3
        El=[El(:,1:3),El(:,3)];
    case 6
        El=[El(:,1:3),El(:,3)];
    case 4
        El=El(:,1:4);
    case 8
        El=El(:,1:4);
end

Ael=zeros(size(El,1),1);
Ac=zeros(size(El,1),3);

for i=1:size(El,1)
    nodes=Node(El(i,1:4)',:);

    tri1 = [nodes(1,:); nodes(2,:); nodes(3,:)]; % 三角形1：顶点1,2,3
    tri2 = [nodes(1,:); nodes(3,:); nodes(4,:)]; % 四面体2：顶点1,3,4


    %% 第四步：计算每个四面体的体积，并求和得到六面体体积
    v1 = triArea(tri1);
    v2 = triArea(tri2);

    Area =Area+ v1 + v2 ; % 六面体总体积
    Ael(i,:)=v1 + v2;
    Ac(i,:)=(mean(tri1)*v1+mean(tri2)*v2)/Ael(i,:);
end

end

function tri_area = triArea(points)
% points = [1 2 3;   % A
%     4 5 6;   % B
%     2 7 8];  % C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 第二步：提取三个顶点的三维坐标
A = points(1,:); % 顶点A [x1,y1,z1]
B = points(2,:); % 顶点B [x2,y2,z2]
C = points(3,:); % 顶点C [x3,y3,z3]

%% 第三步：核心计算（空间三角形面积）
% 1. 构造边向量AB和AC
vec_AB = B - A; % 向量AB = B - A
vec_AC = C - A; % 向量AC = C - A

% 2. 计算向量叉乘（空间向量叉乘，MATLAB内置cross函数）
cross_product = cross(vec_AB, vec_AC);

% 3. 计算叉乘向量的模长（即向量的长度）
cross_norm = norm(cross_product);

% 4. 计算三角形面积（模长的一半）
tri_area = 0.5 * cross_norm;
end
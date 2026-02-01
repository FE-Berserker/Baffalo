% 绘制叶片（NACA翼型）二维网格
% Author: Claude Code

clear; clc;

%% 步骤1：创建 NACA 翼型坐标
% 使用 NACA 2412 翼型作为叶片形状
n = 30;  % 每个表面的点数（减少点数以加快速度）
chord = 100;  % 弦长

% NACA 2412 参数
m = 0.02;   % 最大弯度位置 (弦长的百分比)
p = 0.4;    % 最大弯度位置
t = 0.12;   % 最大厚度 (弦长的百分比)

% 生成上表面点
theta_upper = linspace(0, pi, n+1);
x_upper = (1 - cos(theta_upper)) / 2 * chord;

% NACA 对称翼型厚度分布
yt = 5 * t * chord * (0.2969*sqrt(x_upper/chord) - 0.1260*(x_upper/chord) ...
    - 0.3516*(x_upper/chord).^2 + 0.2843*(x_upper/chord).^3 - 0.1015*(x_upper/chord).^4);

% NACA 弯度线（对于 24xx 系列）
for i = 1:length(x_upper)
    if x_upper(i) <= p * chord
        yc(i) = m / p^2 * (2*p*(x_upper(i)/chord) - (x_upper(i)/chord)^2) * chord;
    else
        yc(i) = m / (1-p)^2 * ((1-2*p) + 2*p*(x_upper(i)/chord) - (x_upper(i)/chord)^2) * chord;
    end
end

% 上下表面坐标
x_surf = [x_upper; flip(x_upper)];
y_surf = [yc + yt; flip(yc) - yt];

% 去除重复的前缘点
x_surf = x_surf(2:end);
y_surf = y_surf(2:end);

%% 步骤2：直接使用 Delaunay 三角剖分
fprintf('使用 Delaunay 三角剖分生成网格...\n');

% 添加一些内部点以改善网格质量
% 在叶片内部添加一些点
inner_x = linspace(10, chord-10, 5)';
inner_y = zeros(size(inner_x));
extra_x = [chord*0.25; chord*0.5; chord*0.75];
extra_y = [2; 3; 2];

% 确保所有数组都是列向量
x_surf = x_surf(:);
y_surf = y_surf(:);

x_mesh = [x_surf; inner_x; extra_x];
y_mesh = [y_surf; inner_y; extra_y];

% Delaunay 三角剖分
tri = delaunay(x_mesh, y_mesh);

% 过滤出在叶片外部的三角形
% 创建约束边界
k = convhull(x_surf, y_surf);

% 找出并保留只在叶片内部的三角形
keep = false(size(tri, 1), 1);
for ii = 1:size(tri, 1)
    % 计算三角形中心
    xc = mean(x_mesh(tri(ii,:)));
    yc = mean(y_mesh(tri(ii,:)));
    % 检查是否在凸包内
    keep(ii) = inpolygon(xc, yc, x_surf(k), y_surf(k));
end

tri = tri(keep,:);

% 创建 Mesh2D 对象
mesh = Mesh2D('BladeMesh', 'Echo', 1);

% 添加边界节点和边
mesh.N = x_surf;
mesh.E = [(1:length(x_surf)-1)', (2:length(x_surf))'];
mesh.E(end, 2) = 1;  % 闭合边界

% 添加到 Mesh2D
mesh.Vert = [x_mesh, y_mesh];  % 需要 N×2 格式
mesh.Face = tri;
mesh.Boundary = FindBoundary(mesh);
mesh.Cb = ones(size(mesh.Face, 1), 1);

fprintf('完成网格生成!\n');

%% 步骤3：可视化
fprintf('绘制网格...\n');

% 绘制基本网格
figure('Position', [100, 100, 1200, 400]);
Plot2(mesh)
Plot(mesh);

%% 步骤4：输出统计信息
fprintf('\n=== 网格统计 ===\n');
fprintf('顶点数: %d\n', size(mesh.Vert, 1));
fprintf('单元数: %d\n', size(mesh.Face, 1));
fprintf('边界边数: %d\n', size(mesh.Boundary, 1));

% 计算几何特性
[Area, Center, Ixx, Iyy, Ixy] = CalculateGeometry(mesh);
fprintf('\n=== 几何特性 ===\n');
fprintf('面积: %.2f mm²\n', Area);
fprintf('质心: (%.2f, %.2f)\n', Center(1), Center(2));
fprintf('惯性矩 Ixx: %.2e mm⁴\n', Ixx);
fprintf('惯性矩 Iyy: %.2e mm⁴\n', Iyy);
fprintf('惯性积 Ixy: %.2e mm⁴\n', Ixy);


%% 步骤5：导出 VTK 文件
fprintf('\n导出 VTK 文件...\n');
VTKWrite(mesh);

%% 步骤6：平滑网格（可选）
fprintf('\n平滑网格...\n');
mesh_smooth = mesh;
mesh_smooth = SmoothFace(mesh_smooth, 3);

% 创建一个长500，宽400，中心随机布置10个无干涉圆孔的板件
clc
clear
close all

%% 板件参数
plateLength = 500;  % 长度 [mm]
plateWidth = 400;   % 宽度 [mm]
thickness = 10;      % 厚度 [mm]
numHoles = 10;      % 孔的数量
holeRadius = 15;     % 孔的半径 [mm]

%% 创建矩形轮廓
% Point2D中的点按成对方式组织，每对点形成一条线
% 每次AddPoint调用需要传入两个点的坐标，x和y必须是列向量
points = Point2D('Rectangle Points');

% 底边：左下 -> 右下
points = AddPoint(points, [-plateLength/2; plateLength/2], [-plateWidth/2; -plateWidth/2]);

% 右边：右下 -> 右上
points = AddPoint(points, [plateLength/2; plateLength/2], [-plateWidth/2; plateWidth/2]);

% 顶边：右上 -> 左上
points = AddPoint(points, [plateLength/2; -plateLength/2], [plateWidth/2; plateWidth/2]);

% 左边：左上 -> 左下
points = AddPoint(points, [-plateLength/2; -plateLength/2], [plateWidth/2; -plateWidth/2]);

% 创建轮廓，添加四条线
outline = Line2D('Rectangular Plate');
outline = AddLine(outline, points, 1);  % 底边
outline = AddLine(outline, points, 2);  % 右边
outline = AddLine(outline, points, 3);  % 顶边
outline = AddLine(outline, points, 4);  % 左边

%% 中心区域范围（用于随机放置孔）
% 中心区域为板件尺寸的60%，避免孔太靠近边缘
centerRegionXL = -plateLength * 0.3;
centerRegionXH = plateLength * 0.3;
centerRegionYL = -plateWidth * 0.3;
centerRegionYH = plateWidth * 0.3;

%% 生成无干涉的10个孔的位置
rng(42); % 设置随机种子，确保结果可重现
holePositions = zeros(numHoles, 2);
maxAttempts = 1000; % 最大尝试次数，避免无限循环

for i = 1:numHoles
    attempts = 0;
    while attempts < maxAttempts
        % 随机生成一个位置
        x = centerRegionXL + rand() * (centerRegionXH - centerRegionXL);
        y = centerRegionYL + rand() * (centerRegionYH - centerRegionYL);

        % 检查是否与现有孔干涉
        interferes = false;
        for j = 1:(i-1)
            % 计算两个圆心之间的距离
            dx = x - holePositions(j, 1);
            dy = y - holePositions(j, 2);
            distance = sqrt(dx^2 + dy^2);

            % 干涉判断：距离 < 2 * 半径（留2mm间隙）
            minDistance = 2 * holeRadius + 2; % 两个孔之间至少保持2mm间隙
            if distance < minDistance
                interferes = true;
                break;
            end
        end

        % 如果不干涉，则接受这个位置
        if ~interferes
            holePositions(i, 1) = x;
            holePositions(i, 2) = y;
            break;
        end

        attempts = attempts + 1;
    end

    if attempts >= maxAttempts
        warning(['无法为孔 ', num2str(i), ' 找到无干涉的位置']);
        holePositions(i, 1) = centerRegionXL + rand() * (centerRegionXH - centerRegionXL);
        holePositions(i, 2) = centerRegionYL + rand() * (centerRegionYH - centerRegionYL);
    end
end

%% 创建孔
holes = [];
for i = 1:numHoles
    % 创建孔的中心点
    holeCenter = Point2D(['Hole', num2str(i), 'Center']);
    holeCenter = AddPoint(holeCenter, holePositions(i, 1), holePositions(i, 2));

    % 创建圆孔
    hole = Line2D(['Hole', num2str(i)]);
    hole = AddCircle(hole, holeRadius, holeCenter, 1);

    % 添加到孔数组
    if isempty(holes)
        holes = hole;
    else
        holes = [holes; hole];
    end
end

%% 显示孔的位置信息
disp('板件参数:');
fprintf('  尺寸: %.0f x %.0f mm\n', plateLength, plateWidth);
fprintf('  厚度: %.0f mm\n', thickness);
fprintf('  孔数量: %d\n', numHoles);
fprintf('  孔半径: %.0f mm\n', holeRadius);
disp('');
disp('孔的位置 (mm):');
disp(holePositions);

%% 验证孔间最小距离（用于确认无干涉）
minDistance = inf;
for i = 1:numHoles
    for j = (i+1):numHoles
        dx = holePositions(i, 1) - holePositions(j, 1);
        dy = holePositions(i, 2) - holePositions(j, 2);
        distance = sqrt(dx^2 + dy^2);
        minDistance = min(minDistance, distance);
    end
end
fprintf('孔间最小距离: %.2f mm\n', minDistance);
fprintf('要求最小距离: %.2f mm\n', 2 * holeRadius + 2);

%% 设置输入参数
inputplate.Outline = outline;
inputplate.Hole = holes;
inputplate.Thickness = thickness;

%% 设置参数（可选）
paramsplate = struct();
paramsplate.Name = 'PlateWith10Holes';
paramsplate.Meshsize = 10;

%% 创建板件
disp('');
disp('正在创建板件...');
obj = plate.Commonplate(paramsplate, inputplate);
obj = obj.solve();

disp('');
disp('板件创建成功!');

%% 绘制2D视图
figure('Name', 'Plate - 2D View', 'Position', [100, 100, 800, 600]);
obj.Plot2D();
title('带孔板件 - 2D视图');
xlabel('X [mm]');
ylabel('Y [mm]');
axis equal;

%% 绘制3D视图
figure('Name', 'Plate - 3D View', 'Position', [200, 150, 800, 600]);
Plot3D(obj);
title('带孔板件 - 3D视图');

%% 输出网格信息
disp('');
disp('网格信息:');
fprintf('  实体网格节点数: %d\n', size(obj.output.SolidMesh.Meshoutput.nodes, 1));
fprintf('  壳网格节点数: %d\n', size(obj.output.ShellMesh.Meshoutput.nodes, 1));

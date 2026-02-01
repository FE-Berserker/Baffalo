% 生成10个随机2D点
clc
clear
close all

%% 参数
numPoints = 10;
coordRange = 200;

%% 创建 Point2D 对象
a = Point2D('RandomPoints');

%% 生成10个随机点
x = -coordRange + 2 * coordRange * rand(numPoints, 1);
y = -coordRange + 2 * coordRange * rand(numPoints, 1);

%% 添加点（批量添加）
a = AddPoint(a, x, y);

%% 绘制点
figure('Position', [100, 100, 800, 600]);
Plot(a, 'grid', 1);
title('10 Random 2D Points');
xlabel('X');
ylabel('Y');
axis equal;
grid on;

%% 输出点信息
disp('========================================');
disp('  10 Random 2D Points');
disp('========================================');
disp('');

fprintf('Generated points: %d\n', numPoints);
fprintf('Coordinate range: +/- %.0f\n', coordRange);
disp('');
disp('Point coordinates (X, Y):');
for i = 1:numPoints
    fprintf('Point %2d: (%8.2f, %8.2f)\n', i, x(i), y(i));
end

disp('');
fprintf('Total points: %d\n', a.NP);
fprintf('Total groups: %d\n', a.NG);

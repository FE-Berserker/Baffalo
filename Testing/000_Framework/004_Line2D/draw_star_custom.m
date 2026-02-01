% Draw a customizable star
% 绘制可定制的星形

%% Parameters
N = 5;       % Number of points (顶点数) - 5 for 5-pointed star
r = 5;       % Radius (半径)
sang = -90;  % Start angle in degrees (起始角度，-90表示从顶部开始)

%% Create Line2D object
L2D = Line2D('CustomStar', 'Echo', 1);

%% Add star
% AddStar(L2D, N, r, 'sang', sang)
% N: number of points
% r: radius
% sang: start angle (degrees)
L2D = AddStar(L2D, N, r, 'sang', sang);

%% Plot the star
Plot(L2D, 'equal', 1, 'grid', 1, 'color', 1);

title(sprintf('%d-Pointed Star (Radius=%.1f)', N, r));

fprintf('Star created successfully!\n');
fprintf('Number of points: %d\n', N);
fprintf('Radius: %.1f\n', r);
fprintf('Start angle: %.1f degrees\n', sang);

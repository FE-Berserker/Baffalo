% Draw a filled 5-pointed star with customizable inner and outer radius
% 绘制可填充的五角星（可指定内外半径）

%% Parameters
N = 5;        % Number of points (顶点数)
R1 = 5;       % Outer radius (外半径)
R2 = 2;       % Inner radius (内半径)
sang = -90;   % Start angle in degrees (起始角度)
fill_color = [1, 0.84, 0];   % Fill color (gold: RGB)
edge_color = [1, 0, 0];       % Edge color (red: RGB)
line_width = 2;        % Line width

%% Calculate vertices
num_vertices = 2 * N;  % 2*N vertices (outer + inner)
vertices = zeros(num_vertices, 2);

for i = 1:num_vertices
    angle = sang + (i - 1) * 180 / N;  % Each vertex separated by 180/N degrees
    if mod(i, 2) == 1
        r = R1;  % Outer vertex
    else
        r = R2;  % Inner vertex
    end
    vertices(i, 1) = r * cosd(angle);
    vertices(i, 2) = r * sind(angle);
end

%% Create filled star figure
figure('Position', [100 100 800 800]);

% Fill the star
fill(vertices(:,1), vertices(:,2), fill_color, ...
    'EdgeColor', edge_color, 'LineWidth', line_width);

% Set axis properties
axis equal;
grid on;
xlim([-R1*1.2, R1*1.2]);
ylim([-R1*1.2, R1*1.2]);
title(sprintf('%d-Pointed Filled Star (R1=%.1f, R2=%.1f)', N, R1, R2));

% Draw center point
hold on;
plot(0, 0, 'k+', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

fprintf('Filled star created successfully!\n');
fprintf('Number of points: %d\n', N);
fprintf('Outer radius: %.1f\n', R1);
fprintf('Inner radius: %.1f\n', R2);
fprintf('Fill color: %s\n', fill_color);
fprintf('Edge color: %s\n', edge_color);

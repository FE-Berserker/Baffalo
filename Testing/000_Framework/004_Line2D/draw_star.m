% Draw a 5-pointed star
% 绘制五角星

% Create Line2D object
L2D = Line2D('FivePointedStar', 'Echo', 1);

% Add 5-pointed star
% Parameters: N = number of points, r = radius
L2D = AddStar(L2D, 5, 5, 'sang', -90);  % 5 points, radius=5, start angle=-90 (top)

% Plot the star
Plot(L2D, 'equal', 1, 'grid', 1, 'color', 1);

fprintf('Five-pointed star created successfully!\n');
fprintf('Number of points: 5\n');
fprintf('Radius: 5\n');

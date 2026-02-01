% Draw a 2D Building Frame Structure
% 绘制2D楼房框架结构

%% Parameters
% Building dimensions
floor_height = 3.0;     % Floor height (meters)
num_floors = 4;          % Number of floors
bay_width = 4.0;         % Bay width (meters)
num_bays = 3;            % Number of bays

% Column and beam sizes
col_width = 0.3;         % Column width
beam_depth = 0.4;        % Beam depth

%% Create Line2D object
L2D = Line2D('BuildingFrame', 'Echo', 1);

% Create Point2D object for storing points
Point = Point2D('FramePoints', 'Echo', 0);

%% Draw Columns (Vertical Lines)
fprintf('Drawing columns...\n');
for i = 0:num_bays
    x0 = i * bay_width;
    y_start = 0;
    y_end = num_floors * floor_height;

    % Add two points as a column vector for the line
    x = [x0; x0];  % Column vector
    y = [y_start; y_end];  % Column vector
    Point = AddPoint(Point, x, y);
    L2D = AddLine(L2D, Point, GetNgpts(Point));
end

%% Draw Beams (Horizontal Lines)
fprintf('Drawing beams...\n');
for floor = 1:num_floors
    y = floor * floor_height;
    % Main beam across all bays
    x = [0; num_bays * bay_width];
    y_line = [y; y];
    Point = AddPoint(Point, x, y_line);
    L2D = AddLine(L2D, Point, GetNgpts(Point));
end

%% Draw Bracing (Diagonal Lines)
fprintf('Drawing bracing...\n');
bracing_floors = [1, 3];  % Add bracing to specific floors
for floor = bracing_floors
    y_bottom = (floor - 1) * floor_height;
    y_top = floor * floor_height;

    for bay = 1:num_bays
        x_left = (bay - 1) * bay_width;
        x_right = bay * bay_width;

        % X-bracing pattern
        % Diagonal 1: bottom-left to top-right
        Point = AddPoint(Point, [x_left; x_right], [y_bottom; y_top]);
        L2D = AddLine(L2D, Point, GetNgpts(Point));

        % Diagonal 2: top-left to bottom-right
        Point = AddPoint(Point, [x_left; x_right], [y_top; y_bottom]);
        L2D = AddLine(L2D, Point, GetNgpts(Point));
    end
end

%% Plot the building frame
fprintf('Plotting building frame...\n');

% Get total building dimensions
total_width = num_bays * bay_width;
total_height = num_floors * floor_height;

% Set up plot
figure('Position', [100 100 1000 800]);

% Plot all curves
Plot(L2D, 'equal', 1, 'grid', 1, 'color', 1);

%% Add labels and annotations
hold on;

% Add floor labels
for floor = 1:num_floors
    y = floor * floor_height + floor_height / 2;
    text(-0.5, y, sprintf('Floor %d', floor), ...
        'HorizontalAlignment', 'right', 'FontSize', 10, 'FontWeight', 'bold');
end

% Add bay labels
for bay = 1:num_bays
    x = (bay - 0.5) * bay_width;
    text(x, total_height + 0.5, sprintf('Bay %d', bay), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
end

% Add dimensions
% Total height dimension
arrow_size = 0.3;
plot([-arrow_size, arrow_size], [0, 0], 'k-', 'LineWidth', 1.5);
plot([-arrow_size, arrow_size], [total_height, total_height], 'k-', 'LineWidth', 1.5);
plot([-arrow_size/2, -arrow_size/2], [0, total_height], 'k-', 'LineWidth', 1.5);
text(-1.5, total_height/2, sprintf('%.1f m', total_height), ...
    'Rotation', 90, 'HorizontalAlignment', 'center', 'FontSize', 9);

% Total width dimension
plot([0, 0], [-arrow_size, arrow_size], 'k-', 'LineWidth', 1.5);
plot([total_width, total_width], [-arrow_size, arrow_size], 'k-', 'LineWidth', 1.5);
plot([0, total_width], [-arrow_size/2, -arrow_size/2], 'k-', 'LineWidth', 1.5);
text(total_width/2, -1.0, sprintf('%.1f m', total_width), ...
    'HorizontalAlignment', 'center', 'FontSize', 9);

% Add building info
title(sprintf('2D Building Frame Structure\n%d Floors x %d Bays (Height=%.1fm, Width=%.1fm)', ...
    num_floors, num_bays, total_height, total_width), 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Width (m)', 'FontSize', 10);
ylabel('Height (m)', 'FontSize', 10);

% Set axis limits
xlim([-2, total_width + 2]);
ylim([-2, total_height + 2]);

hold off;

%% Summary
fprintf('\n=== Building Frame Summary ===\n');
fprintf('Number of floors: %d\n', num_floors);
fprintf('Number of bays: %d\n', num_bays);
fprintf('Floor height: %.2f m\n', floor_height);
fprintf('Bay width: %.2f m\n', bay_width);
fprintf('Total height: %.2f m\n', total_height);
fprintf('Total width: %.2f m\n', total_width);
fprintf('Total curves: %d\n', GetNcrv(L2D));
fprintf('Building frame created successfully!\n');

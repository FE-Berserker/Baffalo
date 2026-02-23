function PlotSNCurve(obj)
    % PlotSNCurve - Plot the S-N curve
    %
    % Plots the fatigue strength curve (S_fw_prime) from the output.
    % S_fw_prime is a matrix with:
    %   Column 1: Number of cycles (N)
    %   Column 2: Fatigue strength (S_fw)

    % Extract S-N curve data
    S_fw_prime = obj.output.S_fw_prime;

    % Check if data is available
    if isempty(S_fw_prime)
        error('S_fw_prime data not available. Please run solve() first.');
    end

    % Extract cycles and fatigue strength
    N = S_fw_prime(:, 1);      % Number of cycles
    S_fw = S_fw_prime(:, 2);    % Fatigue strength

    % Build complete S-N curve:
    % 0~1e3: use 1e3 value (horizontal line)
    % 1e3~1e7: use S_fw_prime data
    % >1e7: use 1e7 value or endurance limit (horizontal line)

    % Pre-segment (0~1e3): use 1e3 value
    N_pre = [1, 1e3]';
    S_pre = S_fw(1) * ones(size(N_pre));

    % Post-segment (>1e7): use 1e7 value or endurance limit
    N_post = [1e7, 1e9]';
    S_post = S_fw(end,1) * ones(size(N_post));

    % Combine all segments
    N_plot = [N_pre; N; N_post];
    S_plot = [S_pre; S_fw; S_post];

    % Create figure and plot S-N curve
    figure;
    loglog(N_plot, S_plot, 'LineWidth', 2, 'Color', 'b');
    hold on;

    % Plot key data points from S_fw_prime
    loglog(N, S_fw, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');

    grid on;
    xlabel('Number of Cycles');
    ylabel('Fatigue Strength (MPa)');

    % Set y-axis range from 0 to 1.1x max value
    ylim([0, max(S_plot) * 1.1]);

    % Set title
    materialName = obj.params.Material.Name;
    if obj.params.IsShotPeened
        shotPeenedStr = '(Shot Peened)';
    else
        shotPeenedStr = '';
    end
    title(sprintf('%s S-N Curve %s', materialName, shotPeenedStr));

    hold off;
end

function obj = checkBuckling(obj)
    % checkBuckling - Check buckling risk based on buckling limit curves
    %
    % Buckling limit curves:
    %   - Lower curve (a_x, a_y): Nonparallel ends
    %   - Upper curve (b_x, b_y): Parallel ends
    %
    % x = FreeLength / MeanDiameter (slenderness ratio)
    % y = ActualDeflection / FreeLength (deflection ratio)
    %
    % Safety criterion: y should be BELOW the corresponding limit curve

    x = obj.input.FreeLength / obj.input.MeanDiameter;
    y = obj.output.ActualDeflection / obj.input.FreeLength;

    % Load buckling limit data from private folder
    bucklingData = load('bucklingLimits.mat');

    % Select limit curve based on end condition
    if strcmpi(obj.input.EndCondition, 'fixed_fixed')
        % Parallel ends - use upper curve (b_x, b_y)
        x_curve = bucklingData.b_x;
        y_curve = bucklingData.b_y;
        endTypeStr = 'Parallel ends (fixed-fixed)';
    else
        % Nonparallel ends (fixed_free or others) - use lower curve (a_x, a_y)
        x_curve = bucklingData.a_x;
        y_curve = bucklingData.a_y;
        endTypeStr = 'Nonparallel ends';
    end

    % Interpolate limit at current x
    if x >= min(x_curve) && x <= max(x_curve)
        y_limit = interp1(x_curve, y_curve, x, 'linear', 'extrap');
        isInDataRange = true;
    else
        y_limit = NaN;
        isInDataRange = false;
    end

    % Check buckling risk: y should be below the limit curve
    if isInDataRange
        % y < y_limit means safe (no buckling risk)
        obj.output.IsBucklingRisk = y >= y_limit;
    else
        if x<min(x_curve)
             obj.output.IsBucklingRisk = 0;
        end
    end

    obj.output.BucklingEndType = endTypeStr;

    % Print buckling check result
    if obj.params.Echo
        fprintf('\n--- Buckling Check ---\n');
        fprintf('End condition: %s\n', endTypeStr);
        fprintf('Slenderness ratio (L0/D): %.3f\n', x);
        fprintf('Deflection ratio (y/L0): %.4f\n', y);
        if isInDataRange
            fprintf('Buckling limit: %.4f\n', y_limit);
            if obj.output.IsBucklingRisk
                fprintf('WARNING: BUCKLING RISK! y >= limit\n');
            else
                fprintf('OK: No buckling risk\n');
            end
        else
            warning('Buckling evaluation is out of range (x = %.3f)', x);
        end
    end
end

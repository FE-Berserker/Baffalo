function checkSafety(obj)
    % checkSafety - Check if safety requirements are met

    % Spring index check
    C = obj.output.SpringIndex;
    if C < obj.baseline.MinSpringIndex
        warning(['HelicalCompressionSpring:SpringIndex', ...
                 'Spring index %.2f less than minimum %.2f, difficult to manufacture'], ...
                 C, obj.baseline.MinSpringIndex);
    end
    if C > obj.baseline.MaxSpringIndex
        warning(['HelicalCompressionSpring:SpringIndex', ...
                 'Spring index %.2f greater than maximum %.2f, prone to buckling'], ...
                 C, obj.baseline.MaxSpringIndex);
    end

    % Static safety check
    if obj.capacity.MinClashPercent < obj.baseline.MinClashPercent/100
        warning(['HelicalCompressionSpring:MinClashPercent', ...
            'MinClashPercent %.2f less than required %.2f, ipercent'], ...
            obj.output.ClashAllowance, obj.baseline.MinClashPercent);
    end

    % Static safety check
    if obj.capacity.MinSafetyFactorStatic < obj.baseline.MinSafetyFactorStatic
        warning(['HelicalCompressionSpring:StaticSafety', ...
                 'Static safety factor %.2f less than required %.2f, increase wire diameter or reduce load'], ...
                 obj.output.SafetyFactorStatic, obj.baseline.MinSafetyFactorStatic);
    end

    % Fatigue safety check (only for dynamic loads)
    if ~isempty(obj.output.SafetyFactorFatigue)
        if obj.capacity.MinSafetyFactorFatigue < obj.baseline.MinSafetyFactorFatigue
            warning(['HelicalCompressionSpring:FatigueSafety', ...
                     'Fatigue safety factor %.2f less than required %.2f, adjust design or use shot peening'], ...
                     obj.output.SafetyFactorFatigue, obj.baseline.MinSafetyFactorFatigue);
        end
    end

    % Surge check
    if obj.output.IsSurgeRisk
        warning(['HelicalCompressionSpring:Surge', ...
                 'Surge ratio %.2f less than required %.2f, resonance risk'], ...
                 obj.output.SurgeRatio, obj.baseline.MinSurgeRatio);
    end

    % Buckling check
    if obj.output.IsBucklingRisk
        warning(['HelicalCompressionSpring:Buckling', ...
                 'Slenderness ratio %.2f greater than limit %.2f, buckling risk, use guide device'], ...
                 obj.input.FreeLength / obj.input.MeanDiameter);
    end
end

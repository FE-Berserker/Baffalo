function obj = calculateCapacity(obj)
    % calculateCapacity - Calculate actual capacity metrics

    % Spring index evaluation - use MinSpringIndex as reference
    C = obj.output.SpringIndex;
    obj.capacity.MinSpringIndex = C;  % Actual value
    obj.capacity.MaxSpringIndex = C;  % Actual value

    % Static safety factor ratio
    obj.capacity.MinSafetyFactorStatic = obj.output.SafetyFactorStatic;  % Actual value

    obj.capacity.MinClashPercent=obj.output.ClashAllowance/obj.input.WorkingDeflection;

    % Fatigue safety factor ratio
    if ~isempty(obj.output.SafetyFactorFatigue)
        obj.capacity.MinSafetyFactorFatigue = obj.output.SafetyFactorFatigue;  % Actual value
    end

    % Surge ratio
    if ~isempty(obj.output.SurgeRatio)
        obj.capacity.MinSurgeRatio = obj.output.SurgeRatio;  % Actual value
    end

    % Slenderness ratio
    slendernessRatio = obj.input.FreeLength / obj.input.MeanDiameter;
    obj.capacity.MaxSlendernessRatio = slendernessRatio;  % Actual value
end

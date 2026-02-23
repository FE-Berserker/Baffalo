function obj = calculateStress(obj, S_sys, S_fw_prime, S_ew_prime)
    % calculateStress - Calculate stress and safety factors

    d = obj.input.WireDiameter;
    D = obj.input.MeanDiameter;
    F = obj.input.WorkingForce;
    C = obj.output.SpringIndex;

    % Direct shear factor (Formula 14.8)
    Ks = 1 + 0.5 / C;
    obj.output.DirectShearFactor = Ks;

    % Wahl factor (Formula 14.9a)
    Kw = (4*C - 1) / (4*C - 4) + 0.615 / C;
    obj.output.WahlFactor = Kw;

    % Select stress calculation method based on load type and process
    if strcmp(obj.input.LoadType, 'static')
        if obj.params.IsSet
            % Static and set: use Ks
            tau_max = Ks * (8 * F * D) / (pi * d^3);
        else
            % Static not set: use Kw (conservative)
            tau_max = Kw * (8 * F * D) / (pi * d^3);
        end
    else  % dynamic
        % Dynamic: use Kw
        tau_max = Kw * (8 * F * D) / (pi * d^3);
    end
    obj.output.MaxShearStress = tau_max;  % MPa

    % Static safety factor
    obj.output.SafetyFactorStatic = S_sys / tau_max;

    % Dynamic fatigue safety factor
    if strcmp(obj.input.LoadType, 'dynamic')

        % Estimate fatigue life
        obj.output.SafetyFactorFatigue = estimateFatigueFactor(tau_max, S_fw_prime, S_ew_prime,...
            obj.params.Cycles);
    else
        obj.output.SafetyFactorFatigue = [];
    end
end

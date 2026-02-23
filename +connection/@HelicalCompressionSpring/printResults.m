function printResults(obj)
    % printResults - Print design result summary

    fprintf('\n--- Geometric Parameters ---\n');
    fprintf('Spring Index: %.2f\n', obj.output.SpringIndex);
    fprintf('Outer Diameter: %.3f mm\n', obj.output.OuterDiameter);
    fprintf('Inner Diameter: %.3f mm\n', obj.output.InnerDiameter);
    fprintf('Total Coils: %.2f\n', obj.output.TotalCoils);
    fprintf('Active Coils: %.2f\n', obj.output.ActiveCoils);
    fprintf('Solid Length: %.2f mm\n', obj.output.SolidLength);
    fprintf('Clash Allowance: %.2f mm (%.1f%%)\n', ...
            obj.output.ClashAllowance, obj.capacity.MinClashPercent);

    fprintf('\n--- Spring Rate & Deflection ---\n');
    fprintf('Spring Rate: %.3f N/mm\n', obj.output.SpringRate);
    fprintf('Actual Deflection: %.3f mm\n', obj.output.ActualDeflection);

    fprintf('\n--- Stress Analysis ---\n');
    fprintf('Wahl Factor: %.3f\n', obj.output.WahlFactor);
    fprintf('Direct Shear Factor: %.3f\n', obj.output.DirectShearFactor);
    fprintf('Max Shear Stress: %.2f MPa\n', obj.output.MaxShearStress);

    fprintf('\n--- Safety Factors ---\n');
    fprintf('Static Safety Factor: %.2f (baseline: %.2f)\n', ...
            obj.output.SafetyFactorStatic, obj.baseline.MinSafetyFactorStatic);

    if strcmp(obj.input.LoadType, 'dynamic')
        fprintf('Fatigue Safety Factor: %.2f (baseline: %.2f)\n', ...
                obj.output.SafetyFactorFatigue, obj.baseline.MinSafetyFactorFatigue);
        fprintf('Natural Frequency: %.1f Hz\n', obj.output.NaturalFrequency);
        fprintf('Surge Ratio: %.2f (baseline: %.2f)\n', ...
                obj.output.SurgeRatio, obj.baseline.MinSurgeRatio);
    end

    fprintf('\n--- Risks ---\n');
    fprintf('Buckling Risk: %s\n', string(obj.output.IsBucklingRisk));
    if strcmp(obj.input.LoadType, 'dynamic')
        fprintf('Surge Risk: %s\n', string(obj.output.IsSurgeRisk));
    end

    fprintf('========================================\n\n');
end

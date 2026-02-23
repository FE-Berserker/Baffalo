function [S_ut, S_us, S_sys, S_fw_prime, S_ew_prime] = calculateMaterialStrength(obj)
    % calculateMaterialStrength - Calculate material strength
    %
    % Returns:
    %   S_ut - Tensile strength (MPa)
    %   S_us - Ultimate shear strength (MPa)
    %   S_sys - Torsional yield strength (MPa)
    %   S_fw_prime - Torsional fatigue strength (MPa)
    %   S_ew_prime - Torsional endurance limit (MPa)

    d = obj.input.WireDiameter;  % mm

    % Material coefficients
    matCoeffs.A= obj.params.Material.A;
    matCoeffs.b= obj.params.Material.b;


    % Tensile strength (Formula 14.3)
    S_ut = matCoeffs.A * (d^matCoeffs.b);  % MPa

    % Ultimate shear strength (Formula 14.4)
    S_us = 0.67 * S_ut;  % MPa

    % Torsional yield strength (Table 14-9)
    S_sys = getYieldStrength(obj.params.Material, S_ut, obj.params.IsSet);

    % Torsional fatigue strength (Table 14-10) (Stress Ratio, R = 0)
    S_fw_prime = getFatigueStrength(obj.params.Material, S_ut, obj.params.IsShotPeened);

    % Torsional endurance limit (infinite life)
    S_ew_prime =getEnduranceLimit(obj.params.Material, S_ut, obj.params.IsShotPeened);
end

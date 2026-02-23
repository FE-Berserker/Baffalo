function S_sys = getYieldStrength(mat, S_ut, isSet)
    % getYieldStrength - Return torsional yield strength
    %
    % S_sys is a percentage of S_ut

    % Cold-drawn carbon steel
    if any(strcmp(mat.ASTM, {'A227', 'A228'}))
        if isSet
            S_sys = 0.60 * S_ut;  % After set: 60-70%
        else
            S_sys = 0.45 * S_ut;  % Not set: 45%
        end
    % Quenched and tempered carbon/low alloy steel
    elseif any(strcmp(mat.ASTM, {'A229','A230','A232', 'A401'}))
        if isSet
            S_sys = 0.65 * S_ut;  % After set: 65-75%
        else
            S_sys = 0.50 * S_ut;  % Not set: 50%
        end
    % Austenitic stainless steel / Non-ferrous alloys
    else
        if isSet
            S_sys = 0.55 * S_ut;  % After set: 55-65%
        else
            S_sys = 0.35 * S_ut;  % Not set: 35%
        end
    end
end

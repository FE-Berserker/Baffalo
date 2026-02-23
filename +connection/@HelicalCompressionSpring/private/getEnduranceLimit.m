function S_ew_prime = getEnduranceLimit(~, ~, isShotPeened)
    % getEnduranceLimit - Return torsional endurance limit
    %
    % For spring wire with diameter d < 10mm
    % Not shot peened ~ 45 kpsi (310 MPa)

    if isShotPeened
        S_ew_prime = 350;  % MPa, after shot peening
    else
        S_ew_prime = 310;  % MPa
    end
end

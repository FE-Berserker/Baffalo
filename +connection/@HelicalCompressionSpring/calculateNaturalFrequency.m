function obj = calculateNaturalFrequency(obj)
    % calculateNaturalFrequency - Calculate natural frequency and surge ratio

    if strcmp(obj.input.LoadType, 'static')
        % Skip surge calculation for static load
        obj.output.NaturalFrequency = [];
        obj.output.SurgeRatio = [];
        obj.output.IsSurgeRisk = false;
        return;
    end

    Mat=obj.params.Material;

    d = obj.input.WireDiameter/1000;  % mm
    D = obj.input.MeanDiameter/1000;  % mm
    Na = obj.output.ActiveCoils;
    G = Mat.G*1e6;  % MPa = N/mm^2
    g = obj.params.g;  % mm/s^2

    % Material weight density (steel)
    gamma = Mat.Dens*1e12;

    % Effective coils (double for fixed-free)
    if strcmp(obj.input.EndCondition, 'fixed_free')
        Na_effective = 2 * Na;
    else
        Na_effective = Na;
    end

    % Natural frequency (Formula 14.12c)
    fn = (2 / (pi* Na_effective))/pi * (d / (D^2)) * sqrt((G * g) / (32 * gamma));  % Hz
    obj.output.NaturalFrequency = fn;

    % Surge ratio
    f_load = obj.input.LoadingFreq;
    surgeRatio = fn / f_load;
    obj.output.SurgeRatio = surgeRatio;

    % Surge risk determination
    obj.output.IsSurgeRisk = surgeRatio < obj.baseline.MinSurgeRatio;
end

function obj = calculateGeometry(obj)
    % calculateGeometry - Calculate spring geometric parameters

    % Spring index
    C = obj.input.MeanDiameter / obj.input.WireDiameter;
    obj.output.SpringIndex = C;

    % Outer and inner diameters
    obj.output.OuterDiameter = obj.input.MeanDiameter + obj.input.WireDiameter;
    obj.output.InnerDiameter = obj.input.MeanDiameter - obj.input.WireDiameter;

    % Estimate total coils (based on deflection formula)
    % y = (8*F*D^3*Na) / (d^4*G)
    d = obj.input.WireDiameter;
    D = obj.input.MeanDiameter;
    R = obj.params.R;
    Fmax = obj.input.WorkingForce; % max force
    Fmin = Fmax*R;
    F=Fmax-Fmin;
    y = obj.input.WorkingDeflection; 
    G = obj.params.Material.G;


    % k=F/y;
    Na = (y * d^4 * G) / (8 * F * D^3);
    k = (d^4 * G) / (8 * D^3 * Na);  % N/mm
    obj.output.SpringRate = k;

    % Actual deflection (Formula 14.6)
    y_actual = (8 * Fmax * D^3 * Na) / (d^4 * G);  % mm
    obj.output.ActualDeflection = y_actual;

    % Determine total coils based on end type
    switch obj.input.EndType
        case 'open'
            Nt = Na;
        case 'open_ground'
            Nt = Na + 1;
        case {'square', 'square_ground'}
            Nt = Na + 2;
    end

    % Round to 1/4 coil (manufacturing precision)
    % Nt = round(Nt * 4) / 4;
    obj.output.TotalCoils = Nt;

    % Recalculate active coils
    switch obj.input.EndType
        case 'open'
            obj.output.ActiveCoils = Nt;
        case 'open_ground'
            obj.output.ActiveCoils = Nt - 1;
        case {'square', 'square_ground'}
            obj.output.ActiveCoils = Nt - 2;
    end

    % Solid length
    if strcmp(obj.input.EndType, 'square_ground')
        % Square ground: each end removes about 0.5 coil
        Ls = Nt * d;
    else
        Ls = (Nt + 1) * d;
    end
    obj.output.SolidLength = Ls;

    obj.output.yintial=Fmin/k;

    % Spring mass: W_t = (pi^2 * d^2 * D * N_t * rho) / 4
    rho = obj.params.Material.Dens;  % Density (tonne/mm^3)
    obj.output.Mass = (pi^2 * d^2 * D * Nt * rho) / 4;  % Mass (tonne)

    % Clash allowance
    ClashAllowance = obj.input.FreeLength - obj.input.WorkingDeflection - Ls-Fmin/k;

    if ClashAllowance<0
        Error('Please increase the free length !')
    end
    obj.output.ClashAllowance=ClashAllowance;
end

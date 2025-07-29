function varargout = AirProperties(t, p, h, varargin)
% AirProperties calculates a variety of air thermodynamic properties from 
% measured values of temperature, pressure and humidity. 
% 
% Variables able to calcuated: 
%   rho         [kg m^-3]       Density
%   mu          [N s m^-2]      Dynamic viscosity
%   k           [W m^-1 K^-1]   Thermal conductivity
%   c_p         [J kg^-1 K^-1]  Specific heat capacity (constant pressure)
%   c_v         [J kg^-1 K^-1]  Specific heat capacity (constant volume)
%   gamma       [1]             Ratio of specific heats
%   c           [m s^-1]        Speed of sound: c = (gamma*R*T/M)^0.5
%   nu          [m^2 s^-1]      Kinematic viscosity: nu = mu/rho
%   alpha       [m^2 s^-1]      Thermal diffusivity: alpha = k/(rho*c_p)
%   Pr          [1]             Prandtl number: Pr = mu*c_p/k
%   M           [kg mol^-1]     Molar mass of humid air
%   R           [J kg^-1 K^-1]  Specific gas constant
%   h           [%]             Relative humidity (if dewpoint inputted)
% 
% Syntax
%   rho = AirProperties
%   [...] = AirProperties(t, p)
%   [...] = AirProperties(t, p, h)
%   [...] = AirProperties(t, p, t_dp, 'DewPoint')
%   [...] = AirProperties(t, p, [], ...)
%   [...] = AirProperties(..., 'xCO2',0.0005)
%   [..., rho]     = AirProperties(..., 'rho')
%   [..., mu]      = AirProperties(..., 'mu')
%   [..., k]       = AirProperties(..., 'k')
%   [..., c_p]     = AirProperties(..., 'c_p')
%   [..., c_v]     = AirProperties(..., 'c_v')
%   [..., gamma]   = AirProperties(..., 'gamma')
%   [..., c]       = AirProperties(..., 'c')
%   [..., nu]      = AirProperties(..., 'nu')
%   [..., alpha]   = AirProperties(..., 'alpha')
%   [..., Pr]      = AirProperties(..., 'Pr')
%   [..., M]       = AirProperties(..., 'M')
%   [..., R]       = AirProperties(..., 'R')
%   [..., h]       = AirProperties(..., 'h')
%   [rho, mu, k, c_p, c_v, gamma, c, nu, alpha, Pr, M, R, h] = AirProperties(t, p, h)
% 
% Inputs
%   <None>      If no inputs are given then it returns the ISA standard air
%               density at 1013.25 hPa and 15°C: 1.225 [kg m^-3].
%               (Recommended value range - see references.)
%   t           ( 15 <= t <= 27  ) [°C]     (m x 1 numeric) Air temperature.
%   p           (600 <= p <= 1100) [hPa]    (m x 1 numeric) Air pressure.
%                   If the pressure is unknown, input [] as p and calculations 
%                   will proceed assuming the standard atmosphere (1013.25 hPa)
%   h           (  0 <= h <= 100 ) [%]      (m x 1 numeric) Relative humidity.
%                   If the humidity is unknown, input [] as h and calculations 
%                   will proceed assuming dry air. 
% 
% Inputs (Optional) 
%   'DewPoint'  Option to calculate the air properties with the dew point rather
%               than the relative humidity. This uses the third input as the 
%               value for dewpoint: t_dp [°C] (t_dp <= t) (m x 1 numeric)
%   'xCO2'      [mol mol^-1] (1 x 1 numeric) Mole fraction of CO2 in the air.
%               Used to improve the estimate of the molar mass of dry air.
%               Default 0.0004.
%   <Output>    (char) The variable to output. 
%               The order of the outputs will follow the input order. 
%               If none of these are provided then the outputs will follow the 
%               default order up to the number of outputs requested (nargout).
%               One or more of the above listed variables. 
% 
% Example Usage
%   rho = AirProperties
%   rho = AirProperties(18)
%   rho = AirProperties(18, 1010)
%   rho = AirProperties(18, 1010, 45)
%   [rho, mu, k] = AirProperties(22, 1010, 18, 'Dewpoint')
%   [rho, mu, k] = AirProperties(18, 1010, 45, 'xCO2', 0.0005)
%   [rho, mu, nu, c] = AirProperties(18, 1010, 45, 'rho', 'mu', 'nu', 'c')
%   [c, nu, mu, rho] = AirProperties(18, 1010, 45, 'c', 'nu', 'mu', 'rho')
%   [c, nu, mu, rho] = AirProperties(18, 1010, [], 'c', 'nu', 'mu', 'rho')
%   [c, nu, mu, rho] = AirProperties(18,   [], [], 'c', 'nu', 'mu', 'rho')
%   
%   t = (15:25)';   p = 1010;           h = 40; 
%   t = 25;         p = (950:10:1040)'; h = 40; 
%   t = 25;         p = 1010;           h = (0:10:100)'; 
%   t = linspace(15,25,10)'; p=linspace(950,1040,10)'; h=linspace(0,100,10)';
%   [rho, mu, k, c, c_p] = AirProperties(t, p, h, 'rho', 'mu', 'k', 'c', 'c_p')
% 
%   t = 0:100; p = 1013.25; h = 0:10:100;
%   n = length(h); Col = repmat((1-1/n:-1/n:0)', 1,3);
%   figure('Position',[50,50,500,400]); hold on; 
%   for ii = 1:n
%       rho(:,ii) = AirProperties(t, [], h(ii), 'rho');
%       plot(t, rho(:,ii), 'color',Col(ii,:));
%   end
%   annotation('textarrow',[0.8,0.75],[0.65,0.35],'String','Humidity')
%   xlabel('Temperature [°C]'); 
%   ylabel('\rho [kg m^{-3}]'); 
%   title('Density of air')
% 
% References:
%   Picard, A, Davis, RS, Glaser, M, Fujii, K, 2008, 'Revised formula for the
%   density of moist air (CIPM-2007)', Metrologia, vol. 45, no. 2, pp. 149-155.
%   DOI: http://dx.doi.org/10.1088/0026-1394/45/2/004
%
%   Tsilingiris, P, 2008, 'Thermophysical and transport properties of humid air
%   at temperature range between 0 and 100°C', Energy Conversion and
%   Management, vol. 49, no. 5, pp.1098-1110. 
%   DOI: https://doi.org/10.1016/j.enconman.2007.09.015
% 
% Shaun Fitzgerald
% Created 2017-09-25
% Modified 
%   2020-03-09  Included calculation of various extra air properties. 
%   2020-11-17  Added to GitHub

%% Inputs 
if nargin == 0
    % ISA standard density of air at 15 °C and 1013.25 hPa
    varargout{1} = 1.225;           % [kg m^-3]
    return
end

% Temperature
assert(isnumeric(t) && isvector(t), ...
    'Expected input ''t'' to be a numeric vector or scalar.')

% Pressure
if nargin < 2 || isempty(p)
    p = 1013.25;                    % [hPa] (1 atm)
else
    assert(isnumeric(p) && isvector(p), ...
        'Expected input ''p'' to be a numeric vector or scalar.')
    assert(all(p >= 0), 'Cannot have a negative pressure.')
end

% Humidity
if nargin < 3 || isempty(h)
    UseHumidity = false;
else
    UseHumidity = true;
    assert(isnumeric(h) && isvector(h), ...
        'Expected input ''h'' to be a numeric vector or scalar.')
    assert(all(h >= 0) && all(h <= 100), ...
        'The humidity must be in the range: 0 <= h <= 100.')
end

% Default values
xCO2        = 0.0004;
DewPoint    = false;
AllOutputs  = {'rho','mu','k','c_p','c_v','gamma','c','nu','alpha','Pr','M','R','h'};
OutputNum   = [];

ii = 0;
cc = 0;
while ii < nargin-3
    ii = ii + 1;
    if ischar(varargin{ii}) && ~isempty(varargin{ii})
        switch varargin{ii}
            case {'dew point', 'dewpoint', 'dew',...
                    'Dew point', 'Dewpoint', 'DewPoint', 'Dew', 't_dp'}
                DewPoint = true;
            case AllOutputs
                cc = cc + 1;
                Outputs{cc} = varargin{ii};
                OutputNum.(Outputs{cc}) = cc;
            case {'xCO2', 'CO2'}
                ii = ii + 1;
                xCO2 = varargin{ii};
            otherwise
                error('Unknown input: %s', varargin{ii})
        end
    else
        error('Unknown input: %g', varargin{ii})
    end
end

% Default condition for no outputs provided. 
if isempty(OutputNum)
    if nargout == 0
        nOut = 1;
    else
        nOut = nargout;
    end
    for ii = 1:nOut
        Outputs{ii} = AllOutputs{ii};
        OutputNum.(Outputs{ii}) = ii;
    end
end

%% Basic calculations 
% Constants
R  = 8.314472;                                  % [J mol^-1 K^-1]   Gas Constant
Ma = (28.96546 + 12.011*(xCO2 - 0.0004))*1e-3;  % [kg mol^-1]       Dry air
Mv = 18.01528e-3;                               % [kg mol^-1]       Water Vapour

% Unit conversion
P = p*100;                                      % [Pa]
T = t + 273.15;                                 % [K]

%% Humidity 
if UseHumidity
    % Saturation vapour pressure
    A =  1.2378847e-5;                          % [K^-2]
    B = -1.9121316e-2;                          % [K^-1]
    C = 33.93711047;                            % [1]
    D = -6.3431645e3;                           % [K]
    p_sv = exp(A*T.^2 + B*T + C + D./T);        % [Pa]
    
    % Enhancement factor
    alpha = 1.00062;                            % [1]
    beta  = 3.14e-8;                            % [Pa^-1]
    gamma = 5.6e-7;                             % [K^-2]
    f = alpha + beta*P + gamma*t.^2;            % [1]
    
    % Mole fraction of water vapour
    if DewPoint    % With dew point temperature
        t_dp = h;
        if any(t_dp > t)
            error('The dew point cannot be greater than the temperature.')
        end
        
        f_dp = alpha + beta*P + gamma*t_dp.^2;  % [1]
        x_v = f_dp.*p_sv./P;                    % [1]
        
        % Calculating relative humidity
        T_dp = t_dp + 273.15;                   % [K]
        p_sv_dp = exp(A*T_dp.^2 + B*T_dp + C + D./T_dp);  % [Pa]
        H = p_sv_dp.*f_dp./(p_sv.*f);           % [1]
        
    else           % With relative humidity
        H = h./100;                             % [1]
        x_v = H.*f.*p_sv./P;                    % [1]
        
    end
    
    if ismember('h', Outputs)
        varargout{OutputNum.h} = H*100;         % [%]
    end
    
    % Molar mass of humid air
    M = Ma*(1 - x_v) + Mv*x_v;                  % [kg mol^-1]
    
    % Compressibility Factor
    a0 =  1.58123e-6;                           % [K Pa^-1]
    a1 = -2.93310e-8;                           % [Pa^-1]
    a2 =  1.10430e-10;                          % [K^-1 Pa^-1]
    b0 =  5.70700e-6;                           % [K Pa^-1]
    b1 = -2.05100e-8;                           % [Pa^-1]
    c0 =  1.98980e-4;                           % [K Pa^-1]
    c1 = -2.37600e-6;                           % [Pa^-1]
    d  =  1.83000e-11;                          % [K^2 Pa^-2]
    e  = -0.76500e-8;                           % [K^2 Pa^-2]
    
    Z = 1 - P./T.*(a0 + a1*t + a2*t.^2 + (b0 + b1*t).*x_v + ...
        (c0 + c1*t).*x_v.^2) + P.^2.*T.^-2.*(d + e*x_v.^2);    % [1]
else
    if ismember('h', Outputs)
        varargout{OutputNum.h} = NaN;
    end
    
    % Assuming the molar mass of dry air
    M = Ma;                                     % [kg mol^-1]
    Z = 1;                                      % [1]
end

%% Density & molecular values
rho = P.*M./(R*Z.*T);                           % [kg m^-3]
if ismember('rho', Outputs)
    varargout{OutputNum.rho} = rho;
end
if ismember('M', Outputs)
    varargout{OutputNum.M} = M.*ones(size(rho));
end
if ismember('R', Outputs)
    varargout{OutputNum.R} = R./M.*ones(size(rho));
end

%% Viscosity 
if any(ismember({'mu', 'nu', 'k', 'alpha', 'Pr'}, Outputs))
    % Dry air - for 250 <= T <= 600 K
    MA0 = -9.8601e-1;
    MA1 =  9.080125e-2;
    MA2 = -1.17635575e-4;
    MA3 =  1.2349703e-7;
    MA4 = -5.7971299e-11;
    mu_a = (MA0 + MA1*T + MA2*T.^2 + MA3*T.^3 + MA4*T.^4)*1e-6; % [N s m^-2]
    
    if UseHumidity
        % Water vapour - for 0 <= t <= 120 °C
        MV0 = 80.58131868;
        MV1 =  0.4000549451;
        mu_v = (MV0 + MV1*t)*1e-7;              % [N s m^-2]
        
        % Interaction parameters
        Phi_av = 2^0.5/4*(1+Ma/Mv)^-0.5.*(1+(mu_a./mu_v).^0.5*(Mv/Ma)^0.25).^2;
        Phi_va = 2^0.5/4*(1+Mv/Ma)^-0.5.*(1+(mu_v./mu_a).^0.5*(Ma/Mv)^0.25).^2;
        
        % Mixture viscosity
        mu = ((1 - x_v).*mu_a)./((1 - x_v) + x_v.*Phi_av) + ...
            (x_v.*mu_v)./(x_v + (1 - x_v).*Phi_va); % [N s m^-2]
    else
        mu = mu_a;
    end
    
    if ismember('mu', Outputs)
        varargout{OutputNum.mu} = mu;           % [N s m^-2]
    end
    
    % Kinematic viscosity
    if ismember('nu', Outputs)
        nu = mu./rho;                           % [m^2 s^-1]
        varargout{OutputNum.nu} = nu;
    end
end

%% Specific heat capacity 
if any(ismember({'c_p', 'gamma', 'c', 'alpha', 'Pr'}, Outputs))
    % Dry air - for 250 < T < 1050 K
    CA0 =  1.03409;
    CA1 = -0.284887e-3;
    CA2 =  0.7816818e-6;
    CA3 = -0.4970786e-9;
    CA4 =  0.1077024e-12;
    c_pa = CA0 + CA1*T + CA2*T.^2 + CA3*T.^3 + CA4*T.^4;	% [kJ kg^-1 K^-1]
    
    if UseHumidity
        % Water vapour - for 0 < t < 120 °C
        CV0 =  1.86910989;
        CV1 = -2.578421578e-4;
        CV2 =  1.941058941e-5;
        c_pv = CV0 + CV1*t + CV2*t.^2;                      % [kJ kg^-1 K^-1]
        
        % Specific heat capacity
        c_p = c_pa.*(1 - x_v)*Ma./M + c_pv.*x_v*Mv./M;      % [kJ kg^-1 K^-1]
        
    else
        c_p = c_pa;
    end
    c_p = c_p*1000;                                         % [J kg^-1 K^-1]
    
    if ismember('c_p', Outputs)
        varargout{OutputNum.c_p} = c_p;
    end
    
end

%% Thermal conductivity 
if any(ismember({'k', 'alpha', 'Pr'}, Outputs))
    % Dry air - for 250 < T < 1050 K
    KA0 = -2.276501e-3;
    KA1 =  1.2598485e-4;
    KA2 = -1.4815235e-7;
    KA3 =  1.73550646e-10;
    KA4 = -1.066657e-13;
    KA5 =  2.47663035e-17;
    k_a = KA0 + KA1*T + KA2*T.^2 + KA3*T.^3 + KA4*T.^4 + KA5*T.^5; 
    
    if UseHumidity
        % Water vapour - for 0 <= t <= 120 °C
        KV0 = 1.761758242e-2;
        KV1 = 5.558941059e-5;
        KV2 = 1.663336663e-7;
        k_v = KV0 + KV1*t + KV2*t.^2;               % [W m^-1 K^-1]
        
        k = ((1 - x_v).*k_a)./((1 - x_v) + x_v.*Phi_av) + ...
            (x_v.*k_v)./(x_v + (1 - x_v).*Phi_va);  % [W m^-1 K^-1]
    else
        k = k_a;
    end
    
    if ismember('k', Outputs)
        varargout{OutputNum.k} = k;
    end
end

%% Ratio of specific heats & speed of sound 
if any(ismember({'gamma', 'c', 'c_v'}, Outputs))
    gamma = c_p.*M./(c_p.*M - R);               % [1]
    c_v = c_p./gamma;                           % [J kg^-1 K^-1]
    
    if ismember('gamma', Outputs)
        varargout{OutputNum.gamma} = gamma;
    end
    if ismember('c_v', Outputs)
        varargout{OutputNum.c_v} = c_v;
    end
    if ismember('c', Outputs)
        c = (gamma*R.*T./M).^0.5;               % [m s^-1]
        varargout{OutputNum.c} = c;
    end
end

%% Thermal diffusivity 
if ismember('alpha', Outputs)
    alpha = k./(rho.*c_p);                      % [m^2 s^-1]
    varargout{OutputNum.alpha} = alpha;
end

%% Prandtl number 
if ismember('Pr', Outputs)
    Pr = mu.*c_p./k;                            % [1]
    varargout{OutputNum.Pr} = Pr;
end

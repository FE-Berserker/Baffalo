classdef AirProperty < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'xCO2' % Material of the Component
            };

        inputExpectedFields = {
            't' % 温度 [℃]
            'p' % hpa
            'h' % 0~100
            };

        outputExpectedFields = {
            'rho'         % [kg m^-3]       Density
            'mu'          % [N s m^-2]      Dynamic viscosity
            'k'           % [W m^-1 K^-1]   Thermal conductivity
            'c_p'         % [J kg^-1 K^-1]  Specific heat capacity (constant pressure)
            'c_v'         % [J kg^-1 K^-1]  Specific heat capacity (constant volume)
            'gamma'       % [1]             Ratio of specific heats
            'c'           % [m s^-1]        Speed of sound: c = (gamma*R*T/M)^0.5
            'nu'          % [m^2 s^-1]      Kinematic viscosity: nu = mu/rho
            'alpha'       % [m^2 s^-1]      Thermal diffusivity: alpha = k/(rho*c_p)
            'Pr'          % [1]             Prandtl number: Pr = mu*c_p/k
            'M'           % [kg mol^-1]     Molar mass of humid air
            'R'           % [J kg^-1 K^-1]  Specific gas constant
            };

        baselineExpectedFields = {
            };

        default_Name='AirProperty_1'; % Set name
        default_Echo=1; % Set default params Echo
        default_xCO2=0.0004; 
    end
    methods

        function obj = AirProperty(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='AirProperty.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Write the fomula of the component calculation
            if isempty(obj.input.t)
                obj.input.t=15;
            end

            if isempty(obj.input.p)
                obj.input.p=1013.25;
            end

            t=obj.input.t;
            p=obj.input.p;
            h=obj.input.h;
            xCO2=obj.params.xCO2;

            [rho, mu, k,c_p,c_v,gamma, c,nu,alpha,Pr,M,R]...
                = AirProperties(t,p,h,'xCO2',xCO2,'rho','mu','k','c_p','c_v',...
                'gamma','c','nu','alpha','Pr','M','R');
            % Parse
            obj.output.rho=rho;
            obj.output.mu=mu;
            obj.output.k=k;
            obj.output.c_p=c_p;
            obj.output.c_v=c_v;
            obj.output.gamma=gamma;
            obj.output.c=c;
            obj.output.nu=nu;
            obj.output.alpha=alpha;
            obj.output.Pr=Pr;
            obj.output.M=M;
            obj.output.R=R;

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate air property ! .\n');
            end
        end
    end
end


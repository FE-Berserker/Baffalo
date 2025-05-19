classdef RotatingDisc < Component
    % 等速圆盘应力分析
    % Author: Xie Yu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            };

        inputExpectedFields = {
            'Ri' % Inner radius
            'Ro' % Outer radius
            'Location'% Stress output location
            'Omega'% Speed RPM
            'Rho' % Density
            'v' % Possion ratio
            };

        outputExpectedFields = {
            'Stress' % Radial stress Hoop stress Eqv stress
            };

        baselineExpectedFields = {
            };

        default_Name='RotatingDisc_1'; % Set default params name
        default_Echo=1; % Set default params Echo
    end
    methods

        function obj = RotatingDisc(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='RotatingDisc.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Write the fomula of the component calculation
            % Check input
            [Ri,Ro,v,Rho,Omega]=Checkinput(obj);

            r=obj.input.Location;
            [SigmaR,SigmaH,SigmaEqv]=CalStress(Ri,Ro,v,Rho,Omega,r);

            % Parse
            obj.output.Stress=[SigmaR,SigmaH,SigmaEqv];
            if obj.params.Echo
                fprintf('Successfully calculate rotating disc stress .\n');
            end
        end
    end
end
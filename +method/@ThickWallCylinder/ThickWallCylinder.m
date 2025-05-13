classdef ThickWallCylinder < Component
    % 厚壁圆筒应力分析
    % Author: Xie Yu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            };

        inputExpectedFields = {
            'Ri' % Inner radius
            'Ro' % Outer radius
            'Pi' % Inner pressure
            'Po' % Outer pressure
            'Location'% Stress output location
            };

        outputExpectedFields = {
            'Stress' % Radial stress Hoop stress Eqv stress
            };

        baselineExpectedFields = {
            };

        default_Name='ThickWallCylinder_1'; % Set default params name
        default_Echo=1; % Set default params Echo
    end
    methods

        function obj = ThickWallCylinder(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='ThickWallCylinder.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Write the fomula of the component calculation
            % Check input
            [Ri,Ro,Pi,Po]=Checkinput(obj);
            A=Ri^2*Ro^2*(Po-Pi)/(Ro^2-Ri^2);
            % B=0;
            C=(Pi*Ri^2-Po*Ro^2)/2/(Ro^2-Ri^2);

            r=obj.input.Location;
            [SigmaR,SigmaH,SigmaEqv]=CalStress(A,C,r);

            % Parse
            obj.output.Stress=[SigmaR,SigmaH,SigmaEqv];
            if obj.params.Echo
                fprintf('Successfully calculate thick wall cylinder stress .\n');
            end
        end
    end
end
classdef ISO1940 < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Ratio' % Unbalance mass ratio
            'G'
            };

        inputExpectedFields = {
            'LA' % Length A
            'LB' % Length B
            'n' % Speed RPM
            'Mass' % Mass ton
            
            };

        outputExpectedFields = {
            'Uper' % gmm
            'UperA'% gmm
            'UperB'% gmm
            'MA'% ton
            'MB'% ton
            'DisA'% mm
            'DisB'% mm
            };

        baselineExpectedFields = {
            };

        default_Name='ISO1940_1'; % Set default params name
        default_G=2.5;
        default_Ratio=0.0001;
        default_Echo=1; % Set default params Echo
    end
    methods

        function obj = ISO1940(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='ISO1940.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Write the fomula of the component calculation
            omega=pi*obj.input.n/30;
            Mass=obj.input.Mass;
            Uper=1000*obj.params.G*Mass*1000/omega;
            LA=obj.input.LA;
            LB=obj.input.LB;
            L=LA+LB;
            UperA=Uper*LB/L;
            UperB=Uper*LA/L;
            % Parse
            obj.output.Uper=Uper;
            obj.output.UperA=UperA;
            obj.output.UperB=UperB;
            obj.output.MA=obj.params.Ratio*Mass*LB/L;
            obj.output.MB=obj.params.Ratio*Mass*LA/L;
            obj.output.DisA=UperA/1e6/obj.output.MA;
            obj.output.DisB=UperB/1e6/obj.output.MB;
            if obj.params.Echo
                fprintf('Successfully calculate unbalacnce .\n');
            end
        end
    end
end


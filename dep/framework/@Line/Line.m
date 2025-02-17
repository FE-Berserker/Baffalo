classdef Line < handle
    % 3D Line object, Nurb curve
    % Author : Xie Yu

    % tolerances
    properties
        Cell_Data
        Nurbs % Nurb curves
        Subd  % Sub division of curve
    end

    properties
        Name
        Echo % 0=no print
    end

    properties (SetAccess = private)
        MP      % middle point MP(:,1)=x, MP(:,2)=y and  MP(:,3)=z for label curves
        
    end

    properties (Hidden)
        documentname % document name
    end

    methods
        function obj = Line(Name,varargin)
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            %Create Line2D object with default value
            obj.Echo = opt.Echo;
            obj.documentname='Line.pdf';

            if obj.Echo
                fprintf('Creating Line object ...\n');
            end
        end
    end
end


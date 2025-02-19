classdef Line < handle
    % 3D Line object, Nurb curve
    % Author : Xie Yu

    % tolerances
    properties
        Dtol
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
            addParameter(p,'Dtol',1e-5);
            parse(p,varargin{:});
            opt=p.Results;

            %Create Line object with default value
            obj.Echo = opt.Echo;
            obj.Dtol = opt.Dtol;
            obj.documentname='Line.pdf';

            if obj.Echo
                fprintf('Creating Line object ...\n');
            end
        end


        function Help(obj)
            rootDir = Baffalo.whereami;
            filename=strcat(rootDir,'\Document\',obj.documentname);
            open(filename);
        end
    end
end


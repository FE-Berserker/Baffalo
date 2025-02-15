classdef Point < handle
    % Class Points 3D
    % Author : Xie Yu
    properties
        Dtol    % distance tolerance      
        PP      % coordinates of point cell
        Name
        P
        Point_Data
        Point_Vector
        Echo
    end
    
    properties
        NG      % Number of Point Group
        NP      % Number of Point
        Roughness
        Normal
        NormNormal % Normalize Normal
    end

    properties (Hidden)
        documentname % document name
    end
    
    methods
        function obj = Point(Name,varargin)
            % Create Point object with default values    
            p=inputParser;
            addParameter(p,'Dtol',1e-5);
            addParameter(p,'Echo',0);
            parse(p,varargin{:});
            opt=p.Results;

            % Parse Parameter
            obj.Name = Name;
            obj.Dtol = opt.Dtol;
            obj.Echo = opt.Echo;
            obj.documentname='Point.pdf';
        end 

        function Help(obj)
            rootDir = Baffalo.whereami;
            filename=strcat(rootDir,'\Document\',obj.documentname);
            open(filename);
        end
    end
end


classdef Point2D < handle
    % Class Point2D
    % Author : Xie Yu
    properties
        Name    % Name of Point2D
        Echo    % print
        Dtol    % distance tolerance
        P       % coordinates of point
        PP      % coordinates of point cell
        Point_Data % Point Data
        Point_Vector % Point Vector
    end
    
    properties
        NG      % Number of Point Group
        NP      % Number of Point
    end
    
    methods
        function obj = Point2D(Name,varargin)
            % Create Point2D object with default values
            % x and y are mandatory first two arguments
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Dtol',1e-5);
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            obj.Dtol = opt.Dtol;
            obj.Echo = opt.Echo;

            if obj.Echo
                fprintf('Creating Point2D object ...\n');
            end
        end 
    end
end


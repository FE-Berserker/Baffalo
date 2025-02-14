classdef Line < handle
    % 3D Line object, Nurb curve
    % Author : Xie Yu

    % tolerances
    properties
        Atol  % for check of equality of among Line2d objects
        Rtol  % for check of relative error when calculate curve length
        Dtol  % distance tolerance
        Gtol  % geometric tolerance h/d
        Point
        Cell_Data
        Meshoutput
        Nurbs % Nurb curves
        Subd  % Sub division of curve
    end

    properties
        Name
        Echo % 0=no print
        Arrow
        Form % Arrow Form
        Adfac  % factor for arrowhead size (def 0.05)
    end

    properties (SetAccess = private)
        C       % curve data
        CT      % curve type
        CIX     % index for curve data
        MP      % middle point MP(:,1)=x, MP(:,2)=y and  MP(:,3)=z for label curves
        
    end

    % Derived control data
    properties (SetAccess = private)
        sizeX
        sizeY
        Ad      % arrowhead dimension
    end

    properties (SetAccess = private)
        Close   % curve closed
        CJ      % true = non-self intersecting
        CN      % number of points on curve used to calculate CL
        CL      % curve length
        CL0     % curve reference length CL/CN
        CHD     % max. h/d
    end

    methods
        function obj = Line(Name,varargin)
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            addParameter(p,'Gtol',0.04);
            addParameter(p,'Dtol',1e-5);
            addParameter(p,'Atol',1e-4);
            addParameter(p,'Rtol',1e-3);
            addParameter(p,'Adfac',0.1);
            addParameter(p,'Arrow',[]);
            addParameter(p,'Form',3);
            parse(p,varargin{:});
            opt=p.Results;

            %Create Line2D object with default value
            obj.Echo = opt.Echo;
            % set default values
            obj.Gtol = opt.Gtol;  % default tolerance for h/d
            obj.Dtol = opt.Dtol;  % distance tolerance
            obj.Atol = opt.Atol;
            obj.Rtol = opt.Rtol; % numerical calculation
            obj.Adfac = opt.Adfac;
            obj.Arrow=opt.Arrow;
            obj.Form=opt.Form;
            obj.Point=Point2D('Point','Dtol',opt.Dtol);
        end
    end
end


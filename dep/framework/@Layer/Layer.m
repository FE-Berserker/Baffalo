classdef Layer < handle
    % Class Layer
    % Author : Xie Yu
    properties
        Name % Name of Layer;
        Echo % 0=no print
        Summary % Summary of information
    end

    properties
        Points % Point
        Lines % Lines
        Meshes % Meshes
        Duals % Dual Meshes
        Planes % Planes
        Meshoutput
        Matrix
    end

    methods
        function obj = Layer(Name,varargin)
            % Create Layer object with default value
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;       
            obj.Echo = opt.Echo;

            obj.Summary.TotalLine=0;
            obj.Summary.TotalMesh=0;
            obj.Summary.TotalPoint=0;
            obj.Summary.TotalDual=0;
            obj.Summary.TotalPlane=0;

            if obj.Echo
                fprintf('Creating Layer object ...\n');
            end
        end

    end
end

classdef Mesh< handle
    % Mesh object
    % Author : Xie Yu
    
    properties
        Name % Name of Mesh
        Echo % Print
    end
    
    properties
        Vert % Vert of face
        Face % Face
        El  % Element
        Cb % Face label
        G % MRST Geo
        Point_Data
        Point_Vector
        Cell_Data
        Voronoi
        Boundary
        Meshoutput
    end

    properties (Hidden)
        documentname % document name
    end


    methods
        function obj = Mesh(Name,varargin)
            % default values
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            obj.Echo = opt.Echo;
            obj.documentname='Mesh.pdf';

            if obj.Echo
                fprintf('Creating Mesh Object...\n');
            end

        end

        function Help(obj)
            rootDir = Baffalo.whereami;
            filename=strcat(rootDir,'\Document\',obj.documentname);
            open(filename);
        end
    end
end


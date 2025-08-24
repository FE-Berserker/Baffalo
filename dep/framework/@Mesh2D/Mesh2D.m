classdef Mesh2D
    % Create mesh2D object    
    properties
        Name % Name of objec
        Echo % print
    end

    properties
        N       % Edge Node
        E       % Edge
        Cb
        Vert % Vert
        Face % Face
        Dual % Dual mesh
        Size % Size of mesh edge
        CNode % Internal constraint node
        CEdge % Internal constraint edge
        G % MRST geo
        Boundary % Boundary Node
        Cell_Data
        Point_Data
        Point_Vector
        Meshoutput % Output of mesh
    end

    properties (Hidden)
        documentname % document name
    end
    
    methods
        function obj = Mesh2D(Name,varargin)
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            % default values
            obj.Echo =opt.Echo;
            if obj.Echo
                fprintf('Creating Mesh2D Object...\n');
            end

            meshtool.initmsh();
            obj.documentname='Mesh2D.pdf';

        end

        function Help(obj)
            rootDir = Baffalo.whereami;
            filename=strcat(rootDir,'\Document\',obj.documentname);
            open(filename);
        end
    end
end


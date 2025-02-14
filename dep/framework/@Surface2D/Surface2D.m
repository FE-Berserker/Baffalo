classdef Surface2D < handle
    % Surface2D Create a Surface2D object (2d region)
    % Author : Xie Yu

    properties (SetAccess = private)
        Echo   % 0=no print
    end

    properties
        Line   % Line2D data
        FN      % Face Num
        FS      % FS FS=0 Close Face, FS=1 Internal Face
        NN      % Node Num
        EN      % Edge Num
        N       % Edge Node
        Node    % Edge Node cell
        E       % Edge
        Edge    % Edge cell
    end

    methods
        function obj = Surface2D(Line,varargin)
            % Create Surface2D object
            % default values
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            if ~isa(Line,'Line2D')
                error('Expected input to be Line object')
            end

            obj.Line{1,1}= Line;
            obj.Echo=opt.Echo;

            if opt.Echo
                fprintf('Creating Surface2D object\n');
            end
            init(obj)
        end
    end
    methods(Access = private)
        function init(obj)
            % Import points and curves. Approximate curves as polygons.

            ncrv = GetNcrv(obj.Line{1,1});
            if ncrv <= 0
                error('Curve table is empty.')
            end

            obj.Node{1,1} = obj.Line{1,1}.Point.P;
            obj.N=cell2mat(obj.Node);
            obj.NN=size(obj.N,1);
            Temp1=(1:obj.NN)';
            Temp2=(2:obj.NN)';
            Temp2=[Temp2;1];
            obj.Edge{1,1}=[Temp1 Temp2];
            obj.E=cell2mat(obj.Edge);
            obj.EN=size(obj.E,1);
            obj.FN=1;
            obj.FS=0;

            %% Print
            if obj.Echo
                fprintf('Successfully import Line2D .\n');
            end
        end
    end

end



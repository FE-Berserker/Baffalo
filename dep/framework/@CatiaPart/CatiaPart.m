classdef CatiaPart< handle & matlab.mixin.Copyable
    % Assembly Create catia part object 
    % Author: Xie Yu
    
    properties
        Name % Name of Catiapart
        Echo % print
        Summary % Summary of CatiaPart
    end
    
    properties
        Sketches % Sketch
        Body % Body
        Material
        Boolean
    end

    methods
        function obj = CatiaPart(Name,varargin)
            % default values
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            obj.Summary.Total_Sketches=0; % Total number of sketches
            obj.Summary.Total_Body=0; % Total number of body
            obj.Summary.Total_Boolean=0; % Total number of Boolean

            obj.Echo = opt.Echo;
            obj.Sketches=[];
            obj.Body=[];
            obj.Boolean=[];

            if obj.Echo
                fprintf('Creating CatiaPart object ...\n');
            end

        end

    end
end


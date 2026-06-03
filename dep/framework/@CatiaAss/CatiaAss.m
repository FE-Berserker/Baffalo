classdef CatiaAss< handle & matlab.mixin.Copyable
    % Assembly Create catia assembly object 
    % Author: Xie Yu
    
    properties
        Name % Name of CatiaAss
        Echo % print
        Summary % Summary of CatiaAss
    end
    
    properties
        Part % Part
    end

    methods
        function obj = CatiaAss(Name,varargin)
            % default values
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            obj.Summary.Total_Part=0; % Total number of Part

            obj.Echo = opt.Echo;
            obj.Part=[];

            if obj.Echo
                fprintf('Creating CatiaAss object ...\n');
            end

        end

    end
end


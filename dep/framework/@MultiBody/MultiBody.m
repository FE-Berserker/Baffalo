classdef MultiBody< handle & matlab.mixin.Copyable
    % MultiBody 
    % Author: Xie Yu
    
    properties
        Name % Name of MultiBody
        Echo % print
        Gravity % Gravity
    end
    
    properties
        Body % Bodys in MultiBody
        Constraint % Constraints in MultiBody
        Joint % Joints in MultiBody
        Summary % Summary information
        Ref % Reference system
        Force % Froce element
        Function % Input Function
        SubStructure % SubStructure
        Pair % SubStructure Pair
        Sender % Sender
        Receiver % Receiver
    end

    methods
        function obj = MultiBody(Name,varargin)
            % default values
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            addParameter(p,'Gravity',[0,0,-9.8]);
            parse(p,varargin{:});
            opt=p.Results;
    
            obj.Echo=opt.Echo;
            obj.Gravity=opt.Gravity;

            obj.Summary.Total_Body=0;
            obj.Summary.Total_Constraint=0;
            obj.Summary.Total_Joint=0;
            obj.Summary.Total_Ref=0;
            obj.Summary.Total_Force=0;
            obj.Summary.Total_Function=0;
            obj.Summary.Total_SubStructure=0;
            obj.Summary.Total_Pair=0;
            obj.Summary.Total_Sender=0;
            obj.Summary.Total_Receiver=0;

            obj.Ref{1,1}.Type=1;
            obj.Ref{1,1}.Pos=[0,0,0];
            obj.Ref{1,1}.Par=[];

            if obj.Echo
                fprintf('Creating MultiBody object ...\n');
            end

        end

    end
end


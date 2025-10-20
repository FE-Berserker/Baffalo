classdef PlateDeform < Component
    % Class PlateDeform
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % Material of the Component
            };

        inputExpectedFields = {
            'fx' % Function of x
            'fy' % Function of y
            'fxy' % Function of xy
            'M' % Mesh2D of plate
            'Thickness' % Thickness of plate  
            };

        outputExpectedFields = {
            'Assembly'% Mesh assembly
            'Output1' % Output1
            };

        baselineExpectedFields = {
            };

        default_Name='PlateDeform_1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
    end
    methods

        function obj = PlateDeform(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='PlateDeform.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input
            if ~isempty(obj.input.fxy)
                warning('Function fx and fy will be ignored !');
            elseif and(isempty(obj.input.fx),isempty(obj.input.fy))
                warning('No change to the plate !');
            end

            % 

            

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate results .\n');
            end
        end
    end
end


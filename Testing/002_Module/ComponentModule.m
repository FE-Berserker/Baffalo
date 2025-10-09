classdef ComponentModule < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % Material of the Component
            };

        inputExpectedFields = {
            'Input1' % Input1
            'Input2' % Input2
            };

        outputExpectedFields = {
            'Assembly'% Mesh assembly
            'Output1' % Output1
            };

        baselineExpectedFields = {
            'Baseline1' % Baseline1
            };

        default_Name='ComponentModule1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        base_Baseline1=1; % Set Baseline1
    end
    methods

        function obj = ComponentModule(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='ComponentModule.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input is Null
            Check(obj)

            % Write the fomula of the component calculation
            
            % Print
            if obj.params.Echo
                fprintf('Successfully calculate results .\n');
            end
        end
    end
end


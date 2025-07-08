classdef SubModel < Component
    % Class SubModel
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' %名称
            };

        inputExpectedFields = {
            'Coarse' % Coarse assembly
            'Sub' % Subnodel assembly
            };

        outputExpectedFields = {
            };

        baselineExpectedFields = {
            };


        default_Name='SubModel1';

    end
    methods

        function obj = SubModel(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='SubModel.pdf'; % Set help file name, put it in the folder "Document"
            obj.input.Coarse.Name='Coarse';
            obj.input.Sub.Name='Submod';
        end

        function obj = solve(obj)
            ANSYS_Output(obj.input.Coarse,'Save',1);
            SubModel_Output(obj.input.Sub)
            ANSYSSolve(obj.input.Coarse)
        end

    end
end

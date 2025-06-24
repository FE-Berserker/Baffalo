classdef WovenCell < Component
    % Class Name
    % Mat=1 matrix material Mat>1 yarn material
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Vf' % Yarn volume ratio
            };

        inputExpectedFields = {
            'FileName' % FileName
            'Dimension' %[nx,ny,nz]
            'Fiber' % Fiber material      
            'Matrix' % Matrix material
            };

        outputExpectedFields = {
            'Yarn' % Yarn material
            'Assembly'% Mesh assembly
            'SolidMesh' % Solid mesh
            'YarnIndex'
            'YarnTangent'
            'Location'
            'SurfaceDistance'
            'Orientation'
            'Property' % Woven cell material properties
            'YarnVolumeRatio'
            };

        baselineExpectedFields = {
            };

        default_Name=[]; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Vf=0.75
    end
    methods

        function obj = WovenCell(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='WovenCell.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input
            if isempty(obj.input.FileName)
                error('Please input the filename of cell !')
            end

            obj.params.Name=obj.input.FileName;

            if isempty(obj.input.Fiber)
                error('Please input Fiber ！')
            end

            if isempty(obj.input.Matrix)
                error('Please input Matrix ！')
            end

            if isempty(obj.input.Dimension)
                error('Please input mesh dimension ！')
            end

            % Calculate Yarn properties
            inputStruct.Vf=obj.params.Vf; % Yarn volume ratio
            inputStruct.Fiber=obj.input.Fiber;
            inputStruct.Matrix=obj.input.Matrix;
            paramsStruct.Theory='MT';
            Yarn= method.Composite.Micromechanics(paramsStruct, inputStruct);
            Yarn=Yarn.solve();
            obj.output.Yarn=Yarn.output.Plyprops;

            % Load element
            obj = LoadElement(obj);

            % Output assembly
            obj = OutputAss(obj);

            % Print
            if obj.params.Echo
                fprintf('Successfully input woven cell !.\n');
            end
        end
    end
end


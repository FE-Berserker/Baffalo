classdef MagnetCoupling < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % [Magnet,Shaft,Housing]
            'MeshNum' % [LengthNum,ThicknessNum] for each magnet
            'Pos1' % Inner position
            'Pos2' % Outer position
            'Dx' % x displacement
            'Dy' % y displacement
            'Rot' % Rotate angle [°]
            'WidthNum' % Mesh number in the length direction
            };

        inputExpectedFields = {
            'Pair' % Magnet pair number
            'A' % Shaft inner diameter
            'B' % Shaft outer diameter
            'C' % Housing inner diamater
            'D' % Housing outer diamater
            'OuterMagnetSize' % [Length,thickness]  
            'InnerMagnetSize' % [Length,thickness]
            'Width' % Coupling width
            };

        outputExpectedFields = {
            'Assembly'% Mesh assembly
            'Section' % Section of Magnet coupling
            'SolidMesh' % Solid mesh
            'ShellMesh' % Section mesh
            'Number' % Element number
            'Surface'
            'FEA_Force'
            };

        baselineExpectedFields = {
            };

        default_Name='MagnetCoupling_1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        default_MeshNum=[10,5]
        default_Pos1=0.5
        default_Pos2=0.5
        default_Dx=0
        default_Dy=0
        default_Rot=0
        default_WidthNum=10;

    end
    methods

        function obj = MagnetCoupling(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='MagnetCoupling.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input
            if isempty(obj.params.Material)
                error('Please input material !')
            elseif size(obj.params.Material,1)~=3
                error('Please check the number of materials !')
            end

            % Calculate section
            obj=CalSection(obj);
            % Output Solid mesh
            obj=OutputSolidMesh(obj);
            % Output Assembly
            obj=OutputAss(obj);

            obj.output.Number=[1;obj.input.Pair+1;...
                2*obj.input.Pair+1;2*obj.input.Pair+2];

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate magnet coupling ! .\n');
            end
        end
    end
end


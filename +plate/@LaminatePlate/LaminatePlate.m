classdef LaminatePlate < Component
    % LaminatePlate
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the commonplate
            'Order' % Element order
            'Offset' % Shell offset
            'Echo' % Print
            };

        inputExpectedFields = {
            'Outline' % Outline of commonplate [mm]
            'Hole' % Hole of commonplate
            'Meshsize' % Mesh size [mm]
            'Orient' % Ply orientation [°]
            'Plymat' % Ply Material Number
            'Tply' % Unit [mm]
            };

        outputExpectedFields = {
            'Surface'% Section surface of commonplate
            'SolidMesh'% Common plate solid mesh
            'ShellMesh'% Common plate shell mesh
            'Assembly' % Assembly of solidmesh commonplate
            'Assembly1' % Assembly of shellmesh commonplate
            };

        baselineExpectedFields = {};
        default_Name='LaminatePlate_1';
        default_Material=[];
        default_Offset="Bot"
        default_Order=1
        default_Echo=1
    end
    methods

        function obj = LaminatePlate(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='LaminatePlate.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)

            if isempty(obj.params.Material)
                error('Material is not defined !')
            end

            % Base surface
            S=Surface2D(obj.input.Outline,'Echo',0);
            for i=1:size(obj.input.Hole,1)
                S=AddHole(S,obj.input.Hole(i,1));
            end
            obj.output.Surface=S;

            % Calculate output
            obj=OutputSolidModel(obj);
            obj=OutputShellModel(obj);
            obj=OutputAss(obj);
            obj=OutputAss1(obj);

            
            % Print
            if obj.params.Echo
                fprintf('Successfully calculate LaminatePlate .\n');
            end
        end

        function Plot2D(obj)
            Plot(obj.output.Surface);
        end
    end
end


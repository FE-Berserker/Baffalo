classdef Commonplate < Component
    % Common Plate
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'N_Slice' % Number of element in height direction
            'Name' % Name of the commonplate
            'Order' % Element order
            'Offset' % Shell offset
            'Echo' % Print
            };

        inputExpectedFields = {
            'Outline' % Outline of commonplate [mm]
            'Hole' % Hole of commonplate
            'Thickness' % Thickness [mm]
            'Meshsize' % Mesh size [mm]
            };

        outputExpectedFields = {
            'Surface'% Section surface of commonplate
            'SolidMesh'% Common plate solid mesh
            'ShellMesh'% Common plate shell mesh
            'Assembly' % Assembly of solidmesh commonplate
            'Assembly1' % Assembly of shellmesh commonplate
            };

        baselineExpectedFields = {};
        default_N_Slice=3;
        default_Name='Commonplate1';
        default_Material=[];
        default_Offset="Mid"
        default_Order=1
        default_Echo=1
    end
    methods

        function obj = Commonplate(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Commonplate.pdf';
        end

        function obj = solve(obj)
            % Base surface
            S=Surface2D(obj.input.Outline,'Echo',0);
            for i=1:size(obj.input.Hole,1)
                S=AddHole(S,obj.input.Hole(i,1));
            end
            obj.output.Surface=S;
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end
            % Calculate output
            obj=OutputSolidModel(obj);
            obj=OutputShellModel(obj);
            obj=OutputAss(obj);
            obj=OutputAss1(obj);

        end

        function Plot2D(obj)
            Plot(obj.output.Surface);
        end

    end
end


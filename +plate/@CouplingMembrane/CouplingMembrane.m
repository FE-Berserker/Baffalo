classdef CouplingMembrane < Component
    % CouplingMembrane
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'N_Slice' % Number of element in height direction
            'Name' % Name of the CouplingMembrane
            'Order' % Element order
            'Offset' % Shell offset
            'Type' % 
            'Echo' % Print
            };

        inputExpectedFields = {
            'GeomData' % Type 1 : [D1,D2,D3,D4]
                       % Type 2 :
            'HoleNum' % Hole of CouplingMembrane
            'Thickness' % Thickness [mm]
            'Meshsize' % Mesh size [mm]
            };

        outputExpectedFields = {
            'Surface'% Section surface of CouplingMembrane
            'SolidMesh'% CouplingMembrane solid mesh
            'ShellMesh'% CouplingMembrane shell mesh
            'Assembly' % Assembly of solidmesh CouplingMembrane
            'Assembly1' % Assembly of shellmesh CouplingMembrane
            };

        baselineExpectedFields = {};
        default_N_Slice=3;
        default_Name='CouplingMembrane_1';
        default_Material=[];
        default_Offset="BOT"
        default_Order=1
        default_Type=1
        default_Echo=1
    end
    methods

        function obj = CouplingMembrane(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='CouplingMembrane.pdf';
        end

        function obj = solve(obj)

            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end
            % Calculate outputs
            obj=CalOutput(obj);

        end

        function Plot2D(obj)
            Plot(obj.output.Surface);
        end

    end
end


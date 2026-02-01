classdef Rod < Component
    % Rod
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the Bolt
            'Order' % Element order
            'Type' % Rod Type Type=1 square Type=2 Circle Type=3 SemiCircle
            'N_Slice' % Number of element in height direction
            'ConnectionType'
            'Freq' % Frequency range
            'NMode'
            'Echo' % Print
            };s

        inputExpectedFields = {
            'GeometryData' % [Length,Width,Thickness] Type=1
            'Meshsize'
            'Hole' % [x,y,r]
            };

        outputExpectedFields = {
            'Assembly' % Solidmesh assembly
            'SolidMesh'
            'Surface'
            'SubStr'
            };

        baselineExpectedFields = {};
        default_Name='Rod_1';
        default_Material=[];
        default_Order=1
        default_Echo=1
        default_Type=1
        default_N_Slice=3
        default_ConnectionType='Rbe2'
        default_Freq=[0,2000];
        default_NMode=50;

    end
    methods

        function obj = Rod(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Rod.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % Calculate outputs
            obj=CalSurface(obj);
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);

        end

        function Plot2D(obj)
            Plot(obj.output.Surface);
        end

    end
end


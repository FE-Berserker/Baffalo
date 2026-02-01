classdef Pin < Component
    % Pin
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the Bolt
            'Order' % Element order
            'ConnectionType'
            'Freq' % Frequency range
            'NMode'
            'Echo' % Print
            };

        inputExpectedFields = {
            'R' % Radius
            'Length' % Length
            'Meshsize'
            'Marker' % Marker Height 
            };

        outputExpectedFields = {
            'Assembly' % Solidmesh assembly
            'SolidMesh'
            'Surface'
            'SubStr'
            };

        baselineExpectedFields = {};
        default_Name='Pin_1';
        default_Material=[];
        default_Order=1
        default_Echo=1
        default_ConnectionType='Rbe2'
        default_Freq=[0,2000];
        default_NMode=50;

    end
    methods

        function obj = Pin(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Pin.pdf'; % Set help file name, put it in the folder "Document"
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


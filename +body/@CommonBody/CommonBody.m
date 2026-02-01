classdef CommonBody < Component
    % CommonBody
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the CommonBody
            'Order' % Element order
            'Type' % CommonBody Type=1 Cuboid Type=2 Cylinder Type=3 Ball Type=4 Prism Type=5 Pyramid
            'ConnectionType'
            'Freq' % Frequency range
            'NMode'
            'Echo' % Print
            };

        inputExpectedFields = {
            'GeometryData' 
            % Type=1 [Length,Width,Height] Type=2 [Radius,Height] Type=3 [Radius]
            % Type=4 [NumEdge,EdgeLength,Height] Type=5 [NumEdge,EdgeLength,Height]
            'Meshsize'
            'Marker' % [x,y,z]
            };

        outputExpectedFields = {
            'Assembly' % Solidmesh assembly
            'SolidMesh'
            'SubStr'
            };

        baselineExpectedFields = {};
        default_Name='CommonBody_1';
        default_Material=[];
        default_Order=1
        default_Echo=1
        default_Type=1
        default_ConnectionType='Rbe2'
        default_Freq=[0,100000];
        default_NMode=50;

    end
    methods

        function obj = CommonBody(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='CommonBody.pdf'; % Set help file name, put it in the folder "Document"    
        end

        function obj = solve(obj)
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % Calculate outputs
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);

        end

    end
end


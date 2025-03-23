classdef Housing < Component
    % Class Housing
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % Material properties，default is steel
            'N_Slice' % Rotate num
            'Degree' % Rotate degree [°]
            'Axis'% Rotate axis
            'Name' % Name
            'Echo' % Print
            'Order' % Element order
            };

        inputExpectedFields = {
            'Outline' % outline
            'Hole' % Hole geometry
            'Meshsize' % Mesh size
            };

        outputExpectedFields = {
            'Surface'% Housing Section surface
            'SolidMesh'% Housing solid mesh
            'Assembly'% Assembly of solid mesh
            };

        baselineExpectedFields = {};
        default_N_Slice=36;
        default_Name='Housing_1';
        default_Material=[];
        default_Axis='x' % Default rotate axis is x
        default_Degree=360 % Default rotate angle 360°
        default_Echo=1
        default_Order=1
    end
    methods

        function obj = Housing(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Housing.pdf';
        end

        function obj = solve(obj)
            % Calculate outputs
            S=Surface2D(obj.input.Outline);
            for i=1:size(obj.input.Hole,1)
                S=AddHole(S,obj.input.Hole(i,1));
            end
            obj.output.Surface=S;
            %% Print
            if obj.params.Echo
                fprintf('Successfully create surface .\n');
            end
            % Material
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
        end

        function Plot2D(obj)
            Plot(obj.output.Surface);
        end

    end
end


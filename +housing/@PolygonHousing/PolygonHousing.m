classdef PolygonHousing < Component
    % Class PolygonHousing
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % Material properties，default is steel
            'Name' % Name
            'Echo' % Print
            'Order' % Element order
            'Slice'
            };

        inputExpectedFields = {
            'Outline' % outline
            'Meshsize' % Mesh size
            'r' % Edge radius
            'EdgeNum'
            };

        outputExpectedFields = {
            'Surface'% ToothShaft Section surface
            'SolidMesh'% ToothShaft solid mesh
            'ShellMesh'% ToothShaft shell mesh
            'Assembly'% Assembly of solid mesh
            };

        baselineExpectedFields = {};
        default_Name='PolygonHousing_1';
        default_Material=[];
        default_Echo=1
        default_Order=1
        default_Slice=8

    end
    methods

        function obj = PolygonHousing(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='PolygonHousing.pdf';
        end

        function obj = solve(obj)
            %% Check input
            if isempty(obj.input.Outline)
                error('Please input the outline !')
            end

            if isempty(obj.input.r)
                obj.input.r=1;
            end

            % Calculate outputs
            S=Surface2D(obj.input.Outline);
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
            Plot(obj.output.ShellMesh);
        end

    end
end


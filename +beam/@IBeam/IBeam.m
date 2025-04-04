classdef IBeam < Component
    % IBeam
    % Author: Yu Xie
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% Material properties，default is steel
            'Name' % Name of the commonplate
            'Order' % Element order
            'Echo' % Print
            };

        inputExpectedFields = {
            't' % 翼缘厚度 [mm]
            'h' % 高度 [mm]
            'r' % 倒角 [mm]
            'd' % 腰厚 [mm]
            'b' % 腿宽度 [mm]
            'l' % 长度 [mm]
            'Stiffner' % 肋板位置，厚度 [mm]
            'Meshsize' % Mesh size [mm]
            };

        outputExpectedFields = {
            'Surface'% Section surface of IBeam
            'Stiffner_Surface' % Section surface of Stiffner
            'SolidMesh'% IBeam solid mesh
            'Assembly' % Assembly of solidmesh IBeam
            };

        baselineExpectedFields = {};
        default_Name='IBeam1';
        default_Material=[];
        default_Order=1
        default_Echo=1
    end
    methods

        function obj = IBeam(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='IBeam.pdf';
        end

        function obj = solve(obj)

            obj=CalSurface(obj);
            % Calculate outputs

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


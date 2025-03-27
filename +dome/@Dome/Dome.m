classdef Dome < Component
    % Class Dome
    % Author: Xie Yu
   
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % Material properties，default is steel
            'E_Revolve' % Rotate num
            'Name' % Name
            'Echo' % Print
            'Order' % Element order
            'Offset' % Shell element offset 
            };

        inputExpectedFields = {
            'Curve' % Curve of dome
            'Thickness' % Thickness of dome
            'Meshsize' % Mesh size
            };

        outputExpectedFields = {
            'Matrix'
            'ShellMesh'% Dome shell mesh
            'Assembly'% Assembly of shell mesh
            };

        baselineExpectedFields = {};
        default_E_Revolve=72;
        default_Name='Dome_1';
        default_Material=[];
        default_Echo=1
        default_Order=1
        default_Offset="BOT"
    end
    methods

        function obj = Dome(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Dome.pdf';
        end

        function obj = solve(obj)
            % Check input
            if mod(obj.params.E_Revolve,8)~=0
                obj.params.E_Revolve=ceil(obj.params.E_Revolve/8)*8;
            end
            % Material
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            obj=OutputShellModel(obj);
            obj=OutputAss(obj);
        end

    end
end


classdef TaperPMB < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % Material of the Magnet
            'MeshNum' % [RadialNum,HeightNum] for each magnet
            'N_Slice' % Revolve number for mesh
            'Order' % Element order
            'SecNum' % Sec number for stiffness calculation
            'TaperAngle' % Taper angle [°]
            };

        inputExpectedFields = {
            'StatorR' % [Ri,Ro]
            'RotorR' % [Ri,Ro]
            'Height' % [H1,H2,...]
            'StatorDir' % [Angle1,Angle2,..]
            'RotorDir' % [Angle1,Angle2,...]
            };

        outputExpectedFields = {
            'Assembly'% Mesh assembly
            'SolidMesh' % Solid mesh
            'ShellMesh' % Section mesh
            'StiffnessX' % Stiffness curve of bearing
            'StiffnessY' % Stiffness curve of bearing 
            };

        baselineExpectedFields = {
            };

        default_Name='TaperPMB_1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        default_MeshNum=[10,10]
        default_N_Slice=36
        default_Order=1
        default_SecNum=16
        default_TaperAngle=0
    end
    methods

        function obj = TaperPMB(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='TaperPMB.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input
            Num1=size(obj.input.Height,2);
            if  size(obj.input.StatorDir,2)~=Num1-1
                error('Size mismatch !')
            end

            if  size(obj.input.RotorDir,2)~=Num1-1
                error('Size mismatch !')
            end

            if isempty(obj.input.StatorR)
                error('Please input Radius if stator !')
            elseif size(obj.input.StatorR,2)~=2
                error('Please input the ri and ro if stator !')
            end

            if isempty(obj.input.RotorR)
                error('Please input Radius if rotor !')
            elseif size(obj.input.RotorR,2)~=2
                error('Please input the ri and ro of rotor !')
            end

            if isempty(obj.params.Material)
                error('Please input material !')
            end

            % Calculate section
            obj=CalSection(obj);
            % Output Solid mesh
            obj=OutputSolidMesh(obj);
            % Output Assembly
            obj=OutputAss(obj);

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate Radial passive magnet bearing ! .\n');
            end
        end
    end
end


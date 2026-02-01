classdef STLBody < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Material' % Material of the Component
            'Position'
            };

        inputExpectedFields = {
            'STLFile' % STLFileName
            };

        outputExpectedFields = {
            'SolidMesh' % Solid Mesh
            'Assembly'% Mesh assembly
            };

        baselineExpectedFields = {
            };

        default_Name='STLBody_1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Material=[]; % Set default material
        default_Position=[0,0,0,0,0,0]
    end
    methods

        function obj = STLBody(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='STLBody.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input is Null
            Check(obj)

            % Read STL file
            l1=Layer('Layer1','Echo',0);
            FileName=strcat(obj.input.STLFile,'.stl');
            l1=STLRead(l1,FileName);

            Position=obj.params.Position;
     
            l1=Rotate(l1,Position(4:6),'Meshes',1);
            l1=Move(l1,Position(1:3),'Meshes',1);

            % Build Mesh
            mm=Mesh(obj.params.Name,'Echo',0);
            mm.Vert=l1.Meshes{1, 1}.Vert;
            mm.Face=l1.Meshes{1, 1}.Face;
            mm.Cb=l1.Meshes{1, 1}.Cb;
            mm=Mesh3D(mm);

            % Parse 
            obj.output.SolidMesh=mm;

            % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % Output Assembly
            obj=OutputAss(obj);

            % Print
            if obj.params.Echo
                fprintf('Successfully build mesh form stl file ! .\n');
            end
        end
    end
end


classdef ShellGrid < Component
    % Class ShellGrid
    % Author: Yu Xie
       
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material, default is steel
            'Name' % Name of Grid
            'Section'
            'Type'
            'JointType' % 0 Link180 1 Beam188
            'BoundaryType' % 0 [1,1,1,0,0,0] 1 [1,1,1,1,1,1]
            'Echo' % Print
           'Gravity' 
            };
        
        inputExpectedFields = {
            'f' % [mm]
            'span' % [mm]
            'kn'
            'nx'
            'PP' % N/mm2 permanent pressure
            'VP' % N/mm2 variable pressure
            };
        
        outputExpectedFields = {
            'Matrix'
            'Shape'
            'BeamMesh'% Shell grid mesh
            'Assembly'% Shell grid mesh assembly
            };
        
        baselineExpectedFields = {};
        default_Name='ShellGrid_1';
        default_Material=[];
        default_Echo=1;
        default_Section=[];
        default_Type=1;
        default_JointType=1;
        default_BoundaryType=0;
        default_Gravity=1;
    end
    methods
        
        function obj = ShellGrid(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='ShellGrid.pdf';
        end
        
        function obj = solve(obj)
            % Check input
            switch obj.params.Type
                case 1
                    if size(obj.params.Section,1)~=2
                        error('Section num shoule be 2 ! ')
                    end

                case 2
                    if size(obj.params.Section,1)~=3
                        error('Section num shoule be 3 ! ')
                    end
                case 3
                    if size(obj.params.Section,1)~=2
                        error('Section num shoule be 2 ! ')
                    end
                case 4
                    if size(obj.params.Section,1)~=2
                        error('Section num shoule be 2 ! ')
                    end
            end

           % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % calculate outputs
            obj=CalShape(obj);
            obj=OutputBeamModel(obj);
            obj=OutputAss(obj);
        end       
    end
end
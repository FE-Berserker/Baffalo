classdef Grid < Component
    % Class Grid
    % Author: Yu Xie
       
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material, default is steel
            'Name' % Name of Grid
            'Section'
            'Type'
            'Boundary'
            'Echo' % Print
            'JointType' % 0 Link180 1 Beam188
            'BoundaryType' % 0 [1,1,1,0,0,0] 1 [1,1,1,1,1,1]
            'LoadPosition' % Load position
            'Gravity'
            
            };
        
        inputExpectedFields = {
            'lx' % [mm]
            'ly' % [mm]
            'lz' % [mm]
            'nx'
            'ny'
            'PLoad' % N Permanent load
            'VLoad' % N Variable load
            
            };
        
        outputExpectedFields = {
            'Matrix'
            'Shape'
            'BeamMesh'%  Grid mesh
            'Assembly'% Grid mesh assembly

            };
        
        baselineExpectedFields = {};

        default_Name='Grid_1';
        default_Material=[];
        default_Echo=1;
        default_Section=[];
        default_Type=1;
        default_Boundary=[1;2];
        default_JointType=0;
        default_BoundaryType=0;
        default_LoadPosition=1;
        default_Gravity=1;
    end
    methods
        
        function obj = Grid(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Grid.pdf';
        end
        
        function obj = solve(obj)
            % Check input
            switch obj.params.Type
                case 1
                    if mod(obj.input.nx, 2) == 0
                        error('nx can not be even number ! ')
                    end
                    if mod(obj.input.ny, 2) == 0
                        error('ny can not be even number ! ')
                    end

                    if size(obj.params.Section,1)~=4
                        error('Section num shoule be 4 ! ')
                    end

                case 2
                    if size(obj.params.Section,1)~=4
                        error('Section num shoule be 4 ! ')
                    end
                case 3
                    if size(obj.params.Section,1)~=3
                        error('Section num shoule be 3 ! ')
                    end
                case 4
                    if size(obj.params.Section,1)~=3
                        error('Section num shoule be 3 ! ')
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
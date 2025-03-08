classdef BossPlate < Component
    % Class BossPlate
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material, default is steel
            'Name' % Name of BossPlate
            'Order' % Solid element order
            'Type' % Type=1, Extrude innerside Type=2, Extrude outerside 
            'HoleSeg'% Hole edge segments
            'Echo' % Print
            
            };
        
        inputExpectedFields = {
            'OutLine' % Outline of BossPlate [mm]
            'MidLine' % Midline of BossPlate [mm]
            'InnerLine' % Innerline of BossPlate [mm]
            'InnerHole' % Innerpart Hole
            'OuterHole' % Outerpart Hole
            'BossHeight' % Boss height [mm]
            'PlateThickness' % Plate thickness [mm]
            'Meshsize' % Mesh size [mm]
            };
        
        outputExpectedFields = {
            'PlateNode' % Boss plate node at plate side
            'SolidMesh'% Boss plate 3D mesh
            'Assembly'% Boss plate solid mesh assembly
            };

        baselineExpectedFields = {};
        
        default_Name='BossPlate1';
        default_Material=[];
        default_Echo=1;
        default_Order=1;
        default_Type=1;
        default_HoleSeg=16;
    end
    methods
        
        function obj = BossPlate(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='BossPlate.pdf';
        end
        
        function obj = solve(obj)
            % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
        end

    end
end
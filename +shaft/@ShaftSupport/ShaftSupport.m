classdef ShaftSupport < Component
    % Class ShaftSupport
    % Author: Yu Xie
    
    properties
        %other cComponentTemplate specific properties...
    end
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material, default is steel
            'Name' % Name of ShaftSupport
            'E_Revolve' % Spin number
            'Order' % Solid element order
            'Type' % Shaft support type
            'Echo' % Print
            };
        
        inputExpectedFields = {
            'N' % Wall Thickness [mm]
            'L' % Length of shaft support [mm]
            'D' % Shaft diameter [mm]
            'H' % Size of Plate [mm]
            'T' % Thickness of plate [mm]
            'd1' % Hole diameter [mm]
            'P' % Pitch diameter [mm]
            'NH' % Number of holes
            'K'
            'W'
            'F'
            };
        
        outputExpectedFields = {
            'SolidMesh'% Shaft 3D mesh
            'Assembly'% Shaft solid mesh assembly
            };

        baselineExpectedFields = {
            };

        default_Name='ShaftSupport_1';
        default_E_Revolve=40;
        default_Material=[];
        default_Echo=1;
        default_Type=1;
        default_Order=1;
    end
    methods
        
        function obj = ShaftSupport(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='ShaftSupport.pdf';
        end
        
        function obj = solve(obj)
            % Check input
            if mod(obj.params.E_Revolve,8)~=0
                obj.params.E_Revolve=ceil(obj.params.E_Revolve/8)*8;
            end
            % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end
            switch obj.params.Type
                case 1
                    obj=OutputSolidModel1(obj);
                case 2
                    obj=OutputSolidModel2(obj);
                case 3
                    obj=OutputSolidModel3(obj);
                case 4
                    obj=OutputSolidModel4(obj);

            end
            obj=OutputAss(obj);
        end


        
    end
end
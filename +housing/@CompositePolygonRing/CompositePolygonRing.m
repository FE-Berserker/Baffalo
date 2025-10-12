classdef CompositePolygonRing < Component
    % Class CompositePolygonRing
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material
            'Name' % Name of CompositeRing
            'Echo' % Print
            'NRot' % Number of Egde
            'NHeight' % Number of elements in height direction
            'T' % Temperature
            'Order'
            };
        
        inputExpectedFields = {
            'Di' % Inner diameter [mm]
            'Thickness' % Layer thickness [mm]
            'EdgeNum'
            'r'
            'Angle' % Layer angles [°]
            'MatNum' % Layer Material number
            'Height' % Height of rotor section
            };
        
        outputExpectedFields = {
            'TotalThickness'% Total thickness
            'SolidMesh'% CompositeRing 3D mesh
            'Assembly'% CompositeRing solid mesh assembly
            'NRot'
            'Matrix'
            };
        baselineExpectedFields = {}
        
        default_Name='CompositePolygonRing_1';
        default_NRot=8;
        default_Material=[];
        default_Echo=1;
        default_NHeight=40;
        default_Order=1;
        default_T=20;
    end
    methods
        
        function obj = CompositePolygonRing(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='CompositePolygonRing.pdf';
        end
        
        function obj = solve(obj)
            % Material setting
            if isempty(obj.params.Material)
                error('Please define the composite material properties! ')
            end

            % Check input
            if mod(obj.params.NRot,2)~=0
                obj.params.NRot=ceil(obj.params.NRot/2)*2;
            end

            if isempty(obj.input.r)
                obj.input.r=1;
            end

            % calculate outputs
            obj.output.TotalThickness=sum(obj.input.Thickness);
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
        end
        
    end
end
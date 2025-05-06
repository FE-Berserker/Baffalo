classdef CompositeRing < Component
    % Class CompositeRing
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material
            'Name' % Name of CompositeRing
            'Echo' % Print
            'NRot' % Number of elements in rotate direction
            'NHeight' % Number of elements in height direction
            'Order'
            };
        
        inputExpectedFields = {
            'Di' % Inner diameter [mm]
            'Thickness' % Layer thickness [mm]
            'Angle' % Layer angles [°]
            'MatNum' % Layer Material number
            'Height' % Height of rotor section
            };
        
        outputExpectedFields = {
            'TotalThickness'% Total thickness
            'SolidMesh'% CompositeRing 3D mesh
            'Assembly'% CompositeRing solid mesh assembly
            'Matrix'
            };
        baselineExpectedFields = {}
        
        default_Name='CompositeRing_1';
        default_NRot=36*4;
        default_Material=[];
        default_Echo=1;
        default_NHeight=40;
        default_Order=1;
    end
    methods
        
        function obj = CompositeRing(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='CompositeRing.pdf';
        end
        
        function obj = solve(obj)
            % Material setting
            if isempty(obj.params.Material)
                error('Please define the composite material properties! ')
            end

            % Check input
            if mod(obj.params.NRot,4)~=0
                obj.params.NRot=ceil(obj.params.NRot/4)*4;
            end

            % calculate outputs
            obj.output.TotalThickness=sum(obj.input.Thickness);
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
        end
        
    end
end
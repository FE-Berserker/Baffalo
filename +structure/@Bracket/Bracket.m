classdef Bracket < Component
    % Class Bracket
    % Author: Yu Xie
       
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material, default is steel
            'Name' % Name of bracket
            'Section'
            'Echo' % Print
            
            };
        
        inputExpectedFields = {
            'Layer' %  Layer of the bracket          
            'SectionNum'
            'Meshsize' % Mesh size [mm]
            'Rotate'
            };
        
        outputExpectedFields = {
            'Matrix'
            'BeamMesh'%  Shaft beam mesh
            'Assembly'% Shaft beam mesh assembly
            };
        
        baselineExpectedFields = {};
        default_Name='Bracket_1';
        default_Material=[];
        default_Echo=1;
        default_Section=[];
    end
    methods
        
        function obj = Bracket(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Bracket.pdf';
        end
        
        function obj = solve(obj)
           % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            if isempty(obj.params.Section)
                error('Please set the section !')
            end

            if isempty(obj.input.SectionNum)
                error('Please set the section number !')
            end

            if isempty(obj.input.Rotate)
                obj.input.Rotate=zeros(size(obj.input.SectionNum,1),1);
            end

            % calculate outputs
            obj=OutputBeamModel(obj);
            obj=OutputAss(obj);
        end       
    end
end
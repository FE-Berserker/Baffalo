classdef TimoshenkoLinearElement < handle
% Class with the element formulation for Timoshenko elements

%   Timoshenko elements describe beam elements
%   they consist of 2 nodes with 6 degrees of freedom each, so that 1
%   element has 12 degrees of freedom


    properties
        E
        G
        v
        Dens
        Node
        Element
        radius_outer
        radius_inner      
        Area % Unit：m^2
        Length % Unit: m
        Volume % Unit：m^3
        I_p
        I_y
        localisation_matrix
        stiffness_matrix
        mass_matrix
        gyroscopic_matrix

    end
    
    methods
        function obj = TimoshenkoLinearElement(Node,Element,Section,Material,MatNum)
            % Constructor
            % unit mm --> m
            obj.Node=Node/1000;
            obj.Element=Element;

            if size(MatNum,1)~=size(Element,1)
                error('Wrong mat num input !')
            end

            % Convert Section
            R1=cellfun(@(x)0.*(x.subtype=='CSOLID')+x.data(1).*(x.subtype=='CTUBE'),Section,'UniformOutput',false);
            R2=cellfun(@(x)x.data(1).*(x.subtype=='CSOLID')+x.data(2).*(x.subtype=='CTUBE'),Section,'UniformOutput',false);
            obj.radius_outer=cell2mat(R2)/1000;
            obj.radius_inner=cell2mat(R1)/1000;
            
            E=cell(1,size(Element,1));
            G=cell(1,size(Element,1));
            Dens=cell(1,size(Element,1));
            v=cell(1,size(Element,1));
            for i=1:size(MatNum,1)
                k=MatNum(i,1);
                v{1,i}=Material{k,1}.v;
                % unit Mpa --> pa
                E{1,i}=Material{k,1}.E*1e6;
                G{1,i}=E{1,i}/2/(1+Material{k,1}.v);
                % unit t/mm3 --> kg/m3
                Dens{1,i}=Material{k,1}.Dens*1e12;
            end
            obj.E=E;
            obj.G=G;
            obj.Dens=Dens;
            obj.v=v;

        end

        function obj=solve(obj)
            obj=create_ele_loc_matrix(obj);
            obj=calculate_geometry_parameters(obj);
            % Assembly elementary matrices
            obj=assemble_stiffness_matrix(obj);
            obj=assemble_mass_matrix(obj);
            obj=assemble_gyroscopic_matrix(obj);
        end


    end
    
end
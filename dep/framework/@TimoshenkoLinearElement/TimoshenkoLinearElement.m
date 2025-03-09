classdef TimoshenkoLinearElement < handle
% Class with the element formulation for Timoshenko elements

%   Timoshenko elements describe beam elements
%   they consist of 2 nodes with 6 degrees of freedom each, so that 1
%   element has 12 degrees of freedom


    properties
        Material
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
        function obj = TimoshenkoLinearElement(Node,Element,Section,Material)
            % Constructor
            % unit mm --> m
            obj.Node=Node/1000;
            obj.Element=Element;
            % Convert Section
            R1=cellfun(@(x)0.*(x.subtype=='CSOLID')+x.data(1).*(x.subtype=='CTUBE'),Section,'UniformOutput',false);
            R2=cellfun(@(x)x.data(1).*(x.subtype=='CSOLID')+x.data(2).*(x.subtype=='CTUBE'),Section,'UniformOutput',false);
            obj.radius_outer=cell2mat(R2)/1000;
            obj.radius_inner=cell2mat(R1)/1000;
            % unit Mpa --> pa 
            Material.E=Material.E*1e6;
            Material.G=Material.E/2/(1+Material.v);
            % unit t/mm3 --> kg/m3
            Material.Dens=Material.Dens*1e12;
            obj.Material=Material;
            
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
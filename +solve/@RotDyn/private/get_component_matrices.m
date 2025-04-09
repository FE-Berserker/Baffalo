function [M_Comp,D_Comp,G_Comp,K_Comp]= get_component_matrices(obj,rpm)
% Extracts the specific component matrices (M,D,G,K)
%
%    :param components: Desired component object
%    :type components: object
%    :param rpm: Rotational speed
%    :type rpm: double
%    :return: Component matrices (M,D,G,K)


Component=obj.Component;
n_nodes=length(obj.Rotor.Mesh.Node);

M_Comp =sparse(6*n_nodes,6*n_nodes);
D_Comp =sparse(6*n_nodes,6*n_nodes);
G_Comp =sparse(6*n_nodes,6*n_nodes);
K_Comp =sparse(6*n_nodes,6*n_nodes);

for i=1:size(Component,2)    
    component_node =Component{i}.Node;
    Type=Component{i}.Type;

    L_ele = sparse(6,6*n_nodes);
    L_ele(1:6,(component_node-1)*6+1:(component_node-1)*6+6)=Component{i}.localisation_matrix; %#ok<SPRIX>

    if Type=="LUTBearing"
        mass_matrix=Component{i}.mass_matrix;
        damping_matrix= get_LUTBearing_loc_damping_matrix(Component{i},rpm);
        gyroscopic_matrix=Component{i}.gyroscopic_matrix;
        stiffness_matrix= get_LUTBearing_loc_stiffness_matrix(Component{i},rpm);
    else
        mass_matrix=Component{i}.mass_matrix;
        damping_matrix=Component{i}.damping_matrix;
        gyroscopic_matrix=Component{i}.gyroscopic_matrix;
        stiffness_matrix=Component{i}.stiffness_matrix;
    end
    
    M_Comp  = M_Comp +L_ele'*mass_matrix*L_ele;
    D_Comp  = D_Comp +L_ele'*damping_matrix*L_ele;
    G_Comp  = G_Comp +L_ele'*gyroscopic_matrix*L_ele;
    K_Comp  = K_Comp +L_ele'*stiffness_matrix*L_ele;

    if isfield(Component{i},'IsCon')
        IsCon=Component{i}.IsCon;
        if IsCon~=0
            L_ele1 = sparse(6,6*n_nodes);
            L_ele1(1:6,(IsCon-1)*6+1:(IsCon-1)*6+6)=Component{i}.localisation_matrix; %#ok<SPRIX>

            D_Comp  = D_Comp +L_ele1'*damping_matrix*L_ele1...
                -L_ele'*damping_matrix*L_ele1-L_ele1'*damping_matrix*L_ele;% 交叉项
            K_Comp  = K_Comp +L_ele1'*stiffness_matrix*L_ele1...
                -L_ele'*stiffness_matrix*L_ele1-L_ele1'*stiffness_matrix*L_ele;% 交叉项

        end
    end
end

end
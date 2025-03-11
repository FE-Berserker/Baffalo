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
    L_ele = sparse(6,6*n_nodes);
    L_ele(1:6,(component_node-1)*6+1:(component_node-1)*6+6)=Component{i}.localisation_matrix; %#ok<SPRIX>
    
    M_Comp  = M_Comp +L_ele'*Component{i}.mass_matrix*L_ele;
    D_Comp  = D_Comp +L_ele'*Component{i}.damping_matrix*L_ele;
    G_Comp  = G_Comp +L_ele'*Component{i}.gyroscopic_matrix*L_ele;
    K_Comp  = K_Comp +L_ele'*Component{i}.stiffness_matrix*L_ele;
end

end
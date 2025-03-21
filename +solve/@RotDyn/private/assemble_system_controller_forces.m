function h = assemble_system_controller_forces(obj,t,Z)
% Adds the controller force to the load vector
% 
%    :parameter t: time step
%    :type t: double
%    :parameter Z: state-space vector [x; x_dot]
%    :type Z: vector
%    :return: Load vector h
%    :rtype: vector


n_nodes=length(obj.Rotor.Mesh.Node);
h = sparse(6*n_nodes,1);

for i=1:length(obj.PIDController)
    Control=obj.PIDController{i};
    n_nodes=length(obj.Rotor.Mesh.Node);
    node=Control.Node;
    glob_dof = get_gdof(obj,Control.Direction,node);
    % localisation matrix is only a vector
    L_glob = sparse(1,6*n_nodes);
    L_glob(glob_dof) = 1; %#ok<SPRIX>

    [displacementCntrNode, ~] = find_state_vector(obj,node, Z);
    force = get_controller_force(Control,t,displacementCntrNode);

    h = h + L_glob' * force;

end


end
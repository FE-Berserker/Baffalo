function [u, ud] = find_state_vector(obj, node, Z)
% Searches for the state-space vector of nodes regarding the position in the form u = [x; x_dot]
%
%    :param position: Position of interest along rotor axis 
%    :type position: double
%    :param Z: Global state-space vector
%    :type Z: vector
%    :return: Overall translational mass


dof_x = get_gdof(obj,'Uy',node);
dof_psi_z = get_gdof(obj,'Rotx',node);

% displacement
u = Z(dof_x:dof_psi_z);

% velocity
ud = Z(end/2+(dof_x:dof_psi_z));

% u_node = [u; u_dot];

end
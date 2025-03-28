function [A,B] = get_state_space_matrices3(obj,omega)
% Builds state space matrices of form A=[0, I;-M_inv*K, -M_inv*(C+G*omega)] and B=[0, 0;0, M_inv]
%
%    :param omega: Angular velocity
%    :type omega: double
%    :return: State space matrices A, B

% Licensed under GPL-3.0-or-later, check attached LICENSE file

[M,C,G,K]= assemble_system_matrices(obj,omega*60/2/pi);
M_inv = M\eye(size(M));



A = sparse([zeros(length(M)), eye(length(M)); -M_inv*K, -M_inv*(C+G*omega)]);
B= sparse([zeros(length(M)),zeros(length(M));zeros(length(M)),M_inv]);

end
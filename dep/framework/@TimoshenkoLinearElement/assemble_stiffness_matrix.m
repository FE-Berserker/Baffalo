function obj = assemble_stiffness_matrix(obj)
% Assembles stiffness matrix
%    :return: Stiffness matrix K

K_A = compute_axial_stiffness_matrix(obj);
K_T = compute_torsional_stiffness_matrix(obj);
[K_F1, K_F2] = compute_bending_stiffness_matrix(obj);

K=cellfun(@(x,y,z,a)[x,zeros(2,10);zeros(2,2),y,zeros(2,8);zeros(4,4),z,zeros(4,4);zeros(4,8),a]...
    ,K_A,K_T,K_F1,K_F2,'UniformOutput',false);

obj.stiffness_matrix = K;
end
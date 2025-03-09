function obj = assemble_mass_matrix(obj)
% Assembles mass matrix 
%:return: Mass matrix M

M_A = compute_axial_mass_matrix(obj);
M_T = compute_torsional_mass_matrix(obj);
[M_F1, M_F2] = compute_flexural_mass_matrix(obj);

M=cellfun(@(x,y,z,a)[x,zeros(2,10);zeros(2,2),y,zeros(2,8);zeros(4,4),z,zeros(4,4);zeros(4,8),a]...
    ,M_A,M_T,M_F1,M_F2,'UniformOutput',false);
obj.mass_matrix = M;
end
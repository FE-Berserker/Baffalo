function obj = assemble_gyroscopic_matrix(obj)
% Assembles gyroscopic matrix 
%
%    :return: Gyroscopic matrix G


% According to Genta 2005: Dynamics of Rotating Systems


[GAB,GBA] = compute_gyroscopic_matrix(obj);
% results GAB and GBA in q_A and q_B
% q_A = [u_x1; psi_y1; u_x2; psi_y2] (bending in x-z-plane)
% q_B = [u_y1; psi_x1; u_y2; psi_x2] (bending in y-z-plane)

G=cellfun(@(x,y)[zeros(4,12);zeros(4,8),x;zeros(4,4),y,zeros(4,4)]...
    ,GAB,GBA,'UniformOutput',false);

obj.gyroscopic_matrix = G;
end
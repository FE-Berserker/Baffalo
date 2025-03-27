function [M,C,G,K]= assemble_system_matrices(obj,rpm)
% Assembles the specific component matrices to the global matrices
%
%    :param rpm: Rotational speed
%    :type rpm: double
%    :param varargin: Placeholder
%    :return: Global component matrices (M,D,G,K)

if nargin == 1
    rpm=0;
end

%% Rotormatrizen aus FEM erstellen
            
            
%Lokalisierungsmatrix hat 6x6n 0 Einträge
%Element L wird dann an der Stelle (i-1)*6 drauf addiert.

                    
%% Add component matrices
[M_Comp,D_Comp,G_Comp,K_Comp]= get_component_matrices(obj,rpm);


%% Add to global matrices
M = obj.Rotor.mass_matrix + M_Comp;
C = obj.Rotor.damping_matrix + D_Comp ;
G = obj.Rotor.gyroscopic_matrix + G_Comp;
K = obj.Rotor.stiffness_matrix + K_Comp ;

        
end
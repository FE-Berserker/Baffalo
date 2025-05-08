function [Aij, Bij, Dij] = GetABD(Orient, plymat, N, z)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Calculate the laminate ABD matrix
% Input:
% - Orient: Array of ply orientation angles theta (deg)
% - plyprops: Cell array containing ply material properties
% - plymat: Array of ply material id numbers
% - N: Total number of plies
% - z: Array of ply boundary z-coordinates
% Output:
% - Aij: Laminate extensional stiffness matrix
% - Bij: Laminate coupling stiffness matrix
% - Dij: Laminate bending stiffness matrix
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -- Preaallocate arrays
Aij = zeros(3,3);
Bij = zeros(3,3);
Dij = zeros(3,3);

Aij_vect = zeros(1,N);
Bij_vect = zeros(1,N);
Dij_vect = zeros(1,N);

% -- Calculate for A,B,D vectors by using for-loops to create summation
for i = 1:3
    for j = 1:3
        for k = 1:N  % -- k is current ply
            
            Qb = Qbar(Orient(k),plymat{k});

            % -- .* and .^ are element by element operations
            Aij_vect(k) = Qb(i,j).*(z(k+1) - z(k));           % -- Eq. 2.64
            Bij_vect(k) = Qb(i,j).*((z(k+1)).^2 - (z(k)).^2); % -- Eq. 2.65
            Dij_vect(k) = Qb(i,j).*((z(k+1)).^3 - (z(k)).^3); % -- Eq. 2.66

        end
        
        Aij(i,j) = sum(Aij_vect);   % -- Eq. 2.64
        Bij(i,j) = sum(Bij_vect)/2; % -- Eq. 2.65
        Dij(i,j) = sum(Dij_vect)/3; % -- Eq. 2.66
        
    end   
end

end

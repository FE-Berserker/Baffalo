function Q_bar = Qbar(A, mat)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Calculate the transformed reduced stiffness matrix
% Input:
% - A: Ply orientation angle theta (deg)
% - plyprops: Cell array containing ply material properties
% - matID: ply-level material id number
% Output:
% - Q_bar: transformed reduced stiffness matrix
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

E1 = mat.E1;
E2 = mat.E2;
G12 = mat.G12;
v12 = mat.v12;

% -- Define plane-stress compliance matrix (Eqs. 2.17, 2.18)
S11 = 1/E1;
S12 = -v12/E1;
S22 = 1/E2;
S66 = 1/G12;

S = [S11 S12 0;S12 S22 0;0 0 S66];

% -- Define the reduced stiffness matrix in material coordinates (1,2,3)
Q = inv(S); % -- Equivalent to Eqs. 2.42

% -- Determine transformation matrices
[T1,T2] = GetT(A);

% -- Calculate transformed reduced stiffness matrix (Eq. 2.46)
Q_bar = inv(T1)*Q*T2;

end
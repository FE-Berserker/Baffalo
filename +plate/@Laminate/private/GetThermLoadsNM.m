function [NMT, alphbar] = GetThermLoadsNM(Orient, plymat, N, z)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Calculate the laminate thermal force and moment results, NT and MT **per 
%          degree** - That is, these must be multiplied by DT to obtain actual force 
%          and moment resultants in Eqs. 2.67 and 2.68
% Input:
% - Orient: Array of ply orientation angles theta (deg)
% - plyprops: Cell array containing ply material properties
% - plymat: Array of ply material id numbers
% - N: Total number of plies
% - z: Array of ply boundary z-coordinates
% Output:
% - NMT: Vector containing NT and MT (see Eq. 2.70) **per degree**
% - alphbar: Cell array containing ply CTEs in the global (x-y) coordinates
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -- Preallocate alphbar
alphbar = cell(1,N);

% -- Obtain alphbar - cell array of ply CTEs in x-y coords
for k = 1:N
    a1 = plymat{k}.a1;   
    a2 = plymat{k}.a2;
    alph =[a1; a2; 0]; % -- alph is the ply CTE vector, a12 = 0 in local 
    [~,T2] = GetT(Orient(k));
    alphbar{k} = inv(T2) * alph;  % -- Eq. 2.48                     
end

% -- Preallocate NT and MT
NT = zeros(3,1);
MT = zeros(3,1);

% -- Perform summation over plies
for k = 1:N 
    Qb = Qbar(Orient(k), plymat{k});   
    NTply = Qb*alphbar{k}*(z(k+1) - z(k)); % -- Eq. 2.67 (divided by DT)
    NT = NT + NTply;
    MTply = Qb*alphbar{k}*(z(k+1)^2 - z(k)^2)/2; % -- Eq. 2.68 (divided by DT)
    MT = MT + MTply;
end

% -- Store NT and MT in single vector (NOTE: these are per degree)
NMT = [NT;MT]; % [Nx,Ny,Nxy,Mx,My,Mxy]

end
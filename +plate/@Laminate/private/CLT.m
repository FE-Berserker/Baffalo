function [Geometry, LamResults] = CLT(Orient,plymat,tl, Loads, LamResults)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Perform classical lamination theory calculations
% - Calculate laminate ABD, effective props, thermal force and moment resultants, 
%   unknown midplane strains/curvatures, and stresses/strains through the thickness 
%   at top and bottom of each ply
% Input:
% - plyprops: Cell array containing ply material properties
% - Geometry: Struct containing laminate definition variables
% - Loads: Struct containing problem loading information
% - LamResults: Struct containing laminate analysis results
% Output:
% - Geometry: Updated struct containing laminate definition variables
% - LamResults: Updated struct containing laminate analysis results
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -- Extract variables from structs for convenience
DT = 0;

% -- Check lengths of plymat, Orient, t1 (must all be the same)
if isequal(length(plymat), length(Orient), length(tl))
    N = length(plymat);
    Geometry.N = N;
else
    error('Lengths of plymat, Orient, tl are not the same');
end

% -- Calculate z coordinate of each ply boundary
t = sum(tl);
tlx = cumsum(tl);
z = [-t/2,-t/2+tlx];

% -- Calculate ABD matrix and inverse
[Aij, Bij, Dij] = GetABD(Orient, plymat, N, z);
ABD = [Aij, Bij; Bij, Dij];
ABDinv = inv(ABD);

% -- Calculate effective mechanical laminate properties (Eqs. 2.74)
%    (Valid for symmetric laminates Only, Bij = 0) 
EX = 1/(ABDinv(1,1)*t);
EY = 1/(ABDinv(2,2)*t);
NuXY = -ABDinv(1,2)/ABDinv(1,1);
NuYX = -ABDinv(2,1)/ABDinv(2,2);
GXY =  1/(ABDinv(3,3)*t);

% -- Calculate thermal force and moment resultants **per degree** and
%    ply level CTEs transformed to global x-y coords (alphbar)
[NMT, alphbar] = GetThermLoadsNM(Orient,plymat, N, z);

%  -- Calculate laminate effective CTEs (Eq. 2.75)
%    (Valid for symmetric laminates Only, Bij = 0) 
EKT = ABDinv*NMT; % -- Note, NMT is per degree at this point
AlphX = EKT(1);
AlphY = EKT(2);
AlphXY = EKT(3);

% -- Calculate actual thermal force and moment resultants
NMT = NMT*DT;


% -- Detemine unknown global NM and EK components based on specified loading
[NM, EK] = SolveLoading(6, ABD, -NMT, Loads);
Loads.NM = NM;

% -- Extract mid-plane strains (Eps_o) and Curvatures (Kappa)
Eps_o = EK(1:3);
Kappa = EK(4:6);

% ---------------------------------------
% -- Localization of Laminate Stresses
% ---------------------------------------
stress = [];
strain = [];
MCstress = [];
MCstrain = [];
LayerZ = zeros(1,N*2);

% -- Calculate stresses and strains at top and bottom points of each ply
for i = 0:N - 1
    
    LayerZ(2*i + 2) = z(i + 2);
    LayerZ(2*i + 1) = z(i + 1);
    
    % -- Eqs. 2.53, 2.59
    strainbot = Eps_o + z(i + 1)*(Kappa);
    stressbot = Qbar(Orient(i + 1), ...
                     plymat{i + 1})*(strainbot - alphbar{i + 1}*DT);
    straintop = Eps_o + z(i + 2)*(Kappa);
    stresstop = Qbar(Orient(i + 1), ...
                     plymat{i + 1})*(straintop - alphbar{i + 1}*DT);
    
    stress = [stress, stressbot, stresstop]; % -- recursively concat vectors 
    strain = [strain, strainbot, straintop]; % -- recursively concat vectors 
    
% -- Transform stress and strain to material coordinates (MC) per ply (Eqs. 2.43)
    Ang = Orient(i + 1);
    [T1, T2] = GetT(Ang);
    MCstrainbot = T2*strainbot;
    MCstressbot = T1*stressbot;
    MCstraintop = T2*straintop;
    MCstresstop = T1*stresstop;
    MCstress = [MCstress,MCstressbot,MCstresstop]; % -- recursively concat vectors
    MCstrain = [MCstrain,MCstrainbot,MCstraintop]; % -- recursively concat vectors     
    
end

% -- Store geometry and results for return
Geometry.LayerZ = LayerZ;
LamResults.A = Aij;
LamResults.B = Bij;
LamResults.D = Dij;
LamResults.EX = EX;
LamResults.EY = EY;
LamResults.NuXY = NuXY;
LamResults.NuYX = NuYX;
LamResults.GXY = GXY;
LamResults.AlphX = AlphX;
LamResults.AlphY = AlphY;
LamResults.AlphXY = AlphXY;
LamResults.EK = EK;
LamResults.NM = NM;
LamResults.NMT = NMT;
LamResults.stress = stress;
LamResults.strain = strain;
LamResults.MCstress = MCstress;
LamResults.MCstrain = MCstrain;
end
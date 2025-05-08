function [SG, EG] = SolveLoading(ISIZE, ZG, B, Loads)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Solves the system: {SG} = [ZG] * {EG} + {B} 
%          Where one of each S, E pair is specified, that is, the user may 
%          specify either Si or Ei (i = 1, ISIZE) for each i, and the 
%          unspecified Si or Ei values are determined
% Input:
% - ISIZE: Number of equations in system (6 in current application)
% - ZG: Stiffness matrix
% - B: Right hand side vector (used for thermal stresses)
% - Loads: Struct containing problem loading information
% Output:
% - SG: Vector of global stress components
% - EG: Vector of global total strain components
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -- Preallocate
LOPV = zeros(6, 1);
SG = zeros(6, 1);
EG = zeros(6, 1);

% -- Vector of known stresses or strains as specified by the user
VKNO = Loads.Value;

% -- Handle both laminate and stand-alone micromechanics loading
if isfield(Loads, 'NM')
     StrainNum = Loads.EK; % -- Laminate problem
else                   
     StrainNum = Loads.E;  % -- Stand-alone micromechanics problem
end
 
for I = 1: ISIZE
    if Loads.Type(I) == StrainNum
        LOPV(I) = 1;
    else 
        LOPV(I) = 2;
    end
end

% -- Preallocate
ZTN = zeros(ISIZE);
BN = zeros(ISIZE, 1);
VUNK = zeros(ISIZE, 1);
 
% -- Copy ZG to temporary Z [ZT]
ZT = ZG;

% -- Rearrange equations such that all unknowns are on r.h.s.
for I = 1: ISIZE
    if LOPV(I) == 2 

       for J = 1: ISIZE
          if (J ~= I) 
              ZTN(I, J) = - ZT(I, J) / ZT(I, I);
          end
       end

       BN(I) = - B(I) / ZT(I, I);
       ZTN(I, I) = 1.0 / ZT(I, I);

% -- Cycle through other rows
       for K = 1: ISIZE
          if K ~= I

             BN(K) = B(K) - ZT(K, I) * B(I) / ZT(I, I);

             for J = 1: ISIZE
                if J == I 
                   ZTN(K, J) = ZT(K, J) / ZT(I, I);
                else
                   ZTN(K, J) = ZT(K, J) - ZT(K, I) * ZT(I, J) / ZT(I, I);
                end
             end

          end
       end
        
% -- Reset B and ZT for next time (i.e. next specified S)
       B = BN;
       ZT = ZTN;

    end

end

% -- Solve for the unknown vector
for I = 1: ISIZE
    VUNK(I) = B(I);
    for J = 1: ISIZE
        VUNK(I) = VUNK(I) + ZT(I, J) * VKNO(J);
    end
end         

% -- Copy unknowns and knowns to appropriate SG, EG
for I = 1: ISIZE
    if LOPV(I) == 1 
        SG(I) = VUNK(I);
        EG(I) = VKNO(I);

    elseif LOPV(I) == 2
        SG(I) = VKNO(I);
        EG(I) = VUNK(I);

    end
end
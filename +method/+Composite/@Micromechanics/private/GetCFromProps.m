function [C] = GetCFromProps(Props)

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Calculates the stiffness matrix from the elastic properties
% - Assumes material is at most transversely isotropic (Eq. 2.16) 
% Input:
% - Props: Struct containing material elastic properties
% Output:
% - C: 6x6 material stiffness matrix
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

S = zeros(6);

% -- Eq. 2.17
S(1,1) = 1./Props.E1;
S(2,2) = 1./Props.E2;
S(3,3) = 1./Props.E2;

% -- Eq. 2.18
S(4,4) = 1./(Props.E2/(2.*(1. + Props.v23)));
S(5,5) = 1./Props.G12;
S(6,6) = 1./Props.G12;

% -- Eq. 2.17
S(2,1)= -Props.v12/Props.E1;
S(1,2)=S(2,1);
S(3,1)= -Props.v12/Props.E1;
S(1,3)=S(3,1);
S(3,2)= -Props.v23/Props.E2;
S(2,3)= S(3,2);

C = inv(S);

end


      

         
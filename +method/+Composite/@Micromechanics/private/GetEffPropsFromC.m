function [Effprops] = GetEffPropsFromC(C)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Calculates the elastic properties from the stiffness
% - Assumes material is at most orthotropic (Eq. 2.19) 
% Input:
% - C: 6x6 material stiffness matrix
% Output:
% - Effprops: Struct containing material elastic properties
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

S = inv(C);

% -- Eqs. 2.34 - 2.36
Effprops.E1 = 1./S(1,1);
Effprops.E2 = 1./S(2,2);
Effprops.E3 = 1./S(3,3);

Effprops.G23 = 1./S(4,4);
Effprops.G13 = 1./S(5,5);
Effprops.G12 = 1./S(6,6);

Effprops.v12 = -S(2,1)/S(1,1);
Effprops.v13 = -S(3,1)/S(1,1);
Effprops.v23 = -S(3,2)/S(2,2);

end

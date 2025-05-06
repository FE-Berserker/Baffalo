function [Damagedconstit] = DamageConstit(constit, D)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2020 United States Government as represented by the Administrator of the 
% National Aeronautics and Space Administration. No copyright is claimed in the 
% United States under Title 17, U.S. Code. All Other Rights Reserved. BY DOWNLOADING 
% OR USING THIS SOFTWARE, YOU ACKNOWLEDGE THAT YOU HAVE READ THE NASA OPEN SOURCE 
% AGREEMENT V1.3, THAT YOU UNDERSTAND IT, AND THAT YOU AGREE TO BE BOUND BY ITS 
% TERMS. IF YOU DO NOT AGREE TO THE TERMS AND CONDITIONS OF THIS AGREEMENT, DO NOT 
% USE OR DOWNLOAD THE SOFTWARE. THIS SOFTWARE IS PROVIDED AS IS WITHOUT ANY WARRANTY 
% OF ANY KIND. RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST, AND INDEMNIFIES 
% AND HOLDS HARMLESS, THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND 
% SUBCONTRACTORS, AS WELL AS ANY PRIOR RECIPIENT. This code was prepared by Drs. 
% B.A. Bednarcyk and S.M. Arnold to complement the book 揚ractical Micromechanics of 
% Composite Materials� during the course of their government work.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% Purpose: Defines damaged constituent properties for use in progressive damage
% Input:
% - constit: Struct containing constituent material information
% - D: Fractional damage level for damaged constituents (default: very low value) 
% Output:
% - Damagedconstit: Struct containing damaged constituent material information
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -- Copy constituent info
Damagedconstit = constit;

% -- Reduce constituent stiffness properties by a factor of D
Damagedconstit.E1 = D*constit.E1;
Damagedconstit.E2 = D*constit.E2;
Damagedconstit.G12 = D*constit.G12;

% -- Damaged material given original id + 100
Damagedconstit.ID = constit.ID + 100;

end


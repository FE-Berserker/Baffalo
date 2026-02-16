function [v,r]=sfreesurf(p,alpha,beta)
% 
% [v,r]=sfreesurf(p,alpha,beta)
%
% SFREESURF calculates the free surface effect for an s-wave. The
% algorithm was developed by D.W. Eaton, modified by D.C. Lawton,
% and translated to MATLAB by G.F. Margrave.
%
%   p      :Vector of ray parameters of emergent rays 
%   alpha  :P-wave velocity in the weathering layer
%   beta   :S-wave velocity in the weathering layer
%
%   v      :Vector of coefficients for vertical component receiver
%   r      :Vector of coefficients for radial component receiver 
% 
% NOTE: If Ao is the total displacement amplitude of the s-wave just
%	beneath the surface, the v*Ao will be recorded on a vertical
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.

% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by
% its author (identified above) and the CREWES Project.  The CREWES
% project may be contacted via email at:  crewesinfo@crewes.org
%
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE

%	phone and r*Ao on a radial phone.

%
% ********************************************************************
%                           ============
%
% ********************************************************************
% * Subroutine to calculate the free-surface effect for S-waves      *
% *------------------------------------------------------------------*
% * Developed by D.W. Eaton, modified by D.C. Lawton                 *
% *------------------------------------------------------------------*
% * Update history:  Version 4.0, February, 1993                     *
% * --------------                                                   *
% * Original code                                                    *
% ********************************************************************
%
% General comments
% ----------------
% This routine computes the net reflection coefficient at a free
% surface for an up-coming S-wave. It allows for the reflected S-
% wave and the reflected converted wave (P-wave). However, the data
% have to be pre-conditioned to prevent the reflected converted wave
% from being complex.
%
% Algorithm is developed from equations in:
% Dankbaar, J. W.M., 1985, Separation of P- and S-waves: Geophysical
% Prospecting, 33, 970-986.
%
% ====================================================================
      psi = sqrt(beta^2/alpha^2-beta^2*p.^2);
      peta = sqrt(1.-beta^2*p.^2);
      ro = (1.-2*beta^2*p.^2).^2 + 4*(p.^2*beta^2).*psi.*peta;
      v = 4*beta*p.*psi.*peta./ro;
      r = 2*peta.*(1.-2*beta^2*p.^2)./ro;
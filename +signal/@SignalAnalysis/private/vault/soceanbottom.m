function [v,r]=soceanbottom(p,alpha,beta,rho,alphaw,rhow)
% 
% [v,r]=soceanbottom(p,alpha,beta)
%
% SOCEANBOTTOM alculates the ground motion at the ocean bottom 
% for a s-wave incident from below. The
% algorithm is based on the theory of White (1965) as given by Donati
% and Stewart (1996)
%
%   p       ... Vector of ray parameters of upcoming rays 
%   alpha ... P-wave velocity in the sediment beneath the ocean bottom
%   beta   ... S-wave velocity in the sediment beneath the ocean bottom
%   rho    ...  Density in the sediment beneath the ocean bottom
%   alphaw ... P-wave velocity in the water
%   rhow    ... Density in the water layer
%
%   v      :Vector of coefficients for vertical component receiver
%   r      :Vector of coefficients for radial component receiver 
% 
% NOTE: If Ao is the total displacement amplitude of the p-wave just
%  beneath the ocean bottom, the v*Ao will be recorded on a vertical
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

%  phone and r*Ao on a radial phone.
      sinphi=p*beta;
      cosphi=sqrt(1-sinphi.^2);
      gamma=beta/alpha;
      xsi=sqrt(gamma^2-beta^2*p.^2);
      eta=sqrt(1-beta^2*p.^2);
      ro=rhow*alphaw*sqrt(1-alpha^2*p.^2)./(rho*alpha*sqrt(1-alphaw^2*p.^2))+...
           4*gamma^3*sinphi.^2.*cosphi.*sqrt(1.-gamma^2*sinphi.^2)+(1-2*gamma^2*sinphi.^2);
      v=4*beta*p.*eta.*xsi./ro;
      r=2*eta.*((rhow*alphaw*sqrt(1-alpha^2*p.^2)./(rho*alpha*sqrt(1-alphaw^2*p.^2)))+...
            sqrt(1-beta^2*p.^2))./ro;
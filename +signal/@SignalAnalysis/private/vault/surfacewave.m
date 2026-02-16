function [sw,tsw]=surfacewave(dt,tmax,tlength,tnot,amp,fdom)
%
% [sw,tsw]=surfacewave(dt,tmax,tlength,tnot,amp,fdom)
%
% A simple waveform model of a surface wave is returned in an otherwise
% empty trace. The surface wave is a sine wave of frequency "fdom"
% multiplied by a Gaussian of the form exp(-(2*(tsw-tnot)/tlength).^2). The
% peak amplitude of the sine wave is "amp". This is not based on any
% physical theory.
%
% dt ... time sample interval in seconds
% tmax ... total record length of the trace that the surface wave is placed in
% tlength ... approximate temporal duration of the surface wave
% *********  default = .4 seconds or .4*tmax whichever is less **********
% tnot ... time of the amplitude maximum of the surface wave
% ********* default = tmax/2
% amp ... strength of the surface wave
% ************ default = 1 *************
% fdom ... vector of dominant frequencies in Hz
% ************ default = 6:15 ***********
% 
% by G.F. Margrave, Nov. 2005
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
if(nargin<6)
    fdom=6:15;
end
if(nargin<5)
    amp=1;
end
if(nargin<4)
    tnot=tmax/2;
end
if(nargin<3)
    tlength=min([.4 .4*tmax]);
end

tsw=(0:floor(tmax/dt))*dt;
tsw=tsw';
sw=zeros(size(tsw));
%define different tnots to spread them out a bit
tnot2=linspace(tnot-.4*tlength,tnot+.4*tlength,length(fdom));
for k=1:length(fdom)
    sw=sw+amp*sin(2*pi*fdom(k)*tsw).*exp(-(2*(tsw-tnot2(k))/tlength).^2);
end
    
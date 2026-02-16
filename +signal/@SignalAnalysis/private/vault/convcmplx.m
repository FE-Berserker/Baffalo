function s=convcmplx(rc,w,nzero,flag)
%
% s=convcmplx(rc,w,nzero,flag)
%
% CONVCMPLX is designed to convolve a wavelet with the complex reflection
% sequence produced by ZOEPPRITZ. That is rc is expected to be a complex
% vector of reflection coeficients whose real part is the reflection 
% coefficient magnitude and whose complex part is the reflection phase
% shift (in radians). 
% 
% rc ... vector of complex reflection coefficients in polar form. That is
%	real(rc) give the magnitude of the reflection coefficient and imag(rc)
%	gives the phase shift (in radians)
% w ... wavelet (vector)
% nzero ... sample number at which time zero occurs in w.
% flag ... 0 means the length(s) will be length(rc)+length(w)-1
%          1 means s will be shortened to the same length as rc by appropriatly
%            truncating samples off the beginning and end.
%
% G.F. Margrave, CREWES Project, Summer 1995
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

%small angle
small = pi/1000;

%convert to column vectors
[l,m]=size(rc);
rc=rc(:);
w=w(:);

rrc=real(rc);
phi=imag(rc);
ap=abs(phi);

i1= find( (ap<pi+small & ap > pi-small) );% the negative reals
i2= find( ap<small );%the positive reals
i3= find( ap>small & ap < pi-small );%the complex

%simple part
r1=zeros(size(rrc));
r1(i1) = -1*rrc(i1);
r1(i2) = rrc(i2);

s=conv(r1,w);

%hard part
lw=length(w);
for k=1:length(i3)
	%phase shift the wavelet
	w2=phsrot(w,180*phi(i3(k))/pi);
	
	%sum into s
	%s(i3(k)-nzero+1:i3(k)-nzero+lw)=s(i3(k)-nzero+1:i3(k)-nzero+lw)+...
	s(i3(k):i3(k)+lw-1)=s(i3(k):i3(k)+lw-1)+...
		w2*rrc(i3(k));
end

if(flag) %truncate if needed
	s=s(nzero:length(rc)+nzero-1);
end

if(l==1) s=s.'; end
	
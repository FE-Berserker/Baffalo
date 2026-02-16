function [w,tw]=waveseis(s,t,fsmo,sigma,phase,stab)
% WAVESEIS: Create a zero, minimum, or constant phase wavelet with the amplitude spectrum of a seismic trace
%
% [w,tw]=waveseis(s,t,fsmo,sigma,phase,stab)
% 
% s ... the seismic trace upon which the amplitude spectrum is modelled
% t ... time coordinate for s
% fsmo ... length of a convolutional smoother (HZ) applied to the amplitude spectrum of s
% ************** default 10 Hz *************
% sigma ... standard deviation of a Gaussian window applied to the wavelet (time domain truncation).
% The wavelet will be truncated at +/- 3*sigma from t=0.
% ************** default 0.1 sec ***********
% phase ... phase of the seismic wavelet with the following meaning
%           0 means zero phase
%           1 means minimum phase
%           x means constant phase of x degrees
% **************** default = 0 ***************
% NOTE: If for some strange reason a constant phase of 1 degree is desired, use phase=1.01 or similar.
% stab ... stability constant used only if phase==1
% **************** default=.0001 *************
%
% w ... the wavelet
% tw ... time coordinate for the wavelet (same size as w)
% 
%
% by G.F. Margrave, 2016
%
% NOTE: This SOFTWARE may be used by any individual or corporation for any purpose
% with the exception of re-selling or re-distributing the SOFTWARE.
% By using this software, you are agreeing to the terms detailed in this software's
% Matlab source file.

% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by
% its 'AUTHOR' (identified above) and the CREWES Project.  The CREWES
% project may be contacted via email at:  crewesinfo@crewes.org
%
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) This SOFTWARE may be used by any individual or corporation for any purpose
%    with the exception of re-selling or re-distributing the SOFTWARE.
%
% 2) The AUTHOR and CREWES must be acknowledged in any resulting publications or
%    presentations
%
% 3) This SOFTWARE is provided "as is" with no warranty of any kind
%    either expressed or implied. CREWES makes no warranties or representation
%    as to its accuracy, completeness, or fitness for any purpose. CREWES
%    is under no obligation to provide support of any kind for this SOFTWARE.
%
% 4) CREWES periodically adds, changes, improves or updates this SOFTWARE without
%    notice. New versions will be made available at www.crewes.org .
%
% 5) Use this SOFTWARE at your own risk.
%
% END TERMS OF USE LICENSE
if(nargin<6)
    stab=.0001;
end
if(nargin<5)
    phase=0;
end
if(nargin<4)
    sigma=.1;
end
if(nargin<3)
    fsmo=10;%10 Hz smoother
end
s=s(:);
t=t(:);
dt=t(2)-t(1);
nsigma=round(3*sigma/dt);%number of samples in 3*sigma
nsamps=length(t);
if(nsamps<=2*nsigma)
   %if the trace is shorter than 2*nsigma, pad it
   npad=2*nsigma-nsamps+1;
   s=[s;zeros(npad,1)];
   nsamps=length(s);
   t=dt*(0:nsamps-1)';
end

inot=round(nsamps/2);%middle

df=1/(length(t)*dt);

nsmo=round(fsmo/df);

imp=impulse(s,inot);%impulse the size of s
tnot=t(inot);

tmp=bandwidth_xfer(s,imp,nsmo);%transfer the bandwidth of s to impulse


if(phase==1)
    tmpm=tomin(tmp,stab).*exp(-t.^2/4*sigma^2);
%     w=tmpm(1:2*nsigma)/max(tmpm);
    w=tmpm(1:2*nsigma);
    tw=dt*(0:length(w)-1)';
else
    tmp2=tmp.*exp(-(t-tnot).^2/sigma^2);%taper
    w=tmp2(inot-nsigma:inot+nsigma);%
%     w=w/max(w);
    tw=dt*(-nsigma:nsigma)';
    if(phase~=0)
        w=phsrot(w,phase);
    end
end
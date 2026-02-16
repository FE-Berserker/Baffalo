function phs=waveletphase(w,tw,flag)
% Estimate the constant phase of any wavelet
%
% phs=waveletphase(w,tw,flag)
%
% Method: If the wavelet is causal, it is first modified to include as much negative time as there is
% positive time. This allows samples to rotate into negative time. Then the phase is estimated by
% comparing the wavelet to a unit spike placed at time zero in s reference signal the same length as
% the wavelet. The phase estimation can be done with either of 3 methods.
%
% w ... the wavelet
% tw ... time coordinates for w (same length as w)
% flag ...  1=> use constphase (analytic solution)  
%           2=> use constphase2 (direct search)
%           3=> use constphase3 (symmetrized direct search)
% *********** default = 3 **************
%

if(nargin<3)
    flag=3;
end


% the return is the wavelet phase such that w2=phsrot(w,-phs) will be zero phase
izero=near(tw,0);
if(izero(1)==1)
    %causal so pad
    tmax=tw(end);
    tmp=tw;
    dt=tmp(2);
    tw=-tmax:dt:tmax;
    nzero=length(tw)-length(tmp);
    w=[zeros(nzero,1);w];
    izero=izero+nzero;
end
spike=impulse(w,izero)*max(abs(w));
switch flag
    case 1
        phs=constphase(spike,w);
    case 2
        phs=constphase2(spike,w);
    case 3
        phs=constphase3(spike,w);
end


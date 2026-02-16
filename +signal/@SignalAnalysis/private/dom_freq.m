function fdom=dom_freq(w,t,p)
% This is a wrapper for domfreq.  Please see that function for more details.

%DOM_FREQ ... now renamed to DOMFREQ

if(nargin<3); p=2; end
fdom=crewes.seismic.domfreq(w,t,p);
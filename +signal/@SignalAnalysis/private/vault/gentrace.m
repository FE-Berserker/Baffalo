function [gathout,tgath,gathspike]=gentrace(gath,tgath,w,tw,flag)
%
% [gathout,tgath,gathspike]=gentrace(gath,tgath,w,tw,flag)
%
% GENTRACE takes in a gather of complex rcs, one trace per
% column, and convolves a wavelet with them allowing for
% possible phase rotations from the complex rcs.
%
% gath ... gather of complex rcs. Should be in normal real & imag
%	parts not in polar form
% tgath ... time coordinates of gather
% w ... wavelet
% tw ... time coordinates of wavelet
% flag ... 0 means the synthtic trace length will be length(gath)
%		+length(w)-1 as is computed from convolution.
%          1 means that the synthetic trace length will be truncated
%		to equal the length(gath). Truncation is done appropriately
%		for the type of wavelet.
% *************** default = 1 ***********
% gathout ... output gather
% tgath ... output of traveltimes for gather
% gathspike ... if programmed, then this is an version of the gather with a
% spike wavelet.  The spike wavelet is all zeros except for the time-zero
% sample which is 1.0.
%
% Note (tgath(2)-tgath(1))/(tw(2)-tw(1)) should be a positive
% integer. If not, temporal inaccuracies will occur in the output
% gather. (i.e. it will be erroneous)
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

if (nargin<5) flag=1; end
[ntg,nx]=size(gath);
ntw=length(tw);
dtg=tgath(2)-tgath(1);
dt=abs(tw(2)-tw(1));

small=10000*eps;
if( (abs(dtg-dt)> small) )
	%resample the gather
	itg2tw= round( (tgath-tgath(1))/dt )+1;
	ntg= round((ntg-1)*dtg/dt)+1;
	if( rem(ntg,2)~=0 )
	   ntg=ntg+1;
	end
	gathout=zeros(ntg,nx);
	gathout(itg2tw,:)=gath;
else
	gathout=gath;
end
nzero=near(tw,0.0);
if(abs(tw(nzero))>1.e07*eps)
	disp(' WARNING: Wavelet has no sample at zero time');
end
if(nargout==3)
    gathspike=gathout;
    wspike=zeros(size(w));
    wspike(nzero)=1;
end

if(flag)
	nt=ntg;
	ishift=0;
else
	nt=ntg+ntw-1;
	%ishift=floor(ntw/2);
	ishift=nzero-1;
end

%convert gath to polar form
gath = abs(gathout) + i*angle(gathout);



for k=1:nx
	tmp= convcmplx(gath(:,k),w,nzero,flag);
	if(k==1) 
        gathout=zeros(length(tmp),nx);
        if(nargout==3)
            gathspike=gathout;
        end
    end
	gathout(:,k)=tmp;
    if(nargout==3)
        gathspike(:,k)=convcmplx(gath(:,k),wspike,nzero,flag);
    end
end

tgat = xcoord(tgath(1)-dt*ishift,dt,length(tmp));

tgath=tgat'; gathout=real(gathout);
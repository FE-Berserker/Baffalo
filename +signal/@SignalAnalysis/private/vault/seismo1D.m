function [s,t,rcs,pm,p]=seismo1D(sonic,rho,z,w,tw,vsurf,fmult,fpress,tmax)
% SEISMO1D computes a 1D normal incidence p-wave reflection seismogram with or without multiples.
%
% [s,t,rcs,pm,p]=seismo1D(sonic,rho,z,w,tw,vsurf,fmult,fpress,tmax)
%
% METHOD: The input logs are resampled (or blocked) to have constant 2-way time-thickness layers. The
% time-thickness is equal to the sample rate of the wavelet. This is done because it allows the
% traveltimes of the multiples to be easily computed from the number of bounces. Then the impedance
% of the resampled logs is computed and from that the reflectivity. If no multiples are desired,
% then the seismogram is simply obtained by convolving the reflectivity with the wavelet. If
% multiples are desired, then the reflectivity is run through the Goupillaud scattering algorithm. 
% Either a pressure or a displacement seismogram can be computed with the former being the choice
% for marine and the latter for land. If R is a reflection coefficient and Wi the incident wave on a
% reflector and Wr the reflected wave, then for pressure Wr=R*Wi while for displacement Wr=-R*Wi.
% Note that this assums R to be defined by R=(I2-I1)/(I2+I1) where I1 is the incident medium and I2
% the the transmitted medium. When multiples are computed, they can be isolated by the subtraction
% pm-p but you will probably want to apply the wavelet for most purposes. Note that when fmult=1, 
% the primaries are computed with transmission losses while for fmult=0, the primaries are identical
% to the rcs for a pressure seismogram and are the negative of the rcs for a displacement seismogram.
% The algorithm will show scattering Q (the O'Doherty-Anstey effect) when fmult=1 but the degree of 
% Q effect will increase with decreasing wavelet sample rate due to the time-thickness blocking.
%
% To make a synthetic not based on a real well log, you must craft artificial logs. To do this, 
% choose a depth sample size that is about ten times smaller than .5*dt*vintmin where dt is the desired 
% time sample size and vintmin is the minimum interval velocity. Compute the sonic values from the 
% formula sonic = 10^6 ./vint . Density values can have arbitrary units.
%
% sonic ... p-wave sonic log.
%           Note that inteval velocity is computed from the sonic by 10^6 ./sonic and this works
%           regardless of the units of the sonic.
% rho  ... density log. The seismogram is not sensitive to units of density since they cancel when 
%           computing reflection coefficients.
% z ... depth coordinate for the logs.
% NOTE: the first three arguments must all be the same length. There must be no NULL values in the
%   logs but the depths need not be regularly space although they must always be increasing. The
%   depth sample size should always be much smaller than .5*dt*vint where dt is the wavelet sample
%   rate and vint is the slowest interval velocity impled by the sonic.
% NOTE: logs must be defined with valid physical values at all depths. No NULLS.
% w ... wavelet. The wavelet is only applied to the first output (not to rcs, pm, and p).
% tw ... time coordinate for the wavelet. The time sample rate of the wavelet (tw(2)-tw(1))
%       determines both the log blocking and the time sample rate of the outputs.
% vsurf ... p-wave velocity at the earth's surface. The overburden velocity will then be described 
%           as a linear gradient from the surface value to the average value (over ten samples) at
%           the log top. To craft your own overburden, just define your logs to zero depth. Use NAN
%           to get the default. The seismogram always starts at t=0 while the first reflectivity
%           occurs at the start depth of the log. The time of the first reflectivity is determined
%           by your overburden model. Choosing the default will usually mean your reflectivity
%           starts too early because the surface velocity is generally much slower that the first
%           logged velocity. A good choice for vsurf is 6000 ft/sec or 1800 m/sec (the speed of
%           sound in consolidated soil). Your overburden will then have a traveltime defined by the
%           described linear gradient. Suppose z1 is the first logged depth and v1 is the average
%           velocity at the top of the log. Then the time to the first reflectivty is
%           2*Z1*ln(v1/v0)/(v1-v0) where ln is natural log. If you want your reflectivity to start
%           at time zero, then shift the log depths to start at zero.
% ************ default = average at log top so the overburden is constant velocity ************
% fmult ... multiple flag. 
%            0 -> produce a primaries only convolutional seismogram
%            1 -> produce a primaries (with attenuation losses) plus multiples seismogram
%           Users should be aware that the computed multiple content is highly
%           sensitive to this time-blocking of the logs. This is not so true of the primaries. The
%           time blocking is determined by the time sample rate of the wavlet. Therefore running a
%           series of tests with ever smaller wavelet sample rate will show this effect. If very
%           accurate multiples are desired, choose a wavelet sample rate ten times smaller than
%           needed and resample afterwards. Note also that the multiple train is terminated by tmax.
%           Making tmax larger always shows more multiples.
% ************ default fmult=0 ************
% fpress ... flag for a pressure or displacement seismogram.
%            1 -> a pressure seismogram is desired
%            0 -> a displacement seismogram is desired
%           For a pressure seismogram, the source is a unit compression. For a displacement
%           seismogram, the source is a unit displacement in the positive z (down) direction.
% ************ default fpress = 0 ************ 
% tmax ... maximum time for the ouput seismogram. When fmult=1, then choosing tmax larger shows more
%          multiples. When fmult=0, a larger tmax just gives a larger zero pad.
% ********** default: time length of sonic + time overburden + length of wavelet ********
% 
% s ... final seismogram, includes zero pads for overburden and for tmax
% t ... time coordinate for s (and rcs, pm, and p)
% rcs ... normal incidence rcs, same length as s.
% NOTE: It is possible to see the effects of the constant time-thickness blocking from the rcs. 
%   To do this, Let dt=tw(2)-tw(1) and then:
%   v=10^6 ./sonic;%velocity from the sonic
%   imp=v.*rho; %impedance from logs
%   tz(2:length(impz))=2*cumsum(diff(z)./v(1:end-1));%traveltime coordinate from logs
%   imp0=mean(imp(1:50));%local average of impedance at log top
%   ind=find(rcs~=0);%find where rcs are non zero to indicate log top
%   impt=rcs2imp1(rcs(ind(1):end),imp0);%convert rcs to time, note the use of imp0. 
%                                       %rcs2imp1 is in the CREWES inversion tools
%   ti=dt*(0:length(impt)-1)+dt/2;%time coordinate for impt. Note this may be off by a half-sample
%   figure;plot(tz,imp,ti,impt)
%   title('impedance comparison (integrated RCS versus log)')
%   legend('exact (log)',['new seismo I_0= ' num2str(imp0,5)])
%   prepfig
% pm ... attenuated primaries plus multiples, same length as s. If fmult == 0, this is identical to rcs.
% p ... attenuated primary rcs, same length as s. If fmult==0, this is identical to rcs. If fmult==1,
%       then the multiple content can be obtained as: pm-p . The primaries are called "attenuated"
%       because they have transmission losses applied. Transmission losses are not applied when
%       fmult=0.
%
%
% G.F. Margrave, CREWES
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

sz=size(sonic);
if(size(rho)~=sz)
    error('sonic and density logs nmust be the same size');
end
if(size(z)~=sz)
    error('depth coordinate does not match sonic')
end

szw=size(w);
if(size(tw)~=szw)
    error('wavelet does not match its time coordinate');
end

%find zero time of wavelet
izero=find(tw==0);
if(isempty(izero))
    error('Wavelet does not contain zero time sample');
end

%check logs for null values
ind=find(isnan(sonic), 1);
if(~isempty(ind))
    error('Sonic log contains NULL values');
end
ind=find(isnan(rho), 1);
if(~isempty(ind))
    error('Density log contains NULL values');
end
ind=find(sonic==-999.25, 1);
if(~isempty(ind))
    error('Sonic log contains NULL values');
end
ind=find(rho==-999.25, 1);
if(~isempty(ind))
    error('Density log contains NULL values');
end

sonic=sonic(:); %force column vector
rho=rho(:); %force column vector
z=z(:); %force column vector

if(nargin<6)
    vsurf=nan;
end

if(nargin<7)
    fmult=0;
end

if(nargin<8)
    fpress=0;
end

if(nargin<9)
    tmax=nan;
end

if(fmult~=0 && fmult ~= 1)
    error('invalid multiple flag')
end

if(fpress~=0 && fpress ~= 1)
    error('invalid multiple flag')
end

%compute vintz (interval velocity in depth)
vintz=10^6 ./sonic;

%dz=z(2)-z(1);
dt=tw(2)-tw(1);
%determine time shift through overburden
if(z(1)>0)
    iave=10;
    vtop=mean(vintz(1:iave));%value at log top
    if(isnan(vsurf))
        vsurf=vtop;
    end
    c=(vtop-vsurf)/z(1);%velocity gradient
    if(c~=0)
        tnot=2*log(1+c*z(1)/vsurf)/c;
    else
        tnot=2*z(1)/vsurf;
    end
else
    tnot=0;
end
%round tnot to an even number of samples so that seismogram samples will fall on correct time grid
tnot=round(tnot/dt)*dt;

%compute time function for all depths
% compute a dz vector
nz=length(z);
dzvec=diff(z);

% integrate
tz=zeros(size(z));
tz(2:nz)=2*cumsum(dzvec./vintz(1:nz-1));
%tz is now two way traveltime from top of log to any depth

%block logs into constant traveltime layers
nt=round((tz(end)-tz(1))/dt)+1;
vintt=zeros(nt,1);
rhot=vintt;
j=1;%counts depth samples
trcs=dt*(0:nt-1)';
tnow=trcs(1);
for k=1:nt
    tnext=tnow+dt;
    %find the first time greater than or equal to tnext
    j1=j;
    while tz(j)<tnext && j<nz
        j=j+1;
    end
    if(j==j1)
        break;
    end
    % so the layer extends approximately from j1 to j
    vintt(k)=mean(vintz(j1:j));
    rhot(k)=mean(rho(j1:j));
    tnow=tnext;
end
%check for missing final sample
if(vintt(end)==0)
    vintt(end)=vintt(end-1);
    rhot(end)=rhot(end-1);
end
%compute impedance and rcs in time
imp=vintt.*rhot;
i1=1:nt-1;
i2=2:nt;
rcs=zeros(nt,1);
rcs(2:nt)=(imp(i2)-imp(i1))./(imp(i2)+imp(i1));
%pad rcs to tmax
if(isnan(tmax))
    tmax=tnot+trcs(end)+dt*(length(w)-1);
end
nt2=round(tmax/dt)+1;
t=dt*(0:nt2-1)';%output time coordinate
inot=round(tnot/dt)+1;%time of first live RC
tmaxrc=tnot+trcs(end);%time of last live RC
tpad=tmax-tmaxrc;%size of zero pad needed at end
ntpad=round(tpad/dt);%number of zero samples to pad on end
rcspad=[rcs;zeros(ntpad,1)];
%now compute multiples if requested
if(fmult)
    [pma,pa]=goup(rcspad,fpress);
else
    
    if(fpress)
        pma=rcspad;
        pa=rcspad;
    else
        pma=-rcspad;
        pa=-rcspad;
    end
    
end
%attach zeros for the overburden
rcs=[zeros(inot-1,1);rcspad];
pm=[zeros(inot-1,1);pma];
p=[zeros(inot-1,1);pa];
%convolve
tmp=conv(pm,w);
s=tmp(izero:length(pm)+izero-1);

end

function [pm,p]=goup(rin,fpress)
% [pm,p]=goup(r)
%
% GOUP computes the multiple contamination in a 1-D p-wave
% seismogram according to the Goupillaud algorithm as described in
%	Waters, "Reflection Seismology", 1981, John Wiley, pp 128-135
%
% r ... input reflection coeficients, regularly sampled in TIME
%			(2-way time)
% fpress ... flag for a pressure or displacement seismogram
%            1 -> a pressure seismogram is desired
%            0 -> a displacement seismogram is desired
%          this makes no difference if fmult=0
%      ******* default = 1 ******
% pm ... output 1-D impulse response, primaries plus multiples,
%	sampled at the same times as r.
% p ... primaries only showing the effects of transmission losses
%
% G.F. Margrave, CREWES, Oct 1995
%
% NOTE: This SOFTWARE may be used by any individual or corporation for any purpose
% with the exception of re-selling or re-distributing the SOFTWARE.
% By using this software, you are agreeing to the terms detailed in this software's
% Matlab source file.

if(nargin<2)
    fpress=1;
end
if(fpress==0)
    fpress=2;%the code needs a 1 or 2 but the user interface is a 0 or 1.
end

%initialize a few things
r=rin(2:length(rin));
r0=rin(1);
d=zeros(size(rin));
d(1)=1;
pm=zeros(size(r));
p=zeros(size(r));

%loop over output times

factor = 1-2*(fpress-1);
% fpress=1 -> factor =1
% fpress=2 -> factor = -1;
for k=1:length(r)
    
    %zero upgoing wave at each step
    u=0.0;%upgoing primaries plus multiples
    up=0.0;%upgoing, primaries only wave
    
    %step from r(k) to the surface
    for j=k:-1:1
        
        %update downgoing wave
        d(j+1)=(1-r(j))*d(j) -factor*r(j)*u; %JKC 14feb/08
        
        %update upgoing wave
        u=factor*r(j)*d(j) + (1+r(j))*u; %JKC 14feb/08
        if( j==k )
            up = u;
        else
            up = (1+r(j))*up; %JKC 14feb/08
        end
        
    end
    
    %step to surface
    d(1)= -factor*r0*u;
    pm(k)=u+d(1);
    p(k)=up;
    
    
end

%include surface rc in final result
pm = [factor*r0;pm]; 
p = [factor*r0;p]; 
end


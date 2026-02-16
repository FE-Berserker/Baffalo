function [uw, u, cangles, coffs, logmat]=seismogather(vp,vs,rho,z,vp0,vs0,rho0,xoffs,w,tw,...
    angles,zshot,zrec,zwater,vwater,ghostflags,ozrat,xcap,itermax,mindepth,maxdepth,receiver,reftype,dtlog,...
    loginttime, sflag,pflag,polarity,nmoflag,trloss,sphdiv,response,...
    clevels,cflag,raymsg,gatherflag,Q)%37 input args
% SEISMOGATHER: Construct a PP or PS offset gather with possible ghosts
%
% [uw, u, cangles, coffs, logmat]=seismogather(vp,vs,rho,z,vp0,vs0,rho0,xoffs,w,tw,...
%     angles,zshot,zrec,zwater,vwater,ghostflags,ozrat,xcap,itermax,mindepth,maxdepth,receiver,reftype,dtlog,...
%     loginttime, sflag,pflag,polarity,nmoflag,trloss,sphdiv,response,...
%     clevels,cflag,raymsg,gatherflag,Q)
%
% SEISMOGATHER creates a PP or a PSv reflection gather by raytracing the primary arrivals through
% constant time-thicknesss blocked logs and evaluating the zoeppritz equations for each reflection.
% The zoeppritz equations apply strictly only for plane waves and this approximation becomes
% seriously inaccurate near or beyond the critcal angle. Therefore, if critical angle effects are
% observed, it is recommended to adjust ozrat to exclude them. Both offset and angle gathers are
% supported. Any number of offset/angle traces are computed and the source and receiver can be at
% different non-zero depths. The free surface effect or the ocean bottom effect are applied if
% appropriate. Both geophones and hydrophones can be simulated. An overburden model is automatically
% constructed. The output gather can be one of 3 types: nmo not removed, nmo removed, or pseudo
% zero-offset. NMO removal is done by reytracing and is not approximate. Pseudo zero-offset means
% that the reflection coefficients are mapped directly to zero-offset time. It differs from "nmo
% removed" by not having any moveout stretch. (For angle gathers only pseudo zero-offset is
% supported.) For geophone simulation, both vertical and horizontal components are automatically
% computed. A VSP option is contemplated but not currently functional.
%
% Ghost responses, if requested, are computed as separate gathers and there are 3 possibilities: 
% (1) source ghost (2) receiver ghost (3) source ghost with receiver ghost. To simulate a real
% record contianing ghosts the separate ghost responses should be summed together with the primary
% (un-ghosted) response.
%
% NOT IMPLEMENTED (but possible):  
%                   water layer multiples
%                   variable receiver depth for hydrophone cable
%                   
% NOTE: All input parameters must be provided.
% NOTE: The defaults for any defaultable parameters are be triggered by providing the parameter as
%   either nan or empty. That is the logical test used is: isnan(x)||isempty(x) for parameter x.
%   When this evaluates to true, the default is prescribed.
% NOTE: The first 10 parameters have no defaults and the user must prescribe sensible values.
%
% vp ... column vector of p-wave interval velocities in depth
% vs ... column vector of s-wave interval velocities in depth
% rho ... column vector of densities in depth
% z ... column vector of depths to match vp,vs, and rho. Need not be regular.
% vp0 .. scalar value giving vp at z=0
% vs0 ... scalar value giving vs at z=0
% rho0 ... scalar value giving rho at z=0
% NOTE: If an overburden has been applied external to this function then the first value of z 
%       should be 0 and in this case the values of the previous 3 parameters are ignored. If z(1)
%       is not equal to 0, then this function will automatically create and attach a linear gradient
%       overburden and the previous 3 parameters are essential to describe the first value of that
%       overburden. The gradient is then determined by computing the average of the first 100
%       samples at the top of each log. The overburden is then a linear function that begins at the
%       surface values and extends to the averages determined at the log tops.
% xoffs ... row vector of offsets (need not be regularly sampled)
% w ... vector describing the wavelet.
% tw ... the wavelet time coordinates.
% angles ... null or empty gives a normal offset seismogram. To get an angle seismgram, this must 
%           be a vector of angles at which angle traces are desired.  Note, if angles is not
%           defaulted, then xoffs is ignored.
% ***************** default =[] *****************
% zshot ... depth of shot (scalar)
%   *************** default =0 ***************
% zrec ... depth of receivers. If a scalar, then we are doing cmp geometry,
%           if a vector, we are doing vsp.
%   *************** default =0 ***************
% zwater ... depth of water. Must be less than or equal to the first value of z. if zwater>0, then a 
%           water layer will be automatically constructed with vs=0 and vp=1500m/s or 4900 ft/sec.
%           In this case, the values of vp0, vs0, rho0 are assumed to apply at the water bottom.
%   *************** default = 0 **************
% vwater ... speed of sound in water
% ************** default = 1500 m/sec or 4900 ft/sec *************
% ghostflags ... [source_ghost,receiver_ghost,combined s-r_ghost]
% ************** default = [1,1,1] *************
% NOTE: ghosts are only generated for non-zero source and receiver depths regardless of the value of
%       these flags.
% NOTE: for ghostflag=3, four total trace gathers are created. These are (1) the unghosted result, 
%   (2) the source ghost response, (3) the receiver ghost response, and (4) the source ghost with 
%   also the reciever ghost. These are all separate responses and need to be summed together to get
%   complete results.
% ozrat ... maximum offset/depth ratio. For depth z, offsets greater than
%           ozmax*z will not be modelled. This is a kind of mute and can suppress
%           critical angle effects
%   *************** default =1.5 *****************
% xcap ... raytace capture radius. Only matters for offset gathers.
%   *************** default = .1*min(diff(xoff)) **************
% itermax ... maximum number of raytrace iterations. 4 is reasonable
%  *************** default = 4 *****************
% mindepth ... minimum depth at which to begin reflectivity calculations. Normally this should be 
%           the first logged depth. If an overburden has been attached external to this program then
%           the z(1) will be 0 and this parameter should be programmed to prevent needless
%           calculation of reflectivity in the overburden.
%   ************** default = z(1) ***************
% maxdepth ... depth at which reflectivity calculations end
%   ************** default = z(end) ***************
% receiver ... 1 for hydrophone
%              2 for geophone
% *************** default = 2 **************
% reftype ... 1 gives a PP gather
%        ... 2 gives a PS gather
% ************ default = 1 **********
% NOTE: When PS is selected with hydrophone, the rays are traced as P from source to reflector,
%   then S up to water bottom, and P to hydrophone.
% dtlog ... time sample interval which controls log averaging
%  ********* default = tw(2)-tw(1) ********
% loginttime ... if 1 the dtlog refers to PS time, if 0 it is PP time.
%          Because tps>tpp for any depth, then if the time blocking size is dtlog, there will be
%          more blocked intervals in ps time than pp for any depth. This means that pp blocking
%          averages out more detail than ps. However, in both cases retained detail should be more
%          than sufficient to model reflectivity at for frequencies below half-Nyquist. This control
%          is provided so that pp and ps gathers can be computed from the same reflectivity. A major
%          virtue of this blocking is that the raytracing is stabilized by suppressing high velocity
%          streaks and fewer critical angles are computed.
% ********** default = 0 (PP time) ************
% sflag ... if 0, then the output seismogram will have a time length
%		equal to the length(rcs)+length(w)-1 as convolution delivers
%           if 1, the the output seismogram will be truncated after
%		convolution to have the same length as the rcs. (Truncation
%		is done with consideration of the phase of the wavelet.)
%  ********* default = 1 ***********
% pflag ... if nonzero, then print progress information
%  ********* default = 1 ***********
% polarity ... only affects PSv section. If 1, then Aki&Richards
%   polarity convention is used which is opposite to the PP section.
%   if -1, then polarity is flipped to agree with PP
%  *************** default = -1 ************
% nmoflag ... 0 for nmo included in the gather
% 	  ... 1 for a pseudo-zero offset gather
% 	  ... 2 for nmo to be removed in the gather
% **************** default = 2 *************
% NOTE: Moveout correction for any of the ghost gathers is always done with the traveltimes for the
%   primaries. Therefore the ghost gathers will not be perfectly flattened. 
% trloss ... 0 for no transmission losses
%	 ... 1 to include transmission losses
% **************** default = 0 *************
% sphdiv ... 0 for no spherical divergence
%	 ... 1 for spherical divergence effects
% **************** default = 0 *************
% response ... 0 do not include the free surface or OB effect
%               ... 1 do include the free surface effect or the oocean bottom effect (geophone only)
% **************** default = 1 ***************
% clevels ... contour levels for angles, set to -1 to turn off contouring
% **************** default is levels chosen automatically *************
% cflag ... 0 means don't contour, 1 means contour in true time, 2 means contour
%             in zero offset time
% **************** default = 0 **********************
% raymsg ... 0 means don't print messages about failed rays, 1=print them
% **************** default = 0 **********************
% gatherflag ... 0 offset, 1 vsp, 2 angle
% ***************** default =0 ******************
% Q ... scalar giving the value of Q to apply to the gather after it is created. This is a reasonable 
%       approximation if Q is not spatially variant. Enter nan or [] for no Q applied
% ***************** default = infinity (meaning no attenuation) *********************
% NOTE: Q is applied by first generating the completely elastic response and then applying a Q
%       matrix to each trace (see function qmatrix). This is a very good approximation to Q effects 
%       (both amplitude and phase). If the wavelet was minimum phase then the result will be 
%       nonstationary minimum phase just like real data. The application of Q takes much longer than 
%       the computation of the elastic traces. 
%
% uw ...  The output with wavelet applied. uw is a structure with all relevant information as listed below: 
%       uw.x = For geophones the is the horizontal component with wavelet applied. For hydrophones 
%               this is the pressure. It is a 3D array of size nt,nx,4 where nt is number of time
%               samples, nx is number of offsets
%               uw.x(:,:,1) = primary gather (no ghosts)
%               uw.x(:,:,2) = source ghost gather
%               uw.x(:,:,3) = receiver ghost gather
%               uw.x(:,:,4) = source ghost with receiver ghost gather
%       uw.z = Similar to uw.x but the vertical component for geophones. This is zero for hydrophones.
%       uw.time = time coordinate of the gather. It is a vector of length nt.
%       uw.offset = offsets of the gather. For angle gathers ignore this.
%       uw.angles = angles of the gather. For offset gathers ignore this.
% u ...  similar to uw except there is not wavelet convolved. This is the impulse response.
% cangles ... contour matrix of incidence angles for the primaries. See CONTOURC for a description.
% coffs ... contour matrix of offsets for the primaries. See CONTOURC for a description.
% NOTE: either cangles will be NULL or coffs will be. They cannot both have
%       values simultaneously.
% logmat ... matrix of the resampled logs. These are computed from the original logs
%               to have layers of equal traveltime 'thickness'.
%               Columns are depth, vp, vs, and rho.
%
%	NOTE: The raytracing used here will return NaN for rays which
%	reach or excede a critical angle or are otherwise uncaptured.
%	If a wavelet is applied, then these NaN's are converted to zeros
%	prior to convolution. Otherwise, they are still present in
%	the gathers.
% 
% G.F. Margrave, Margrave-Geo, 2020-2021
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
nargs=37;
if(nargin<nargs)
    error(['All ' int2str(nargs) ' inputs must be prescribed. Use nan or [] to get defaults ']);
end

if(gatherflag==0 && isempty(xoffs))
    error('xoffs cannot be empty if gatherflag==0');
end
if(gatherflag==2 && isempty(angles))
    error('angles cannot be empty if gatherflag==2');
end
if(gatherflag==1)
    error('vsp not ready yet');
end

if(usedefault(zwater))
    zwater=0;
end
if(usedefault(zrec))
    zrec=0;
end
if(usedefault(receiver))
    receiver=2;
end

%sanity check for hydrophone
if(receiver==1)
    if(zwater==0)
        error('hydrophone receiver requires zwater>0 to indicate a water layer');
    end
    if(zwater<zrec)
        error('hydrophone receiver depth not in the water layer'); 
    end
end

if(zwater>z(1))
   error('zwater cannot exceed z(1)'); 
end



% 1) determine overburden
% 2) determine time blocking of logs
% 3) determine receiver type and component
% 4) raytrace through logs, pp or ps
% 6) evaluate reflection coefficients for each arrival
% 7) regularize in time
% 8) apply free surface or ocean bottom effect
% 9) spply wavelet
% 10) contour incidence angles

%define overburden

%check rho0 for consistency
rhomean=mean(rho);
if(~between(rhomean/10,rhomean*10,rho0))
    error('rhotop appears to be in different units that the density log')
end

%gradient in overburden
nave=100;%number of samples at top of log to average
%compute average values at logtop
vptop=mean(vp(1:nave));
vstop=mean(vs(1:nave));
rhotop=mean(rho(1:nave));
%extend depth axis to zero
dz=z(2)-z(1);
zmin=z(1);
zmax=max(z);
nzmax=round(zmax/dz)+1;
z2=(0:nzmax-1)*dz;
%define extended logs (i.e. attach the overburden)
nz=length(z);
if(zwater==0)
    %land case
    if(z(1)~=0)%if first depth is zero then overburden is not needed
        %vp overburden
        vp2=zeros(size(z2));
        vp2(nzmax-nz+1:nzmax)=vp;
        vp2(1:nzmax-nz)=vp0+(vptop-vp0)*(z2(1:nzmax-nz)/z2(nzmax-nz));
        %vs overburden
        vs2=zeros(size(z2));
        vs2(nzmax-nz+1:nzmax)=vs;
        vs2(1:nzmax-nz)=vs0+(vstop-vs0)*(z2(1:nzmax-nz)/z2(nzmax-nz));
        %rho overburden
        rho2=zeros(size(z2));
        rho2(nzmax-nz+1:nzmax)=rho;
        rho2(1:nzmax-nz)=rho0+(rhotop-rho0)*(z2(1:nzmax-nz)/z2(nzmax-nz));
    else
        vp2=vp;
        z2=z;
        vs2=vs;
        rho2=rho;
    end
else
    %marine case
    if(usedefault(vwater))
        if(max(vp)<7000)
            vwater=1500;
        else
            vwater=4900;
        end
    end
    if(rho0>100)
        rhowater=1000;
    else
        rhowater=1;
    end
    iwater=find(z2<=zwater);
    %vp overburden
    vp2=zeros(size(z2));
    vp2(nzmax-nz+1:nzmax)=vp;
    vp2(iwater)=vwater;
    ii=iwater(end):nzmax-nz;
    vp2(ii)=vp0+(vptop-vp0)*(z2(ii)/z2(nzmax-nz));
    %vs overburden
    vs2=zeros(size(z2));
    vs2(nzmax-nz+1:nzmax)=vs;
    vs2(ii)=vs0+(vstop-vs0)*(z2(ii)/z2(nzmax-nz));
    %rho overburden
    rho2=zeros(size(z2));
    rho2(nzmax-nz+1:nzmax)=rho;
    rho2(iwater)=rhowater;
    rho2(ii)=rho0+(rhotop-rho0)*(z2(ii)/z2(nzmax-nz));
end

%check for geophone in the water
if(receiver==2 && zwater>0)
    if(zrec<zwater)
        error('you cannot have a geophone in the water layer');
    end
end
%check for hydrophone on the surface
if(receiver==1 && zrec==0)
    error('you cannot have a hydrophone on the water surface');
end
%check for hydrophone below the water layer
if(receiver==1 && zrec>zwater)
    error('you cannot have a hydrophone below the water layer');
end

%constant time blocking
if(usedefault(dtlog))
    dtlog=tw(2)-tw(1);
end
if(usedefault(loginttime))
    loginttime=0;
end
dzvec=diff(z2);
nz2=length(z2);
if(loginttime==0)
    %compute pp time curve
    tint=2*cumsum(dzvec./vp2(1:nz2-1));
else
    %compute ps time curve
    tint=cumsum(dzvec./vp2(1:nz2-1)+dzvec./vs2(1:nz2-1));
end

nt=round(tint(end)/dtlog)+1;%number of time samples needed
vp=zeros(nt,1);
vs=vp;
rho=vp;
z=vp;
t1=0;
for k=1:nt
    t2=t1+dtlog;
    ind=near(tint,t1,t2);
    vp(k)=mean(vp2(ind));
    vs(k)=mean(vs2(ind));
    rho(k)=mean(rho2(ind));
    z(k)=z2(ind(1));%use the first depth of each interval.
    t1=t2;
end

% so now the original logs with overburden attached are in vp2,vs2,rho2,z2 while the time-blocked
% logs are vp,vs,rho,z
if(usedefault(gatherflag))
    gatherflag=0;
end


%the initial gathers are not specialized to the receiver type. This is done later.
if(usedefault(angles))
    angles=[];
end
noffs=length(xoffs);%number of offsets or angles
nangles=length(angles);
if(gatherflag==0)
    %offset gather
    angletraces=false;%flag
    ntraces=noffs;
elseif(gatherflag==1)
    %vsp
    %     angletraces=0;
    %     ntraces=length(zrec);
    error('VSP not yet implemented');
elseif(gatherflag==2)
    %angle gather
    angletraces=true;%flag
    ntraces=nangles;
else
    error('invalid gather flag in seismogather')
end

if(usedefault(mindepth))
    mindepth=zmin;
end
if(usedefault(maxdepth))
    maxdepth=zmax;
end

ilivelayer=near(z,mindepth);
iendlayer=near(z,maxdepth);

%determine reflection type
%reftype=1 is pp, reftype=2 is ps. Nothing else is supported
if(usedefault(reftype))
    reftype=1;
end
if( reftype ==1 )
    incwave = 1;
    refwave=1;
else
    incwave=1;
    refwave=2;
end

if(usedefault(ozrat))
    ozrat=1.5;
end

if(usedefault(sphdiv))
    sphdiv=false;
end

if(usedefault(zshot))
    zshot=0;
end



if(usedefault(itermax))
    itermax=4;
end

if(usedefault(raymsg))
    raymsg=0;
end

if(usedefault(sflag))
    sflag=0;
end

if(usedefault(pflag))
    pflag=1;
end

if(usedefault(polarity))
    polarity=-1;
end

if(usedefault(nmoflag))
    nmoflag=2;
end

if(usedefault(trloss))
    trloss=0;
end

if(usedefault(response))
    response=1;
end

if(usedefault(xcap))
    if(length(xoffs)>1)
        xcap=.1*min(diff(xoffs));
    else
        xcap=10;
    end
end
%
% now comes the major computational loop over reflecting depth level. For each level we must:
% 1) trace rays from source to reflector and back to receiver (at each offset)
% 2) evaluate zoeppritz equations at the reflecting depth to determine the reflection response
% 3) the result is a matrix (called gather) with one row per depth level (and one column per offset)
%   containing the RC's and corresponding matrices containing the traveltimes and the ray parameters.
% 4) After this loop are steps to construct regularly sampled traces from these matrices
%
% The code calculates 3 ghost results. Essentially, these will be separate matrices containing the
% reflections and traveltimes for the ghost signals. The resulting ghost traces can then be combined
% with (added to) the ghost-free result as desired.
%
% If the gather is NMO corrected, the nmo removal for the ghost gathers will be done with the
% traveltimes for the primary gather.
%
% NOTE: ghosts will not be computed for anglegathers
%
nreflections=iendlayer-ilivelayer+1;%total number of reflections
if(angletraces)
    ngathers=1;%no ghosts for angle gathers
else
    ngathers=4;%number of separate responses to compute (primaries and ghosts)
end

tbegin=clock;

for jgath=1:ngathers
    if(jgath==1)
        calculate=true;
    else
        calculate=logical(ghostflags(jgath-1));
    end
    if(calculate)
        gather= zeros(nreflections,ntraces);%holds the zoeppritz RCs
        pgath = gather;%holds the ray parameters
        tgath2= gather;%holds the traveltimes to each reflection. These are irregularly spaced in time at each offset.
        offgath=gather;%Used for angle gathers, contains the offsets for each angle and allows contouring them.
        for k=ilivelayer:iendlayer
            if(~angletraces)
                ioffuse=find(xoffs<=ozrat*z(k));
                if(isempty(ioffuse)); ioffuse=1; end
                switch jgath
                    case 1 %primary rays
                        if(reftype==2)%PS reflections
                            if(receiver==2)%geohones
                                %trace the psv rays
                                raycode=[zshot,1;z(k),2;zrec,1];
                                if(~sphdiv) %the reason for the if statement is to save computation time
                                    %because usually spherical spreading is not wanted.
                                    [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),...
                                        xcap,-1,itermax,1,raymsg);
                                    Ltmp=ones(size(pfantmp));
                                else
                                    [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),...
                                        xcap,-1,itermax,1,raymsg);
                                end
                            else %hydrophone
                                %for hydrophone, we trace p to reflector, s up to water bottom, p to hydro
                                raycode=[zshot,1;z(k),2;zwater,1;zrec,1];
                                %trace the psv rays
                                if(~sphdiv) %the reason for the if statement is to save computation time
                                    %because usually spherical spreading is not wanted.
                                    [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),...
                                        xcap,-1,itermax,1,raymsg);
                                    Ltmp=ones(size(pfantmp));
                                else
                                    [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,...
                                        xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                                end
                            end
                            
                        elseif(reftype==1)%PP reflections
                            %trace PP rays
                            raycode=[zshot,1;z(k),1;zrec,1];
                            if(~sphdiv)
                                [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),...
                                        xcap,-1,itermax,1,raymsg);
                                %                 if(k==433)
                                %                     disp('here');
                                %                 end
                                %xoffs(ioffuse),xcap,pfan,itermax,1,raymsg);
                                Ltmp=ones(size(pfantmp));
                            else
                                [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),...
                                        xcap,-1,itermax,1,raymsg);
                            end
                        end
                    case 2 %source ghost
                        if(reftype==2)%PS reflections
                            if(zwater>0)
                                %pwave up to ocean surface; pwave down to reflector; shear wave
                                %up to water bottom;pwave to hydrophone/geophone.
                                raycode=[zshot,1;0,1;z(k),2;zwater,1;zrec,1];
                            else
                                %pwave up to free surface; pwave down to reflector; shear wave
                                %up to receiver
                                raycode=[zshot,1;0,1;z(k),2;zrec,2];
                            end
                            %trace the psv rays
                            if(~sphdiv)
                                [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                                Ltmp=ones(size(pfantmp));
                            else
                                [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                            end
                        elseif(reftype==1)%PP reflections
                            %trace PP rays
                            %pwave to free surface;pwave down to reflector;pwave up to receiver
                            raycode=[zshot,1;0,1;z(k),1;zrec,1];
                            if(~sphdiv)
                                [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                                Ltmp=ones(size(pfantmp));
                            else
                                [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                            end
                        end
                    case 3 %receiver ghost
                        if(reftype==2)%PS reflections
                            if(zwater>0) %marine case
                                %pwave down to reflector, swave up to water bottom, pwave
                                %to ocean surface, pwave down to receiver
                                raycode=[zshot,1;z(k),2;zwater,1;0,1,zrec,1];
                            else %land case
                                %pwave down to reflector, swave up to free surface, swave
                                %down to receiver
                                raycode=[zshot,1;z(k),2;0,2,zrec,2];
                            end
                            %trace the psv rays
                            if(~sphdiv)
                                [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                                Ltmp=ones(size(pfantmp));
                            else
                                [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                            end
                        elseif(reftype==1)%PP reflections
                            %pwave down to reflector;pwave up to free surface;pwave down to receiver
                            raycode=[zshot,1;z(k),1;0,1;zrec,1];
                            %trace PP rays
                            if(~sphdiv)
                                [time_rtmp,pfantmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                                Ltmp=ones(size(pfantmp));
                            else
                                [time_rtmp,pfantmp,Ltmp]=traceray(vp,z,vs,z,raycode,xoffs(ioffuse),xcap,-1,itermax,1,raymsg);
                            end
                        end
                    case 4 %source-receiver ghost
                end
                time_r=nan*xoffs;
                pfan=time_r;
                L=time_r;
                time_r(ioffuse)=time_rtmp;
                pfan(ioffuse)=pfantmp;
                L(ioffuse)=Ltmp;
            else
                %ok make angle traces
                %trace the psv rays
                if(reftype==2)
                    if(~sphdiv)
                        [time_rtmp,ptmp,xofftmp]=angleray_ps(vp,z,vs,z,zshot,zrec,z(k),angles);
                        Ltmp=ones(size(ptmp));
                    else
                        [time_rtmp,ptmp,xofftmp,Ltmp]=angleray_ps(vp,z,vs,z,zshot,zrec,z(k),angles);
                    end
                elseif(reftype==1)
                    %trace PP rays
                    if(~sphdiv)
                        [time_rtmp,ptmp,xofftmp]=angleray_pp(vp,z,zshot,zrec,z(k),angles);
                        Ltmp=ones(size(ptmp));
                    else
                        [time_rtmp,ptmp,xofftmp,Ltmp]=angleray_pp(vp,z,zshot,zrec,z(k),angles);
                    end
                end
                time_r=time_rtmp;
                pfan=ptmp;
                L=Ltmp;
            end
            tfill=-1;
            ind = find(isinf(time_r));
            sizeind = size(ind);
            if(sum(sizeind) ~= 0)
                time_r(ind) = ones(sizeind)*tfill;
            end
            
            tgath2(k-ilivelayer+1,:)=time_r;
            
            if( k>ilivelayer+1 ) %we only start calculating reflectivity after ilivelayer+1
                pgath(k-ilivelayer+1,:)=pfan;
                if(gatherflag==2)
                    offgath(k-ilivelayer+1,:)=xofftmp;%means something for angle gather
                end
                
                %calculate the offset reflectivities
                vpup=vp(k-1);
                vsup=vs(k-1);
                rhoup=rho(k-1);
                vpdown=vp(k);
                vsdown=vs(k);
                rhodown=rho(k);
                anginc= 180*asin(vpup*pfan)/pi;%vector of angles
                rcz = zoeppritz(rhoup,vpup,vsup,rhodown,vpdown,vsdown,...
                    incwave,refwave,0,anginc);%zoeppritz is vectorized over angles
                %rcz has the possibly complex reflection coefficients, one per angle/offset
                if(sum(sizeind) ~= 0)
                    rcz(ind) = zeros(sizeind);
                end
                
                if(iscomplex(rcz))
                    disp('complex rcs found')
                end
                %L is the spreading factor
                gather(k-ilivelayer+1,:)=rcz./L;
                
                %calculate transmission losses if desired
                %these losses are correct only to the top of log. i.e. the fake layers are not modelled
                if(trloss)
                    kmin=ilivelayer+1;
                    
                    if(k>=kmin)% start at layer 2 because the first layer has no trloss
                        
                        anginc = 180*asin(vp(kmin-1:k)*pfan)/pi;% matrix of P angles for all layers above the reflector
                        %loop over layers and compute transmission coefficients
                        
                        transamp=ones(size(anginc));
                        for l=1:size(anginc,1)-1 %loop over columns of anginc
                            %should only use the non-nan angles
                            laynum=l+ilivelayer-1;
                            if(reftype==2) %P down and S up
                                angshear=180*asin(vs(laynum+1)*sin(pi*anginc(l+1,:)/180)/vp(laynum+1))/pi;
                                transamp(l,:) = zoeppritz(rho(laynum),vp(laynum),vs(laynum),rho(laynum+1),vp(laynum+1),...
                                    vs(laynum+1),1,3,0,anginc(l,:)).*zoeppritz(rho(laynum+1),vp(laynum+1),...
                                    vs(laynum+1),rho(laynum),vp(laynum), vs(laynum),2,4,0,angshear);
                            else % P down and P up
                                transamp(l,:) = zoeppritz(rho(laynum),vp(laynum),vs(laynum),rho(laynum+1),vp(laynum+1),...
                                    vs(laynum+1),1,3,0,anginc(l,:)).*zoeppritz(rho(laynum+1),vp(laynum+1),...
                                    vs(laynum+1),rho(laynum),vp(laynum), vs(laynum),1,3,0,anginc(l+1,:));
                                %correct for energy flux
                            end
                        end
                        %transamp is a row vector of all the transmission coefficients above the reflector
                        %apply transmission loss
                        gather(k-ilivelayer+1,:)=prod(transamp).*gather(k-ilivelayer+1,:);
                    end
                    
                end
                %         if(~isempty(pflag))
                %             waitbar((k-ilivelayer+1)/(1.1*nreflections),pflag)
                %         end
                if( (rem(k-ilivelayer+1,50)==0) && ~isempty(pflag) )
                    disp([' finished depth number ', int2str(k-ilivelayer+1) ' of ' int2str(nreflections)])
                end
            end
        end %end loop over layers
        %     end
        
        
        %get rid of any -1's
        ind=tgath2>0;
        tfill=min(tgath2(ind));
        ind=find(tgath2==-1);
        if(~isempty(ind))
            tgath2(ind)=tfill;
        end
        
        %handle zeros at the end of tgath2
        if(size(tgath2,1)>iendlayer-ilivelayer+1)
            imax=iendlayer-ilivelayer+1;
            [nr,nc]=size(tgath2);
            for k=1:nc
                delt=abs(tgath2(imax,k)-tgath2(imax-1,k));
                tgath2(imax+1:nr,k)=tgath2(imax,k)+delt*(1:nr-imax)';
            end
        end
        
        tgath=tgath2(:,1);%zero offset times
        
        %contouring. If an offset gather then we are contouring angles. If an angle gather then we are contouring offsets
        if(jgath==1)%only contour the primaries
            coffs=[];
            cangles=[];
            if(~angletraces)
                cangles=0;
                if(nargout>4)
                    if(cflag)
                        %contour up the incidence angles
                        anginc=real(180*asin(pgath.*vp(ilivelayer:end,ones(1,length(xoffs))))/pi);
                        % toss the first few rows as anomalous
                        ntoss = round(.05*size(anginc,1));
                        anginc(1:ntoss,:)=nan*ones(ntoss,size(anginc,2));
                        xxx=xoffs(ones(size(anginc,1),1),:);
                        delx=xoffs(2)-xoffs(1);
                        xxx=[xxx(:,1)-delx xxx xxx(:,end)+delx];
                        anginc=[anginc(:,1) anginc anginc(:,end)];
                        htmpfig=figure('visible','off'); %seems to be necessary to use CONTOUR
                        %interpolate onto regular grid
                        if(cflag==1)
                            tcontour=tgath2;
                            tcontour = [tcontour(:,1) tcontour tcontour(:,end)];
                        else
                            tcontour = tgath(:,ones(1,size(anginc,2)));
                        end
                        %    anginc=conv2(anginc,ones(3,10),'same')/30;
                        
                        if(isempty(clevels))
                            %             cangles=contour(xxx,tcontour,anginc);
                            %         else
                            cangles=contour(xxx,tcontour,anginc,clevels);
                        else
                            cangles=[];
                        end
                        delete(htmpfig);
                    end
                end
            else
                %contour offsets
                if(nargout>4)
                    if(cflag)
                        %contour up the offsets
                        
                        % toss the first few rows as anomalous
                        ntoss = round(.05*size(offgath,1));
                        offgath(1:ntoss,:)=nan*ones(ntoss,size(offgath,2));
                        aaa=angles(ones(size(offgath,1),1),:);
                        dela=1;
                        aaa=[aaa(:,1)-dela aaa aaa(:,end)+dela];
                        offgath=[offgath(:,1) offgath offgath(:,end)];
                        htmpfig=figure('visible','off'); %seems to be necessary to use CONTOUR
                        %interpolate onto regular grid
                        if(cflag==1)
                            tcontour=tgath2;
                            tcontour = [tcontour(:,1) tcontour tcontour(:,end)];
                        else
                            tcontour = tgath(:,ones(1,size(offgath,2)));
                        end
                        %    offgath=conv2(offgath,ones(3,10),'same')/30;
                        if(length(xoffs)<15)
                            clevels=xoffs;
                        else
                            dx=xoffs(2)-xoffs(1);
                            clevels=round(linspace(xoffs(1),xoffs(end),15)/dx)*dx;
                        end
                        
                        if(isempty(clevels))
                            coffs=contour(aaa,tcontour,offgath);
                        else
                            %at present, clevels are angles, so we fake it here
                            %             offmin=min(offgath(:));
                            %             offmax=max(offgath(:));
                            %             clevels=linspace(offmin,offmax,length(clevels));
                            coffs=contour(aaa,tcontour,offgath,clevels);
                        end
                        delete(htmpfig);
                    end
                end
            end
        end
        
        
        
        
        %eliminate nans in gather
        ind=find(isnan(gather(:,:)));
        if(~isempty(ind)); gather(ind)=zeros(size(ind)); end
        
        % polarity flip if PSv
        if(reftype==2 && polarity == -1)
            gather=gather*polarity;
        end
        
        %compute near surface effect if not vsp
        %for vsp we don't compute free surface effect
        vsp=0;%flag for later
        if(length(zrec)==1)
            %determine layer the receiver is in
            il=find(z>zrec);
            irec=il(1)-1;
            
            if(response==1&&receiver==2)
                
                if(zwater>0)
                    %ocean bottom effect
                    if(reftype==2)
                        [v,r]=soceanbottom(pgath,vp(irec),vs(irec),rho(irec),vp(irec-1),rho(irec-1));
                    else
                        [v,r]=poceanbottom(pgath,vp(irec),vs(irec),rho(irec),vp(irec-1),rho(irec-1));
                    end
                else
                    %free surface effect
                    if(reftype==2)
                        [v,r]=sfreesurf(pgath,vp(irec),vs(irec));
                    else
                        [v,r]=pfreesurf(pgath,vp(irec),vs(irec));
                    end
                end
            elseif(response==0&&receiver==2)%no free surface
                
                if(reftype==2)
                    v=pgath*vs(irec); %sine of emergence angle
                    r=sqrt(1-v.^2);%cosine
                else
                    r=pgath*vp(irec); %sine of emergence angle
                    v=sqrt(1-r.^2);%cosine
                end
%             else%hydrophone in water
%                 r=pgath*vp(irec); %sine of emergence angle
%                 v=sqrt(1-r.^2);%cosine
            end
        else
            %for VSP mode, each receiver is at a different depth and so has a
            %different local velocity
            vsp=1;
            r=zeros(size(pgath));
            v=r;
            for k=1:length(zrec)
                %determine layer the receiver is in
                il=find(z>zrec(k));
                irec=il(1)-1;
                if(reftype==2)
                    r(:,k)=pgath(:,k)*vs(irec);
                    v(:,k)=sqrt(1-r(:,k).^2);
                else
                    r(:,k)=pgath(:,k)*vp(irec);
                    v(:,k)=sqrt(1-r(:,k).^2);
                end
            end
        end
        
        % decompose into components and build output traces
        
        if(receiver==2)
            % Geophone
            u2.x=gather.*r;%radial component
            u2.z=gather.*v;%vertical component
            
        elseif(receiver==1)
            % Hydrophone
            % This is the divergence of displacement
%             sintheta=vwater*pgath;
%             u2.x=gather.*(v.*sqrt(1-sintheta.^2)+r.*sintheta);
            u2.x=gather;
            u2.z=[];
        else
            error('invalid receiver request');
        end
        
        % At this point, u2 contains complex reflection coefficients for each
        % reflector and each offset or angle. tgath2 contains the raytraced
        % traveltimes for the reflection events in u2. So, the next setion has
        % to create regularly sampled traces and convolve those with the source
        % wavelet. In addition, the raytraced traveltimes are either (1) ignored
        % and the zero offset traveltimes (in tgath) are used instead (this is called the
        % pseudo zero-offset gather), (2) the traveltimes are used as is and the
        % gather is created showing reflection events following moveout trajectories
        % (this is called the normal moveout gather), or (3) the normal moveout
        % gather is created as in (2) and then moveout is removed. (This is called
        % the nmo removed gather.) The third option is the most realistic for a
        % conventional offset gather. However, it is not practical for an angle
        % gather because adjacent samples on the same trace can have very different
        % offsets. For this reason, if an angle gather is requested, then the
        % pseudo zero-offset display is forced.
        %
        % For ghost gathers, the polarity of the gather depends upon a number of factors including
        % most especially the receiver type. Here are the polarity factors
        % source ghost ... ghostpol = -1 for both types of receivers.
        % receiver ghost ... ghostpol = -1 for hydrophones and +1 for geophones.
        % source-receiver ghost ... ghostpol = +1 for hydrophones and -1 for geophones.
        %
        % To understand these, consider the physics. Because pressure must vanish at the free
        % surface, the pressure reflection from the free surface must be opposite in sign from the
        % incident pressure. Displacement does not vanish and the incident and reflected
        % displacements have the same sign. 
        % (1) For the source ghost (vertical component or pressure), upward and downward pressure
        % from the source have the same sign but the reflection from the free surface of the upward
        % pressure changes the sign. However, upward and downward displacements from the source have
        % opposite signs and the reflection from the free surface preserves the sign. Therefore the
        % source ghost polarity is -1 (with respect to the primary downgoing wave) for both types.
        % (2) For the receiver ghost (pressure or vertical comp), the same rules lead to a polarity
        % of -1 for hydrophones and +1 for geophones.
        % (3) For the horizontal component of displacement, the downgoing and upgoing pulses have
        % the same polarity and again the upgoing does not reverse upon reflection. So for the
        % horizontal components the ghost has the same polarity as the primary.
        % (4) For the source-receiver ghost, the polarity is the product of the first two cases.
        %
        % The ghostpol multipliers will be applied to both the wavelet and the "spike" outputs. This
        % ensures that if a subsequently different wavelet is applied to the ghost gathers the
        % polarity will be correct.
        
        ghostpolz=1; %this will be used for primaries
        ghostpolx=1;
        if(jgath==2) %source ghost
            ghostpolz=-1;
        elseif(jgath==3) %receiver ghost
            if(receiver==1)
                ghostpolz=-1;
            else
                ghostpolz=1;
            end
        elseif(jgath==4) %source-receiver ghost
            if(receiver==1)
                ghostpolz=1;
            else
                ghostpolz=-1;
            end
        end
        
        dt=tw(2)-tw(1); %desired final sample rate is determined by wavelet
        doQ=true;
        if(usedefault(Q))
            doQ=false;%there will be no Q
        end
        if(doQ)
            if(length(Q)~=1)
                error('Q must be a scalar');
            end
        end
        %from here down, gather gets defined. Previously in gather there was one row per reflection,
        %now, after treace construction, gather will be one row per time sample
        for j=1:2 %loop over components
            if(j==2 && receiver==1)
                uw.z=[];
                u.z=[];
                break;
            end
            if(j==1)
                gath1=u2.x;
            else
                gath1=u2.z;
            end
            %eliminate nans in gath1
            iii=find(isnan(gath1));
            if(~isempty(iii))
                gath1(iii)=0*iii;
            end
            % gatherflag ... 0 offset, 1 vsp, 2 angle
            % nmoflag ... 0 for nmo included in the gather
            % 	  ... 1 for a pseudo-zero offset gather
            % 	  ... 2 for nmo to be removed in the gather
            
            if (nmoflag==1 || gatherflag==2) %pseudo zero offset or angle gathers
                % pseudo zero offset (PZO) means offset reflections are mapped direct to zero offset time
                % without NMO stretch
                [gather,time,gatherspike]=gentrace(gath1,tgath,w,tw,sflag);
                % apply Q. Q should depend on true NMO time so this is not quite correct for PZO
                if(doQ)
                    qmat=qmatrix(Q,time,[1 0],[0 dt],3);
                    for k=1:size(gather,2)
                        gather(:,k)=qmat*gather(:,k);
                        gatherspike(:,k)=qmat*gatherspike(:,5);
                    end
                end
                %pad or truncate depending on first time sample
                if(time(1)>0)
                    npad=round(time(1)/dt);
                    nx=size(gather,2);
                    gather=[zeros(npad,nx); gather]; %#ok<AGROW>
                    gatherspike=[zeros(npad,nx); gatherspike]; %#ok<AGROW>
                    time=[dt*(0:npad-1)';time]; %#ok<AGROW>
                elseif(time(1)<0)
                    nkill=round(-time(1)/dt);
                    gather(1:nkill,:)=[];
                    gatherspike(1:nkill,:)=[];
                    time(1:nkill,:)=[];
                end
                if(receiver==1)%hydrophone
%                     gather=hyd_freq_adjust(gather,time,1);
%                     gatherspike=hyd_freq_adjust(gatherspike,time,1);
                end
                if(jgath==1)%primary
                    if(j==1)%horizontal component or hydrophone
                        u.x=zeros(size(gather,1),size(gather,2),ngathers);
                        uw.x=u.x;
                        if(receiver==1)%Hydrophone
                            u.x(:,:,jgath)=ghostpolz*gatherspike;
                            uw.x(:,:,jgath)=ghostpolz*gather;
                        else%horizontal
                            u.x(:,:,jgath)=ghostpolx*gatherspike;
                            uw.x(:,:,jgath)=ghostpolx*gather;
                        end
                        u.time=time;
                        uw.time=time;
                        u.offset=xoffs;
                        uw.offset=xoffs;
                        u.angle=angles;
                        uw.angle=angles;
                    else%vertical
                        u.z=zeros(size(gather,1),size(gather,2),ngathers);
                        uw.z=u.z;
                        u.z(:,:,jgath)=ghostpolz*gatherspike;
                        uw.z(:,:,jgath)=ghostpolz*gather;
                    end
                    
                else%ghosts
                    if(j==1)%horizontal or hydrophone
                        if(receiver==1)%hydro
                            u.x(:,:,jgath)=ghostpolz*gatherspike;
                            uw.x(:,:,jgath)=ghostpolz*gather;
                        else%horizontal
                            u.x(:,:,jgath)=ghostpolx*gatherspike;
                            uw.x(:,:,jgath)=ghostpolx*gather;
                        end
                    else%vertical
                        u.z(:,:,jgath)=ghostpolz*gatherspike;
                        uw.z(:,:,jgath)=ghostpolz*gather;
                    end
                end
                
            end
            
            if (nmoflag==0 || nmoflag==2 && gatherflag~=2)%no NMO removal or NMO removal with offset gathers
                [gather,time,gatherspike]=make_nmo_trace(gath1,tgath2,dt,xoffs,w,tw,sflag);
                % apply Q before NMOR so it depends on the true traveltime
                if(doQ)
                    qmat=qmatrix(Q,time,[1 0],[0 dt],3);
                    for k=1:size(gather,2)
                        gather(:,k)=qmat*gather(:,k);
                        gatherspike(:,k)=qmat*gatherspike(:,5);
                    end
                end
                if(receiver==1)%hydrophone
%                     gather=hyd_freq_adjust(gather,time,1);
%                     gatherspike=hyd_freq_adjust(gatherspike,time,1);
                end
                if(nmoflag~=2)%no NMO removal
                    if(jgath==1)%primary
                        if(j==1)%horizontal component or hydrophone
                            u.x=zeros(size(gather,1),size(gather,2),ngathers);
                            uw.x=u.x;
                            if(receiver==1)%hydrophone
                                u.x(:,:,jgath)=ghostpolz*gatherspike;
                                uw.x(:,:,jgath)=ghostpolz*gather;
                            else
                                u.x(:,:,jgath)=ghostpolx*gatherspike;
                                uw.x(:,:,jgath)=ghostpolx*gather;
                            end
                            u.time=time;
                            uw.time=time;
                            u.offset=xoffs;
                            uw.offset=xoffs;
                            u.angle=angles;
                            uw.angle=angles;
                        else%vertical component
                            u.z=zeros(size(gather,1),size(gather,2),ngathers);
                            uw.z=u.z;
                            u.z(:,:,jgath)=ghostpolz*gatherspike;
                            uw.z(:,:,jgath)=ghostpolz*gather;
                        end
                    else%ghost gathers
                        ntsamp=size(u.x,1);
                        itout=1:ntsamp;
                        if(j==1)%horizontal comp or hydrophones
                            if(receiver==1)%hydrophones
                                u.x(:,:,jgath)=ghostpolz*gatherspike(itout,:);
                                uw.x(:,:,jgath)=ghostpolz*gather(itout,:);
                            else%geophones
                                u.x(:,:,jgath)=ghostpolx*gatherspike(itout,:);
                                uw.x(:,:,jgath)=ghostpolx*gather(itout,:);
                            end
                        else%vertical component
                            u.z(:,:,jgath)=ghostpolz*gatherspike(itout,:);
                            uw.z(:,:,jgath)=ghostpolz*gather(itout,:);
                        end
                    end
                else%NMO removal
                    if(~vsp)
                        if(jgath==1)
                            tgath2_primary=tgath2;
                        end
                        gath_nmor=remove_nmor(gather,time,tgath2_primary,xoffs,sflag);
                        [gathspike_nmor,time2]=remove_nmor(gatherspike,time,tgath2_primary,xoffs,sflag);
                        %truncate in time to a reasonable limit
                        tmaxzo=max(tgath2(:,1));%maximum zero offset traveltime
                        tmax=dt*ceil(tmaxzo/dt)+tw(end);%allow for wavelet
                        if(tmax<time2(end))%should always be true
                            imax=near(time2,tmax);
                            time2(imax+1:end)=[];
                            gath_nmor(imax+1:end,:)=[];
                            gathspike_nmor(imax+1:end,:)=[];
                        end
                        if(jgath==1)%primary
                            if(j==1)
                                u.x=zeros(size(gath_nmor,1),size(gath_nmor,2),ngathers);
                                uw.x=u.x;
                                if(receiver==1)%hydrophones
                                    u.x(:,:,jgath)=ghostpolz*gathspike_nmor;
                                    uw.x(:,:,jgath)=ghostpolz*gath_nmor;
                                else%horizontal component
                                    u.x(:,:,jgath)=ghostpolx*gathspike_nmor;
                                    uw.x(:,:,jgath)=ghostpolx*gath_nmor;
                                end
                                u.time=time2;
                                uw.time=time2;
                                u.offset=xoffs;
                                uw.offset=xoffs;
                                u.angle=angles;
                                uw.angle=angles;
                            else%vertical component
                                u.z=zeros(size(gath_nmor,1),size(gath_nmor,2),ngathers);
                                uw.z=u.z;
                                u.z(:,:,jgath)=ghostpolz*gathspike_nmor;
                                uw.z(:,:,jgath)=ghostpolz*gath_nmor;
                            end
                        else%ghosts
                            ntsamp=size(u.x,1);
                            itout=1:ntsamp;
                            if(j==1)%horizontal comp or hydrophones
                                if(receiver==1)%hydrophones
                                    u.x(:,:,jgath)=ghostpolz*gathspike_nmor(itout,:);
                                    uw.x(:,:,jgath)=ghostpolz*gath_nmor(itout,:);
                                else%horizontal
                                    u.x(:,:,jgath)=ghostpolx*gathspike_nmor(itout,:);
                                    uw.x(:,:,jgath)=ghostpolx*gath_nmor(itout,:);
                                end
                            else%vertical
                                u.z(:,:,jgath)=ghostpolz*gathspike_nmor(itout,:);
                                uw.z(:,:,jgath)=ghostpolz*gath_nmor(itout,:);
                            end
                        end
                    else %vsp, currently not functional
                        gath_flat=flatten_vsp(gather,time,tgath2,sflag);
                        [gathspike_flat,time2]=flatten_vsp(gatherspike,time,tgath2,sflag);
                        if(jgath==1)%primary
                            if(j==1)%horizontal or hydro
                                u.x=zeros(size(gath_flat,1),size(gath_flat,2),ngathers);
                                uw.x=u.x;
                                if(receiver==1)%hydro
                                    u.x(:,:,jgath)=ghostpolz*gathspike_flat;
                                    uw.x(:,:,jgath)=ghostpolz*gath_flat;
                                else%horizontal
                                    u.x(:,:,jgath)=ghostpolx*gathspike_flat;
                                    uw.x(:,:,jgath)=ghostpolx*gath_flat;
                                end
                                u.time=time2;
                                uw.time=time2;
                                u.offset=xoffs;
                                uw.offset=xoffs;
                                u.angle=angles;
                                uw.angle=angles;
                            else%vertical comp
                                u.z=zeros(size(gath_flat,1),size(gath_flat,2),ngathers);
                                uw.z=u.z;
                                u.z(:,:,jgath)=ghostpolz*gathspike_flat;
                                uw.z(:,:,jgath)=ghostpolz*gath_flat;
                            end
                        else%ghosts
                            if(j==1)%horizontal or hydro
                                if(receiver==1)%hydro
                                    u.x(:,:,jgath)=ghostpolz*gathspike_flat;
                                    uw.x(:,:,jgath)=ghostpolz*gath_flat;
                                else
                                    u.x(:,:,jgath)=ghostpolx*gathspike_flat;
                                    uw.x(:,:,jgath)=ghostpolx*gath_flat;
                                end
                            else%vertical
                                u.z(:,:,jgath)=ghostpolz*gathspike_flat;
                                uw.z(:,:,jgath)=ghostpolz*gath_flat;
                            end
                        end
                    end
                end
            end
            
        end
        
        %interpolate pgath to regular sample rate at the output time
%         tp=round(tgath(1)/dt)*dt:dt:round(tgath(end)/dt)*dt;
%         pgath2=zeros(length(tp),size(pgath,2));
%         for k=1:size(pgath,2)
%             pgath2(:,k)=interpextrap(tgath,pgath(:,k),tp);
%         end
%         pgath=pgath2;
%         tgath=tp;
        
        %stack the gathers
        % Stack the section (transpose to get the rows/cols right)
        xstack = sum(uw.x,2);%stack across primary and 3 ghosts
        xstackspike=sum(u.x,2);
        zstack = sum(uw.z,2);
        zstackspike=sum(u.z,2);
        % normalize the stack by dividing by the number of live samples
        inotzero=find(abs(uw.x)>=10*eps);
        dummy=zeros(size(uw.x));
        dummy(inotzero)=ones(size(inotzero));
        stkfold=sum(dummy,2);
        
        ind=find(stkfold==0);
        if(~isempty(ind))
            stkfold(ind)=ones(size(ind));
        end
        
        uw.xstack=xstack./(stkfold);
        u.xstack=xstackspike./(stkfold);
        if(~isempty(zstack))
            uw.zstack=zstack./(stkfold);
            u.zstack=zstackspike./(stkfold);
        else
            uw.zstack=[];
            u.zstack=[];
        end
        
        if(~isempty(pflag))
            t1=clock;
            switch jgath
                case 1
                    time=etime(t1,tbegin);
                    disp([' primary gather computed in ', num2str(time) ' seconds']);
                    t0=t1;
                case 2
                    time=etime(t1,tbegin);
                    timej=etime(t1,t0);
                    disp([' source ghost gather computed in ', num2str(timej) ' seconds']);
                    disp([' total elapsed time ', num2str(time) ' seconds']);
                    t0=t1;
                case 3
                    time=etime(t1,tbegin);
                    timej=etime(t1,t0);
                    disp([' receiver ghost gather computed in ', num2str(timej) ' seconds']);
                    disp([' total elapsed time ', num2str(time) ' seconds']);
                    t0=t1;
                case 4
                    time=etime(t1,tbegin);
                    timej=etime(t1,t0);
                    disp([' source-receiver ghost gather computed in ', num2str(timej) ' seconds']);
                    disp([' total elapsed time ', num2str(time) ' seconds']);
                    t0=t1;
            end
        end
    end
end
logmat=[z vp vs rho];
end

function flag=usedefault(x)
if(all(isempty(x))||all(isnan(x)))
    flag=true;
else
    flag=false;
end

end

function [gather,time,gatherspike]=make_nmo_trace(gath1,tgath2,dt,xoffs,w,tw,sflag)
% put in NMO
% gath1 is the single component (vertical, radial, or hydrophone) gather.
% one trace per column but irregularly sampled in time. Amplitudes
% are reflection coefficients, possibly complex.
% the time of the arrivals in each column is in tgath2.

% get maximum and minimum traveltime from raytraced traveltimes
indy=find(~isnan(tgath2));
maxt=1.2*max(tgath2(indy));
maxt_out=ceil(maxt/dt)*dt;%adjust to nearest sample on output grid
mint=min(tgath2(indy));
mint_out=floor(mint/dt)*dt;

% set temporary sample rate at 1/100 times the desired final rate
rfactor=10; %resample factor
dtmp=dt/rfactor;

% reset the input gather at 200x sample rate
% use RESAMP with zero phase filter
%maxt=maxt+dtmp;
ttmp=(mint_out:dtmp:maxt_out)';
ntmp=length(ttmp);
if(2*floor(ntmp/2)~=ntmp)%make sure its an even number
   ttmp=[ttmp; ttmp(end)+dt];
end
maxrc=0;
for j=1:length(xoffs)
    % nearest neighbor interpolation
    indx=find(~isnan(tgath2(:,j)));
    ind=round((tgath2(indx,j)-mint_out)/dtmp) + 1;
    tmptrace=zeros(size(ttmp));
    tmptrace(ind)=gath1(indx,j);
    %tmptrace contains the jth trace, with nearest neighbor

    %apply anti alias filter
    fmax=.6*(.5/dt);%60 percent of Nyquist
%     froll=.2*(.5/dt);%rolloff
%     tmptracef=filtf(tmptrace,ttmp,[0 0],[fmax froll],1);
    tmptracef=butterband(tmptrace,ttmp,0,fmax,4,0);%butterband is much better than filtf (above) or direct Fourier multiply (below)
%     [TMPF,f]=fftrl(tmptrace,ttmp);
%     ind=find(f>=fmax);
%     g=exp(-(f(ind)-fmax).^2/(froll^2));
%     TMPF(ind)=TMPF(ind).*g;
%     tmptracef=ifftrl(TMPF,f);
    tmptrace_r=tmptracef(1:rfactor:length(tmptrace));
    ttmp_r=(0:length(tmptrace_r)-1)*dt+mint_out;
    % generate a trace (apply wavelet)
    maxr=max(abs(tmptrace));
    if(maxr>maxrc)
        maxrc=maxr;
    end
    [fintrace,time,fintrace2]=gentrace(tmptrace_r,ttmp_r,w,tw,sflag);
    %
    if(j==1)
        gather=zeros(length(fintrace),length(xoffs));
        gatherspike=gather;
    end
    gather(:,j)=fintrace;
    gatherspike(:,j)=fintrace2;
end
%pad or truncate depending on first time sample
if(time(1)>0)
    npad=round(time(1)/dt);
    nx=size(gather,2);
    gather=[zeros(npad,nx); gather];
    gatherspike=[zeros(npad,nx); gatherspike];
%     time=[dt*(0:npad-1)';time];
elseif(time(1)<0)
    nkill=round(-time(1)/dt);
    gather(1:nkill,:)=[];
    gatherspike(1:nkill,:)=[];
%     time(1:nkill,:)=[];
end
    
gather=maxrc*gather/max(abs(gather(:)));
gatherspike=maxrc*gatherspike/max(abs(gatherspike(:)));
time=dt*(0:size(gather,1)-1)';
end

function [gath_nmor,tzo]=remove_nmor(gather,time,tgath2,xoffs,sflag)
% NMO removal
%gather is a gather of traces that need NMO correction.
%time is the time coordinate for the gather.
%tgath2 contains the actual reflection times for each trace in
%    gather. So, if the first trace is zero offset and the other
%    traces are prograssivly larger offsets, then comparing column k
%    of tgath2 to column 1 establishes the NMO traveltime map for
%    offset k.
%xoffs is the vector of offsets, one per column
%sflag is a flag described in the help for this function

% interpolate traces at offset to zero offset traveltimes
if(sflag)
    ind=between(tgath2(1,1),tgath2(end,1),time,2);
    nt=length(ind);
else
    nt=length(time);
end

tfill=min(min(tgath2));
for j=1:length(xoffs)
    %make tx-to curve
    ind=find(tgath2(:,j)~=tfill);
    if(isempty(ind))
        tmptrc=zeros(nt,1);
    else
        tnmo=interpextrap(tgath2(ind,1),tgath2(ind,j),time(1:nt));%interpolate the traveltimes
        tmptrc=sinci(gather(:,j),time,tnmo);%interpolate the amplitudes
        if(j==1)
            gath_nmor=zeros(length(tmptrc),length(xoffs));
        end
    end
    gath_nmor(:,j)=tmptrc;
end
tzo=time(1:size(gath_nmor,1));%zero offset time
end

function gather=hyd_freq_adjust(gather,time,flag)
nsamps=size(gather,1);
ntrcs=size(gather,2);
amps=zeros(1,ntrcs);
for k=1:ntrcs
    amps(k)=norm(gather(:,k),1);
end
[Gath,f]=fftrl(gather,time);
%phase rotate
%Gath=Gath.*exp(i*pi/2);
%Gath=-Gath;
if(flag)
    %multiply by frequency
    ff=f(:,ones(size(Gath,2),1));
    Gath=ff.*Gath;
end
gather=ifftrl(Gath,f);
for k=1:ntrcs
    gathnorm = norm(gather(:, k), 1);
    if (gathnorm ~= 0)  % Had to add this to avoid divide by zero errors. -Chad
        gather(:,k)=gather(:,k)*amps(k)/norm(gather(:,k),1);
    end
end
gather=gather(1:nsamps,1:ntrcs);
end

function [gath_flat,tflat]=flatten_vsp(gather,time,tgath2,sflag)
% flatten vsp.
%gather is a gather of vsp traces. First trace is the shallowest receiver
%    flattening is achieved by adjusting all traveltimes to match the
%    shallowest receiver.
%time is the time coordinate for the gather.
%tgath2 contains the actual reflection times for each trace in
%    gather. So, if the first trace is shallowest receiver and the other
%    traces are progressivly deeper, then comparing column k
%    of tgath2 to column 1 establishes the flattening traveltime map for
%    offset k.
%zrec is the vector of receiver depths, one per column
%sflag is a flag described in the help for this function

% interpolate traces at offset to zero offset traveltimes
if(sflag)
    ind=between(tgath2(1,1),tgath2(end,1),time,2);
    if(ind==0); ind=[]; end
    tflat=time(ind);%these are the times that we will adjust everything to
    nt=length(ind);
else
    nt=length(time);
    tflat=time;
end
nx=size(gather,2);
gath_flat=zeros(length(tflat),nx);
%tfill=min(min(tgath2));
for j=1:nx %start with column 1
    %make tj-t1 curve, tj= times for column j, t1 times for column 1
    % 	         ind=find(tgath2(:,j)~=tfill);
    %              if(isempty(ind))
    %                  tmptrc=zeros(nt,1);
    %              else
    %                  tj=interpextrap(tgath2(ind,1),tgath2(ind,j),time(1:nt));%interpolate the traveltimes
    %                  tmptrc=sinci(gather(:,j),time,tj);%interpolate the amplitudes
    %                  if(j==1)
    %                      gath_flat=zeros(length(tmptrc),length(xoffs));
    %                  end
    %              end
    tj=interpextrap(tgath2(:,1),tgath2(:,j),tflat);%interpolate the traveltimes
    gath_flat(:,j)=sinci(gather(:,j),time,tj);%interpolate the amplitudes
end
end
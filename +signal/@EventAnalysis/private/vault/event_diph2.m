function amat=event_diph2(amat,t,x,v,x0,x1,z0,ndelx,theta,amp,flag,noversamp)
% EVENT_DIPH2: construct a dipping event with sparse diffraction superposition
% EVENT_DIPH2: 构造一个带有稀疏绕射叠加的倾伏事件
%
% amat=event_diph(amat,t,x,v,x0,x1,z0,ndelx,theta,amp,flag,noversamp)
%
% EVENT_DIPH2 inserts a dipping (linear) event in a matrix. The event
% is constructed from a superposition of hyperbolae. The spacing of the
% hyperbolae is controlled by ndelx.
% EVENT_DIPH2 在矩阵中插入一个倾伏（线性）事件。该事件由双曲线的叠加构成。
% 双曲线的间距由 ndelx 控制。
%
% amat ... the matrix of size nrows by ncols
% t ... vector of length nrows giving the matrix t coordinates
% x ... vector of length ncols giving the matrix x coordinates
% v ... velocity (scalar)
% x0 ... starting x coordinate of the event
% x1 ... ending x coordinate of the event
% z0 ... starting depth of the event
% ndelx ... horizontal distance between hyperbola expressed as xdist=ndelx*dx
%        where dx=x(2)-x(1). ndelx must be an integer greater than or equal to one.
% theta ... dip (degrees) of the event
% amp ... vector of length 2 giving the amplitudes at either end
%	of the event. Intermediate amplitudes are interpolated in x.
% flag ... if 1, then amplitudes are divided by cos(theta)
%				otherwise no effect
%      ******** default = 1 *********
% noversamp ... each output trace is created by nearest-neighbor interpolation into
%		a temporary over-sampled trace that is then properly resampled. The greater the
%		oversampling, the better the result.
%      ******** default = 10 *********
%


if(nargin<12) noversamp=10; end
if(nargin<11) flag=1; end

if(ndelx<1 | rem(ndelx,1)~=0)
   error('invalid value for ndelx')
end

if(z0==0)
   z0=.0001*(abs(x(2)-x(1)));
end

%loop over columns
% 遍历列
%nc= between(xlims(1),xlims(2),x,2);
[nr,nc]=size(amat);

v=v/2;

if(length(amp)==1) amp=[amp amp]; end

%determine the origins of the hyperbolae
% 确定双曲线的原点
ind=between(x0,x1,x,2);
ind=ind(1:ndelx:end);
if(x0>x1) ind=fliplr(ind); end
if(~ind) error('check x coordinates'); end
xnot=zeros(size(ind));znot=xnot;tnot=xnot;
xnot(1)=x(ind(1));znot(1)=z0;tnot(1)=znot(1)/v;
dx=sign(x1-x0)*(x(2)-x(1));
for k=2:length(ind)
	xnot(k)=x(ind(k));
	znot(k)=znot(k-1)+dx*ndelx*tan(pi*theta/180);
	tnot(k)=znot(k)/v;
end


%interpolate new locations
%this is inefficient but who cares
% 插值新位置
% 效率低但没关系
dxnew=dx*cos(pi*theta/180);
xnew=xnot(1):dxnew:xnot(end);
znew=interp1(xnot,znot,xnew);

xnot=xnew(1:ndelx:end);
znot=znew(1:ndelx:end);
tnot=znot/v;			

anot=amp(1)+(xnot-x0)*(amp(2)-amp(1))/(x1-x0);

tmin=t(1);
tmax=t(length(t));
dt=t(2)-t(1);
dt2=dt/noversamp;
ttmp=tmin:dt2:tmax;

costheta=1;
if(flag==1) costheta=cos(pi*theta/180); end

for k=1:nc %loop over traces
% 遍历轨迹
	trctmp=zeros(size(ttmp))';
	tk=sqrt(tnot.^2+((x(k)-xnot)/v).^2);
	ak=anot.*tnot./tk;
	ind2=between(tmin,tmax,tk);
	if(ind2~=0)
		ik=round(tk(ind2)/dt2)+1;
		for kh=1:length(ik)
			trctmp(ik(kh))=trctmp(ik(kh))+ak(ind2(kh));
		end
	
		%amat(:,k)=amat(:,k) + resamp(trctmp,ttmp,dt);
		amat(:,k)=amat(:,k) + resample(trctmp,1,noversamp)/costheta;
	end
end
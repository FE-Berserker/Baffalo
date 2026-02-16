function amat=event_diph(amat,t,x,v,x0,x1,z0,theta,amp,flag,noversamp)
% EVENT_DIPH: construct a dipping event by diffraction superposition
%
% amat=event_diph(amat,t,x,v,x0,x1,z0,theta,amp,flag,noversamp)
%
% EVENT_DIPH inserts a dipping (linear) event in a matrix. The event
% is constructed from a superposition of hyperbolae. This is an exploding reflector simulation
% so your input velocity is divided by 2.
% EVENT_DIPH 在矩阵中插入一个倾伏（线性）事件。该事件由双曲线的叠加构成。
% 这是一个爆炸反射器模拟，因此输入速度除以2。
%
% amat ... the matrix of size nrows by ncols
% amat ... 矩阵，尺寸为 nrows x ncols（行数 x 列数）。
% t ... vector of length nrows giving the matrix t coordinates
% t ... 时间坐标向量，长度为 nrows。
% x ... vector of length ncols giving the matrix x coordinates
% x ... 空间坐标向量，长度为 ncols。
% v ... velocity (scalar)
% v ... 速度（标量）。
% x0 ... starting x coordinate of the event
% x0 ... 事件的起始 x 坐标。
% x1 ... ending x coordinate of the event
% x1 ... 事件的结束 x 坐标。
% z0 ... starting depth of the event
% z0 ... 事件的起始深度。
% theta ... dip (degrees) of the event
% theta ... 事件的倾角（度）。
% amp ... vector of length 2 giving the amplitudes at either end of the event. Intermediate
%       amplitudes are interpolated in x. Can be a single number if constant amplitude is desired.
% amp ... 长度为 2 的向量，给出事件两端的振幅。中间振幅在 x 方向进行插值。
%       如需恒定振幅，可输入单个数值。
% flag ... if 1, then amplitudes are divided by cos(theta), otherwise no effect
% flag ... 如果为 1，振幅除以 cos(theta)，否则无影响。
%      ******** default = 1 *********
%      ******** 默认值 = 1 *********
% noversamp ... each output trace is created by nearest-neighbor interpolation into
%		a temporary over-sampled trace that is then properly resampled. The greater the
%		oversampling, the better the result.
% noversamp ... 每条输出道通过最近邻插值创建到临时过采样道中，然后进行适当重采样。
%		过采样倍数越高，结果越好。
%      ******** default = 10 *********
%      ******** 默认值 = 10 *********

% END TERMS OF USE LICENSE

if(nargin<11); noversamp=10; end % 默认过采样倍数
if(nargin<10); flag=1; end % 默认flag值

%loop over columns
% 遍历列
%nc= between(xlims(1),xlims(2),x,2);
nc=size(amat,2);

v=v/2;%exploding reflector % 爆炸反射器，速度除以2

if(isscalar(amp)); amp=[amp amp]; end % 如果amp为标量，扩展为向量

%determine the origins of the hyperbolae % 确定双曲线的原点
ind=between(x0,x1,x,2);
if(x0>x1); ind=fliplr(ind); end
if(~ind); error('check x coordinates'); end
xnot=zeros(size(ind));znot=xnot;tnot=xnot; % 初始化双曲线原点坐标和时间
xnot(1)=x(ind(1));znot(1)=z0;tnot(1)=znot(1)/v;
dx=sign(x1-x0)*(x(2)-x(1)); % x方向步长
for k=2:length(ind)
	xnot(k)=x(ind(k));
	znot(k)=znot(k-1)+dx*tan(pi*theta/180); % 根据倾角计算深度
	tnot(k)=znot(k)/v; % 计算到达时间
end	

%interpolate new locations % 插值新位置
%this is inefficient but who cares % 效率不高但无所谓
dxnew=dx*cos(pi*theta/180); % 沿倾角方向的新步长
xnew=xnot(1):dxnew:xnot(end);
znew=interp1(xnot,znot,xnew); % 线性插值深度

xnot=xnew;
znot=znew;
tnot=znot/v; % 更新时间坐标	

anot=amp(1)+(xnot-x0)*(amp(2)-amp(1))/(x1-x0); % 线性插值振幅

tmin=t(1);
tmax=t(length(t));
dt=t(2)-t(1);
dt2=dt/noversamp; % 过采样时间间隔
ttmp=tmin:dt2:tmax; % 过采样时间向量

costheta=1;
if(flag==1); costheta=cos(pi*theta/180); end % 计算cos(theta)因子

for k=1:nc %loop over traces % 遍历每道
    trctmp=zeros(size(ttmp))'; % 初始化临时道
    tk=sqrt(tnot.^2+((x(k)-xnot)/v).^2);%diffraction arrival time % 绕射到达时间
    ak=anot.*tnot.*(tk.^(-1.5));%empirical amplitude % 经验振幅公式
    ind2=between(tmin,tmax,tk); % 检查时间是否在范围内
    if(ind2~=0)
        ik=round(tk(ind2)/dt2)+1; % 转换为过采样索引
        for kh=1:length(ik)
            trctmp(ik(kh))=trctmp(ik(kh))+ak(ind2(kh)); % 叠加振幅
        end
        trctmp2=resamp(trctmp,ttmp,dt,[min(t) max(t)],0); % 重采样到原时间轴
%         trctmp3=(trctmp2-min(trctmp2)+min(trctmp))*(max(trctmp)-min(trctmp));
        trctmp3=trctmp2;
        amat(:,k)=amat(:,k) + trctmp3/costheta; % 添加到矩阵并应用cos(theta)因子
        %amat(:,k)=amat(:,k) + resample(trctmp,1,noversamp)/costheta;
    end
end
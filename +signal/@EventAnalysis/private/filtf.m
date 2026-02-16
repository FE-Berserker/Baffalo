function trout=filtf(trin,t,fmin,fmax,phase,max_atten)
% FILTF: apply a bandpass filter to a trace
% FILTF: 对轨迹应用带通滤波器
%
% trout=filtf(trin,t,fmin,fmax,phase,max_atten)
% trout=filtf(trin,t,fmin,fmax,phase)
% trout=filtf(trin,t,fmin,fmax)
%
% FILTF filters the input trace in the frequency domain.
% FILTF 在频域对输入轨迹进行滤波。
% Trin is automatically padded to the next larger power of
% two and the pad is removed when passing trout to output.
% Trin 自动填充到下一个较大的2的幂次，并在输出 trout 时移除填充。 
% Filter slopes are formed from Gaussian functions.
% 滤波器斜坡由高斯函数形成。
%
% trin= input trace
%    输入轨迹
% t= input trace time coordinate vector
%    输入轨迹的时间坐标向量
% fmin = a two element vector specifying:
%        fmin(1) : 3db down point of filter on low end (Hz)
%        fmin(2) : gaussian width on low end
%   note: if only one element is given, then fmin(2) defaults
%         to 5 Hz. Set to [0 0] or just 0 for a low pass filter
%    两元素向量，指定：
%        fmin(1) : 低端3dB下降点（Hz）
%        fmin(2) : 低端高斯宽度
%   注意：如果只给出一个元素，则 fmin(2) 默认为5Hz。
%         设置为 [0 0] 或仅为0 表示低通滤波器  
% fmax = a two element vector specifying:
%        fmax(1) : 3db down point of filter on high end (Hz)
%        fmax(2) : gaussian width on high end
%   note: if only one element is given, then fmax(2) defaults
%         to 10% of Fnyquist. Set to [0 0] or just 0 for a high pass filter.
%    两元素向量，指定：
%        fmax(1) : 高端3dB下降点（Hz）
%        fmax(2) : 高端高斯宽度
%   注意：如果只给出一个元素，则 fmax(2) 默认为奈奎斯特频率的10%。
%         设置为 [0 0] 或仅为0 表示高通滤波器。 
% phase= 0 ... zero phase filter
%       1 ... minimum phase filter
%  ****** default = 0 ********
%    0 ... 零相位滤波器
%       1 ... 最小相位滤波器
%  ****** 默认值 = 0 ********
% note: Minimum phase filters are approximate in the sense that
%  the output from FILTF is truncated to be the same length as the
%  input. This works fine as long as the trace being filtered is
%  long compared to the impulse response of your filter. Be wary
%  of narrow band minimum phase filters on short time series. The
%  result may not be minimum phase.
% 注意：最小相位滤波器是近似的，因为 FILTF 的输出被截断为与输入相同的长度。
%      只要被滤波的轨迹相对于滤波器的脉冲响应足够长，这就能正常工作。
%      对短时间序列使用窄带最小相位滤波器时要小心。结果可能不是最小相位。
% 
% max_atten= maximum attenuation in decibels
%   ******* default= 80db *********
%    最大衰减（分贝）
%   ******* 默认值= 80db *********
%
% trout= output trace
%    输出轨迹
 
% set defaults
% 设置默认值
 if nargin < 6
   max_atten=80.;            % 默认最大衰减80dB
 end
 if nargin < 5
   phase=0;                  % 默认零相位
 end
 if length(fmax)==1
   fmax(2)=.1/(2.*(t(2)-t(1)));  % 默认高端宽度为奈奎斯特频率的10%
 end
 if length(fmin)==1
   fmin(2)=5;                % 默认低端宽度5Hz
 end
% HDG need error message for fmin(1) > fmax(1)
% convert to column vectors
% 转换为列向量
[rr,cc]=size(trin);
trflag=0;
nt=length(t);
if rr~=nt && cc==nt
  trin=trin';
  trflag=1;
elseif(rr~=nt&&cc~=nt)
  warning('time vector length not found in input matrix dimensions, filtering columns'); 
end
dbd=3.0; % this controls the dbdown values of fmin and fmax
        % 控制 fmin 和 fmax 的dB下降值
%HDG save and remove the mean value of the trace
%HDG 保存并移除轨迹的均值
  nt=size(trin,1);
  trinDC=ones(nt,1)*sum(trin)/nt;
  trin=trin-trinDC;
% forward transform the trace
% 轨迹前向变换
  trin=padpow2(trin);
  %trin=crewes.utilities.padpow2(crewes.utilities.padpow2(trin,1),1);
  t=(t(2)-t(1))*(0:nt-1);
  [Trin,f]=fftrl(trin,t);
  nf=length(f);
  df=f(2)-f(1);
% design low end gaussian
% 设计低端高斯函数
  if fmin(1)>0
   fnotl=fmin(1)+sqrt(log(10)*dbd/20.)*fmin(2);
%HDG commented out, otherwise fmin(1) is not 3 dbd point
%   fnotl= round(fnotl/df)*df;
   gnot=10^(-abs(max_atten)/20.);%abs used here in case max_atten is input as negative
                                 % 使用abs以防max_atten输入为负值
   glow=gnot+gauss(f,fnotl,fmin(2));
%HDG added to force mean to zero
%HDG 添加以强制均值为零
%HENRY min phase blows up if glow(1) is 0
%HENRY 如果glow(1)为0，最小相位会爆炸
  if phase ~= 1
   glow(1)=0;
  end
  else
   glow=0;
   fnotl=0;
  end
% design high end gaussian
 if fmax(1)>0
  fnoth=fmax(1)-sqrt(log(10)*dbd/20.)*fmax(2);
  if(fnoth<0)%sometimes with a very broad rolloff fnothigh can become negative
      % 有时下降率很宽时，fnoth可能为负
      fnoth=0;
  end
%HDG commented out, otherwise fmax(1) is not 3dbd point
%  fnoth= round(fnoth/df)*df;
  gnot=10^(-max_atten/20.);
  ghigh=gnot+gauss(f,fnoth,fmax(2));
 else
  ghigh=0;
  fnoth=0;
 end
% make filter
% 构造滤波器
  fltr=ones(size(f));
%HDG change to floor and ceil from round
%HDG 将round改为floor和ceil
  nl=floor(fnotl/df);     % 低端截止点索引
  nh=ceil(fnoth/df);      % 高端截止点索引
  if nl==0
    fltr=[fltr(1:nh);ghigh(nh+1:length(f))];
  elseif nh==0
%HDG change from fltr=[glow(1:nl-1);fltr(nl:length(f))];
    fltr=[glow(1:nl+1);fltr(nl+2:length(f))];
  else
%HDG change from fltr=[glow(1:nl-1);fltr(nl:nh);ghigh(nh+1:length(f))];
%HDG tried this but it didn't work if nh<nl
%    fltr=[glow(1:nl+1);fltr(nl+2:nh);ghigh(nh+1:length(f))];
    fltr=[glow(1:nl+1);fltr(nl+2:nf)].*[fltr(1:nh);ghigh(nh+1:length(f))];
    fltr=fltr/max(abs(fltr));
  end
% make min phase if required
% 如果需要，制作最小相位
  if phase==1
    L1=1:length(fltr);L2=length(fltr)-1:-1:2;
    symspec=[fltr(L1);conj(fltr(L2))];
    cmpxspec=log(symspec)+1i*zeros(size(symspec));
    fltr=exp(conj(hilbm(cmpxspec)));
  end
% apply filter
% 应用滤波器
  trout=ifftrl(Trin.*(fltr(1:length(f))*ones(1,size(Trin,2))),f);
  if(size(trout,1)~=nt);
    win=mwindow(nt,10);%in this case we are truncating so a taper is needed
                                          % 此时我们正在截断，因此需要锥度
    trout=trout(1:nt,:).*win(:,ones(1,size(trout,2)));
  end
%HDG return the mean if low pass only, removing any residual mean from
%truncation after zero padding
%HDG 如果仅低通则返回均值，移除零填充截断后的任何残差均值
  trinDC=trinDC*abs(fltr(1));
  troutDC=ones(nt,1)*sum(trout)/nt;
  trout=trout-troutDC+trinDC;
  if(trflag)
	trout=trout';
  end
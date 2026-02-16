function [trout,tout]=stat(trin,t,dt,flag)
% STAT: static shift a trace
% STAT: 对轨迹进行静校正（时移）
% [trout,tout]=stat(trin,t,dt,flag)
% [trout,tout]=stat(trin,t,dt)
%
% STAT time shifts a time series by dt seconds.
%   A sample at time t on input will be at t+dt on output
% STAT 将时间序列时移 dt 秒。输入时间 t 处的样本在输出中位于 t+dt
%
% trin= tinput trace or trace gather (if a gather, then one trace per
%       column)
%       输入轨迹或轨迹道集（如果是道集，则每列一条轨迹）
% t= time coordinate vector for trin
%    trin 的时间坐标向量
% dt = static shift in seconds (either a single value or one entry per trace)
%      静校正时移（秒）（可以是单个值，也可以是每条轨迹一个值）
% flag = 0 ... the time coordinate of trout will equal that of trin
%               (means the shifted trace loses samples off the beginning or
%               the end)
%      = 1 ... the time coordinate of trout will be
%               0<= tout <= max(t)+dt ... dt>0.0
%               -dt <= tout <= max(t) ... dt<0.0
%   (the shifted trace grows in size and retains all input samples)
%   ************** default = 0 *************
% NOTE: if a gather is input, then only flag=0 is implemented
%
% trout= time shifted output trace
% tout = time coordinate of output trace

if nargin<4, flag=0; end       % 默认flag=0
[nr,nc]=size(trin);
ntraces=1;
if((nr-1)*(nc-1)~=0)
    ntraces=nc;                  % 检测到多轨迹输入
%     error('STAT can handle only one trace at a time');
end
if(nr==1)
   trin=trin(:);                % 强制转为列向量
end
if(ntraces>1)
    %gather
    % 道集处理
    if(isscalar(dt))
        dt=dt*ones(1,ntraces);     % 扩展dt为向量
    elseif(length(dt)~=ntraces)
        error('there must be one static per trace')
    else
        dt=dt(:)';                % 确保为行向量
    end
    % pad trin
    nt=size(trin,1);               % 原始长度
      %lt= length(trin);
    nstat= abs(ceil(dt/(t(2)-t(1))));
    tmp=trin(:,1);
    while length(tmp)<=nt+nstat, tmp=padpow2(tmp,1); end  % 填充到2的幂次
    trin=[trin;zeros(length(tmp)-nt,ntraces)];  % 填充零
    t=(0:length(trin)-1)'*(t(2)-t(1))+t(1);  % 扩展t以考虑填充
    % fft
    [Trin,f]=crewes.seismic.fftrl(trin,t);  % 前向傅里叶变换
    % phase shift
    shiftr=exp(-1i*2.*pi*f*dt);    % 相位因子
    Trout=Trin.*shiftr;             % 应用相位移动
    % inverse fft
    trout=crewes.seismic.ifftrl(Trout,f);  % 逆傅里叶变换
    %
%remove pad
      trout=trout(1:nt,:);          % 移除填充部分
      tout=t(1:nt);                % 恢复原始时间坐标
else
    %single trace
    % 单条轨迹处理
        % pad trin
      nt=length(trin);                % 原始长度
      %lt= length(trin);
     nstat= abs(ceil(dt/(t(2)-t(1))));
     while length(trin)<=nt+nstat, trin=padpow2(trin,1); end  % 填充到2的幂次
     t=(0:length(trin)-1)'*(t(2)-t(1))+t(1);  % 扩展t以考虑填充
    % fft
     [Trin,f]=fftrl(trin,t);  % 前向傅里叶变换
%     Trin=fft(trin);
%     f=freqfft(t,[],1)';
    % phase shift
%
% apply a low-pass filter to reject frequencies hight than .9 of Nyquist because these
% don't behave well. shiftr is a linear phase shift combined with a zero
% phase lowpass.
%
% 应用低通滤波器以拒绝高于奈奎斯特频率0.9倍的频率，因为这些频率表现不佳。
% shiftr 是线性相位移动与零相位低通的组合。
%
     shiftr=exp(-1i*2.*pi*dt*f).*filtspec(t(2)-t(1),max(t)-t(1),[0 0],[.9*max(f) .1*max(f)],0,40);
%      shiftr=exp(-1i*2.*pi*dt*f).*sigmoid_window(f,.9*max(f),2);
     Trout=Trin.*shiftr;           % 应用相位移动
     Trout(end)=real(Trout(end));    % 强制最后一个点为实数
    % inverse fft
     trout=ifftrl(Trout,f);  % 逆傅里叶变换
%     trout=real(ifft(Trout));
    %
     if flag==0
      trout=trout(1:nt);           % 保留原始长度
      tout=t(1:nt);               % 恢复原始时间坐标
     else
      if dt>=0
        if(nstat+nt<length(trout))
            trout=trout(1:nstat+nt);    % 扩展轨迹以包含新增样本
        end
        tout=(0:length(trout)-1)'*(t(2)-t(1));
      else
        nt2=length(trout);
        trout=[trout(nt2-nstat+1:nt2);trout(1:nt)];  % 重新排列以处理负时移
        tout=(0:length(trout)-1)'*(t(2)-t(1))+(-nstat+1)*(t(2)-t(1));
      end
     end
     if(nr==1)
         trout=trout';              % 转换为行向量
         tout=tout';
     end
end
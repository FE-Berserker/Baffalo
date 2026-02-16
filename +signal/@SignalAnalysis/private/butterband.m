function sf=butterband(s,t,fmin,fmax,n,phase)
% BUTTERBAND ... Butterworth带通、高通和低通滤波
%
% sf=butterband(s,t,fmin,fmax,n,phase)
%
% BUTTERBAND使用Matlab的BUTTER命令来设计和应用Butterworth滤波器。
% BUTTER包含在SIGNAL工具箱中，因此只有拥有该工具箱时才能使用。
% 滤波器可以是最小相位或零相位，尽管它天然是最小相位的。
% 要生成零相位，最小相位滤波器需正向和反向各应用一次。
% 因此，实际上零相位滤波器的阶数（n）是最小相位的两倍。
% 滤波器可以是带通、高通或低通。
%
% s ... 地震道或道集（每列一道）。
% t ... s的时间坐标向量
% fmin ... 滤波器低截频，输入0表示低通滤波器
% fmax ... 滤波器高截频，输入0表示高通
% n ... Butterworth阶数。高阶数意味着更大的衰减但可能
%       引起更多令人不快的时间域振荡。
%   推荐：零相位用4，最小相位用8
% ******* 默认 n=4 ********
% phase ... 1表示最小相位，0表示零相位
% ******* 默认 =0 *********
%
% sf ... 输出的滤波道。大小与s相同。

if(nargin<6)
    phase=0;
end
if(nargin<5)
    n=4;
end

[nr,nc]=size(s);
nt=length(t);
trunc=0; % 是否转置标志
if(nc==nt && nr==1)
    s=s.';
    trunc=1;
elseif(nc==nt && nr>1)
    error('多道应存储在列中')
elseif(nr~=nt && nc~=nt)
    error('t和s的大小不兼容'); 
end

if(phase~=1 && phase ~=0)
    error('无效的标志');
end
dt=t(2)-t(1); % 时间采样间隔
fn=.5/dt; % 奈奎斯特频率
if(fmin>fn || fmin<0)
    error('无效的fmin指定值')
end
if(fmax>fn || fmax<0)
    error('无效的fmax指定值')
end

if(n<0)
    error('无效的Butterworth阶数')
end



W1=fmin/fn;
W2=fmax/fn;
if(W1==0)
    [B,A]=butter(n,W2,'low');
elseif(W2==0)
    [B,A]=butter(n,W1,'high');
else
    [B,A]=butter(n,[W1 W2]);
end
if(phase==0)
    sf=filtfilt(B,A,s);
elseif(phase==1)
    sf=filter(B,A,s);
end

if(trunc)
    sf=sf.';
end
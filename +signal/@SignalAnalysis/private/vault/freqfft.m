function f=freqfft(t,n,flag)

% f=freqfft(t,n,flag)
% f=freqfft(t,[],flag)
% f=freqfft(t);
%
% 返回时间序列s的适当频率坐标向量，其频谱S通过以下方式计算：
% S= fftshift(fft(s,n)) （大致如此，详见flag参数）
%
% t= 与s对应的输入时间坐标向量
% n= FFT的填充长度
% ******** 默认 n=length(t) ***********
% flag ... 如果为0，返回未平移的f向量（f=0在中心，值在-Nyquist到Nyquist之间）
%          如果为1，返回平移后的f向量（f=0是第一个采样点，值在-Nyquist到Nyquist之间）
%          如果为2，返回平移后的f向量（f=0是第一个采样点，值在0到2*Nyquist之间）
%   ******* 默认为0 *******
% f= 输出频率向量

% 设置默认值
if nargin==1
    n=length(t);
end
if(isempty(n))
    n=length(t);
end
%
% 如果未提供flag参数，设置默认值为0
if(nargin<3)
    flag=0;
end
% 计算时间采样间隔
dt=abs(t(2)-t(1));
% 计算奈奎斯特频率
fnyq=.5/dt;
% df=2.*fnyq/n;

% 计算频率分辨率
df=1/(n*dt);
if(floor(n/2)*2==n)
   % 偶数情况：n为偶数
   f1=(0:n/2)*df;    % 正频率部分
   f=[-fliplr(f1(2:end)) f1(1:end-1)];  % 构建对称频率向量
else
   % 奇数情况：n为奇数
   f1=df*(0:(n-1)/2); % 正频率部分
   f=[-fliplr(f1(2:end)) f1];  % 构建对称频率向量
end
% flag=1: 将零频率移到第一个位置（平移格式）
if(flag==1)
    ind=find(f==0);
    f=[f(ind:end) f(1:ind-1)];
% flag=2: 将零频率移到第一个位置，负频率部分平移为0到2*Nyquist之间
elseif(flag==2)
    ind=find(f==0);
    f=[f(ind:end) 2*fnyq+f(1:ind-1)];
end

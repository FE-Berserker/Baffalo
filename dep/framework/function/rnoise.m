function noise=rnoise(v,s_to_n,irange,flag)
% RNOISE ... create a random noise signal with a given s/n
% RNOISE ... 创建具有给定信噪比的随机噪声信号
%
% noise= rnoise(v,s_to_n,irange,flag)
% noise= rnoise(v,s_to_n,irange)
% noise= rnoise(v,s_to_n)
% noise= rnoise(v)
%
% returns a vector of zero mean pseudo random noise
% of the same dimensions as v.
% 返回一个与 v 维度相同的零均值伪随机噪声向量
%
% v= input signal vector used to determine the dimensions
%    of the noise vector and the rms signal level.
%    输入信号向量，用于确定噪声向量的维度和信号均方根电平
% s_to_n= desired signal to noise level (rms). Rnoise measures
%         rms amplitude of v and sets the standard deviation of the
%         noise as: noise_rms = signal_rms/s_to_n
%      ******* default = 2 *******
%         期望的信噪比（均方根）。Rnoise 测量 v 的均方根幅度，
%         并设置噪声的标准差为：noise_rms = signal_rms/s_to_n
%      ******* 默认值 = 2 *******
% irange= vector of indicies pointing to the range of v over
%         which the signal is to be measured. For example, '1:50'
%         would use the first 50 samples, or near(t,.72,.99) would
%         use the time zone from .72 to .99 (assuming t is the time
%         coordinate for v)
%      ********* default= 1:length(v) ********
%         指向 v 中测量范围的索引向量。例如，'1:50' 将使用
%         前 50 个样本，或 near(t,.72,.99) 将使用 0.72 到 0.99
%         的时间区间（假设 t 是 v 的时间坐标）
%      ********* 默认值= 1:length(v) ********
% flag= 1 ... noise is normally distributed
%       0 ... noise is uniformly distributed
%      ******** default = 1 *******
%         1 ... 噪声服从正态分布
%       0 ... 噪声服从均匀分布
%      ******** 默认值 = 1 *******


% 设置默认值
 if nargin<4
   flag=1;              % 默认正态分布
 end
 if nargin<3
   irange=1:length(v);  % 默认全部范围
 end
 if nargin<2
   s_to_n=2;             % 默认信噪比为2
 end
 if nargin<4
   flag=1;
 end
 if nargin<3
   irange=1:length(v);
 end
 if nargin<2
   s_to_n=2;
 end
% 
%  done=0;
%  if flag==1
%   done=1;
%  end
%  if flag==0
%    done=1; 
%  end
%  if done==0
%    error(' invalid flag');
%  end
%
 c=clock;                 % 获取系统时钟
 n=fix(10.*c(6));        % 生成随机数种子
 if flag == 1            % 正态分布
    %randn('seed',n);
    noise=randn(size(v)); % 生成标准正态分布噪声
 end
 if flag == 0            % 均匀分布
	%rand('seed',n);
    noise=rand(size(v));  % 生成均匀分布噪声
    % adjust to zero mean
    noise=noise-mean(noise);  % 调整为零均值
 end  


% measure signal and noise powers
% 测量信号和噪声功率
 [m,n]=size(v);
 if m==1
   ps= sqrt(v(irange)*v(irange)');   % 计算信号的均方根
   pn= sqrt(noise(irange)*noise(irange)');  % 计算噪声的均方根
   scalar= ps/(pn*s_to_n);            % 计算缩放因子
 end
 if n==1
   ps= sqrt(v(irange)'*v(irange));    % 计算信号的均方根
   pn= sqrt(noise(irange)'*noise(irange));  % 计算噪声的均方根
   scalar= ps/(pn*s_to_n);            % 计算缩放因子
 end
% adjust noise power
% 调整噪声功率
 noise=noise*scalar;                  % 应用缩放因子


 
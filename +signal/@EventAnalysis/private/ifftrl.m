function [r,t]= ifftrl(spec,f)
% IFFTRL 实值时间序列的逆傅里叶变换 / inverse Fourier transform for real time series
%
% [r,t]= ifftrl(spec,f)
%
% 将频谱逆变换为实值时间序列。频谱长度应为 floor(n/2+1)，其中 n 是输出时间序列长度
% (如果使用 fftrl 生成频谱，则自动满足此条件)。


% 检测输入维度 / Test for matrix or vector
[m,n1,n2]=size(spec);  % m=频率样本数, n1=道数(2D), n2=额外维度(3D)
itr=0;  % 转置标志，用于处理行向量输入
% 判断是否为向量 / Test for vector
if( ~(m-1)*(n1-1) )  % 如果是向量（m=1或n1=1）
	if(m==1); spec=spec.'; itr=1; end  % 行向量转为列向量
	nsamps=length(spec);  % 频率样本数
	nx=1;  % 单道
    ny=1;
else
    % 数组输入(2D或3D) / We have an array
	nsamps=m;  % 频率样本数
	nx=n1;     % 道数
    ny=n2;     % 额外维度
end

% 构造 ifft 需要的共轭对称频谱 / Form conjugate symmetric spectrum for ifft
% 检测奈奎斯特频率样本是否存在 / Test for presence of nyquist
nyq=0;  % 奈奎斯特标志
rnyq=real(spec(end));  % 最后一个样本的实部
inyq=imag(spec(end));  % 最后一个样本的虚部
small=100*eps;  % 数值容差
% 判断是否为奈奎斯特频率（虚部近似为零）
if(rnyq==0 && inyq==0) nyq=1;
elseif(rnyq==0 && abs(inyq)<small) nyq=1;
elseif(rnyq==0) nyq=0;
elseif(abs(inyq/rnyq)<small) nyq=1;
end
%if(isreal(spec(end))) nyq=1; end
% 根据奈奎斯特标志构建对称索引
if(nyq)
    % 有奈奎斯特：正频率1:nsamps，负频率nsamps-1:-1:2（排除奈奎斯特重复）
    L1=1:nsamps;L2=nsamps-1:-1:2;
else
    % 无奈奎斯特：正频率1:nsamps，负频率nsamps:-1:2
    L1=1:nsamps; L2=nsamps:-1:2;
end

% 构建共轭对称频谱：正频率 + 负频率的共轭
symspec=[spec(L1,:,:);conj(spec(L2,:,:))];

% 执行逆傅里叶变换，取实部 / Transform and force real result
 r=real(ifft(symspec));

% 构建时间向量 / Build the time vector
 n=size(r,1);        % 时间样本数
 df=f(2)-f(1);       % 频率采样间隔
 dt=1/(n*df);        % 时间采样间隔 (由 df * dt = 1/n 推导)

 t=dt*(0:n-1)';      % 时间向量从0开始
 
 % 如果输入是行向量，输出也转为行向量
 if(itr==1)
 	r=r.';
    t=t';
 end
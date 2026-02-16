function [spec,f]= fftrl(s,t,percent,npad)
% FFTRL: forward Fourier transform for real-valued signals.
% FFTRL: 实值信号的前向傅里叶变换
%
% [spec,f]= fftrl(s,t,percent,npad)
% [spec,f]= fftrl(s,t,percent)
% [spec,f]= fftrl(s,t)
%
% Forward fourier transform of a real-valued signal. Relative to
% MATLAB's fft it returns only the positive frequencies in an array
% roughly half the size. If there are n input time samples, then there
% will be floor(n/2+1) frequency samples. This means that if n is an even
% number, then a time series of length n and one of length n+1 will produce
% frequency spectra of the same length. However, only the first case will
% have a sample at Nyquist. If the input trace is a vector, then the return
% is simply the transform of that vector. If a matrix, then each
% column of the matrix is transformed. The inverse is accomplished by
% IFFTRL.
% 实值信号的前向傅里叶变换。与 MATLAB 的 fft 相比，它仅返回正频率部分，
% 数组大小约为原来的一半。如果有 n 个输入时间样本，则将有 floor(n/2+1) 个
% 频率样本。这意味着如果 n 是偶数，长度为 n 的时间序列和长度为 n+1 的时间
% 序列将产生相同长度的频谱。但只有第一种情况会在奈奎斯特频率处有采样点。
% 如果输入轨迹是向量，则返回该向量的变换。如果是矩阵，则变换矩阵的每一列。
% 逆变换由 IFFTRL 完成。
% NOTE: FFTRL, like fft, uses the + sign in the complex Fourier
% exponential, while ifftrl uses the - sign and divides by n.
% 注意：FFTRL 与 fft 一样，在复数傅里叶指数中使用 + 号，而 ifftrl 使用 - 号并除以 n。
%
% s= input signal (trace or gather, i.e. vector or matrix or 3D array)
%    输入信号（轨迹或道集，即向量、矩阵或三维数组）
% t= input time coordinate vector
%    输入时间坐标向量
% percent= specifies the length of a raised cosine taper to be
%          applied to s (both ends) prior to any padding.
%          Taper is a percent of the length of s. Taper is
%          applied using MWINDOW.
%         ********** Default=0% ***********
%          指定在填充前应用于 s（两端）的升余弦锥度长度。
%          锥度为 s 长度的百分比。使用 MWINDOW 应用锥度。
%         ********** 默认值=0% ***********
% npad= length (in samples) to which the input trace is to be padded with zeros.
%     ********** Default is the input length (no pad) ***********
% NOTE: a value of 0 for npad is taken to mean no pad is desired.
%      输入轨迹填充零的长度（以样本为单位）。
%      ********** 默认为输入长度（不填充） ***********
% 注意：npad 为 0 表示不需要填充。
%  
% spec= output spectrum
%      输出频谱
% f= output frequency sample vector
%    输出频率采样向量

 
% set defaults
% 设置默认值
 if(nargin<4)
		npad=length(t);
 else
     if(npad==0)
         npad=length(t);
     end
 end
 if(nargin<3)
   percent=0.0;
 end

% determine number of traces in ensemble
% 确定道集中的轨迹数量
 [l,m1,m2]=size(s);
 nx=1;
 ny=1;
 %test for row vector
 % 测试是否为行向量
 itr=0; %transpose flag 转置标志
 if(l==1 && m2==1)
     nsamps=m1; itr=1; s=s(:); %switch to column vectors 切换为列向量
 elseif(m1==1 && m2==1) 
     nsamps=l;
 elseif(m1~=1)
 	nsamps=l; nx=m1; ny=m2;
 else
     error('unrecognizable data array')
 end
 if(nsamps~=length(t))
		t=t(1)+(t(2)-t(1))*(0:nsamps-1);
        if(nargin<4)
            npad=nsamps;
        end
	%error(' time vector and trace matrix don''t match in length');
 end
 
% apply the taper
% 应用锥度窗
 if(percent>0)
	 mw=mwindow(nsamps,percent);
	 mw=mw(:,ones(1,nx),ones(1,ny));
	 s=s.*mw;
	 clear mw
 end
% pad s if needed : NOT NEEDED, fft will pad
% 如需填充 s：不需要，fft 会自动填充
%  if (nsamps<n),
% 	s=[s;zeros(n-nsamps,ntraces)];
%   	nsamps=n; 
%  end

% transform the array
% 变换数组
	spec=fft(s,npad);
    spec=spec(1:floor(npad/2+1),:,:);% save only the positive frequencies 仅保存正频率
	clear s;
    
% build the frequency vector
% 构建频率向量
fnyq=1. / (2*(t(2)-t(1)));  % Nyquist frequency 奈奎斯特频率
 nf=size(spec,1);
 df=2*fnyq/npad;  % frequency interval 频率间隔
 %f=linspace(0.,fnyq,nf)';
 f=df*(0:nf-1)';
 
 if(itr)
 	f=f';
 	spec=spec.';
 end
function [tfr,Te,GD,TEO] = TETransform(x,hlength)
%   Transient-extracting transform
%   瞬态提取变换
%   Input
%	x       : Signal.
%	hlength : Window length.
%   输入
%	x       : 信号
%	hlength : 窗长度

%   Output
%	tfr   :  STFT Representation.
%	Te    :  TET Representation.
%	GD    :  2D  group delay.
%	TEO   :  Transient-extracting operator.
%   输出
%	tfr   : 短时傅里叶变换（STFT）表示
%	Te    :  TET 表示
%	GD    :  2D 群延迟
%	TEO   :  瞬态提取算子

%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
%
%   Written at 2017.3.17.

[xrow,xcol] = size(x);

N=xrow;

if (xcol~=1)
 error('X must be column vector');
end

if (nargin < 2)
 hlength=round(xrow/8);            % 默认窗长度为信号长度的1/8
end

t=1:N;
%ft = 1:round(N/2);

[~,tcol] = size(t);

hlength=hlength+1-rem(hlength,2);
ht = linspace(-0.5,0.5,hlength);ht=ht';

% Gaussian window
% 高斯窗
h = exp(-pi/0.32^2*ht.^2);

% Window tg(t)
% 窗 tg(t)
th=h.*ht;
[hrow,~]=size(h); Lh=(hrow-1)/2;

tfr1= zeros (N,tcol);
tfr2= zeros (N,tcol);

for icol=1:tcol
ti= t(icol); tau=-min([round(N/2)-1,Lh,ti-1]):min([round(N/2)-1,Lh,xrow-ti]);
indices= rem(N+tau,N)+1;
rSig = x(ti+tau,1);
tfr1(indices,icol)=rSig.*conj(h(Lh+1+tau));
tfr2(indices,icol)=rSig.*conj(th(Lh+1+tau));
end

tfr1=fft(tfr1);
tfr2=fft(tfr2);

tfr1=tfr1(1:round(N/2),:);
tfr2=tfr2(1:round(N/2),:);

E=mean(abs(x));
omega= zeros(round(N/2),tcol);

for a=1:round(N/2)
omega(a,:) = t+(hlength-1)*real(tfr2(a,t)./tfr1(a,t));
end

GD=omega;
TEO=zeros(round(N/2),tcol);

for i=1:round(N/2)%frequency
for j=1:N%time
     if abs(tfr1(i,j))>12*E%
      if abs(omega(i,j)-j)<0.5%
        TEO(i,j)=1;            % 标记瞬态
      end
    end
end
end
tfr=tfr1/(xrow/2);%the amplitude of tfr result has been pre-rectified.
                    % tfr结果的幅值已预先整流
%tfr=tfr1/(sum(h)/2);%
Te=TEO.*tfr;              % 应用瞬态提取算子

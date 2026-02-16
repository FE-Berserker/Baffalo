function w = mwindow(n,percent)
% MWINDOW: creates an mwindow (boxcar with raised-cosine tapers)
% MWINDOW: 创建 Margrave 窗（两端带有升余弦锥度的矩形窗）
%
% w = mwindow(n,percent)
% w = mwindow(n)
%
% MWINDOW returns the N-point Margrave window in a
% column vector. This window is a boxcar over the central samples
% round((100-2*percent)*n/100) in number, while it has a raised cosine
% (hanning style) taper on each end. If n is a vector, it is
% the same as mwindow(length(n))
% MWINDOW 以列向量的形式返回 N 点 Margrave 窗。该窗在中心样本
% round((100-2*percent)*n/100) 个点为矩形窗，而两端各有一个
% 升余弦（汉宁风格）锥度。如果 n 是向量，则等同于 mwindow(length(n))
%
% n= input length of the mwindow. If a vector, length(n) is
%    used
%    Margrave 窗的输入长度。如果是向量，则使用 length(n)
% percent= percent taper on the ends of the window
%   ************* default=10 ************
%          窗两端锥度的百分比
%          ************* 默认值=10 ************


% set defaults
% 设置默认值
 if nargin<2
  percent=10;
 end
 if length(n)>1
   n=length(n);
 end
% compute the Hanning function
% 计算汉宁窗函数 
 if(percent>50)||(percent<0)
   error(' invalid percent for mwindow')
 end
 m=2.*percent*n/100.;           % 计算锥度总长度
 m=2*floor(m/2);                % 确保为偶数
 h=han(m);                      % 生成汉宁窗
 w = [h(1:m/2);ones(n-m,1);h(m/2:-1:1)];  % 组合窗：左锥度 + 中间矩形 + 右锥度

function w=han(n)                % 汉宁窗子函数

xint=2*pi/(n+1);                % 采样间隔
x=xint*(1:n)-pi;                % 生成从 -pi 到 pi 的采样点

w=.5*(1+cos(x))';              % 汉宁窗公式
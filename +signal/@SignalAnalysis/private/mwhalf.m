function w = mwhalf(n,percent)
% MWHALF: half an mwindow (boxcar with raised-cosine taper on one end)
% MWHALF: 半个 Margrave 窗（一端带有升余弦锥度的矩形窗）
%
% mwhalf(n,percent)
% mwhalf(n)
%
% MWHALF returns the N-point half-Margrave window in a
% row vector. This window is a boxcar over the first samples,
% (100-percent)*n/100 in number, while it has a raised cosine
% (hanning style) taper on the end. If n is a vector, it is
% the same as mwindow(length(n)
% MWHALF 以行向量的形式返回 N 点半 Margrave 窗。该窗在
% (100-percent)*n/100 个起始样本为矩形窗，而在末端有一个
% 升余弦（汉宁风格）锥度。如果 n 是向量，则等同于 mwindow(length(n))
%
% n= input length of the mwindow. If a vector, length(n) is
%    used
%    Margrave 窗的输入长度。如果是向量，则使用 length(n)
% percent= percent taper on the ends of the window
%   ************* default=10 ************
%          窗末端锥度的百分比
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
 if(percent>100)||(percent<0)
   error(' invalid percent for mwhalf')
 end
 m=floor(percent*n/100);         % 计算锥度长度
 h=han(2*m);                     % 生成汉宁窗（长度为锥度的2倍）
 h=h(:);                         % 转为列向量
 w = [ones(n-m,1);h(m:-1:1)];    % 组合窗：矩形 + 末端锥度

function w=han(n)                % 汉宁窗子函数

xint=2*pi/(n+1);                % 采样间隔
x=xint*(1:n)-pi;                % 生成从 -pi 到 pi 的采样点

w=.5*(1+cos(x))';              % 汉宁窗公式
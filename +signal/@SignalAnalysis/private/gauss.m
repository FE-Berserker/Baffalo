function g=gauss(f,fnot,fwidth)
% GAUSS: 返回在频率上采样的高斯分布
%
% g=gauss(f,fnot,fwidth)
%
% 返回在向量f中给定的频率点采样的高斯分布
%
% f= 输入频率向量
% fnot= 高斯分布的中心频率
% fwidth= 高斯分布的1/e宽度
% g= 输出的高斯分布
%
% 即 g=exp(-((f-fnot)/fwidth).^2);

% 计算高斯分布
g=exp(-((f-fnot)/fwidth).^2);
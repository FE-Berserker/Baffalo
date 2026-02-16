function ampspec=tntamp(fnot,f,m)
% TNTAMP: create an amplitude spectrum for an impulsive source
% TNTAMP: 创建脉冲源的振幅谱
%
% ampspec=tntamp(fnot,f)
%
% TNTAMP returns an amplitude spectrum appropriate for an impulsive
% source. The spectrum has the shape: ampspec=(1-gaus)./(1+(f/fnot).^m);
% where gauss=exp(-(f/fnot).^2).
% TNTAMP 返回适合脉冲源的振幅谱。频谱的形状为：ampspec=(1-gaus)./(1+(f/fnot).^m);
% 其中 gauss=exp(-(f/fnot).^2)。
%
% fnot ... the dominant frequency
%         优势频率（主频）
% f ... a frequency sample vector such as that created by fftrl.
%       频率采样向量，如由fftrl创建的向量
% m ... exponent in the denonimator controlling the spectral shape. Make m
%       larger for a sharper spectral rolloff at high frequencies.
%    ******* default = 2 *******.
%     分母中的指数，控制频谱形状。增大 m 可使高频端的频谱下降更陡峭。
%     ******* 默认值 = 2 *******

 if(nargin<3); m=2; end
 gaus=exp(-(f/fnot).^2);  % 高斯项
 ampspec=(1-gaus)./(1+(f/fnot).^m);  % 计算振幅谱
function [wavelet, tw] = ricker(dt, fdom, tlength)
% RICKER: 创建 Ricker 小波（墨西哥帽小波）
%
% [wavelet, tw] = ricker(dt, fdom, tlength)
% [wavelet, tw] = ricker(dt, fdom)
% [wavelet, tw] = ricker(dt)
%
% RICKER 返回一个 Ricker 小波。
%
% dt  = 期望的时间采样率 [秒]
% fdom = 主频 [Hz]（默认值: 15 Hz）
% tlength = 小波长度 [秒]（默认值: 127*dt，即 2 的幂）
%
% 小波从 Ricker 小波的模拟表达式生成，然后进行归一化处理。
% 归一化使得主频处的正弦波以单位振幅通过
%（详见 wavenorm.m）

%% 参数默认值处理
if nargin < 3
    tlength = 127 .* dt;  % 默认小波长度
end
if nargin < 2
    fdom = 15.;  % 默认主频
end

%% 创建时间向量
n = round(tlength / dt) + 1;
nzero = ceil((n + 1) / 2);  % 零时间样本在此处
nr = n - nzero;                   % nzero 右侧的样本数
nl = n - nr - 1;                 % nzero 左侧的样本数
tw = dt * (-nl:nr)';               % 以零为中心的时间向量

%% 解释时间向量结构
% 假设小波长度为 9 个样本。那么上面意味着
% 时间 0 处的样本是第 #5 个，nl = nr = 4。
% 如果有 8 个样本，那么时间 0 处的样本仍然是
% 第 5 个样本，但 nl = 4 且 nr = 3。

%% 创建小波（Ricker 模拟表达式）
pf = pi^2 * fdom^2;                      % 主频的平方乘以 π²
wavelet = (1 - 2 .* pf .* tw.^2) .* exp(-pf .* tw.^2);

%% 归一化小波
% 生成主频处的参考正弦波
wavelet = wavenorm(wavelet, tw, 2);

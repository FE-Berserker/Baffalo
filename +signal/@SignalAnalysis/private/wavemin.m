function [w, tw] = wavemin(dt, fdom, tlength, m, stab)
% WAVEMIN: 创建最小相位小波，用于脉冲震源
%
% [w, tw] = wavemin(dt, fdom, tlength, m, stab)
% [w, tw] = wavemin(dt, fdom, tlength, m)
% [w, tw] = wavemin(dt, fdom)
% [w, tw] = wavemin(dt)
%
% WAVEMIN 返回一个最小相位小波，它模拟了一个可能的
% 无噪声脉冲震源。函数使用 TNTAMP 生成一个合理的功率谱。
% 然后通过傅里叶逆变换转换为自相关序列，
% 该序列被输入到莱文森递归（LEVREC）。
% 最后，通过频域除法对莱文森递归的结果进行反转，
% 以获得最终的小波。小波被归一化处理，
% 使得主频处的正弦波以单位振幅通过。
%
% dt  = 期望的时间采样率 [秒]
% fdom = 主频 [Hz]
%        ******* 默认值: 15 Hz *******
% tlength = 小波长度 [秒]
%        ******* 默认值: 127*dt（即 2 的幂）*******
% m = 控制频谱形状的指数。详见 tntamp 描述。
%       较大的值使高频衰减更快。默认值是适度的衰减。
%       像是 10 或 12 这样的值将是极端的。
%       换句话说，m 的低值（如 2）给出一个非常宽带的小波，
%       很容易进行反褶积。高的数（如 7）是非常窄带的，
%       甚至可能不是真正的最小相位。详见下面的示例。
%       必须在 2 和 7 之间。
%       ************ 默认值 = 4 ************
% stab = 白噪声因子。为了稳定莱文森递归，
%       零滞后自相关乘以 (1+stab)。这对
%       大于 2 的 m 值很重要。
%       ************ 默认值 = .000001 **********
%


%% 参数默认值处理
if nargin < 5
    stab = .000001;  % 默认白噪声因子
end
if nargin < 4
    m = 4;  % 默认频谱形状指数
end
if m < 2 || m > 7
    error('m must lie between 2 and 7');
end
if nargin < 3
    tlength = 127 .* dt;  % 默认小波长度
end
if nargin < 2
    fdom = 15.;  % 默认主频
end

%% 调整主频以考虑 tntamp 的异常
switch round(m)
    case 2
        f0 = -0.0731;
        m0 = 1.0735;
        fdom2 = (fdom - f0) / m0;
    case 3
        f0 = 0.0163;
        m0 = 0.9083;
        fdom2 = (fdom - f0) / m0;
    case 4
        f0 = 0.0408;
        m0 = 0.8470;
        fdom2 = (fdom - f0) / m0;
    case 5
        f0 = -0.0382;
        m0 = 0.8282;
        fdom2 = (fdom - f0) / m0;
    case 6
        f0 = 0.0243;
        m0 = 0.8206;
        fdom2 = (fdom - f0) / m0;
    case 7
        f0 = 0.0243;
        m0 = 0.8206;
        fdom2 = (fdom - f0) / m0;
end

%% 创建时间向量
nt = round(2 .* tlength / dt) + 1;
nt = 2.^nextpow2(nt);  % 取最近的 2 的幂
tmax = dt * (nt - 1);
tw = 0 : dt : tmax;

%% 创建频率向量
fnyq = 1 ./ (2 * (tw(2) - tw(1)));
f = linspace(0., fnyq, length(tw) / 2 + 1);

%% 创建功率谱
tmp = tntamp(fdom2, f);
% tmp = (tmp / max(tmp)).^4;
powspec = tmp .^ 2;

%% 创建自相关序列
auto = ifftrl(powspec, f);
auto(1) = auto(1) * (1 + stab);  % 乘以稳定因子

%% 通过莱文森递归计算
nlags = round(tlength / dt) + 1;
b = [1.0, zeros(1, nlags - 1)]';
winv = levrec(auto(1:nlags), b);

%% 反转得到小波
w = real(ifft(1 ./ fft(winv)));

%% 创建时间向量
tw = dt * (0:length(w) - 1)';

%% 归一化小波
w = wavenorm(w, tw, 2);

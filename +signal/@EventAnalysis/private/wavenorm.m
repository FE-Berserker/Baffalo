function wnorm = wavenorm(w, tw, flag)
% WAVENORM: 归一化小波
%
% wnorm = wavenorm(w, tw, flag)
%
% WAVENORM 通过多种标准之一对一个小波进行归一化处理。
% 选择包括：(1) 将最大绝对值归一化到 1
%          (2) 使主频处的正弦波以单位振幅通过
%          (3) 将均方根（RMS）振幅归一化到 1。
%
% w  ... 输入小波
% tw ... w 的时间坐标向量
% flag ... (1) 将最大绝对值归一化到 1
%          (2) 使主频处的正弦波以单位振幅通过
%          (3) 将均方根振幅归一化到 1
%
%% 根据标志选择归一化方式
if flag == 1
    % 归一化方式 1: 将最大绝对值归一化到 1
    wnorm = w / max(abs(w));

elseif flag == 2
    % 归一化方式 2: 使主频处的正弦波以单位振幅通过
    % 计算频谱
    [W, f] = fftrl(w, tw);
    A = real(todb(W));  % 转换为分贝

    % 选取最大振幅对应的频率作为主频
    ind = find(A == max(A));
    fdom = f(ind(1));

    % 生成主频处的参考正弦波
    refwave = sin(2 * pi * fdom * tw);

    % 将参考正弦波与小波进行卷积（使用 convz）
    reftest = convz(refwave, w);
    % 计算归一化因子
    fact = max(refwave) / max(reftest);
    wnorm = w * fact;

elseif flag == 3
    % 归一化方式 3: 将均方根振幅归一化到 1
    rms_ave = norm(w) / sqrt(length(w));
    wnorm = w / rms_ave;

else
    error('invalid flag');
end

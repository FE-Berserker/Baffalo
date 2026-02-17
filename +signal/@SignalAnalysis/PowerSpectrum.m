function obj=PowerSpectrum(obj, s1, s2, varargin)
% POWERSPECTRUM: 功率谱分析
%
% obj = PowerSpectrum(obj, s1, s2, varargin)
%
% 使用 MATLAB 内置函数 pwelch (自功率谱) 和 cpsd (互功率谱) 分析
%
% s1 ... 第一个信号类别
%       0 - 原始信号 (input.s)
%       1 - 转换信号 (output.s_Transform)
%       2 - 合成信号 (output.s_Synthesis)
% s2 ... 第二个信号类别
%       0 - 原始信号 (input.s)
%       1 - 转换信号 (output.s_Transform)
%       2 - 合成信号 (output.s_Synthesis)
%
% varargin ... 可选参数:
%   'Window'    - 窗函数 (默认 hamming)
%                 可选: hamming, hann, blackman, bartlett, kaiser
%   'WindowLength' - 窗口长度 (默认 min(1024, floor(length(sig1)/4)))
%                   增加窗口长度可提高频率分辨率
%   'Noverlap'   - 重叠样本数 (默认 floor(window_length/2))
%   'Nfft'      - FFT 点数 (默认 2^nextpow2(window_length))
%   'Confidence' - 置信区间 [lower, upper] (默认 [])
%                 格式: [90, 95] 表示 90% 到 95% 置信区间
%
% 输出:
%   obj.output.PSD_s.Pxx - 功率谱密度
%   obj.output.PSD_s.f  - 频率向量
%   obj.output.PSD_s.PxxdB - 功率谱密度 (dB)
%   obj.output.PSD_s.Pxxc - 置信区间 (如果有)

%% 解析可选参数
p = inputParser;
addParameter(p, 'Window', 'hamming', @(x) ischar(x) || isstring(x));
addParameter(p, 'WindowLength', [], @(x) isempty(x) || isnumeric(x));
addParameter(p, 'Noverlap', [], @(x) isempty(x) || isnumeric(x));
addParameter(p, 'Nfft', [], @(x) isempty(x) || isnumeric(x));
addParameter(p, 'Confidence', [], @(x) isempty(x) || (isnumeric(x) && numel(x) == 2));
parse(p, varargin{:});
opt = p.Results;

%% 获取信号数据
switch s1
    case 0
        sig1 = obj.input.s;
        t1 = obj.input.t;
    case 1
        sig1 = obj.output.s_Transform;
        t1 = obj.output.t;
    case 2
        sig1 = obj.output.s_Synthesis;
        t1 = obj.output.t;
end

switch s2
    case 0
        sig2 = obj.input.s;
        t2 = obj.input.t;
    case 1
        sig2 = obj.output.s_Transform;
        t2 = obj.output.t;
    case 2
        sig2 = obj.output.s_Synthesis;
        t2 = obj.output.t;
end

%% 获取采样频率
if isfield(obj.output, 'fs') && ~isempty(obj.output.fs)
    fs = obj.output.fs;
elseif length(t1) > 1
    fs = 1 / (t1(2) - t1(1));
else
    error('无法确定采样频率');
end

%% 判断是自功率谱还是互功率谱
is_cross = (s1 ~= s2) || ~isequal(sig1(:), sig2(:));

if is_cross
    % 互功率谱分析
    fprintf('\n========== 功率谱分析结果 ==========\n');
    fprintf('  分析类型: 互功率谱 (CPSD)\n');

    % 设置默认窗口长度
    if isempty(opt.WindowLength)
        window_length = min(1024, floor(length(sig1) / 4));
    else
        % 确保窗口长度不超过信号长度
        window_length = min(opt.WindowLength, length(sig1));
        if window_length < opt.WindowLength
            fprintf('  警告: 指定窗口长度 %d 超过信号长度，使用 %d\n', ...
                opt.WindowLength, window_length);
        end
    end
    if ischar(opt.Window) || isstring(opt.Window)
        switch lower(opt.Window)
            case 'hamming'
                window = hamming(window_length);
            case 'hann'
                window = hann(window_length);
            case 'blackman'
                window = blackman(window_length);
            case 'bartlett'
                window = bartlett(window_length);
            case 'kaiser'
                window = kaiser(window_length, 5);
            otherwise
                window = hamming(window_length);
        end
    else
        window = opt.Window;
    end

    % 设置默认重叠
    if isempty(opt.Noverlap)
        noverlap = floor(window_length / 2);
    else
        noverlap = opt.Noverlap;
    end

    % 设置默认 FFT 点数
    if isempty(opt.Nfft)
        nfft = 2^nextpow2(window_length);
    else
        nfft = opt.Nfft;
    end

    % 计算互功率谱
    if ~isempty(opt.Confidence)
        [Pxx, f, Pxxc] = cpsd(sig1(:)', sig2(:)', window, noverlap, nfft, fs, ...
            'ConfidenceLevel', opt.Confidence(2)/100);
        fprintf('  置信区间: %.1f%%\n', opt.Confidence(2));
    else
        [Pxx, f] = cpsd(sig1(:)', sig2(:)', window, noverlap, nfft, fs);
    end

    fprintf('  采样频率: %.2f Hz\n', fs);
    fprintf('  窗函数: %s (长度 %d)\n', opt.Window, window_length);
    fprintf('  FFT 点数: %d\n', nfft);
    fprintf('  频率范围: %.2f - %.2f Hz\n', f(1), f(end));
    fprintf('==========================================\n');

    % 输出结果 (存储到第一个信号对应的位置)
    switch s1
        case 0
            obj.output.PSD_s.Pxx = Pxx;
            obj.output.PSD_s.f = f;
            obj.output.PSD_s.PxxdB = 10 * log10(Pxx + eps);
            if ~isempty(opt.Confidence)
                obj.output.PSD_s.Pxxc = Pxxc;
            end
        case 1
            obj.output.PSD_s_Transform.Pxx = Pxx;
            obj.output.PSD_s_Transform.f = f;
            obj.output.PSD_s_Transform.PxxdB = 10 * log10(Pxx + eps);
            if ~isempty(opt.Confidence)
                obj.output.PSD_s_Transform.Pxxc = Pxxc;
            end
        case 2
            obj.output.PSD_s_Synthesis.Pxx = Pxx;
            obj.output.PSD_s_Synthesis.f = f;
            obj.output.PSD_s_Synthesis.PxxdB = 10 * log10(Pxx + eps);
            if ~isempty(opt.Confidence)
                obj.output.PSD_s_Synthesis.Pxxc = Pxxc;
            end
    end

else
    % 自功率谱分析
    fprintf('\n========== 功率谱分析结果 ==========\n');
    fprintf('  分析类型: 自功率谱 (Welch PSD)\n');

    % 设置默认窗口长度
    if isempty(opt.WindowLength)
        window_length = min(1024, floor(length(sig1) / 4));
    else
        % 确保窗口长度不超过信号长度
        window_length = min(opt.WindowLength, length(sig1));
        if window_length < opt.WindowLength
            fprintf('  警告: 指定窗口长度 %d 超过信号长度，使用 %d\n', ...
                opt.WindowLength, window_length);
        end
    end
    if ischar(opt.Window) || isstring(opt.Window)
        switch lower(opt.Window)
            case 'hamming'
                window = hamming(window_length);
            case 'hann'
                window = hann(window_length);
            case 'blackman'
                window = blackman(window_length);
            case 'bartlett'
                window = bartlett(window_length);
            case 'kaiser'
                window = kaiser(window_length, 5);
            otherwise
                window = hamming(window_length);
        end
    else
        window = opt.Window;
    end

    % 设置默认重叠
    if isempty(opt.Noverlap)
        noverlap = floor(window_length / 2);
    else
        noverlap = opt.Noverlap;
    end

    % 设置默认 FFT 点数
    if isempty(opt.Nfft)
        nfft = 2^nextpow2(window_length);
    else
        nfft = opt.Nfft;
    end

    % 计算自功率谱
    if ~isempty(opt.Confidence)
        [Pxx, f, Pxxc] = pwelch(sig1(:)', window, noverlap, nfft, fs, ...
            'ConfidenceLevel', opt.Confidence(2)/100);
        fprintf('  置信区间: %.1f%%\n', opt.Confidence(2));
    else
        [Pxx, f] = pwelch(sig1(:)', window, noverlap, nfft, fs);
    end

    fprintf('  采样频率: %.2f Hz\n', fs);
    fprintf('  窗函数: %s (长度 %d)\n', opt.Window, window_length);
    fprintf('  FFT 点数: %d\n', nfft);
    fprintf('  频率范围: %.2f - %.2f Hz\n', f(1), f(end));
    fprintf('  最大功率谱密度: %.6f\n', max(Pxx));
    fprintf('==========================================\n');

    % 输出结果
    switch s1
        case 0
            obj.output.PSD_s.Pxx = Pxx;
            obj.output.PSD_s.f = f;
            obj.output.PSD_s.PxxdB = 10 * log10(Pxx + eps);
            if ~isempty(opt.Confidence)
                obj.output.PSD_s.Pxxc = Pxxc;
            end
        case 1
            obj.output.PSD_s_Transform.Pxx = Pxx;
            obj.output.PSD_s_Transform.f = f;
            obj.output.PSD_s_Transform.PxxdB = 10 * log10(Pxx + eps);
            if ~isempty(opt.Confidence)
                obj.output.PSD_s_Transform.Pxxc = Pxxc;
            end
        case 2
            obj.output.PSD_s_Synthesis.Pxx = Pxx;
            obj.output.PSD_s_Synthesis.f = f;
            obj.output.PSD_s_Synthesis.PxxdB = 10 * log10(Pxx + eps);
            if ~isempty(opt.Confidence)
                obj.output.PSD_s_Synthesis.Pxxc = Pxxc;
            end
    end
end

end

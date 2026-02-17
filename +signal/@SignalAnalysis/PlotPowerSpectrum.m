function PlotPowerSpectrum(obj, varargin)
% PlotPowerSpectrum - 绘制功率谱
% 使用 MATLAB 内置绘图函数绘制功率谱图
% Author: Claude
%
% Inputs:
%   obj - SignalAnalysis 对象
%
% Optional Parameters (varargin):
%   'Title'       - 图表标题 (默认 '功率谱密度')
%   'XLabel'      - x轴标签 (默认 '频率 [Hz]')
%   'YLabel'      - y轴标签 (默认 '功率谱密度')
%   'Color'       - 线条颜色 (默认 'b')
%   'LineWidth'    - 线条宽度 (默认 1.5)
%   'SaveFig'     - 是否保存图形 (默认 false)
%   'SavePath'    - 保存路径 (默认当前目录下的 'PowerSpectrum.png')
%   'CloseFig'    - 保存后是否关闭图形 (默认 false)
%   'FreqRange'   - 显示的频率范围 [min, max] Hz (默认 [] 显示全部)
%   'YScale'      - y轴刻度：'linear'(默认), 'log', 'db'
%   'ShowConfidence' - 是否显示置信区间 (默认 true)
%   'ShowMaxFreq'  - 是否标记最大功率谱密度对应的频率 (默认 true)
%   'Type'        - 信号类型：0-原始, 1-转换, 2-合成 (默认 0)
%
% Examples:
%   PlotPowerSpectrum(obj);
%   PlotPowerSpectrum(obj, 'Title', '自功率谱', 'YScale', 'db');
%   PlotPowerSpectrum(obj, 'SaveFig', true, 'SavePath', 'psd.png');

%% 解析可选参数
p = inputParser;
addParameter(p, 'Title', '功率谱密度', @(x) ischar(x) || isstring(x));
addParameter(p, 'XLabel', '频率 [Hz]', @(x) ischar(x) || isstring(x));
addParameter(p, 'YLabel', '功率谱密度', @(x) ischar(x) || isstring(x));
addParameter(p, 'Color', 'b', @(x) isempty(x) || ischar(x) || isstring(x));
addParameter(p, 'LineWidth', 1.5, @isnumeric);
addParameter(p, 'SaveFig', false, @(x) islogical(x) || isnumeric(x));
addParameter(p, 'SavePath', 'PowerSpectrum.png', @(x) ischar(x) || isstring(x));
addParameter(p, 'CloseFig', false, @(x) islogical(x) || isnumeric(x));
addParameter(p, 'FreqRange', [], @(x) isempty(x) || (isnumeric(x) && numel(x) == 2));
addParameter(p, 'YScale', 'linear', @(x) ischar(x) || isstring(x));
addParameter(p, 'ShowConfidence', true, @(x) islogical(x) || isnumeric(x));
addParameter(p, 'ShowMaxFreq', true, @(x) islogical(x) || isnumeric(x));
addParameter(p, 'Type', 0, @isnumeric);
parse(p, varargin{:});
opts = p.Results;

%% 检查输入数据
switch opts.Type
    case 0
        if isempty(obj.output.PSD_s.Pxx)
            error('请先进行功率谱分析 (PowerSpectrum 函数)');
        end
        f = obj.output.PSD_s.f;
        Pxx = obj.output.PSD_s.Pxx;
        PxxdB = obj.output.PSD_s.PxxdB;
        if isfield(obj.output.PSD_s, 'Pxxc')
            Pxxc = obj.output.PSD_s.Pxxc;
        else
            Pxxc = [];
        end
    case 1
        if isempty(obj.output.PSD_s_Transform.Pxx)
            error('请先进行功率谱分析 (PowerSpectrum 函数)');
        end
        f = obj.output.PSD_s_Transform.f;
        Pxx = obj.output.PSD_s_Transform.Pxx;
        PxxdB = obj.output.PSD_s_Transform.PxxdB;
        if isfield(obj.output.PSD_s_Transform, 'Pxxc')
            Pxxc = obj.output.PSD_s_Transform.Pxxc;
        else
            Pxxc = [];
        end
    case 2
        if isempty(obj.output.PSD_s_Synthesis.Pxx)
            error('请先进行功率谱分析 (PowerSpectrum 函数)');
        end
        f = obj.output.PSD_s_Synthesis.f;
        Pxx = obj.output.PSD_s_Synthesis.Pxx;
        PxxdB = obj.output.PSD_s_Synthesis.PxxdB;
        if isfield(obj.output.PSD_s_Synthesis, 'Pxxc')
            Pxxc = obj.output.PSD_s_Synthesis.Pxxc;
        else
            Pxxc = [];
        end
end

%% 应用频率范围限制
if ~isempty(opts.FreqRange)
    valid_idx = f >= opts.FreqRange(1) & f <= opts.FreqRange(2);
    f = f(valid_idx);
    Pxx = Pxx(valid_idx);
    PxxdB = PxxdB(valid_idx);
    if ~isempty(Pxxc)
        Pxxc = Pxxc(:, valid_idx);
    end
end

%% 选择y轴刻度
switch lower(opts.YScale)
    case 'linear'
        y = Pxx;
        ylabel_text = '功率谱密度';
        set_log_scale = false;
    case 'log'
        y = log10(Pxx + eps);
        ylabel_text = '功率谱密度 (log10)';
        set_log_scale = false;
    case 'db'
        y = PxxdB;
        ylabel_text = '功率谱密度 [dB]';
        set_log_scale = false;
    otherwise
        error('不支持的 YScale 类型，请选择：linear, log, 或 db');
end

%% 更新y轴标签
if ~isempty(opts.YLabel)
    ylabel_text = opts.YLabel;
end

%% 绘制图形
figure('Position', [100 100 1600 600]);
hold on;

% 绘制功率谱曲线
plot(f, y, 'Color', opts.Color, 'LineWidth', opts.LineWidth);

%% 添加置信区间
if opts.ShowConfidence && ~isempty(Pxxc)
    try
        % 确保 Pxxc 维度正确
        if size(Pxxc, 2) == length(f)
            % 确保 f 和 Pxxc 维度匹配
            if iscolumn(f)
                f_plot = f';  % 转为行向量
            else
                f_plot = f;
            end

            switch lower(opts.YScale)
                case 'linear'
                    plot(f_plot, Pxxc(1,:), 'r--', 'LineWidth', 1);
                    plot(f_plot, Pxxc(2,:), 'r--', 'LineWidth', 1);
                case 'log'
                    plot(f_plot, log10(Pxxc(1,:) + eps), 'r--', 'LineWidth', 1);
                    plot(f_plot, log10(Pxxc(2,:) + eps), 'r--', 'LineWidth', 1);
                case 'db'
                    plot(f_plot, 10 * log10(Pxxc(1,:) + eps), 'r--', 'LineWidth', 1);
                    plot(f_plot, 10 * log10(Pxxc(2,:) + eps), 'r--', 'LineWidth', 1);
            end
            legend('功率谱', '置信区间', 'Location', 'best');
        else
            fprintf('警告: Pxxc 维度不匹配，跳过置信区间绘制\n');
            fprintf('  Pxxc 大小: [%d, %d], f 长度: %d\n', size(Pxxc, 1), size(Pxxc, 2), length(f));
        end
    catch ME
        fprintf('警告: 绘制置信区间时出错 (%s)，跳过\n', ME.message);
    end
end

%% 添加最大功率谱密度标记
if opts.ShowMaxFreq
    [max_pxx, max_idx] = max(y);
    max_freq = f(max_idx);
    plot(max_freq, max_pxx, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    text(max_freq, max_pxx, sprintf('  %.2f Hz\n  最大值: %.3e', max_freq, Pxx(max_idx)), ...
        'VerticalAlignment', 'bottom');
end

%% 设置图形属性
title(opts.Title);
xlabel(opts.XLabel);
ylabel(ylabel_text);
grid on;
box on;
hold off;

%% 保存图形（如果需要）
if opts.SaveFig
    saveas(gcf, opts.SavePath);
    if obj.params.Echo
        fprintf('图形已保存至: %s\n', opts.SavePath);
    end
    if opts.CloseFig
        close(gcf);
    end
end

end

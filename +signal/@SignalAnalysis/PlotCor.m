function PlotCor(obj, varargin)
% PlotCor - 绘制相关性分析结果
% 使用 Rplot 绘图框架绘制相关性函数图
% Author: Claude
%
% Inputs:
%   obj - SignalAnalysis 对象
%
% Optional Parameters (varargin):
%   'Title'       - 图表标题 (默认 '相关性函数')
%   'XLabel'      - x轴标签 (默认 '延迟 [s]')
%   'YLabel'      - y轴标签 (默认 '相关值')
%   'Color'       - 线条颜色 (默认自动)
%   'Geom'        - 图形类型：'line'(默认), 'point', 'both', 'stem'
%   'SaveFig'     - 是否保存图形 (默认 false)
%   'SavePath'    - 保存路径 (默认当前目录下的 'Correlation.png')
%   'CloseFig'    - 保存后是否关闭图形 (默认 false)
%   'ShowZeroLag' - 是否标记零延迟位置 (默认 true)
%   'ShowMaxLag' - 是否标记最大相关值位置 (默认 true)
%   'LagRange'   - 显示的延迟范围 [min, max] 秒 (默认 [] 显示全部)
%
% Examples:
%   PlotCor(obj);
%   PlotCor(obj, 'Title', '自相关函数', 'Geom', 'stem');
%   PlotCor(obj, 'SaveFig', true, 'SavePath', 'correlation.png');


%% 解析可选参数
p = inputParser;
addParameter(p, 'Title', '相关性函数', @(x) ischar(x) || isstring(x));
addParameter(p, 'XLabel', '延迟 [s]', @(x) ischar(x) || isstring(x));
addParameter(p, 'YLabel', '相关值', @(x) ischar(x) || isstring(x));
addParameter(p, 'Color', [], @(x) isempty(x) || isnumeric(x) || ischar(x) || isstring(x));
addParameter(p, 'Geom', 'line', @(x) ischar(x) || isstring(x));
addParameter(p, 'SaveFig', false, @logical);
addParameter(p, 'SavePath', 'Correlation.png', @(x) ischar(x) || isstring(x));
addParameter(p, 'CloseFig', false, @logical);
addParameter(p, 'ShowZeroLag', true, @logical);
addParameter(p, 'ShowMaxLag', true, @logical);
addParameter(p, 'LagRange', [], @(x) isempty(x) || (isnumeric(x) && numel(x) == 2));
parse(p, varargin{:});
opts = p.Results;

%% 检查输入数据
if isempty(obj.output.Corr.c)
    error('请先进行相关性分析 (Correlation 函数)');
end

%% 获取数据
lags = obj.output.Corr.lags;
corr_values = obj.output.Corr.c;

% 转换延迟为时间单位
if isfield(obj.output, 'dt') && ~isempty(obj.output.dt)
    dt = obj.output.dt;
elseif isfield(obj.input, 't') && length(obj.input.t) > 1
    dt = obj.input.t(2) - obj.input.t(1);
else
    dt = 1;  % 默认单位
    warning('无法获取采样间隔，延迟单位为样本数');
end

lag_time = lags * dt;

%% 应用延迟范围限制
if ~isempty(opts.LagRange)
    valid_idx = lag_time >= opts.LagRange(1) & lag_time <= opts.LagRange(2);
    lag_time = lag_time(valid_idx);
    corr_values = corr_values(valid_idx);
end

%% 创建 Rplot 对象
if ~isempty(opts.Color)
    g = Rplot('x', lag_time, 'y', corr_values, 'color', opts.Color);
else
    g = Rplot('x', lag_time, 'y', corr_values);
end

%% 添加几何图层
switch lower(opts.Geom)
    case 'line'
        g = geom_line(g);
    case 'point'
        g = geom_point(g);
    otherwise
        error('不支持的 Geom 类型，请选择：line, point');
end

%% 设置标题和标签
g = set_names(g, 'x', opts.XLabel, 'y', opts.YLabel);
g = set_title(g, opts.Title);

%% 绘制图形
figure('Position', [100 100 1600 600]);
draw(g);

%% 添加零延迟标记
if opts.ShowZeroLag
    hold on;
    plot([0, 0], ylim, 'k--', 'LineWidth', 1.5);
    text(0, max(ylim)*0.95, '零延迟', 'HorizontalAlignment', 'center');
    hold off;
end

%% 添加最大相关值标记
if opts.ShowMaxLag
    hold on;
    [max_corr, max_idx] = max(corr_values);
    max_lag = lag_time(max_idx);
    plot(max_lag, max_corr, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    text(max_lag, max_corr, sprintf('  最大值: %.3f\n  延迟: %.4f s', max_corr, max_lag), ...
        'VerticalAlignment', 'bottom');
    hold off;
end

%% 添加网格
grid on;

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

function PlotPhase(obj, varargin)
% PlotPhase - 绘制FFT 相位图
% 使用 Rplot 绘图框架绘制时间-信号幅值图
% Author: Claude
%
% Inputs:
%   obj - SignalAnalysis 对象
%
% Optional Parameters (varargin):
%   'Title'       - 图表标题 (默认 '原始信号')
%   'XLabel'      - x轴标签 (默认 '时间')
%   'YLabel'      - y轴标签 (默认 '信号幅值')
%   'Color'       - 线条颜色 (默认自动)
%   'Geom'        - 图形类型：'line'(默认), 'point', 'both'
%   'SaveFig'     - 是否保存图形 (默认 false)
%   'SavePath'    - 保存路径 (默认当前目录下的 'ori_signal.png')
%   'CloseFig'    - 保存后是否关闭图形 (默认 false)
%
% Examples:
%   PlotOriSignal(obj);
%   PlotOriSignal(obj, 'Title', '测量信号', 'Geom', 'both');
%   PlotOriSignal(obj, 'SaveFig', true, 'SavePath', 'signal.png');


%% 解析可选参数
p = inputParser;
addParameter(p, 'Title', 'FFT 相位', @(x) ischar(x) || isstring(x));
addParameter(p, 'XLabel', '频率[Hz]', @(x) ischar(x) || isstring(x));
addParameter(p, 'YLabel', '相位[°]', @(x) ischar(x) || isstring(x));
addParameter(p, 'Color', [], @(x) isempty(x) || isnumeric(x) || ischar(x) || isstring(x));
addParameter(p, 'Geom', 'line', @(x) ischar(x) || isstring(x));
addParameter(p, 'SaveFig', false, @logical);
addParameter(p, 'SavePath', 'FFT_phase.png', @(x) ischar(x) || isstring(x));
addParameter(p, 'CloseFig', false, @logical);
addParameter(p,'Freq',[]);
addParameter(p,'Type',0);
parse(p, varargin{:});
opts = p.Results;

%% 获取数据

switch opts.Type
    case 0
        %% 检查输入数据
        if isempty(obj.output.FFT_s)
            error('请先进行FFT变换');
        end
        x = obj.output.FFT_s.f;
        y = obj.output.FFT_s.phase/pi*180;
    case 1
        %% 检查输入数据
        if isempty(obj.output.FFT_s_Transform)
            error('请先进行FFT变换');
        end
        x = obj.output.FFT_s_Transform.f;
        y = obj.output.FFT_s_Transform.phase/pi*180;
    case 2
        %% 检查输入数据
        if isempty(obj.output.FFT_s_Synthesis)
            error('请先进行FFT变换');
        end
        x = obj.output.FFT_s_Synthesis.f;
        y = obj.output.FFT_s_Synthesis.phase/pi*180;
end

if ~isempty(opts.Freq)
    y=y(and(x>=opts.Freq(1),x<=opts.Freq(2)));
    x=x(and(x>=opts.Freq(1),x<=opts.Freq(2)));
end

%% 创建 Rplot 对象
if ~isempty(opts.Color)
    g = Rplot('x', x, 'y', y, 'color', opts.Color);
else
    g = Rplot('x', x, 'y', y);
end

%% 添加几何图层
switch lower(opts.Geom)
    case 'line'
        g = geom_line(g);
    case 'point'
        g = geom_point(g);
    case 'both'
        g = geom_line(g);
        g = geom_point(g);
    otherwise
        error('不支持的 Geom 类型，请选择：line, point, 或 both');
end

%% 设置标题和标签
g = set_names(g, 'x', opts.XLabel, 'y', opts.YLabel);
g = set_title(g, opts.Title);

%% 绘制图形
figure('Position',[100 100 1600 400])
draw(g);

%% 保存图形（如果需要）
if opts.SaveFig
    g.save_image(opts.SavePath);
    if obj.params.Echo
        fprintf('图形已保存至: %s\n', opts.SavePath);
    end
    if opts.CloseFig
        close(gcf);
    end
end

end

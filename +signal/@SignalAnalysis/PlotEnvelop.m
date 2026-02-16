function PlotEnvelop(obj, varargin)
% PlotEnvelop - 绘制包络
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
addParameter(p, 'Title', 'Envelop', @(x) ischar(x) || isstring(x));
addParameter(p, 'XLabel', '时间[s]', @(x) ischar(x) || isstring(x));
addParameter(p, 'Geom', 'line', @(x) ischar(x) || isstring(x));
addParameter(p, 'SaveFig', false, @logical);
addParameter(p, 'SavePath', 'Envelop.png', @(x) ischar(x) || isstring(x));
addParameter(p, 'CloseFig', false, @logical);
addParameter(p,'Type',0); % 0 - 原始信号 1 - 转换信号 2 - 合成信号 

parse(p, varargin{:});
opts = p.Results;

%% 获取数据


switch opts.Type
    case 0
        t=obj.input.t;
        s=obj.input.s;
        h = obj.output.Env_s;
    case 1
        t=obj.output.t;
        s=obj.output.s_Transform;
        h=obj.output.Env_s_Transform;
    case 2
        t=obj.output.t;
        s=obj.output.s_Synthesis;
        h=obj.output.Env_s_Synthesis;
end

%% 检查输入数据
if isempty(h)
    error('请先进行包络计算');
end

x = t;
y = [s;h;-h]';
Color={'信号','正包络','负包络'};

%% 创建 Rplot 对象
g = Rplot('x', x', 'y', y', 'color', Color);


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
g = set_names(g, 'x', opts.XLabel,'color','Type');
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

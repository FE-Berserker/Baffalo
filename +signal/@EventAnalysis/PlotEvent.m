function [fig, imagePath] = PlotEvent(obj, varargin)
    % PlotEvent - 绘制事件数据
    %
    % Parameters:
    %   varargin - 可选参数:
    %     'xRange' - 空间范围
    %     'tRange' - 时间范围
    %     'filename' - 保存文件名（如未指定则不保存）
    %     'format' - 图片格式 ('png', 'jpg', 'pdf' 等，默认 'png')
    %     'resolution' - 分辨率 ('screen', '300', '600' 等，默认 '300')

    p = inputParser;
    addParameter(p, 'xRange', []);
    addParameter(p, 'tRange', []);
    addParameter(p, 'filename', '');
    addParameter(p, 'format', 'png');
    addParameter(p, 'resolution', '300');
    parse(p, varargin{:});
    opt = p.Results;

    x = obj.input.x;
    t = obj.input.t;
    Event = obj.output.Event;

    if ~isempty(opt.xRange)
        indx = near(x, opt.xRange(1), opt.xRange(2));
        Event = Event(:, indx);
    end

    if ~isempty(opt.tRange)
        ind = near(t, opt.xRange(1), opt.xRange(2));
        Event = Event(ind, :);
    end

    fig = figure;
    set(fig, 'PaperPositionMode', 'auto');
    imagesc(x, t, Event);
    axis xy;
    xlabel('Position');
    ylabel('Time [s]');
    set(gca, 'YDir', 'reverse');
    colormap gray;
    colorbar;

    % 保存图像
    imagePath = '';
    if ~isempty(opt.filename)
        % 使用 print 函数保存（比 saveas 更可靠）
        print(fig, opt.filename, ['-d' opt.format], ['-r' opt.resolution]);
        imagePath = opt.filename;
    end
end

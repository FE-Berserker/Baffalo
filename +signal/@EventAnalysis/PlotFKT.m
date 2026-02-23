function [fig, imagePath] = PlotFKT(obj, varargin)
    % PlotFKT - 绘制 FK 变换结果
    %
    % Parameters:
    %   varargin - 可选参数:
    %     'filename' - 保存文件名（如未指定则不保存）
    %     'format' - 图片格式 ('png', 'jpg', 'pdf' 等，默认 'png')
    %     'resolution' - 分辨率 ('screen', '300', '600' 等，默认 '300')

    p = inputParser;
    addParameter(p, 'filename', '');
    addParameter(p, 'format', 'png');
    addParameter(p, 'resolution', '300');
    parse(p, varargin{:});
    opt = p.Results;

    FKT = obj.output.FKT;
    fks = FKT.fks;
    f = FKT.f;
    k = FKT.k;

    fig = figure;
    imagesc(k, f, abs(fks));
    axis xy;
    xlabel('Wavenumber k_x');
    ylabel('Frequency [Hz]');
    set(gca, 'YDir', 'reverse');
    colormap jet;
    colorbar;

    % 保存图像
    imagePath = '';
    if ~isempty(opt.filename)
        % 使用 print 函数保存（比 saveas 更可靠）
        print(fig, opt.filename, ['-d' opt.format], ['-r' opt.resolution]);
        imagePath = opt.filename;
    end
end

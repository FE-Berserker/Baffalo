function obj = save_image(obj, varargin)
% save_image - 保存当前Rplot图形为图片文件
%
% 语法:
%   obj = save_image()                    % 交互式保存（弹出对话框）
%   obj = save_image('filename')          % 保存到指定文件
%   obj = save_image('filename', 'format')  % 指定格式保存
%
% 参数:
%   filename - 文件名（可选），如未指定则弹出保存对话框
%   format   - 图片格式 ('png', 'jpg', 'eps', 'pdf', 'svg' 等，默认 'png')
%   resolution - 分辨率 ('screen', '300', '600' 等，默认 'screen')
%   closefig - 是否在保存后关闭图形 (true/false，默认 false)
%
% 示例:
%   g1 = Rplot('x', x, 'y', y);
%   g1 = g1.geom_line();
%   g1 = g1.draw();
%   g1.save_image();  % 交互式保存
%
%   g1.save_image('output/result.png');  % 指定文件名
%
%   g1.save_image('output/high_res.jpg', 'format', 'jpg', 'resolution', '600');  % 指定格式和分辨率
%
% Author: Claude Sonnet 4.5

    % 支持位置参数和命名参数
    filename = '';
    if nargin > 1
        % 检查第一个参数是否是已知的选项名
        valid_options = {'filename', 'format', 'resolution', 'closefig'};
        if ~any(strcmpi(varargin{1}, valid_options))
            % 如果第一个参数不是选项名，则作为filename处理
            filename = varargin{1};
            varargin(1) = [];
        end
    end

    % 输入参数解析器
    p = inputParser;
    addParameter(p, 'filename', filename, @ischar);
    addParameter(p, 'format', 'png', @ischar);
    addParameter(p, 'resolution', 'screen', @(x) ischar(x) || isnumeric(x));
    addParameter(p, 'closefig', false, @logical);
    parse(p, varargin{:});
    opt = p.Results;

    % 检查图形是否存在
    % if isempty(obj.parent)
    %     error('图形未创建，请先调用 draw() 方法');
    % end

    % 确定文件名
    if isempty(opt.filename)
        % 弹出保存对话框
        [file, path] = uiputfile('保存图片', ...
            {'*.png';'*.jpg';'*.jpeg';'*.eps';'*.pdf';'*.svg';'*.fig';'*.*'}, ...
            '图片文件', 'Save');
        if ~isequal(file, 0)  % 用户点击了"取消"
            fprintf('保存操作已取消\n');
            return;
        end
        opt.filename = fullfile(path, file);
    end

    % 获取完整文件路径并确保扩展名
    [filepath, name, ext] = fileparts(opt.filename);
    if isempty(ext) || ~any(strcmpi(ext(2:end), {'png','jpg','jpeg','tif','tiff','bmp','eps','pdf','svg','fig'}))
        % 添加扩展名
        opt.filename = [opt.filename '.' opt.format];
    end

    % 获取图形句柄
    fig = obj.parent;

    % 检查图形是否仍然有效
    if ~ishandle(fig) || ~strcmp(get(fig, 'Type'), 'figure')
        error('图形句柄无效，图形可能已被关闭');
    end

    % 处理分辨率参数
    dpi_str = '';
    if ischar(opt.resolution)
        switch lower(opt.resolution)
            case 'screen'
                % 屏幕分辨率，使用默认
                dpi_str = '';
            case '150'
                dpi_str = '-r150';
            case '300'
                dpi_str = '-r300';
            case '600'
                dpi_str = '-r600';
            case '1200'
                dpi_str = '-r1200';
            otherwise
                warning('未知的分辨率值: %s，使用屏幕分辨率', opt.resolution);
        end
    elseif isnumeric(opt.resolution)
        % 直接使用DPI数值
        dpi_str = ['-r' num2str(opt.resolution)];
    end

    % 保存图片
    [~, ~, ext] = fileparts(opt.filename);
    format_str = ext(2:end);  % 去掉点号

    try
        switch lower(format_str)
            % 栅格图像格式
            case 'png'
                if ~isempty(dpi_str)
                    print(fig, opt.filename, '-dpng', dpi_str);
                else
                    print(fig, opt.filename, '-dpng');
                end
                fprintf('图片已保存: %s (PNG格式)\n', opt.filename);
            case 'jpg'
                if ~isempty(dpi_str)
                    print(fig, opt.filename, '-djpeg', dpi_str);
                else
                    print(fig, opt.filename, '-djpeg');
                end
                fprintf('图片已保存: %s (JPG格式)\n', opt.filename);
            case 'jpeg'
                if ~isempty(dpi_str)
                    print(fig, opt.filename, '-djpeg', dpi_str);
                else
                    print(fig, opt.filename, '-djpeg');
                end
                fprintf('图片已保存: %s (JPEG格式)\n', opt.filename);
            case 'tif'
                if ~isempty(dpi_str)
                    print(fig, opt.filename, '-dtiff', dpi_str);
                else
                    print(fig, opt.filename, '-dtiff');
                end
                fprintf('图片已保存: %s (TIF格式)\n', opt.filename);
            case 'tiff'
                if ~isempty(dpi_str)
                    print(fig, opt.filename, '-dtiff', dpi_str);
                else
                    print(fig, opt.filename, '-dtiff');
                end
                fprintf('图片已保存: %s (TIFF格式)\n', opt.filename);
            case 'bmp'
                if ~isempty(dpi_str)
                    print(fig, opt.filename, '-dbmp', dpi_str);
                else
                    print(fig, opt.filename, '-dbmp');
                end
                fprintf('图片已保存: %s (BMP格式)\n', opt.filename);

            % EPS格式（矢量）
            case 'eps'
                print(fig, opt.filename, '-depsc', '-painters');
                fprintf('图片已保存: %s (EPS格式)\n', opt.filename);

            % PDF格式（矢量）
            case 'pdf'
                print(fig, opt.filename, '-dpdf', '-bestfit');
                fprintf('图片已保存: %s (PDF格式)\n', opt.filename);

            % SVG格式（矢量）
            case 'svg'
                print(fig, opt.filename, '-dsvg');
                fprintf('图片已保存: %s (SVG格式)\n', opt.filename);

            % MATLAB .fig文件
            case 'fig'
                savefig(fig, opt.filename);
                fprintf('图片已保存: %s (MATLAB .fig格式)\n', opt.filename);

            otherwise
                warning('不支持的格式: %s，尝试使用默认PNG格式', format_str);
                filename_png = [opt.filename '.png'];
                print(fig, filename_png, '-dpng');
                fprintf('图片已保存: %s (PNG格式)\n', filename_png);
        end
    catch ME
        error('保存图片失败: %s\n错误详情: %s', opt.filename, ME.message);
    end

    % 可选：关闭图形
    if opt.closefig
        close(fig);
        obj.parent = [];
        fprintf('图形已关闭\n');
    end
end

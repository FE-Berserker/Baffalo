function hFig = PlotFRF(obj)
%PLOTFRF 绘制FRF结果
%   创建三个子图: 实部、虚部、幅值
%
%   输入:
%       obj - FRFGen对象
%   输出:
%       hFig - 图形句柄

    % 检查FRF数据是否存在
    if isempty(obj.output.FRF)
        error('FRFGen: FRF数据为空,请先运行solve()方法');
    end
    
    % 获取频率数据
    f = obj.output.Freq;
    
    % 创建图形窗口
    hFig = figure('Name', 'FRF Generation Results', 'NumberTitle', 'off');
    set(gcf, 'unit', 'centimeters', 'position', [5 5 18 12], 'color', 'white');
    
    % 绘制实部
    subplot(3, 1, 1);
    plot(f, obj.output.FRFReal, 'b-', 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency [Hz]', 'FontName', 'Times New Roman');
    ylabel('Real [m/N]', 'FontName', 'Times New Roman');
    title('FRF Real Part', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman');
    xlim([obj.params.FStart, obj.params.FEnd]);
    
    % 绘制虚部
    subplot(3, 1, 2);
    plot(f, obj.output.FRFImag, 'r-', 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency [Hz]', 'FontName', 'Times New Roman');
    ylabel('Imag [m/N]', 'FontName', 'Times New Roman');
    title('FRF Imaginary Part', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman');
    xlim([obj.params.FStart, obj.params.FEnd]);
    
    % 绘制幅值
    subplot(3, 1, 3);
    plot(f, obj.output.FRFMag, 'g-', 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency [Hz]', 'FontName', 'Times New Roman');
    ylabel('Magnitude [m/N]', 'FontName', 'Times New Roman');
    title('FRF Magnitude', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman');
    xlim([obj.params.FStart, obj.params.FEnd]);
    
    % 添加总标题
    sgtitle(sprintf('FRF Generation Results (%s Mode)', obj.params.GenerationMode), ...
        'FontName', 'Times New Roman', 'FontSize', 12, 'FontWeight', 'bold');
end

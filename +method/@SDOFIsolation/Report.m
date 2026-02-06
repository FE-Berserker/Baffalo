function obj = Report(obj)
    % Report - 为 SDOFIsolation 对象生成 Markdown 格式技术报告
    %
    %   obj = Report(obj)
    %
    % 输出:
    %   - [Name]_analysis_report.md: Markdown 格式报告
    %   - [Name].assets/: 图像目录，包含生成的图表
    %
    % Author: Xie Yu
    % Date: 2026-02-05

    % 确保已执行计算
    if isempty(obj.output.natural_freq)
        warning('尚未执行计算，请先调用 obj.solve()');
        return;
    end

    % 获取项目名称
    if isfield(obj.params, 'Name') && ~isempty(obj.params.Name)
        projectName = obj.params.Name;
    else
        projectName = 'SDOFIsolation';
    end

    % 设置报告标题和文件名
    reportTitle = [projectName ' analysis report'];
    reportFilename = [projectName '_analysis_report.md'];

    % 创建图像目录
    imageDir = [projectName '_analysis_report.assets'];
    if ~exist(imageDir, 'dir')
        mkdir(imageDir);
    end

    %% 初始化报告
    report = MarkdownReport(...
        'title', reportTitle, ...
        'author', 'Xie Yu', ...
        'filename', reportFilename, ...
        'imageDir', imageDir);

    %% 添加报告内容
    report = report.addTitle('项目概述', 2);
    report = report.addParagraph({
        '本报告采用单自由度（SDOF）模型对建筑隔震系统进行动态响应分析。模型适用于高度小于40m、剪切变形为主、上部结构刚度远大于隔震层的建筑结构。'
    });
    report = report.addHorizontalRule();

    report = report.addTitle('单位系统', 2);
    report = report.addList({
        '质量: ton (吨)',
        '长度: mm (毫米)',
        '压力/应力: MPa (兆帕)',
        '加速度: m/s²',
        '频率: rad/s'
    }, false);

    report = report.addHorizontalRule();

    report = report.addTitle('输入参数', 2);

    % 创建输入参数表格
    headers = {'参数名称', '符号', '数值', '单位'};
    data = {
        '上部结构总质量', 'M', obj.input.M, 'ton';
        '隔震层刚度', 'K', obj.input.K, 'N/mm';
        '隔震层阻尼系数', 'C', obj.input.C, 'N·s/mm';
        '地面运动加速度', 'a_g', obj.input.ground_acc, 'm/s²';
        '场地土特征频率', 'ω', obj.input.soil_freq, 'rad/s';
        '建筑高度', 'H', obj.input.height, 'mm'
    };
    report = report.addCustomTable(headers, data, {}, '表 1: 输入参数');

    report = report.addHorizontalRule();

    report = report.addTitle('计算结果', 2);

    % 创建计算结果表格
    headers = {'参数名称', '符号', '数值', '单位'};
    data = {
        '自振频率', 'ω_n', obj.output.natural_freq, 'rad/s';
        '阻尼比', 'ξ', obj.output.damping_ratio, '-';
        '频率比', 'r', obj.output.freq_ratio, '-';
        '加速度衰减比', 'R_a', obj.output.acc_attenuation_ratio, '-';
        '位移衰减比', 'R_d', obj.output.disp_attenuation_ratio, '-';
        '最大位移反应', 'D_s', obj.output.max_displacement, 'mm';
        '隔震效果', '-', obj.output.isolation_effect, '-';
        '地震烈度降低', '-', obj.output.seismic_reduction, '度'
    };
    report = report.addCustomTable(headers, data, {}, '表 2: 计算结果');

    report = report.addHorizontalRule();

    report = report.addTitle('隔震效果评估', 2);

    % 判断隔震效果
    r = obj.output.freq_ratio;
    if strcmp(obj.output.isolation_effect, '有效')
        effect_color = 'green';
        effect_msg = sprintf('**隔震效果: 有效** (频率比 r = %.3f ≥ 1.414)', r);
    elseif strcmp(obj.output.isolation_effect, '共振风险')
        effect_color = 'red';
        effect_msg = sprintf('**隔震效果: 共振风险** (频率比 r = %.3f 接近 1.0)', r);
    else
        effect_color = 'orange';
        effect_msg = sprintf('**隔震效果: 无效** (频率比 r = %.3f < 1.414)', r);
    end

    report = report.addParagraph(effect_msg);

    if strcmp(obj.output.isolation_effect, '有效')
        report = report.addParagraph(sprintf('预计降低地震烈度: **%.1f 度**', obj.output.seismic_reduction));
    end

    report = report.addHorizontalRule();

    report = report.addTitle('安全校核结果', 2);

    % 创建安全系数表格
    headers = {'安全系数项', '当前值', '基准值', '状态'};
    data = {
        '频率比安全裕度', sprintf('%.3f', obj.capacity.freq_ratio_margin), '1.000', num2str(obj.capacity.freq_ratio_margin >= 1);
        '位移安全系数', sprintf('%.3f', obj.capacity.disp_safety_factor), sprintf('%.3f', obj.baseline.min_safety_factor), num2str(obj.capacity.disp_safety_factor >= obj.baseline.min_safety_factor);
        '综合安全系数', sprintf('%.3f', obj.capacity.safety_factor), sprintf('%.3f', obj.baseline.min_safety_factor), num2str(obj.capacity.safety_factor >= obj.baseline.min_safety_factor)
    };
    report = report.addCustomTable(headers, data, {}, '表 3: 安全系数');

    % 加速度衰减比符合性
    Ra = obj.output.acc_attenuation_ratio;
    if Ra >= obj.baseline.acc_ratio_min && Ra <= obj.baseline.acc_ratio_max
        acc_compliance = '满足';
    else
        acc_compliance = '不满足';
    end

    % 共振风险
    if obj.capacity.resonance_risk
        resonance_status = '存在共振风险';
    else
        resonance_status = '无共振风险';
    end

    % 综合安全
    if obj.capacity.overall_safety
        overall_status = '满足';
    else
        overall_status = '不满足';
    end

    % 使用字符串拼接，避免cell数组问题
    line1 = sprintf('- 加速度衰减比符合性: %s (R_a = %.4f, 范围: [%.2f, %.2f])', acc_compliance, Ra, obj.baseline.acc_ratio_min, obj.baseline.acc_ratio_max);
    line2 = sprintf('- 共振风险检查: %s', resonance_status);
    line3 = sprintf('- 综合安全判断: %s', overall_status);
    report = report.addParagraph(line1);
    report = report.addParagraph(line2);
    report = report.addParagraph(line3);

    report = report.addHorizontalRule();

    report = report.addTitle('可视化分析', 2);
    report = report.addParagraph('以下图表展示了隔震系统的各项性能指标:');

    %% 生成图表并添加到报告
    % 临时设置语言为中文
    originalLanguage = obj.plotLanguage;
    obj.plotLanguage = 'CN';

    % 生成综合分析图
    disp('正在生成可视化图表...');
    obj.PlotCapacity();
    fig = gcf;

    % 保存图表
    figPath = fullfile(imageDir, 'analysis_summary.png');
    figPath = strrep(figPath, '\', '/');
    print(fig, figPath, '-dpng', '-r300');
    close(fig);

    % 添加图表到报告
    report = report.addImage(figPath, '综合分析图：包含加速度衰减比曲线、位移衰减比曲线、安全系数对比、频率响应曲线、隔震效果可视化和阻尼参数评估');

    report = report.addHorizontalRule();

    %% 恢复原始语言设置
    obj.plotLanguage = originalLanguage;

    report = report.addTitle('计算方法说明', 2);

    report = report.addTitle('自振频率计算', 3);
    report = report.addParagraph({
        '自振频率公式: ω_n = sqrt(K/M)',
        '其中 K 为隔震层刚度，M 为上部结构质量。需要将 K 从 N/mm 转换为 N/m，M 从 ton 转换为 kg 进行计算。'
    });

    report = report.addTitle('阻尼比计算', 3);
    report = report.addParagraph({
        '阻尼比公式: ξ = C / (2·M·ω_n)',
        '其中 C 为隔震层阻尼系数，需要从 N·s/mm 转换为 N·s/m。'
    });

    report = report.addTitle('频率比计算', 3);
    report = report.addParagraph({
        '频率比公式: r = ω / ω_n',
        '其中 ω 为场地土特征频率，ω_n 为隔震系统自振频率。'
    });

    report = report.addTitle('加速度响应计算', 3);
    report = report.addParagraph({
        '采用频域分析方法，计算频率响应函数:',
        'H(ω) = sqrt((1 + (2ξr)²) / ((1 - r²)² + (2ξr)²))',
        '加速度衰减比 R_a = H(ω)，即上部结构与地面的加速度比值。'
    });

    report = report.addTitle('位移响应计算', 3);
    report = report.addParagraph({
        '地面运动位移: D_g = |a_g| / ω²',
        '最大位移反应: D_s = D_g · r² / sqrt((1 - r²)² + (2ξr)²)',
        '其中 a_g 为地面运动加速度，最终位移结果以 mm 为单位。'
    });

    report = report.addHorizontalRule();

    report = report.addTitle('适用条件', 2);
    report = report.addList({
        '建筑高度: H < 40m (40000mm)',
        '结构类型: 剪切变形为主',
        '刚度关系: 上部结构刚度远大于隔震层刚度',
        '模型类型: 单自由度（SDOF）模型适用'
    }, false);

    if obj.input.height >= 40000
        report = report.addParagraph({
            '**警告:** 建筑高度超过40m，单自由度模型可能不再适用，需要采用多自由度（MDOF）模型进行分析。'
        });
    end

    report = report.addHorizontalRule();

    report = report.addTitle('参考文献', 2);
    report = report.addList({
        '结构隔震技术和应用',
    }, false);

    report = report.addHorizontalRule();

    report = report.addTitle('版本信息', 2);
    reportDate = datestr(now, 'yyyy-mm-dd');
    report = report.addParagraph('**作者:** Xie Yu');
    report = report.addParagraph('**创建日期:** 2026-02-03');
    report = report.addParagraph(['**报告生成日期:** ' reportDate]);

    report = report.addHorizontalRule();

    %% 导出报告
    report.export();

    fprintf('\n=================================================\n');
    fprintf('  报告生成完成！\n');
    fprintf('=================================================\n');
    fprintf('  报告文件: %s\n', reportFilename);
    fprintf('  图像目录: %s/\n', imageDir);
    fprintf('  总行数: %d\n', report.getLength());
    fprintf('=================================================\n\n');
end

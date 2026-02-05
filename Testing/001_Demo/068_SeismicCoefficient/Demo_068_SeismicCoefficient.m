% Test SeismicCoefficient component
% 地震影响系数计算测试
% 单位系统: 无量纲, s

% 清除工作空间
clear all
close all

disp('==========================================');
disp('  SeismicCoefficient 组件测试');
disp('  地震影响系数计算与绘图');
disp('==========================================');
disp(' ');

%% 测试用例1：典型工况 - 8度多遇地震
disp('--- 测试用例1：典型工况 - 8度多遇地震 ---');

% 输入参数
input1.DampingRatio = 0.05;        % 阻尼比 5%
input1.SiteClass = 'II';            % II类场地
input1.SeismicGroup = 2;           % 第二组

% 参数设置
params1.SeismicIntensity = '8_0.15g';  % 8度 0.15g
params1.EarthquakeType = 'frequent';    % 多遇地震
params1.NumPoints = 500;                % 绘图点数
params1.TimePeriodRange = [0, 6];       % 周期范围 0-6s

% 创建组件实例
obj1 = method.SeismicCoefficient(params1, input1);

% 显示初始参数
disp('初始参数:');
disp(['  地震烈度: ' obj1.params.SeismicIntensity]);
disp(['  场地类别: ' obj1.input.SiteClass]);
disp(['  设计地震分组: ' num2str(obj1.input.SeismicGroup)]);
disp(['  地震类型: ' obj1.params.EarthquakeType]);
disp(['  阻尼比: ' num2str(obj1.input.DampingRatio)]);
disp(' ');

% 执行计算
obj1 = obj1.solve();

% 打印详细信息
obj1.PrintInfo();

disp(' ');

%% 绘制地震影响系数曲线
disp('--- 绘制地震影响系数曲线 ---');
disp('  保存图像到文件...');
obj1.PlotAlphaCurve('SavePath', 'SeismicCoefficient_Type1.png');
disp(' ');

%% 测试用例2：7度多遇地震 - 不同场地类别
disp('==========================================');
disp('--- 测试用例2：7度多遇地震 - 不同场地类别对比 ---');

params2.SeismicIntensity = '7_0.15g';  % 7度 0.15g
params2.EarthquakeType = 'frequent';
params2.NumPoints = 500;
params2.TimePeriodRange = [0, 6];

input2.DampingRatio = 0.05;
input2.SeismicGroup = 2;

site_classes = {'I0', 'I1', 'II', 'III', 'IV'};

disp('对比不同场地类别的地震影响系数曲线:');
disp('  场地类别 | 特征周期 Tg (s) | 最大系数 αmax | 衰减指数 γ');
disp('  -----------------------------------------------------------');

figure('Position', [100 100 900 600]);
hold on;

colors = {'b', 'g', 'r', 'c', 'm'};

for i = 1:length(site_classes)
    input2.SiteClass = site_classes{i};
    obj = method.SeismicCoefficient(params2, input2);
    obj = obj.solve();

    fprintf('    %4s    |     %.2f       |    %.3f     |   %.3f\n', ...
            site_classes{i}, obj.output.Tg, obj.output.AlphaMax, obj.output.Gamma);

    plot(obj.output.PeriodArray, obj.output.AlphaCurve, ...
         [colors{i} '-'], 'LineWidth', 2, 'DisplayName', ...
         ['场地类 ' site_classes{i} ', Tg=' num2str(obj.output.Tg) 's']);
end

hold off;
grid on;
xlabel('周期 T (s)', 'FontSize', 12);
ylabel('地震影响系数 \alpha', 'FontSize', 12);
title('不同场地类别的地震影响系数曲线对比', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);

% 添加信息框
infoText = sprintf('地震烈度 = %s\n地震分组 = %d\n阻尼比 ζ = %.3f', ...
                  params2.SeismicIntensity, input2.SeismicGroup, input2.DampingRatio);
annotation('textbox', [0.65, 0.70, 0.25, 0.15], 'String', infoText, ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'FontSize', 10);

saveas(gcf, 'SeismicCoefficient_Type2_SiteComparison.png');
disp('图像已保存: SeismicCoefficient_Type2_SiteComparison.png');
disp(' ');

%% 测试用例3：不同阻尼比的影响
disp('==========================================');
disp('--- 测试用例3：不同阻尼比的影响 ---');

params3.SeismicIntensity = '8_0.15g';
params3.EarthquakeType = 'frequent';
params3.NumPoints = 500;
params3.TimePeriodRange = [0, 6];

input3.SiteClass = 'II';
input3.SeismicGroup = 2;

damping_ratios = [0.02, 0.05, 0.10, 0.15, 0.20];

disp('对比不同阻尼比的影响:');
disp('  阻尼比 | 衰减指数 γ | 调整系数 η1 | 调整系数 η2');
disp('  ------------------------------------------------------');

figure('Position', [100 100 900 600]);
hold on;

colors = {'b', 'g', 'r', 'c', 'm'};

for i = 1:length(damping_ratios)
    input3.DampingRatio = damping_ratios(i);
    obj = method.SeismicCoefficient(params3, input3);
    obj = obj.solve();

    fprintf('  %.3f  |   %.4f  |   %.4f  |   %.4f\n', ...
            damping_ratios(i), obj.output.Gamma, obj.output.Eta1, obj.output.Eta2);

    plot(obj.output.PeriodArray, obj.output.AlphaCurve, ...
         [colors{i} '-'], 'LineWidth', 2, 'DisplayName', ...
         ['ζ = ' num2str(damping_ratios(i)) ', γ=' num2str(obj.output.Gamma, '%.3f')]);
end

hold off;
grid on;
xlabel('周期 T (s)', 'FontSize', 12);
ylabel('地震影响系数 \alpha', 'FontSize', 12);
title('不同阻尼比的地震影响系数曲线对比', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);

saveas(gcf, 'SeismicCoefficient_Type3_DampingComparison.png');
disp('图像已保存: SeismicCoefficient_Type3_DampingComparison.png');
disp(' ');

%% 测试用例4：不同地震烈度对比
disp('==========================================');
disp('--- 测试用例4：不同地震烈度对比 ---');

params4.EarthquakeType = 'frequent';
params4.NumPoints = 500;
params4.TimePeriodRange = [0, 6];

input4.DampingRatio = 0.05;
input4.SiteClass = 'II';
input4.SeismicGroup = 2;

intensities = {'6', '7_0.15g', '7_0.3g', '8_0.15g', '8_0.30g', '9'};

disp('不同地震烈度的多遇地震影响系数:');
disp('  地震烈度 | 最大系数 αmax | 特征周期 Tg (s)');
disp('  ------------------------------------------------');

figure('Position', [100 100 900 600]);
hold on;

colors = {'b', 'g', 'c', 'r', 'm', 'k'};

for i = 1:length(intensities)
    params4.SeismicIntensity = intensities{i};
    obj = method.SeismicCoefficient(params4, input4);
    obj = obj.solve();

    fprintf('  %8s |     %.3f     |     %.2f\n', ...
            intensities{i}, obj.output.AlphaMax, obj.output.Tg);

    plot(obj.output.PeriodArray, obj.output.AlphaCurve, ...
         [colors{i} '-'], 'LineWidth', 2, 'DisplayName', ...
         [intensities{i} ', αmax=' num2str(obj.output.AlphaMax)]);
end

hold off;
grid on;
xlabel('周期 T (s)', 'FontSize', 12);
ylabel('地震影响系数 \alpha', 'FontSize', 12);
title('不同地震烈度的地震影响系数曲线对比（多遇地震）', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);

saveas(gcf, 'SeismicCoefficient_Type4_IntensityComparison.png');
disp('图像已保存: SeismicCoefficient_Type4_IntensityComparison.png');
disp(' ');

%% 测试用例5：罕遇地震与多遇地震对比
disp('==========================================');
disp('--- 测试用例5：罕遇地震与多遇地震对比 ---');

params5.SeismicIntensity = '8_0.15g';
params5.NumPoints = 500;
params5.TimePeriodRange = [0, 6];

input5.DampingRatio = 0.05;
input5.SiteClass = 'II';
input5.SeismicGroup = 2;

earthquake_types = {'frequent', 'rare'};
type_names = {'多遇地震', '罕遇地震'};

disp('多遇地震与罕遇地震对比:');
disp('  地震类型 | 最大系数 αmax | 特征周期 Tg (s)');
disp('  ------------------------------------------------');

figure('Position', [100 100 900 600]);
hold on;

for i = 1:length(earthquake_types)
    params5.EarthquakeType = earthquake_types{i};
    obj = method.SeismicCoefficient(params5, input5);
    obj = obj.solve();

    fprintf('  %8s |     %.3f     |     %.2f\n', ...
            type_names{i}, obj.output.AlphaMax, obj.output.Tg);

    if strcmp(earthquake_types{i}, 'frequent')
        line_style = 'b-';
    else
        line_style = 'r--';
    end

    plot(obj.output.PeriodArray, obj.output.AlphaCurve, ...
         line_style, 'LineWidth', 2, 'DisplayName', ...
         [type_names{i} ', αmax=' num2str(obj.output.AlphaMax)]);
end

hold off;
grid on;
xlabel('周期 T (s)', 'FontSize', 12);
ylabel('地震影响系数 \alpha', 'FontSize', 12);
title('多遇地震与罕遇地震的地震影响系数曲线对比', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);

saveas(gcf, 'SeismicCoefficient_Type5_EarthquakeTypeComparison.png');
disp('图像已保存: SeismicCoefficient_Type5_EarthquakeTypeComparison.png');
disp(' ');

%% 测试用例6：不同设计地震分组
disp('==========================================');
disp('--- 测试用例6：不同设计地震分组 ---');

params6.SeismicIntensity = '8_0.15g';
params6.EarthquakeType = 'frequent';
params6.NumPoints = 500;
params6.TimePeriodRange = [0, 6];

input6.DampingRatio = 0.05;
input6.SiteClass = 'III';  % 使用III类场地，不同分组差异更明显

seismic_groups = [1, 2, 3];

disp('不同设计地震分组的特征周期:');
disp('  分组 | 特征周期 Tg (s)');
disp('  ------------------------');

figure('Position', [100 100 900 600]);
hold on;

colors = {'b', 'g', 'r'};

for i = 1:length(seismic_groups)
    input6.SeismicGroup = seismic_groups(i);
    obj = method.SeismicCoefficient(params6, input6);
    obj = obj.solve();

    fprintf('  %2d   |     %.2f\n', seismic_groups(i), obj.output.Tg);

    plot(obj.output.PeriodArray, obj.output.AlphaCurve, ...
         [colors{i} '-'], 'LineWidth', 2, 'DisplayName', ...
         ['第' num2str(seismic_groups(i)) '组, Tg=' num2str(obj.output.Tg) 's']);
end

hold off;
grid on;
xlabel('周期 T (s)', 'FontSize', 12);
ylabel('地震影响系数 \alpha', 'FontSize', 12);
title('不同设计地震分组的地震影响系数曲线对比', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);

saveas(gcf, 'SeismicCoefficient_Type6_GroupComparison.png');
disp('图像已保存: SeismicCoefficient_Type6_GroupComparison.png');
disp(' ');

%% 测试用例7：极小阻尼比情况
disp('==========================================');
disp('--- 测试用例7：极小阻尼比情况 (ζ = 0.01) ---');

input7.DampingRatio = 0.01;        % 极小阻尼比 1%
input7.SiteClass = 'II';
input7.SeismicGroup = 2;

params7.SeismicIntensity = '8_0.15g';
params7.EarthquakeType = 'frequent';
params7.NumPoints = 500;
params7.TimePeriodRange = [0, 6];

obj7 = method.SeismicCoefficient(params7, input7);
obj7 = obj7.solve();

disp('极小阻尼比的计算结果:');
fprintf('  阻尼比 ζ = %.3f\n', obj7.input.DampingRatio);
fprintf('  衰减指数 γ = %.4f (>0.9)\n', obj7.output.Gamma);
fprintf('  调整系数 η1 = %.4f\n', obj7.output.Eta1);
fprintf('  调整系数 η2 = %.4f (放大效应)\n', obj7.output.Eta2);
disp(' ');

obj7.PlotAlphaCurve('SavePath', 'SeismicCoefficient_Type7_LowDamping.png');
disp(' ');

%% 测试用例8：不同周期范围
disp('==========================================');
disp('--- 测试用例8：不同周期范围 ---');

params8.SeismicIntensity = '8_0.15g';
params8.EarthquakeType = 'frequent';
params8.NumPoints = 500;

input8.DampingRatio = 0.05;
input8.SiteClass = 'II';
input8.SeismicGroup = 2;

period_ranges = {[0, 3], [0, 6], [0.01, 4]};

disp('不同周期范围的地震影响系数曲线:');
disp('  周期范围 (s) | Tg位置 | α(Tg) | T=0.1s处α值');
disp('  -------------------------------------------------');

figure('Position', [100 100 900 600]);
hold on;

colors = {'b', 'g', 'r'};

for i = 1:length(period_ranges)
    params8.TimePeriodRange = period_ranges{i};
    obj = method.SeismicCoefficient(params8, input8);
    obj = obj.solve();

    % 计算T=0.1s处的α值
    [~, idx] = min(abs(obj.output.PeriodArray - 0.1));
    alpha_0_1 = obj.output.AlphaCurve(idx);

    fprintf('  [%5.2f, %5.2f] | %.2f   | %.3f |    %.3f\n', ...
            period_ranges{i}(1), period_ranges{i}(2), obj.output.Tg, ...
            obj.output.AlphaMax * obj.output.Eta2, alpha_0_1);

    plot(obj.output.PeriodArray, obj.output.AlphaCurve, ...
         [colors{i} '-'], 'LineWidth', 2, 'DisplayName', ...
         ['[' num2str(period_ranges{i}(1)) ', ' num2str(period_ranges{i}(2)) ']s']);
end

hold off;
grid on;
xlabel('周期 T (s)', 'FontSize', 12);
ylabel('地震影响系数 \alpha', 'FontSize', 12);
title('不同周期范围的地震影响系数曲线', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);

saveas(gcf, 'SeismicCoefficient_Type8_PeriodRangeComparison.png');
disp('图像已保存: SeismicCoefficient_Type8_PeriodRangeComparison.png');
disp(' ');

%% 测试完成
disp('==========================================');
disp('  所有测试完成');
disp('==========================================');

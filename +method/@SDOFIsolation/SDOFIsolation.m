classdef SDOFIsolation < Component
    % SDOFIsolation - 基础隔震单自由度分析组件
    % Author: Xie Yu
    % Date: 2026-02-03
    %
    % 单位系统:
    %   - 质量: ton (吨)
    %   - 长度: mm (毫米)
    %   - 压力/应力: MPa (兆帕)
    %   - 加速度: m/s²
    %   - 频率: rad/s
    %
    % 功能:
    %   - 自振频率计算
    %   - 阻尼比计算
    %   - 加速度衰减比计算
    %   - 位移反应分析
    %   - 隔震效果判断
    %   - 安全校核

    properties
        plotLanguage = 'CN'  % 绘图语言: 'CN' or 'EN'
    end

    properties(Hidden, Constant)
        % 中英文标签对照表
        labels_CN = struct(...
            'sgtitle', '基础隔震单自由度分析', ...
            'freq_ratio', '频率比 r = \omega/\omega_n', ...
            'acc_ratio', '加速度衰减比 R_a', ...
            'disp_ratio', '位移衰减比 R_d', ...
            'acc_curve', '加速度衰减比曲线', ...
            'disp_curve', '位移衰减比曲线', ...
            'safety_comp', '安全系数对比', ...
            'freq_resp', '频率响应曲线', ...
            'isolation_effect', '隔震效果', ...
            'damping_eval', '阻尼参数评估', ...
            'freq_margin', '频率比裕度', ...
            'displ_safety', '位移安全', ...
            'overall_safety', '综合安全', ...
            'disp_safety', '位移安全', ...
            'damping', '阻尼比 \xi', ...
            'current_damping', '当前阻尼比', ...
            'safety_factor', '安全系数', ...
            'capacity', 'Capacity', ...
            'baseline', 'Baseline', ...
            'attenuation', '衰减比', ...
            'current_point', '当前点', ...
            'Ra_equals_1', 'R_a=1', ...
            'upper_limit', '上限', ...
            'lower_limit', '下限', ...
            'r_threshold', 'r=1.414', ...
            'baseline_Rd', '基线R_d=1', ...
            'resonance_r1', '共振r=1', ...
            'invalid_region', '无效区域', ...
            'valid_region', '有效区域', ...
            'current_workpoint', '当前工作点', ...
            'boundary', '隔震有效分界线', ...
            'damping_low', '阻尼偏低，建议增大', ...
            'damping_high', '阻尼偏高，影响隔震效果', ...
            'damping_ok', '阻尼适中，符合要求', ...
            'effect_valid', '效果: 有效', ...
            'effect_invalid', '效果: 无效', ...
            'effect_resonance', '效果: 共振风险', ...
            'reduce_degree', '降低烈度' ...
        );

        labels_EN = struct(...
            'sgtitle', 'Base Isolation SDOF Analysis', ...
            'freq_ratio', 'Frequency Ratio r = \omega/\omega_n', ...
            'acc_ratio', 'Acceleration Attenuation Ratio R_a', ...
            'disp_ratio', 'Displacement Attenuation Ratio R_d', ...
            'acc_curve', 'Acceleration Attenuation Curve', ...
            'disp_curve', 'Displacement Attenuation Curve', ...
            'safety_comp', 'Safety Factor Comparison', ...
            'freq_resp', 'Frequency Response Curve', ...
            'isolation_effect', 'Isolation Effect', ...
            'damping_eval', 'Damping Parameter Evaluation', ...
            'freq_margin', 'Freq. Ratio Margin', ...
            'displ_safety', 'Disp. Safety', ...
            'overall_safety', 'Overall Safety', ...
            'disp_safety', 'Disp. Safety', ...
            'damping', 'Damping Ratio \xi', ...
            'current_damping', 'Current Damping Ratio', ...
            'safety_factor', 'Safety Factor', ...
            'capacity', 'Capacity', ...
            'baseline', 'Baseline', ...
            'attenuation', 'Attenuation Ratio', ...
            'current_point', 'Current Point', ...
            'Ra_equals_1', 'R_a=1', ...
            'upper_limit', 'Upper Limit', ...
            'lower_limit', 'Lower Limit', ...
            'r_threshold', 'r=1.414', ...
            'baseline_Rd', 'Baseline R_d=1', ...
            'resonance_r1', 'Resonance r=1', ...
            'invalid_region', 'Invalid Region', ...
            'valid_region', 'Valid Region', ...
            'current_workpoint', 'Current Workpoint', ...
            'boundary', 'Isolation Valid Boundary', ...
            'damping_low', 'Damping too low, increase recommended', ...
            'damping_high', 'Damping too high, affects isolation', ...
            'damping_ok', 'Damping appropriate, meets requirements', ...
            'effect_valid', 'Effect: Valid', ...
            'effect_invalid', 'Effect: Invalid', ...
            'effect_resonance', 'Effect: Resonance Risk', ...
            'reduce_degree', 'Intensity Reduction' ...
        );

        % Input 预期字段
        inputExpectedFields = {
            'M'               % 上部结构总质量 [ton]
            'K'               % 隔震层刚度 [N/mm]
            'C'               % 隔震层阻尼系数 [N·s/mm]
            'ground_acc'      % 地面运动加速度 [m/s²]
            'soil_freq'       % 场地土特征频率 [rad/s]
            'height'          % 建筑高度 [mm]
            };

        % Output 预期字段
        outputExpectedFields = {
            'natural_freq'            % 自振频率 [rad/s]
            'damping_ratio'           % 阻尼比
            'freq_ratio'              % 频率比
            'acc_attenuation_ratio'   % 加速度反应衰减比 R_a
            'disp_attenuation_ratio'  % 位移反应衰减比 R_d
            'max_displacement'        % 最大位移反应 [mm]
            'isolation_effect'        % 隔震效果判断（有效/无效/共振风险）
            'seismic_reduction'       % 地震烈度降低等级
            };

        % Params 预期字段
        paramsExpectedFields = {
            'calc_method'      % 计算方法（频域/时域）
            'Echo'             % 是否输出中间过程
            'Name'             % 名称
            };

        % Baseline 预期字段
        baselineExpectedFields = {
            'min_freq_ratio'       % 频率比最小要求 (1.414)
            'acc_ratio_min'        % 加速度衰减比下限 (0.06)
            'acc_ratio_max'        % 加速度衰减比上限 (0.33)
            'max_displacement'     % 最大允许水平位移 [mm]
            'min_safety_factor'    % 最小综合安全系数
            };

        % Params 默认值
        default_calc_method = '频域';
        default_Echo = false;
        default_Name = 'SDOFIsolation';

        % Baseline 默认值
        base_min_freq_ratio = 1.414;     % 隔震有效阈值
        base_acc_ratio_min = 0.06;       % 对应降低5度地震烈度
        base_acc_ratio_max = 0.33;       % 对应降低2.5度地震烈度
        base_max_displacement = 500;     % 最大允许位移 [mm]
        base_min_safety_factor = 1.0;    % 默认安全系数要求

    end

    methods

        function obj = SDOFIsolation(paramsStruct, inputStruct, varargin)
            % 构造函数
            obj = obj@Component(paramsStruct, inputStruct, varargin);
            obj.documentname = 'SDOFIsolation.pdf';
        end

        function obj = solve(obj)
            % 核心计算方法

            if obj.params.Echo
                disp('==========================================');
                disp('  基础隔震单自由度分析');
                disp('==========================================');
                disp(' ');
            end

            % 1. 检查适用条件
            obj = obj.checkApplicability();

            % 2. 计算核心参数
            obj = obj.calculateCoreParameters();

            % 3. 计算加速度响应
            obj = obj.calculateAccelerationResponse();

            % 4. 计算位移响应
            obj = obj.calculateDisplacementResponse();

            % 5. 判断隔震效果
            obj = obj.evaluateIsolationEffect();

            % 6. 计算安全系数
            obj = obj.calculateSafetyFactors();


            if obj.params.Echo
                disp('==========================================');
                disp('  计算完成');
                disp('==========================================');
                disp(' ');
            end
        end

        function obj = checkApplicability(obj)
            % 检查适用条件

            % 检查建筑高度（应小于40m = 40000mm）
            max_height_mm = 40000;  % mm
            height_m = obj.input.height / 1000;  % mm -> m

            if obj.input.height > max_height_mm
                warning(['建筑高度 %.1fm 超过适用范围 %.1fm，' ...
                         '单自由度模型可能不适用'], ...
                        height_m, max_height_mm/1000);
            end

            if obj.params.Echo
                fprintf('  建筑高度: %.1fm (适用条件: <%.1fm)\n', ...
                        height_m, max_height_mm/1000);
                fprintf('  适用场景确认: 高度<40m、剪切变形为主、上部结构刚度远大于隔震层\n\n');
            end
        end

        function obj = calculateCoreParameters(obj)
            % 计算核心参数
            % 单位转换: ton -> kg (x1000), mm -> m (x0.001)

            % 1. 计算自振频率
            % ω_n = sqrt(K/M), 需要将K从N/mm转换为N/m，M从ton转换为kg
            % K [N/mm] = K * 1000 [N/m]
            % M [ton] = M * 1000 [kg]
            K_si = obj.input.K * 1000;  % N/mm -> N/m
            M_si = obj.input.M * 1000;  % ton -> kg
            obj.output.natural_freq = sqrt(K_si / M_si);

            % 2. 计算阻尼比
            % ξ = C / (2*M*ω_n)
            % C [N·s/mm] = C * 1000 [N·s/m]
            omega_n = obj.output.natural_freq;
            C_si = obj.input.C * 1000;  % N·s/mm -> N·s/m
            obj.output.damping_ratio = C_si / (2 * M_si * omega_n);

            % 3. 计算频率比
            obj.output.freq_ratio = obj.input.soil_freq / omega_n;

            if obj.params.Echo
                fprintf('  [核心参数计算]\n');
                fprintf('  上部结构总质量 M = %.2f ton (%.0f kg)\n', ...
                        obj.input.M, M_si);
                fprintf('  隔震层刚度 K = %.2e N/mm (%.2e N/m)\n', ...
                        obj.input.K, K_si);
                fprintf('  隔震层阻尼系数 C = %.2e N·s/mm (%.2e N·s/m)\n', ...
                        obj.input.C, C_si);
                fprintf('  自振频率 ω_n = %.3f rad/s\n', omega_n);
                fprintf('  阻尼比 ξ = %.4f (%.2f%%)\n', ...
                        obj.output.damping_ratio, obj.output.damping_ratio * 100);
                fprintf('  场地土特征频率 ω = %.3f rad/s\n', obj.input.soil_freq);
                fprintf('  频率比 r = ω/ω_n = %.3f\n\n', obj.output.freq_ratio);
            end
        end

        function obj = calculateAccelerationResponse(obj)
            % 计算加速度响应

            % 获取参数
            r = obj.output.freq_ratio;
            xi = obj.output.damping_ratio;

            % 计算频率响应函数
            % H(ω) = sqrt((1 + (2ξr)²) / ((1 - r²)² + (2ξr)²))
            numerator = 1 + (2*xi*r)^2;
            denominator = (1 - r^2)^2 + (2*xi*r)^2;
            H_omega = sqrt(numerator / denominator);

            obj.output.acc_attenuation_ratio = H_omega;

            if obj.params.Echo
                fprintf('  [加速度响应分析]\n');
                fprintf('  地面运动加速度 = %.3f m/s²\n', obj.input.ground_acc);
                fprintf('  频率响应函数 H(ω) = %.4f\n', H_omega);
                fprintf('  加速度衰减比 R_a = %.4f\n', H_omega);

                % 计算上部结构加速度
                acc_structure = obj.input.ground_acc * H_omega;
                fprintf('  上部结构加速度 = %.3f m/s²\n\n', acc_structure);
            end
        end

        function obj = calculateDisplacementResponse(obj)
            % 计算位移响应
            % 输出单位: mm

            % 获取参数
            r = obj.output.freq_ratio;
            xi = obj.output.damping_ratio;
            omega = obj.input.soil_freq;

            % 计算地面运动位移 (单位: m)
            % D_g = |x_g| = |a_g| / ω²
            D_g_m = abs(obj.input.ground_acc) / omega^2;

            % 计算最大位移反应 (单位: m)
            % D_s = D_g * r² / sqrt((1 - r²)² + (2ξr)²)
            denominator = sqrt((1 - r^2)^2 + (2*xi*r)^2);
            D_s_m = D_g_m * r^2 / denominator;

            % 转换为 mm 并存储
            D_g_mm = D_g_m * 1000;
            D_s_mm = D_s_m * 1000;

            obj.output.max_displacement = D_s_mm;
            obj.output.disp_attenuation_ratio = D_s_m / D_g_m;

            if obj.params.Echo
                fprintf('  [位移响应分析]\n');
                fprintf('  地面运动位移 D_g = %.3f mm\n', D_g_mm);
                fprintf('  最大位移反应 D_s = %.3f mm\n', D_s_mm);
                fprintf('  位移衰减比 R_d = %.4f\n\n', D_s_m / D_g_m);
            end
        end

        function obj = evaluateIsolationEffect(obj)
            % 判断隔震效果

            r = obj.output.freq_ratio;
            R_a = obj.output.acc_attenuation_ratio;

            % 隔震效果判断
            if abs(r - 1) < 0.1
                % 共振风险
                obj.output.isolation_effect = '共振风险';
                obj.output.seismic_reduction = 0;
            elseif r >= 1.414
                % 隔震有效
                obj.output.isolation_effect = '有效';
                % 计算地震烈度降低等级
                if R_a >= 0.06 && R_a <= 0.33
                    obj.output.seismic_reduction = 2.5 + (0.33 - R_a) / (0.33 - 0.06) * 2.5;
                elseif R_a < 0.06
                    obj.output.seismic_reduction = 5 + (0.06 - R_a) * 10;
                else
                    obj.output.seismic_reduction = 2.5;
                end
            else
                % 隔震无效
                obj.output.isolation_effect = '无效';
                obj.output.seismic_reduction = 0;
            end

            if obj.params.Echo
                fprintf('  [隔震效果判断]\n');
                fprintf('  频率比 r = %.3f\n', r);
                fprintf('  阈值判断: r ', r);
                if r >= 1.414
                    fprintf('>= 1.414 ✓ (隔震有效)\n');
                else
                    fprintf('< 1.414 ✗ (隔震无效)\n');
                end

                if abs(r - 1) < 0.1
                    fprintf('  警告: 频率比接近1，存在共振风险！\n');
                end

                fprintf('  加速度衰减比 R_a = %.4f\n', R_a);
                fprintf('  目标范围: [%.2f, %.2f]\n', ...
                        obj.baseline.acc_ratio_min, obj.baseline.acc_ratio_max);

                % 使用strcmp进行字符串比较
                if strcmp(obj.output.isolation_effect, '有效')
                    fprintf('  隔震效果: %s\n', obj.output.isolation_effect);
                    fprintf('  预计降低地震烈度: %.1f 度\n\n', obj.output.seismic_reduction);
                else
                    fprintf('  隔震效果: %s\n\n', obj.output.isolation_effect);
                end
            end
        end

        function obj = calculateSafetyFactors(obj)
            % 计算安全系数

            r = obj.output.freq_ratio;
            R_a = obj.output.acc_attenuation_ratio;
            D_s = obj.output.max_displacement;

            % 1. 频率比安全裕度
            obj.capacity.freq_ratio_margin = r / obj.baseline.min_freq_ratio;

            % 2. 加速度衰减比符合性
            obj.capacity.acc_ratio_compliance = (R_a >= obj.baseline.acc_ratio_min) && ...
                                                 (R_a <= obj.baseline.acc_ratio_max);

            % 3. 位移安全系数
            if D_s > 0
                obj.capacity.disp_safety_factor = obj.baseline.max_displacement / D_s;
            else
                obj.capacity.disp_safety_factor = Inf;
            end

            % 4. 共振风险判断
            obj.capacity.resonance_risk = (abs(r - 1) < 0.1);

            % 5. 综合安全判断
            obj.capacity.overall_safety = (r >= obj.baseline.min_freq_ratio) && ...
                                          obj.capacity.acc_ratio_compliance && ...
                                          (D_s <= obj.baseline.max_displacement) && ...
                                          ~obj.capacity.resonance_risk;

            % 6. 综合安全系数（取各安全系数的最小值）
            safety_ratios = [obj.capacity.freq_ratio_margin, ...
                             obj.capacity.disp_safety_factor];
            obj.capacity.safety_factor = min(safety_ratios);

            if obj.params.Echo
                fprintf('  [安全系数计算]\n');
                fprintf('  频率比安全裕度: %.3f\n', obj.capacity.freq_ratio_margin);

                % 加速度衰减比符合性
                if obj.capacity.acc_ratio_compliance
                    acc_str = '满足';
                else
                    acc_str = '不满足';
                end
                fprintf('  加速度衰减比符合性: %s\n', acc_str);

                fprintf('  位移安全系数: %.3f\n', obj.capacity.disp_safety_factor);

                % 共振风险
                if obj.capacity.resonance_risk
                    res_str = '存在';
                else
                    res_str = '不存在';
                end
                fprintf('  共振风险: %s\n', res_str);

                % 综合安全判断
                if obj.capacity.overall_safety
                    safe_str = '满足';
                else
                    safe_str = '不满足';
                end
                fprintf('  综合安全判断: %s\n', safe_str);

                fprintf('  综合安全系数: %.3f\n\n', obj.capacity.safety_factor);
            end
        end

        function checkSafety(obj)
            % 安全校核 - 检查是否满足安全要求

            warnings = {};

            % 1. 频率比校核
            if obj.output.freq_ratio < obj.baseline.min_freq_ratio
                msg = sprintf('频率比 %.3f 小于要求 %.3f，隔震无效', ...
                            obj.output.freq_ratio, obj.baseline.min_freq_ratio);
                warnings{end+1} = msg;
            end

            % 2. 加速度衰减比校核
            R_a = obj.output.acc_attenuation_ratio;
            if R_a < obj.baseline.acc_ratio_min
                msg = sprintf(['加速度衰减比 %.3f 小于下限 %.2f，' ...
                             '隔震效果过强（可能需要调整阻尼）'], ...
                            R_a, obj.baseline.acc_ratio_min);
                warnings{end+1} = msg;
            elseif R_a > obj.baseline.acc_ratio_max
                msg = sprintf(['加速度衰减比 %.3f 大于上限 %.2f，' ...
                             '隔震效果不足'], R_a, obj.baseline.acc_ratio_max);
                warnings{end+1} = msg;
            end

            % 3. 位移安全校核
            if obj.capacity.disp_safety_factor < obj.baseline.min_safety_factor
                msg = sprintf(['位移安全系数 %.3f 小于要求 %.3f，' ...
                             '位移 %.1fmm 超过允许值 %.1fmm'], ...
                            obj.capacity.disp_safety_factor, ...
                            obj.baseline.min_safety_factor, ...
                            obj.output.max_displacement, ...
                            obj.baseline.max_displacement);
                warnings{end+1} = msg;
            end

            % 4. 共振风险检查
            if obj.capacity.resonance_risk
                msg = sprintf(['频率比 %.3f 接近共振点 1.0，' ...
                             '存在共振风险！'], obj.output.freq_ratio);
                warnings{end+1} = msg;
            end

            % 5. 综合安全系数校核
            if obj.capacity.safety_factor < obj.baseline.min_safety_factor
                msg = sprintf('综合安全系数 %.3f 小于要求 %.3f', ...
                            obj.capacity.safety_factor, obj.baseline.min_safety_factor);
                warnings{end+1} = msg;
            end

            % 输出校核结果
            disp(' ');
            disp('==========================================');
            disp('  安全校核结果');
            disp('==========================================');
            if ~isempty(warnings)
                fprintf('  发现 %d 个警告:\n\n', length(warnings));
                for i = 1:length(warnings)
                    fprintf('  警告 %d: %s\n', i, warnings{i});
                end
            else
                disp('  ✓ 所有必要的安全校核均通过');
                fprintf('  综合安全系数 %.3f >= %.3f\n', ...
                        obj.capacity.safety_factor, ...
                        obj.baseline.min_safety_factor);
                fprintf('  预计降低地震烈度: %.1f 度\n', obj.output.seismic_reduction);
            end
            disp('==========================================');
            disp(' ');
        end

        function InteractiveUI(obj)
            % 覆盖基类的InteractiveUI，确保正确工作
            obj.InteractiveUI@Component();
        end

    end

    methods (Hidden)

        function PlotCapacity(obj, varargin)
            % 绘制容量与基准对比图

            p = inputParser;
            addParameter(p,'ylim',[0,5]);
            parse(p,varargin{:});
            opt=p.Results;

            Base=obj.baseline;
            Capacity=obj.capacity;

            % 获取标签
            labels = obj.getLabels();

            % 创建图形窗口
            fig = figure('Position',[100 100 1400 800], 'Name', 'SDOF Isolation Analysis');

            % 添加语言切换按钮
            uicontrol('Style', 'pushbutton', ...
                      'String', 'CN/EN', ...
                      'Units', 'normalized', ...
                      'Position', [0.88 0.92 0.08 0.05], ...
                      'FontSize', 11, ...
                      'FontWeight', 'bold', ...
                      'Callback', @(src,evt) obj.toggleLanguage(fig, opt));

            % 子图1: 加速度衰减比曲线
            subplot(2,3,1);
            obj.plotAccAttenuationCurve(labels);

            % 子图2: 位移衰减比曲线
            subplot(2,3,2);
            obj.plotDispAttenuationCurve(labels);

            % 子图3: 安全系数对比
            subplot(2,3,3);
            obj.plotSafetyComparison(labels);

            % 子图4: 频率响应曲线
            subplot(2,3,4);
            obj.plotFrequencyResponse(labels);

            % 子图5: 隔震效果可视化
            subplot(2,3,5);
            obj.plotIsolationEffect(labels);

            % 子图6: 阻尼参数评估
            subplot(2,3,6);
            obj.plotDampingOptimization(labels);

            sgtitle(labels.sgtitle, 'FontSize', 14, 'FontWeight', 'bold');
        end

        function plotAccAttenuationCurve(obj, labels)
            % 绘制加速度衰减比曲线

            if nargin < 2
                labels = obj.getLabels();
            end

            xi = obj.output.damping_ratio;
            r_current = obj.output.freq_ratio;

            % 频率比范围
            r = linspace(0.5, 5, 200);

            % 计算加速度衰减比
            Ra = zeros(size(r));
            for i = 1:length(r)
                numerator = 1 + (2*xi*r(i))^2;
                denominator = (1 - r(i)^2)^2 + (2*xi*r(i))^2;
                Ra(i) = sqrt(numerator / denominator);
            end

            % 绘制曲线
            plot(r, Ra, 'b-', 'LineWidth', 2);
            hold on;

            % 标记当前工作点
            Ra_current = obj.output.acc_attenuation_ratio;
            plot(r_current, Ra_current, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

            % 绘制目标区域
            plot([0.5 5], [1 1], 'k--', 'LineWidth', 1);
            plot([0.5 5], [obj.baseline.acc_ratio_max obj.baseline.acc_ratio_max], 'g--', 'LineWidth', 1);
            plot([0.5 5], [obj.baseline.acc_ratio_min obj.baseline.acc_ratio_min], 'g--', 'LineWidth', 1);
            plot([1.414 1.414], [0 max(Ra)*1.2], 'm--', 'LineWidth', 1);

            hold off;

            grid on;
            xlabel(labels.freq_ratio);
            ylabel(labels.acc_ratio);
            title(labels.acc_curve);
            legend({labels.attenuation, labels.current_point, labels.Ra_equals_1, ...
                    labels.upper_limit, labels.lower_limit, labels.r_threshold}, ...
                   'Location', 'best', 'FontSize', 8);
            axis([0.5 5 0 max(Ra)*1.1]);
        end

        function plotDispAttenuationCurve(obj, labels)
            % 绘制位移衰减比曲线

            if nargin < 2
                labels = obj.getLabels();
            end

            xi = obj.output.damping_ratio;
            r_current = obj.output.freq_ratio;

            % 频率比范围
            r = linspace(0.5, 5, 200);

            % 计算位移衰减比（简化形式，忽略地面位移常数）
            Rd = r.^2 ./ sqrt((1-r.^2).^2 + (2*xi*r).^2);

            % 归一化处理
            % Rd = Rd / max(Rd);

            % 绘制曲线
            plot(r, Rd, 'b-', 'LineWidth', 2);
            hold on;

            % 标记当前工作点
            Rd_current = obj.output.disp_attenuation_ratio;

            scatter(r_current, Rd_current, 120, 'r', 'filled', ...
                     'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

            % 绘制基线
            plot([0.5 5], [1 1], 'k--', 'LineWidth', 1);
            plot([1 1], [0 max(Rd)], 'r--', 'LineWidth', 1);

            hold off;

            grid on;
            xlabel(labels.freq_ratio);
            ylabel(labels.disp_ratio);
            title(labels.disp_curve);
            legend({labels.attenuation, labels.current_point, labels.baseline_Rd, labels.resonance_r1}, ...
                   'Location', 'best', 'FontSize', 8);
            axis([0.5 5 0 1.1*max(Rd)]);
        end

        function plotSafetyComparison(obj, labels)
            % 绘制安全系数对比图

            if nargin < 2
                labels = obj.getLabels();
            end

            x_labels = {labels.freq_margin, labels.disp_safety, labels.overall_safety};
            capacity_values = [
                obj.capacity.freq_ratio_margin;
                obj.capacity.disp_safety_factor;
                obj.capacity.safety_factor
            ];
            baseline_values = [
                1;  % 频率比裕度基准为1
                obj.baseline.min_safety_factor;
                obj.baseline.min_safety_factor
            ];

            % 绘制条形图
            x = 1:length(x_labels);
            b1 = bar(x, capacity_values, 'BarWidth', 0.4);
            hold on;
            b2 = bar(x + 0.4, baseline_values, 'BarWidth', 0.4, 'FaceColor', [0.8 0.2 0.2]);

            % 判断是否满足要求
            colors = capacity_values >= baseline_values;
            for i = 1:length(colors)
                if colors(i)
                    b1.CData(i,:) = [0.2 0.8 0.2];  % 绿色
                else
                    b1.CData(i,:) = [0.8 0.2 0.2];  % 红色
                end
            end
            b1.FaceColor = 'flat';

            hold off;

            grid on;
            set(gca, 'XTick', x + 0.2);
            set(gca, 'XTickLabel', x_labels);
            ylabel(labels.safety_factor);
            title(labels.safety_comp);
            legend({labels.capacity, labels.baseline});
        end

        function plotFrequencyResponse(obj, labels)
            % 绘制频率响应

            if nargin < 2
                labels = obj.getLabels();
            end

            xi = obj.output.damping_ratio;
            omega_n = obj.output.natural_freq;

            % 频率比范围
            r = linspace(0.1, 5, 200);

            % 计算加速度衰减比
            Ra = zeros(size(r));
            for i = 1:length(r)
                numerator = 1 + (2*xi*r(i))^2;
                denominator = (1 - r(i)^2)^2 + (2*xi*r(i))^2;
                Ra(i) = sqrt(numerator / denominator);
            end

            % 绘制曲线
            plot(r, Ra, 'b-', 'LineWidth', 2);
            hold on;

            % 标记关键点
            r_current = obj.output.freq_ratio;
            Ra_current = obj.output.acc_attenuation_ratio;
            plot(r_current, Ra_current, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
            plot([1.414 1.414], [0 max(Ra)*1.2], 'g--', 'LineWidth', 2);

            % 标记不同阻尼比的曲线
            xi_values = [0.02, 0.05, 0.15, 0.25];
            colors = [0.8 0.2 0.2; 0.2 0.8 0.2; 0.2 0.2 0.8; 0.8 0.8 0.2];
            for i = 1:length(xi_values)
                Ra_i = zeros(size(r));
                for j = 1:length(r)
                    numerator = 1 + (2*xi_values(i)*r(j))^2;
                    denominator = (1 - r(j)^2)^2 + (2*xi_values(i)*r(j))^2;
                    Ra_i(j) = sqrt(numerator / denominator);
                end
                plot(r, Ra_i, '--', 'Color', colors(i,:));
            end

            hold off;

            grid on;
            xlabel(labels.freq_ratio);
            ylabel(labels.acc_ratio);
            title(labels.freq_resp);
            legend({sprintf('\\xi=%.2f', xi), labels.current_point, labels.r_threshold, ...
                    '\\xi=0.02', '\\xi=0.05', '\\xi=0.15', '\\xi=0.25'}, ...
                   'Location', 'best', 'FontSize', 8);
            axis([0.1 5 0 max(Ra)*1.1]);
        end

        function plotIsolationEffect(obj, labels)
            % 绘制隔震效果可视化

            if nargin < 2
                labels = obj.getLabels();
            end

            r = obj.output.freq_ratio;
            R_a = obj.output.acc_attenuation_ratio;

            % 绘制效果区域
            x = [0.5 1.414 5];
            y = [0 0 0];
            colors = [0.8 0.2 0.2; 0.2 0.8 0.2];

            % 无效区域 (r < 1.414) - 红色背景
            fill([0.5, 1.414, 1.414, 0.5], [0, 0, 1.5, 1.5], [1 0.3 0.3], ...
                 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            hold on;

            % 有效区域 (r > 1.414) - 绿色背景
            fill([1.414, 5, 5, 1.414], [0, 0, 1.5, 1.5], [0.3 0.8 0.3], ...
                 'FaceAlpha', 0.2, 'EdgeColor', 'none');

            % 绘制分界线
            plot([1.414 1.414], [0 1.5], 'k-', 'LineWidth', 2);

            % 标记当前点
            plot(r, R_a, 'o', 'MarkerSize', 15, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');

            % 添加区域文字标注（放在上部，字体缩小）
            text(1, 1.4, labels.invalid_region, 'HorizontalAlignment', 'center', 'FontSize', 6, ...
                 'FontWeight', 'bold', 'Color', [0.8 0.2 0.2]);
            text(3, 1.4, labels.valid_region, 'HorizontalAlignment', 'center', 'FontSize', 6, ...
                 'FontWeight', 'bold', 'Color', [0.2 0.6 0.2]);

            hold off;

            grid on;
            xlabel(labels.freq_ratio);
            ylabel(labels.acc_ratio);
            title(labels.isolation_effect);
            legend({labels.current_workpoint, labels.boundary}, 'Location', 'northeast', 'FontSize', 8);

            % 添加效果说明（在左下角，位置调整）
            if obj.output.isolation_effect == '有效'
                if strcmp(obj.plotLanguage, 'CN')
                    effect_text = sprintf('效果: 有效\n降低烈度: %.1f度', obj.output.seismic_reduction);
                else
                    effect_text = sprintf('%s\n%s: %.1f', labels.effect_valid, labels.reduce_degree, obj.output.seismic_reduction);
                end
            elseif obj.output.isolation_effect == '共振风险'
                effect_text = labels.effect_resonance;
            else
                effect_text = labels.effect_invalid;
            end
            text(0.6, 0.15, effect_text, 'FontSize', 6, 'BackgroundColor', [1 1 1 0.85], ...
                 'EdgeColor', 'k', 'LineWidth', 1);

            axis([0.5 5 0 1.5]);
        end

        function plotDampingOptimization(obj, labels)
            % 绘制阻尼参数评估

            if nargin < 2
                labels = obj.getLabels();
            end

            xi = obj.output.damping_ratio;

            % 只显示当前阻尼比和评估
            bar(xi, 'BarWidth', 0.4, 'FaceColor', [0.2 0.4 0.8]);

            grid on;
            set(gca, 'XTick', 1);
            set(gca, 'XTickLabel', labels.current_damping);
            ylabel(labels.damping);
            title(labels.damping_eval);

            % 设置y轴范围，确保评估文字有空间
            ylim_max = max(0.5, xi * 1.5);
            ylim([0, ylim_max]);

            % 添加数值标注（在柱子顶部）
            text(1, xi, sprintf('%.4f', xi), 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'bottom', 'FontSize', 12, 'FontWeight', 'bold');

            % 添加说明文字（在柱子上方）
            if xi < 0.05
                msg = labels.damping_low;
                msg_color = [0.8 0.2 0.2];
            elseif xi > 0.3
                msg = labels.damping_high;
                msg_color = [0.8 0.2 0.2];
            else
                msg = labels.damping_ok;
                msg_color = [0.2 0.6 0.2];
            end
            % 将评估文字放在柱子上方
            text(1, xi * 1.15, msg, 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'bottom', 'FontSize', 11, 'Color', msg_color, 'FontWeight', 'bold');
        end

        function labels = getLabels(obj)
            % 获取当前语言的标签
            if strcmp(obj.plotLanguage, 'CN')
                labels = obj.labels_CN;
            else
                labels = obj.labels_EN;
            end
        end

        function toggleLanguage(obj, fig, opt)
            % 切换绘图语言并重新绘制
            % 切换语言
            if strcmp(obj.plotLanguage, 'CN')
                obj.plotLanguage = 'EN';
            else
                obj.plotLanguage = 'CN';
            end

            % 关闭当前图形并重新绘制
            close(fig);
            obj.PlotCapacity(opt);
        end

    end
end

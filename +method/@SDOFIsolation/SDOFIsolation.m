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

    properties(Hidden, Constant)

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
            'material_type'    % 支座类型
            'elastic_modulus'  % 弹性模量 [MPa]
            'shear_modulus'    % 剪切模量 [MPa]
            'calc_method'      % 计算方法（频域/时域）
            'Echo'             % 是否输出中间过程
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
        default_material_type = '叠层橡胶支座';
        default_elastic_modulus = 5.0;   % MPa
        default_shear_modulus = 1.0;     % MPa
        default_calc_method = '频域';
        default_Echo = false;

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
                msg = sprintf(['频率比 %.3f 小于要求 %.3f，隔震无效'], ...
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

            % 创建图形窗口
            figure('Position',[100 100 1400 800]);

            % 子图1: 加速度衰减比曲线
            subplot(2,3,1);
            obj.plotAccAttenuationCurve();

            % 子图2: 位移衰减比曲线
            subplot(2,3,2);
            obj.plotDispAttenuationCurve();

            % 子图3: 安全系数对比
            subplot(2,3,3);
            obj.plotSafetyComparison();

            % 子图4: 频率响应曲线
            subplot(2,3,4);
            obj.plotFrequencyResponse();

            % 子图5: 隔震效果可视化
            subplot(2,3,5);
            obj.plotIsolationEffect();

            % 子图6: 阻尼参数优化建议
            subplot(2,3,6);
            obj.plotDampingOptimization();

            sgtitle('基础隔震单自由度分析');
        end

        function plotAccAttenuationCurve(obj)
            % 绘制加速度衰减比曲线

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
            plot([1.414 1.414], [0 min(Ra)*1.2], 'm--', 'LineWidth', 1);

            hold off;

            grid on;
            xlabel('频率比 r = \omega/\omega_n');
            ylabel('加速度衰减比 R_a');
            title('加速度衰减比曲线');
            legend({'衰减比', '当前点', 'R_a=1', '上限', '下限', 'r=1.414'}, ...
                   'Location', 'best', 'FontSize', 8);
            axis([0.5 5 0 max(Ra)*1.1]);
        end

        function plotDispAttenuationCurve(obj)
            % 绘制位移衰减比曲线

            xi = obj.output.damping_ratio;
            r_current = obj.output.freq_ratio;

            % 频率比范围
            r = linspace(0.5, 5, 200);

            % 计算位移衰减比（简化形式，忽略地面位移常数）
            Rd = r.^2 ./ sqrt((1-r.^2).^2 + (2*xi*r).^2);

            % 归一化处理
            Rd = Rd / max(Rd);

            % 绘制曲线
            plot(r, Rd, 'b-', 'LineWidth', 2);
            hold on;

            % 标记当前工作点
            Rd_current = obj.output.disp_attenuation_ratio;
            if max(Rd) > 0
                Rd_norm = Rd_current / max(Rd);
            else
                Rd_norm = 0;
            end
            plot(r_current, Rd_norm, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

            % 绘制基线
            plot([0.5 5], [1 1], 'k--', 'LineWidth', 1);
            plot([1 1], [0 1.2], 'r--', 'LineWidth', 1);

            hold off;

            grid on;
            xlabel('频率比 r = \omega/\omega_n');
            ylabel('位移衰减比 R_d (归一化)');
            title('位移衰减比曲线');
            legend({'衰减比', '当前点', '基线R_d=1', '共振r=1'}, ...
                   'Location', 'best', 'FontSize', 8);
            axis([0.5 5 0 1.1]);
        end

        function plotSafetyComparison(obj)
            % 绘制安全系数对比图

            labels = {'频率比裕度', '位移安全', '综合安全'};
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
            x = 1:length(labels);
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
            set(gca, 'XTickLabel', labels);
            ylabel('安全系数');
            title('安全系数对比');
            legend({'Capacity', 'Baseline'});
        end

        function plotFrequencyResponse(obj)
            % 绘制频率响应

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
            xlabel('频率比 r = \omega/\omega_n');
            ylabel('加速度衰减比 R_a');
            title('频率响应曲线');
            legend({sprintf('当前 (\\xi=%.2f)', xi), '当前点', 'r=1.414', ...
                    '\\xi=0.02', '\\xi=0.05', '\\xi=0.15', '\\xi=0.25'}, ...
                   'Location', 'best', 'FontSize', 8);
            axis([0.1 5 0 max(Ra)*1.1]);
        end

        function plotIsolationEffect(obj)
            % 绘制隔震效果可视化

            r = obj.output.freq_ratio;
            R_a = obj.output.acc_attenuation_ratio;

            % 绘制效果区域
            x = [0.5 1.414 5];
            y = [0 0 0];
            colors = [0.8 0.2 0.2; 0.2 0.8 0.2];

            % 无效区域 (r < 1.414)
            fill([0.5, 1.414, 1.414, 0.5], [0, 0, 1.5, 1.5], [0.8 0.8 0.8], ...
                 'FaceAlpha', 0.3, 'EdgeColor', 'none');
            hold on;

            % 有效区域 (r > 1.414)
            fill([1.414, 5, 5, 1.414], [0, 0, 1.5, 1.5], [0.8 0.8 0.8], ...
                 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            % 标记当前点
            plot(r, R_a, 'o', 'MarkerSize', 15, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');

            % 添加文字标注
            text(1, 0.7, '无效区域', 'HorizontalAlignment', 'center', 'FontSize', 10);
            text(3, 0.7, '有效区域', 'HorizontalAlignment', 'center', 'FontSize', 10);

            hold off;

            grid on;
            xlabel('频率比 r = \omega/\omega_n');
            ylabel('加速度衰减比 R_a');
            title('隔震效果');

            % 添加效果说明
            if obj.output.isolation_effect == '有效'
                effect_text = sprintf('效果: 有效\n降低烈度: %.1f度', obj.output.seismic_reduction);
            elseif obj.output.isolation_effect == '共振风险'
                effect_text = '效果: 共振风险';
            else
                effect_text = '效果: 无效';
            end
            text(0.5, 1.3, effect_text, 'FontSize', 10, 'BackgroundColor', 'white');

            axis([0.5 5 0 1.5]);
        end

        function plotDampingOptimization(obj)
            % 绘制阻尼参数优化建议

            xi = obj.output.damping_ratio;
            r = obj.output.freq_ratio;
            R_a = obj.output.acc_attenuation_ratio;

            % 计算目标阻尼比范围
            xi_target_max = 0;

            % 根据当前频率比计算目标阻尼比
            if r >= 1.414
                % 计算使R_a在目标范围内的阻尼比
                Ra_min = obj.baseline.acc_ratio_min;
                Ra_max = obj.baseline.acc_ratio_max;

                % 简化计算（假设r²远大于1）
                xi_min = sqrt((1/Ra_max^2 - 1/r^4) / 4);
                xi_max = sqrt((1/Ra_min^2 - 1/r^4) / 4);

                if xi_max > 0 && isfinite(xi_max) && xi_max >= xi_min
                    xi_target_max = xi_max;
                end
            end

            % 确保xi_target_max有效
            if xi_target_max <= 0 || ~isfinite(xi_target_max)
                xi_target_max = xi * 2;  % 默认建议值为当前值的2倍
            end

            % 绘制柱状图
            h_bar = bar([xi, xi_target_max], 'BarWidth', 0.5, 'FaceColor', 'flat');

            % 设置颜色
            h_bar.CData = [0.2 0.2 0.8; 0.8 0.8 0.2];  % 蓝色 - 当前值, 黄色 - 目标值

            grid on;
            set(gca, 'XTick', [1 2]);
            set(gca, 'XTickLabel', {'当前阻尼比', '建议最大阻尼比'});
            ylabel('阻尼比 \xi');
            title('阻尼参数优化建议');
            ylim([0, max(xi_target_max, xi) * 1.3]);

            % 添加数值标注
            text(1, xi, sprintf('%.4f', xi), 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'bottom', 'FontSize', 10);
            if xi_target_max > 0 && isfinite(xi_target_max)
                text(2, xi_target_max, sprintf('%.4f', xi_target_max), ...
                     'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
                     'FontSize', 10);
            end

            % 添加说明文字
            if xi < 0.05
                msg = '阻尼偏低，建议增大';
            elseif xi > 0.3
                msg = '阻尼偏高，影响隔震效果';
            else
                msg = '阻尼适中';
            end
            text(1.5, 0.35, msg, 'HorizontalAlignment', 'center', 'FontSize', 9);
        end

    end
end

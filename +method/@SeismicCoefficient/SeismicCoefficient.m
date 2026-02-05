classdef SeismicCoefficient < Component
    % SeismicCoefficient - 地震影响系数计算与绘图组件
    % Author: Claude
    %
    % 根据中国建筑抗震设计规范(GB50011-2010)计算地震影响系数曲线
    %
    % 功能:
    %   - 计算阻尼相关系数 (γ, η1, η2)
    %   - 生成分段地震影响系数曲线
    %   - 绘制 α-T 响应谱曲线
    %
    % 输入:
    %   - DampingRatio: 阻尼比 ζ (默认 0.05)
    %   - SiteClass: 场地类别 ('I0', 'I1', 'II', 'III', 'IV')
    %   - SeismicGroup: 设计地震分组 (1, 2, 3)
    %
    % 参数:
    %   - SeismicIntensity: 地震烈度 ('6', '7_0.10g', '7_0.15g', '8_0.20g', '8_0.30g', '9')
    %   - EarthquakeType: 地震类型 ('frequent': 多遇, 'rare': 罕遇, 默认: 'frequent')
    %   - NumPoints: 绘图点数 (默认 500)
    %   - TimePeriodRange: 周期范围 [T_min, T_max] (默认 [0, 6])
    %
    % 输出:
    %   - Gamma: 衰减指数 γ
    %   - Eta1: 直线下降段调整系数 η1
    %   - Eta2: 阻尼调整系数 η2
    %   - AlphaCurve: 地震影响系数数组
    %   - PeriodArray: 周期数组
    %   - PlotData: 绘图数据结构
    %   - AlphaMax: 计算得到的地震影响系数最大值
    %   - Tg: 计算得到的特征周期

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'SeismicIntensity'  % 地震烈度
            'EarthquakeType'    % 地震类型
            'NumPoints'         % 绘图点数
            'TimePeriodRange'   % 周期范围 [T_min, T_max]
            };

        inputExpectedFields = {
            'DampingRatio'      % 阻尼比 ζ
            'SiteClass'         % 场地类别 ('I0', 'I1', 'II', 'III', 'IV')
            'SeismicGroup'      % 设计地震分组 (1, 2, 3)
            };

        outputExpectedFields = {
            'Gamma'             % 衰减指数 γ
            'Eta1'              % 直线下降段调整系数 η1
            'Eta2'              % 阻尼调整系数 η2
            'AlphaCurve'        % 地震影响系数数组
            'PeriodArray'       % 周期数组
            'PlotData'          % 绘图数据结构
            'AlphaMax'          % 计算得到的地震影响系数最大值
            'Tg'                % 计算得到的特征周期
            };

        baselineExpectedFields = {
            % 本组件为计算/绘图组件，无安全系数基准要求
            };

        % 默认参数值
        default_SeismicIntensity = '8_0.20g';  % 默认地震烈度 (8度0.20g)
        default_EarthquakeType = 'frequent';    % 默认多遇地震
        default_NumPoints = 500;                % 默认绘图点数
        default_TimePeriodRange = [0, 6];       % 默认周期范围 [T_min, T_max]

        % 场地类别列表
        SiteClassList = {'I0', 'I1', 'II', 'III', 'IV'};

        % 特征周期查找表 (Tg, 单位: s)
        % 行: 场地类别 (I0, I1, II, III, IV)
        % 列: 设计地震分组 (1, 2, 3)
        TgTable = [ ...
            0.20, 0.25, 0.30; ...  % I0
            0.25, 0.30, 0.35; ...  % I1
            0.35, 0.40, 0.45; ...  % II
            0.45, 0.55, 0.65; ...  % III
            0.65, 0.75, 0.90 ...   % IV
            ];
    end


    methods
        function obj = SeismicCoefficient(paramsStruct, inputStruct, varargin)
            % 构造函数
            %   obj = SeismicCoefficient(paramsStruct, inputStruct)
            %   obj = SeismicCoefficient(paramsStruct, inputStruct, baselineStruct)

            % 调用父类构造函数
            obj = obj@Component(paramsStruct, inputStruct, varargin);

            % 设置默认输入值
            if isempty(obj.input.DampingRatio)
                obj.input.DampingRatio = 0.05;
            end
        end

        function obj = solve(obj)
            % 核心计算方法 - 计算地震影响系数曲线

            % 检查输入完整性
            obj.Check();

            % 获取输入参数
            zeta = obj.input.DampingRatio;
            site_class = obj.input.SiteClass;
            seismic_group = obj.input.SeismicGroup;

            % 获取参数
            seismic_intensity = obj.params.SeismicIntensity;
            earthquake_type = obj.params.EarthquakeType;
            T_min = obj.params.TimePeriodRange(1);
            T_max = obj.params.TimePeriodRange(2);
            numPoints = obj.params.NumPoints;

            % 1. 根据地震烈度确定 αmax
            switch earthquake_type
                case 'frequent'
                    switch seismic_intensity
                        case '6'
                            alpha_max = 0.04;
                        case '7_0.15g'
                            alpha_max = 0.08;
                        case '7_0.3g'
                            alpha_max = 0.12;
                        case '8_0.15g'
                            alpha_max = 0.16;
                        case '8_0.30g'
                            alpha_max = 0.24;
                        case '9'
                            alpha_max = 0.32;
                        otherwise
                            error('未知的地震烈度: %s (支持: 6, 7_0.15g, 7_0.3g, 8_0.15g, 8_0.30g, 9)', seismic_intensity);
                    end
                case 'rare'
                    switch seismic_intensity
                        case '6'
                            alpha_max = 0.28;
                        case '7_0.15g'
                            alpha_max = 0.5;
                        case '7_0.3g'
                            alpha_max = 0.72;
                        case '8_0.15g'
                            alpha_max = 0.9;
                        case '8_0.30g'
                            alpha_max = 1.2;
                        case '9'
                            alpha_max = 1.4;
                        otherwise
                            error('未知的地震烈度: %s (支持: 6, 7_0.15g, 7_0.3g, 8_0.15g, 8_0.30g, 9)', seismic_intensity);
                    end
            end



            obj.output.AlphaMax = alpha_max;

            % 3. 根据场地类别和设计地震分组确定 Tg
            site_idx = find(strcmpi(site_class, obj.SiteClassList), 1);
            if isempty(site_idx)
                error('未知的场地类别: %s (支持: I0, I1, II, III, IV)', site_class);
            end

            % 地震分组索引（限制在1-3范围内）
            group_idx = max(1, min(3, seismic_group));
            Tg = obj.TgTable(site_idx, group_idx);

            obj.output.Tg = Tg;

            % 1. 计算阻尼相关系数 (规范 GB50011-2010 第5.1.5条)
            if abs(zeta - 0.05) < 1e-6
                % 默认阻尼比 ζ = 0.05
                obj.output.Gamma = 0.9;
                obj.output.Eta1 = 0.02;
                obj.output.Eta2 = 1.0;
            else
                % 非默认阻尼比，按公式计算
                % 衰减指数 γ (式5.1.5-1)
                obj.output.Gamma = 0.9 + (0.05 - zeta) / (0.3 + 6*zeta);

                % 直线下降段调整系数 η1 (式5.1.5-2)
                obj.output.Eta1 = 0.02 + (0.05 - zeta) / (4 + 32*zeta);
                if obj.output.Eta1 < 0
                    obj.output.Eta1 = 0;
                end

                % 阻尼调整系数 η2 (式5.1.5-3)
                obj.output.Eta2 = 1 + (0.05 - zeta) / (0.08 + 1.6*zeta);
                if obj.output.Eta2 < 0.55
                    obj.output.Eta2 = 0.55;
                end
            end

            gamma = obj.output.Gamma;
            eta1 = obj.output.Eta1;
            eta2 = obj.output.Eta2;

            % 2. 生成周期数组
            obj.output.PeriodArray = linspace(T_min, T_max, numPoints);
            T = obj.output.PeriodArray;

            % 3. 分段计算地震影响系数
            alpha = zeros(size(T));

            % 直线上升段 (0 < T < 0.1s)
            idx_linear_up = (T < 0.1) & (T >= 0);
            if any(idx_linear_up)
                % 直线上升: α = α_max × (0.45 + (η2 - 0.45) × T/0.1)
                % 当 T=0 时，α = 0.45 × α_max；当 T=0.1 时，α = η2 × α_max
                alpha(idx_linear_up) = alpha_max * (0.45 + (eta2 - 0.45) * T(idx_linear_up) / 0.1);
            end

            % 水平段 (0.1s ≤ T ≤ Tg)
            idx_flat = (T >= 0.1) & (T <= Tg);
            if any(idx_flat)
                alpha(idx_flat) = alpha_max * eta2;
            end

            % 曲线下降段 (Tg < T ≤ 5Tg)
            idx_curve = (T > Tg) & (T <= 5*Tg);
            if any(idx_curve)
                % α = α_max × (Tg/T)^γ × η2
                alpha(idx_curve) = alpha_max * (Tg ./ T(idx_curve)).^gamma * eta2;
            end

            % 直线下降段 (5Tg < T ≤ 6s)
            idx_linear_down = (T > 5*Tg) & (T <= 6);
            if any(idx_linear_down)
                % α = α_max × [(η2 - 0.02) × (12 - T)] (简化形式)
                % 或 α = α_max × ((Tg/(5Tg))^γ × η2 - η1×(T-5Tg))
                term = (Tg/(5*Tg))^gamma * eta2 - eta1 * (T(idx_linear_down) - 5*Tg);
                alpha(idx_linear_down) = alpha_max * term;
            end

            % 确保非负
            alpha(alpha < 0) = 0;

            obj.output.AlphaCurve = alpha;

            % 4. 生成绘图数据
            obj.output.PlotData = obj.generatePlotData(T, alpha, alpha_max, Tg, gamma, eta1, eta2);

            fprintf('地震影响系数计算完成:\n');
            fprintf('  阻尼比 ζ = %.3f\n', zeta);
            fprintf('  特征周期 Tg = %.3f s\n', Tg);
            fprintf('  衰减指数 γ = %.3f\n', gamma);
            fprintf('  调整系数 η1 = %.3f\n', eta1);
            fprintf('  调整系数 η2 = %.3f\n', eta2);
            fprintf('  最大影响系数 αmax = %.3f\n', alpha_max);
        end

        function plotData = generatePlotData(obj, T, alpha, alpha_max, Tg, gamma, eta1, eta2)
            % 生成绘图数据结构
            % 用于方便绘制地震影响系数曲线

            plotData.T = T;
            plotData.Alpha = alpha;
            plotData.AlphaMax = alpha_max;

            % 关键转折点
            plotData.KeyPoints = struct();
            plotData.KeyPoints.T0 = 0;
            plotData.KeyPoints.T1 = 0.1;
            plotData.KeyPoints.Tg = Tg;
            plotData.KeyPoints.T5g = 5 * Tg;

            % 计算关键点处的 α 值
            plotData.KeyPoints.Alpha0 = 0.45 * alpha_max;
            plotData.KeyPoints.Alpha1 = alpha_max * eta2;
            plotData.KeyPoints.Alpha_g = alpha_max * eta2;
            plotData.KeyPoints.Alpha_5g = alpha_max * (Tg/(5*Tg))^gamma * eta2;

            % 区间标记
            plotData.Segments = struct();
            plotData.Segments.LinearUp = (T < 0.1);
            plotData.Segments.Flat = (T >= 0.1) & (T <= Tg);
            plotData.Segments.CurveDown = (T > Tg) & (T <= 5*Tg);
            plotData.Segments.LinearDown = (T > 5*Tg);

            % 公式说明
            plotData.Formulas = struct();
            plotData.Formulas.LinearUp = sprintf('α = %.3f × (0.45 + (%.3f-0.45) × T/0.1)', alpha_max, eta2);
            plotData.Formulas.Flat = sprintf('α = %.3f × %.3f', alpha_max, eta2);
            plotData.Formulas.CurveDown = sprintf('α = %.3f × (%.2f/T)^%.2f × %.2f', alpha_max, Tg, gamma, eta2);
            plotData.Formulas.LinearDown = sprintf('α = %.3f × ((%.2f/%.2f)^%.2f × %.2f - %.3f × (T-%.2f))', ...
                alpha_max, Tg, 5*Tg, gamma, eta2, eta1, 5*Tg);

            % 系数值
            plotData.Coefficients = struct('Gamma', gamma, 'Eta1', eta1, 'Eta2', eta2);
        end

        function PlotAlphaCurve(obj, varargin)
            % 绘制地震影响系数曲线
            % PlotAlphaCurve() - 使用默认参数
            % PlotAlphaCurve('FigureHandle', fig) - 指定图形句柄
            % PlotAlphaCurve('SavePath', path) - 保存图像到指定路径

            p = inputParser;
            addParameter(p, 'FigureHandle', [], @ishandle);
            addParameter(p, 'SavePath', '', @ischar);
            parse(p, varargin{:});
            opt = p.Results;

            if isempty(obj.output.AlphaCurve)
                error('请先运行 solve() 方法计算地震影响系数曲线');
            end

            data = obj.output.PlotData;
            T = data.T;
            alpha = data.Alpha;

            % 创建图形
            if isempty(opt.FigureHandle)
                fig = figure('Position', [100 100 900 600], 'Name', '地震影响系数曲线');
            else
                fig = opt.FigureHandle;
                figure(fig);
            end
            clf(fig);

            % 绘制主曲线
            plot(T, alpha, 'b-', 'LineWidth', 2);
            hold on;
            grid on;

            % 标记关键点
            keyPoints = data.KeyPoints;
            plot(keyPoints.T1, keyPoints.Alpha1, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
            plot(keyPoints.Tg, keyPoints.Alpha_g, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
            plot(keyPoints.T5g, keyPoints.Alpha_5g, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'm');

            % 添加关键点标注
            text(keyPoints.T1, keyPoints.Alpha1, sprintf(' (0.1, %.3f)', keyPoints.Alpha1), ...
                'FontSize', 10, 'VerticalAlignment', 'bottom');
            text(keyPoints.Tg, keyPoints.Alpha_g, sprintf(' (Tg=%.2f, %.3f)', keyPoints.Tg, keyPoints.Alpha_g), ...
                'FontSize', 10, 'VerticalAlignment', 'bottom');
            text(keyPoints.T5g, keyPoints.Alpha_5g, sprintf(' (5Tg=%.2f, %.3f)', keyPoints.T5g, keyPoints.Alpha_5g), ...
                'FontSize', 10, 'VerticalAlignment', 'bottom');

            % 绘制区间分隔线
            xline(keyPoints.T1, '--r');
            xline(keyPoints.Tg, '--g');
            xline(keyPoints.T5g, '--m');

            % 标注区间
            T_mid_1 = keyPoints.T0 + (keyPoints.T1 - keyPoints.T0) / 2;
            T_mid_2 = keyPoints.T1 + (keyPoints.Tg - keyPoints.T1) / 2;
            T_mid_3 = keyPoints.Tg + (keyPoints.T5g - keyPoints.Tg) / 2;
            T_mid_4 = min(keyPoints.T5g + 1, max(T));

            text(T_mid_1, data.AlphaMax * 0.1, '直线上升段', 'FontSize', 9, ...
                'HorizontalAlignment', 'center', 'Rotation', 0);
            text(T_mid_2, data.AlphaMax * 1.05, '水平段', 'FontSize', 9, ...
                'HorizontalAlignment', 'center');
            text(T_mid_3, data.AlphaMax * 0.6, '曲线下降段', 'FontSize', 9, ...
                'HorizontalAlignment', 'center');
            text(T_mid_4, data.AlphaMax * 0.3, '直线下降段', 'FontSize', 9, ...
                'HorizontalAlignment', 'center');

            % 图形设置
            xlabel('周期 T (s)', 'FontSize', 12);
            ylabel('地震影响系数 \alpha', 'FontSize', 12);
            title('地震影响系数曲线', 'FontSize', 14, 'FontWeight', 'bold');

            % 添加系数信息
            coefText = sprintf('地震烈度 = %s\n', obj.params.SeismicIntensity);
            coefText = [coefText, sprintf('场地类别 = %s\n', obj.input.SiteClass)];
            coefText = [coefText, sprintf('地震分组 = %d\n', obj.input.SeismicGroup)];
            coefText = [coefText, sprintf('阻尼比 ζ = %.3f\n', obj.input.DampingRatio)];
            coefText = [coefText, sprintf('特征周期 T_g = %.2f s\n', obj.output.Tg)];
            coefText = [coefText, sprintf('最大系数 α_{max} = %.3f\n', obj.output.AlphaMax)];
            coefText = [coefText, sprintf('衰减指数 γ = %.3f\n', obj.output.Gamma)];
            coefText = [coefText, sprintf('调整系数 η_1 = %.3f\n', obj.output.Eta1)];
            coefText = [coefText, sprintf('调整系数 η_2 = %.3f', obj.output.Eta2)];

            annotation('textbox', [0.70, 0.70, 0.25, 0.20], 'String', coefText, ...
                'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
                'FontSize', 10);

            % 保存图像
            if ~isempty(opt.SavePath)
                saveas(fig, opt.SavePath);
                fprintf('图像已保存到: %s\n', opt.SavePath);
            end

            hold off;
        end

        function PrintInfo(obj)
            % 打印计算结果摘要
            if isempty(obj.output.AlphaCurve)
                error('请先运行 solve() 方法');
            end

            fprintf('\n========== 地震影响系数计算结果 ==========\n');
            fprintf('\n【输入参数】\n');
            fprintf('  地震烈度        : %s\n', obj.params.SeismicIntensity);
            fprintf('  场地类别        : %s\n', obj.input.SiteClass);
            fprintf('  地震分组        : %d\n', obj.input.SeismicGroup);
            fprintf('  地震类型        : %s\n', obj.params.EarthquakeType);
            fprintf('  阻尼比 ζ        : %.3f\n', obj.input.DampingRatio);

            fprintf('\n【计算系数】\n');
            fprintf('  衰减指数 γ      : %.4f\n', obj.output.Gamma);
            fprintf('  调整系数 η1     : %.4f\n', obj.output.Eta1);
            fprintf('  调整系数 η2     : %.4f\n', obj.output.Eta2);

            fprintf('\n【计算参数】\n');
            fprintf('  最大系数 αmax    : %.4f\n', obj.output.AlphaMax);
            fprintf('  特征周期 Tg      : %.4f s\n', obj.output.Tg);
            fprintf('  绘图点数        : %d\n', obj.params.NumPoints);
            fprintf('  周期范围        : [%.2f, %.2f] s\n', ...
                obj.params.TimePeriodRange(1), obj.params.TimePeriodRange(2));

            fprintf('\n【关键点】\n');
            fprintf('  (0, %.3f)         : 起点\n', 0.45 * obj.output.AlphaMax);
            fprintf('  (0.1, %.3f)      : 直线上升段终点\n', obj.output.AlphaMax * obj.output.Eta2);
            fprintf('  (%.2f, %.3f)    : 水平段终点\n', obj.output.Tg, obj.output.AlphaMax * obj.output.Eta2);
            fprintf('  (%.2f, %.3f)    : 曲线下降段终点\n', 5*obj.output.Tg, ...
                obj.output.AlphaMax * (1/5)^obj.output.Gamma * obj.output.Eta2);

            fprintf('\n【计算公式】\n');
            fprintf('  直线上升段 (T < 0.1): α = αmax × (0.45 + (η2-0.45) × T/0.1)\n');
            fprintf('  水平段 (0.1 ≤ T ≤ Tg): α = αmax × η2\n');
            fprintf('  曲线下降段 (Tg < T ≤ 5Tg): α = αmax × (Tg/T)^γ × η2\n');
            fprintf('  直线下降段 (5Tg < T ≤ 6): α = αmax × ((Tg/(5Tg))^γ × η2 - η1 × (T-5Tg))\n');
            fprintf('=============================================\n\n');
        end
    end
end

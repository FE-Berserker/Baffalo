classdef SignalAnalysis < Component
    % SignalAnalysis - 信号处理分析组件
    % Author: Claude
    %
    % 功能:
    %   - 验证时间序列的时间间隔是否均匀
    %   - 计算并输出时间间隔 dt
    %
    % 输入:
    %   - t: 时间数组
    %   - s: 信号幅值数组
    %
    % 参数:
    %   - Name: 组件名称 (默认 'SignalAnalysis_1')
    %   - Echo: 是否打印输出 (默认 1)
    %
    % 输出:
    %   - dt: 时间间隔
    %
    % Baseline: 无

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % 组件名称
            'Range' % 时间范围 
            'Echo' % 是否打印输出
            };

        inputExpectedFields = {
            't' % 时间
            's' % 信号幅值
            };

        outputExpectedFields = {
            't' % 输出时间
            'dt' % 时间间隔
            's_Transform' % 转换后的信号
            'Wavelet' % 小波
            'Noise' % 噪声
            's_Synthesis' % 合成噪声后的信号
            'FFT_s' % 原始信号快速傅里叶变换
            'FFT_s_Transform' % 转换信号快速傅里叶变换
            'FFT_s_Synthesis' % 合成信号快速傅里叶变换
            'SST'
            'TET'
            'WT'
            'Hilbert_s' % 原始信号希尔伯特变换
            'Hilbert_s_Transform' % 转换信号希尔伯特变换
            'Hilbert_s_Synthesis' % 合成信号希尔伯特变换
            'Env_s' % 原始信号包络
            'Env_s_Transform' % 转换信号包络
            'Env_s_Synthesis'% 合成信号包络
            'FreqDom_s' % 原始信号主频
            'FreqDom_s_Transform' % 转换信号主频
            'FreqDom_s_Synthesis' % 合成信号主频

            };

        baselineExpectedFields = {
            % 为空
            };

        % 默认参数值
        default_Name = 'SignalAnalysis_1';  % 默认组件名称
        default_Range = []; % 默认范围为全部范围
        default_Echo = 1;                    % 默认打印输出
    end


    methods
        function obj = SignalAnalysis(paramsStruct, inputStruct, varargin)
            % 构造函数
            %   obj = SignalAnalysis(paramsStruct, inputStruct)
            %   obj = SignalAnalysis(paramsStruct, inputStruct, baselineStruct)

            % 调用父类构造函数
            obj = obj@Component(paramsStruct, inputStruct, varargin);
        end

        function obj = solve(obj)
            % 核心计算方法 - 分析时间序列信号

            % 检查输入完整性
            obj.Check();

            % 获取输入数据
            t = obj.input.t;
            s = obj.input.s;

            % 验证时间间隔是否均匀
            if length(t) < 2
                error('时间数组长度必须 >= 2');
            end

            if size(t,1)>size(t,2)
                t=t';
                obj.input.t=t;
            end

            if size(s,1)>size(s,2)
                s=s';
                obj.input.s=s;
            end

            dt = diff(t);

            % 使用容差检查时间间隔是否均匀
            mean_dt = mean(dt);
            tolerance = 1e-10;  % 绝对容差

            if any(abs(dt - mean_dt) > tolerance)
                error('时间间隔不均匀，请检查输入的时间数组');
            end

            % 计算时间范围
            if isempty(obj.params.Range)
                tt=t;
            else
                ind=near(t,obj.params.Range(1),obj.params.Range(2));
                tt=t(ind);
            end

            % 输出
            obj.output.dt = mean_dt;
            obj.output.t = tt;

            % 打印结果
            if obj.params.Echo
                fprintf('\n========== 信号处理分析完成 ==========\n');
                fprintf('  组件名称: %s\n', obj.params.Name);
                fprintf('  数据点数: %d\n', length(t));
                fprintf('  时间范围: [%.6f, %.6f]\n', t(1), t(end));
                fprintf('  时间间隔 dt: %.10f\n', obj.output.dt);
                fprintf('==========================================\n\n');
            end
        end

        function PrintInfo(obj)
            % 打印计算结果摘要
            if isempty(obj.output.dt)
                error('请先运行 solve() 方法');
            end

            fprintf('\n========== 信号处理分析结果 ==========\n');
            fprintf('\n【输入参数】\n');
            fprintf('  组件名称     : %s\n', obj.params.Name);
            fprintf('  时间点数     : %d\n', length(obj.input.t));
            fprintf('  信号点数     : %d\n', length(obj.input.s));

            fprintf('\n【输出结果】\n');
            fprintf('  时间间隔     : %.10f\n', obj.output.dt);
            fprintf('  总时长       : %.6f\n', obj.input.t(end) - obj.input.t(1));

            fprintf('\n【时间信息】\n');
            fprintf('  起始时间     : %.6f\n', obj.input.t(1));
            fprintf('  结束时间     : %.6f\n', obj.input.t(end));

            fprintf('\n【验证状态】\n');
            fprintf('  时间间隔     : 均匀\n');
            fprintf('==========================================\n\n');
        end
    end
end

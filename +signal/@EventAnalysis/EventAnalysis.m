classdef EventAnalysis < Component
    % EventAnalysis - 事件处理分析组件
    % Author: XieYu

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % 组件名称
            'Echo' % 是否打印输出

            };

        inputExpectedFields = {
            't' % 时间
            'x' % 空间
            };

        outputExpectedFields = {
            'dt' % 时间间隔
            'dx' % 空间间隔
            'Event'
            'FKT'
            };

        baselineExpectedFields = {
            % 为空
            };

        % 默认参数值
        default_Name = 'EventAnalysis_1';  % 默认组件名称
        default_Echo = 1;                    % 默认打印输出
 
    end


    methods
        function obj = EventAnalysis(paramsStruct, inputStruct, varargin)
            % 构造函数
            %   obj = EventAnalysis(paramsStruct, inputStruct)
            %   obj = EventAnalysis(paramsStruct, inputStruct, baselineStruct)

            % 调用父类构造函数
            obj = obj@Component(paramsStruct, inputStruct, varargin);
        end

        function obj = solve(obj)
            % 核心计算方法 - 分析时间序列信号

            % 检查输入完整性
            obj.Check();

            % 获取输入数据
            t = obj.input.t;
            x = obj.input.x;

            % 验证时间间隔是否均匀
            if length(t) < 2
                error('时间数组长度必须 >= 2');
            end

            % 验证空间间隔是否均匀
            if length(x) < 2
                error('空间数组长度必须 >= 2');
            end

            dt = diff(t);

            % 使用容差检查时间间隔是否均匀
            mean_dt = mean(dt);
            tolerance = 1e-10;  % 绝对容差

            if any(abs(dt - mean_dt) > tolerance)
                error('时间间隔不均匀，请检查输入的时间数组');
            end


            dx = diff(x);

            % 使用容差检查空间间隔是否均匀
            mean_dx = mean(dx);
            tolerance = 1e-10;  % 绝对容差

            if any(abs(dx - mean_dx) > tolerance)
                error('空间间隔不均匀，请检查输入的空间数组');
            end

            Event=zeros(length(t),length(x)); % 预分配地震数据矩阵

            % 输出
            obj.output.dt = mean_dt;
            obj.output.dx = mean_dx;
            obj.output.Event=Event;


            % 打印结果
            if obj.params.Echo
                fprintf('\n========== 事件处理分析完成 ==========\n');
                fprintf('  组件名称: %s\n', obj.params.Name);
                fprintf('  时间数据点数: %d\n', length(t));
                fprintf('  时间范围: [%.6f, %.6f]\n', t(1), t(end));
                fprintf('  时间间隔 dt: %.10f\n', obj.output.dt);
                fprintf('  空间数据点数: %d\n', length(x));
                fprintf('  空间范围: [%.6f, %.6f]\n', x(1), x(end));
                fprintf('  空间间隔 dx: %.10f\n', obj.output.dx);
                fprintf('==========================================\n\n');
            end
        end
    end
end

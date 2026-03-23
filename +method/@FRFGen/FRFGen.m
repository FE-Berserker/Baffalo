classdef FRFGen < Component
    %FRFGEN 频率响应函数(FRF)生成组件
    %   基于模态参数或残差法生成系统的频率响应函数
    %
    %   支持三种FRF生成模式:
    %   1. ModeBased - 基于模态参数(刚度k、阻尼比zeta、固有频率wn)
    %   2. ResidueKai - 基于Kai(2009)残差法
    %   3. ResidueAltintas - 基于Altintas(2012)残差法
    %
    %   Author: AI Assistant
    %   Date: 2026-03-06
    %   Reference:
    %   - Kai, C. (2009). Machining Dynamics. Springer. (p.210)
    %   - Altintas, Y. (2012). Manufacturing Automation. (p.162)

    properties(Hidden, Constant)
        % 参数预期字段
        paramsExpectedFields = {
            'Name'              % 组件名称
            'Echo'              % 是否打印信息: true/false
            'GenerationMode'    % FRF生成模式: 'ModeBased' | 'ResidueKai' | 'ResidueAltintas'
            'FStart'            % 起始频率 [Hz]
            'FEnd'              % 结束频率 [Hz]
            'dF'                % 频率分辨率 [Hz]
            };

        % 输入参数预期字段
        inputExpectedFields = {
            'Wn'                % 固有频率数组 [rad/s]
            'Zeta'              % 阻尼比数组
            'K'                 % 模态刚度数组 [N/m] (ModeBased模式)
            'Residue'           % 残差数组(复数) [m/N] (Residue模式)
            };

        % 输出结果预期字段
        outputExpectedFields = {
            'FRF'               % 复数FRF数据
            'Freq'              % 频率向量 [Hz]
            'FRFReal'           % FRF实部
            'FRFImag'           % FRF虚部
            'FRFMag'            % FRF幅值
            };

        % 基准值预期字段 (FRFGen不需要baseline，设为空)
        baselineExpectedFields = {};

        % Params默认值 (命名规范: default_字段名)
        default_Name = 'FRFGen_1';              % 默认组件名称
        default_Echo = true;                    % 默认打印计算信息
        default_GenerationMode = 'ModeBased';   % 默认使用ModeBased模式
        default_FStart = 0;                     % 默认起始频率 [Hz]
        default_FEnd = 3000;                    % 默认结束频率 [Hz]
        default_dF = 0.5;                       % 默认频率分辨率 [Hz]
    end

    methods
        function obj = FRFGen(paramsStruct, inputStruct, varargin)
            %FRFGEN 构造函数
            %   obj = FRFGen(paramsStruct, inputStruct, baselineStruct)
            %   obj = FRFGen(paramsStruct, inputStruct)  % 使用默认baseline
            %
            %   输入:
            %       paramsStruct - 参数结构体 (可选,可使用默认值)
            %           .Name: 组件名称, 默认'FRFGen_1'
            %           .Echo: 是否打印信息, 默认true
            %           .GenerationMode: 'ModeBased' | 'ResidueKai' | 'ResidueAltintas'
            %           .FStart: 起始频率 [Hz], 默认0
            %           .FEnd: 结束频率 [Hz], 默认3000
            %           .dF: 频率分辨率 [Hz], 默认0.5
            %
            %       inputStruct - 输入结构体
            %           必需字段:
            %               .Wn: 固有频率数组 [rad/s]
            %               .Zeta: 阻尼比数组
            %           ModeBased模式必需字段:
            %               .K: 模态刚度数组 [N/m]
            %           Residue模式必需字段:
            %               .Residue: 残差数组(复数) [m/N]
            %
            %   示例:
            %       % 使用默认params
            %       input = struct();
            %       input.Wn = [1198 1389 1586]*2*pi;
            %       input.Zeta = [0.041 0.048 0.027];
            %       input.K = [1.2e7 1.3e7 3.7e6];
            %       frfGen = FRFGen([], input);
            %       frfGen = frfGen.solve();
            %
            %       % 指定GenerationMode和频率范围
            %       params = struct();
            %       params.GenerationMode = 'ResidueKai';
            %       params.FStart = 0;
            %       params.FEnd = 8000;
            %       params.dF = 1;
            %       frfGen = FRFGen(params, input);
            %       frfGen = frfGen.solve();

            % 调用父类构造函数 (Component基类会自动处理默认值)
            obj = obj@Component(paramsStruct, inputStruct, varargin);
        end

        function obj = solve(obj)
            %SOLVE 执行FRF生成计算
            %   根据params.GenerationMode选择相应的计算方法
            %
            %   ModeBased模式公式:
            %       H_i(w) = (wn_i^2/k_i) / (wn_i^2 - w^2 + j*2*zeta_i*wn_i*w)
            %
            %   Residue模式通用公式:
            %       H_i(w) = (alpha_i + j*beta_i*w) / (wn_i^2 - w^2 + j*2*zeta_i*wn_i*w)
            %
            %   Kai残差法系数:
            %       wd = wn*sqrt(1-zeta^2)
            %       alpha = j*(-zeta*wn*sigma + wd*nu)
            %       beta = j*(-sigma)
            %
            %   Altintas残差法系数:
            %       wd = wn*sqrt(1-zeta^2)
            %       alpha = 2*(zeta*wn*sigma - wd*nu)
            %       beta = 2*sigma

            % 验证输入
            obj = validateInputs(obj);

            % 生成频率向量
            f = (obj.params.FStart:obj.params.dF:obj.params.FEnd)';
            w = f*2*pi;  % rad/s

            % 根据生成模式调用相应方法
            switch upper(obj.params.GenerationMode)
                case 'MODEBASED'
                    obj = computeModeBasedFRF(obj, w);
                case 'RESIDUEKAI'
                    obj = computeResidueFRF(obj, w, 'Kai');
                case 'RESIDUEALTINTAS'
                    obj = computeResidueFRF(obj, w, 'Altintas');
                otherwise
                    error('未知的FRF生成模式: %s', obj.params.GenerationMode);
            end

            % 存储频率向量
            obj.output.Freq = f;

            % 计算实部、虚部、幅值
            obj.output.FRFReal = real(obj.output.FRF);
            obj.output.FRFImag = imag(obj.output.FRF);
            obj.output.FRFMag = abs(obj.output.FRF);

            % 计算容量指标
            obj = computeCapacity(obj);

            % 打印计算信息(如果启用)
            if obj.params.Echo
                fprintf('[%s] FRF generation completed.\n', obj.params.Name);
                fprintf('  Mode: %s\n', obj.params.GenerationMode);
                fprintf('  Frequency range: %.1f ~ %.1f Hz\n', obj.params.FStart, obj.params.FEnd);
                fprintf('  Frequency resolution: %.2f Hz\n', obj.params.dF);
                fprintf('  Number of modes: %d\n', length(obj.input.Wn));
                fprintf('  Max amplitude: %.2e m/N\n', max(obj.output.FRFMag));
            end
        end
    end
end

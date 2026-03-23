function obj = computeModeBasedFRF(obj, w)
%COMPUTEMODEBASEDFRF 基于模态参数计算FRF
%   公式: H_i(w) = (wn_i^2/k_i) / (wn_i^2 - w^2 + j*2*zeta_i*wn_i*w)
%
%   输入:
%       obj - FRFGen对象
%       w - 角频率向量 [rad/s]

    wn = obj.input.Wn;          % 固有频率 [rad/s]
    zeta = obj.input.Zeta;      % 阻尼比
    k = obj.input.K;            % 模态刚度 [N/m]
    
    % 初始化FRF
    numFreq = length(w);
    FRF = zeros(numFreq, 1);
    
    % 各阶模态叠加
    for i = 1:length(wn)
        % 计算第i阶模态的FRF
        % H_i(w) = (wn_i^2/k_i) / (wn_i^2 - w^2 + j*2*zeta_i*wn_i*w)
        numerator = (wn(i)^2/k(i));
        denominator = wn(i)^2 - w.^2 + 1i*2*zeta(i)*wn(i)*w;
        FRFi = numerator./denominator;
        
        % 叠加到总FRF
        FRF = FRF + FRFi;
    end
    
    % 存储结果
    obj.output.FRF = FRF;
end

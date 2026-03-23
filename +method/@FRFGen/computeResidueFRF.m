function obj = computeResidueFRF(obj, w, method)
%COMPUTERESIDUEFRF 基于残差法计算FRF
%   公式: H_i(w) = (alpha_i + j*beta_i*w) / (wn_i^2 - w^2 + j*2*zeta_i*wn_i*w)
%
%   Kai方法系数:
%       wd = wn*sqrt(1-zeta^2)
%       alpha = j*(-zeta*wn*sigma + wd*nu)
%       beta = j*(-sigma)
%
%   Altintas方法系数:
%       wd = wn*sqrt(1-zeta^2)
%       alpha = 2*(zeta*wn*sigma - wd*nu)
%       beta = 2*sigma
%
%   输入:
%       obj - FRFGen对象
%       w - 角频率向量 [rad/s]
%       method - 'Kai' 或 'Altintas'

    wn = obj.input.Wn;              % 固有频率 [rad/s]
    zeta = obj.input.Zeta;          % 阻尼比
    residue = obj.input.Residue;    % 残差 [m/N]
    
    % 提取残差实部和虚部
    sigma = real(residue);          % 残差实部
    nu = imag(residue);             % 残差虚部
    
    % 初始化FRF
    numFreq = length(w);
    FRF = zeros(numFreq, 1);
    
    % 各阶模态叠加
    for i = 1:length(wn)
        % 计算阻尼固有频率
        wd = wn(i)*sqrt(1-zeta(i)^2);
        
        % 根据方法选择系数计算方式
        switch upper(method)
            case 'KAI'
                % Kai (2009) 方法
                alpha = 1i*(-zeta(i)*wn(i)*sigma(i)+wd*nu(i));
                beta = 1i*(-sigma(i));
                
            case 'ALTINTAS'
                % Altintas (2012) 方法
                alpha = 2*(zeta(i)*wn(i)*sigma(i)-wd*nu(i));
                beta = 2*sigma(i);
                
            otherwise
                error('FRFGen: 未知的残差法: %s', method);
        end
        
        % 计算第i阶模态的FRF
        % H_i(w) = (alpha + j*beta*w) / (wn^2 - w^2 + j*2*zeta*wn*w)
        numerator = alpha + 1i*beta*w;
        denominator = wn(i)^2 - w.^2 + 1i*2*zeta(i)*wn(i)*w;
        FRFi = numerator./denominator;
        
        % 叠加到总FRF
        FRF = FRF + FRFi;
    end
    
    % 存储结果
    obj.output.FRF = FRF;
end

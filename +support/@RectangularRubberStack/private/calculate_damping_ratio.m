function zeta_eq = calculate_damping_ratio(w, K_h, D)
    % 计算橡胶隔震支座的等效黏滞阻尼比
    %
    % 输入参数 (均为mm单位制):
    %   w   - 滞回曲线围合面积 (单位: N·mm)
    %   K_h - 水平刚度 (单位: N/mm)
    %   D   - 水平相对位移 (单位: mm)
    %
    % 输出参数:
    %   zeta_eq - 等效黏滞阻尼比 (无量纲)
    %
    % 计算公式: zeta_eq = w / (2 * pi * K_h * D^2)
    %
    % 示例:
    %   zeta = calculate_damping_ratio(500000, 200, 50);

    % 单位转换为SI制 (mm -> m)
    w_Si = w / 1000;      % N·mm -> N·m
    K_h_Si = K_h * 1000;  % N/mm -> N/m
    D_Si = D / 1000;      % mm -> m

    % 计算等效黏滞阻尼比
    zeta_eq = w_Si / (2 * pi * K_h_Si * D_Si^2);

    % 阻尼比应在合理范围内 (0-1)，警告异常值
    if zeta_eq < 0 || zeta_eq > 1
        warning('计算得到的阻尼比 %.4f 超出合理范围 [0, 1]', zeta_eq);
    end
end

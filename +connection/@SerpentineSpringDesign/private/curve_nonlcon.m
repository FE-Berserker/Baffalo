function [c, ceq] = curve_nonlcon(x,vars)
% 曲线非线性约束函数 - 定义优化过程中的约束条件
% Curve Nonlinear Constraints - defines constraints for optimization

    %% 参数
    %% Parameters
    rad_root = vars(1); % 根半径
    rad_tip = vars(2); % 尖端半径
    z_thick = vars(3); % 厚度
    num_flex = vars(4); % 弯曲臂数量
    serp_des = vars(5); % 期望蛇形系数
    tip_load = vars(6); % 尖端载荷
    design_stress = vars(7); % 设计应力
    step = vars(8); % 步长
    n = vars(9); % 控制点数量
    
    %% 转换输入
    %% Convert input
    x_p = [0 x(1:n)' 0];
    y_p = [rad_tip x((n+1):end)' rad_root]; % y_p由fmincon控制
    % y_p = linspace(rad_tip,rad_root,length(x_p)); % y_p固定

    %% 为中性轴创建样条
    %% Create spline for neutral axis
    t = rad_root:-step:rad_tip;
    % 约束在尖端和根部斜率为0
    spline = csape(y_p,x_p,'clamped',[0 0]); % constrained to 0 slope at tip and root
    x_n = fnval(spline,t);
    y_n = t;
    s_prime = fnder(spline);
    slope = fnval(s_prime,t); % 计算每个点处样条的斜率

    %% 初始化变量
    %% Initialize variables
    % 计算沿样条每个点处所需的弯曲臂宽度
    w = sqrt(6*tip_load*(t-rad_tip)/(z_thick*design_stress));
    w_side = w/2;

    side1 = zeros(length(t),2);
    side2 = zeros(length(t),2);

    %% 计算弯曲臂轮廓
    %% Calculate flexure profile
    for i = 1:length(t) % 对于样条上的每个点
        if slope(i) == 0
            m = 1e9; % 接近垂直的线以避免错误
        else
            m = -1/slope(i);
        end
        dx = sign(m)*sqrt(w_side(i)^2/(m^2 + 1)); % 从中性轴计算x距离
        dy = m*dx; % 从中性轴计算y距离
        side1(i,:) = [x_n(i)+dy y_n(i)+dx]; % 构建弯曲臂的一条边
        side2(i,:) = [x_n(i)-dy y_n(i)-dx]; % 构建弯曲臂的另一条边
    end

    %% 面积计算
    %% Area calculations
    A_wedge = pi/num_flex*(rad_root^2 - rad_tip^2); % 计算分配给每个弯曲臂的"饼形切片"面积
    A_nom = -trapz(t,w_side)*2; % 计算名义直弯曲臂的面积
    A_serp = trapz(side2(:,2),side2(:,1),1) - trapz(side1(:,2),side1(:,1),1); % 计算蛇形弯曲臂的面积
    fac_serp = A_serp/A_nom; % 蛇形系数
    fac_dens = A_serp/A_wedge; % 密度系数

    %% 定义约束
    %% Define constraints

    % 横向平衡：中性轴x距离之和必须小于1mm
    c(:,1) = abs(sum(x_n)) - 1e-3; % the sum of the x-distances to the neutral axis must be less than 1mm
    
    % 匹配目标弯曲臂面积
    A_err = serp_des - fac_serp; % 面积目标误差
    c(:,end+1) = abs(A_err) - .001; % 如果要将A_err作为不等式约束而不是等式约束实现（将ceq设为[]）
    
    % 加强约束
    c = c*1e2; % 如果需要更严格的约束
    ceq = [];

end

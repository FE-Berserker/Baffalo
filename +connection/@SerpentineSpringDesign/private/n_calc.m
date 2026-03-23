function [n,ball_rad,theta] = n_calc(rad_root,rad_tip,z_thick,n,deflection,k,design_stress,E,min_ball_rad)
% 弯曲臂数量计算函数 - 计算可装入弹簧的最大弯曲臂数量，同时考虑用户已分配/未分配的输入
% Flexure Number Calculation - calculates the maximum number of flexures

% 设置弯曲臂尖端宽度的下限
if isempty(min_ball_rad)
    l1 = 0.0006; % 弯曲臂尖端宽度下限 [m]
else
    l1 = min_ball_rad*2; % 乘以2得到直径
end

%% 如果n未分配，从最小尖端宽度开始增加直到满足约束
%% If n is unnassigned, start with minimum tip width and increase until 
if isempty(n) % 如果弯曲臂数量未分配
    violated = true; % 设置标志
    % 基于尖端宽度的几何弯曲臂限制
    n_limit = floor(pi*sqrt(l1^2/4 + rad_tip^2)/l1); % geometric flexure limit based on tip width
    while violated == true
        n = n_limit;
        % 计算偏转
        theta = (n*8*z_thick*design_stress^3*(rad_root - rad_tip)^3/(27*E^2*k*rad_tip))^(1/3);
        tau = k*theta;

        % 计算几何参数
        m = tan(pi/6);
        a = m^2;
        b = -(2*m^2*rad_tip + 3*tau/(2*n*rad_tip*z_thick*design_stress));
        c = m^2*rad_tip^2 + 3*tau/(2*n*z_thick*design_stress);
        xi = (-b + sqrt(b^2 - 4*a*c))/2/a;
        yi = m*xi - m*rad_tip;
        ball_rad = norm([xi-rad_tip yi]);
        l1_new = 2*ball_rad;
        n_limit_new = floor(pi*sqrt(l1_new^2/4 + rad_tip^2)/l1_new);

        if n_limit_new >= n_limit
            ball_rad = l1/2;
            violated = false;
        else
            n_limit = n_limit_new;
            l1 = l1_new;
        end

    end

    % 计算期望偏转
    if isempty(deflection)
        n = n_limit;
        theta = (n*8*z_thick*design_stress^3*(rad_root - rad_tip)^3/(27*E^2*k*rad_tip))^(1/3);
    else % 检查期望偏转对应的弯曲臂数量是否低于允许限制
        theta = deflection/180*pi;
        n = ceil(27*E^2*k*theta^3*rad_tip/(8*z_thick*design_stress^3*(rad_root - rad_tip)^3));
        if n > n_limit
            n = n_limit;
            theta = (n*8*z_thick*design_stress^3*(rad_root - rad_tip)^3/(27*E^2*k*rad_tip))^(1/3);
            deflection_new = theta*180/pi;
            sprintf('期望偏转在直弯曲臂情况下无法实现。已从 %0.5g 改为 %0.5g',deflection,deflection_new);
        end
    end

%% 如果n已分配，直接计算偏转和尖端/球半径
%% If n is assigned, calculate deflection and tip/ball radius directly
else
    theta = (n*8*z_thick*design_stress^3*(rad_root - rad_tip)^3/(27*E^2*k*rad_tip))^(1/3);
    if ~isempty(deflection)
        deflection_new = theta*180/pi;
        error('对于给定输入，期望偏转被约束为 %0.5g（直弯曲臂）。请重新运行，设置 n = [], 或 deflection = [], 或两者都为空。',deflection_new);
    end
    tau = k*theta;
    m = tan(pi/6);
    a = m^2;
    b = -(2*m^2*rad_tip + 3*tau/(2*n*rad_tip*z_thick*design_stress));
    c = m^2*rad_tip^2 + 3*tau/(2*n*z_thick*design_stress);
    xi = (-b + sqrt(b^2 - 4*a*c))/2/a;
    yi = m*xi - m*rad_tip;
    ball_rad = norm([xi-rad_tip yi]);
    if ball_rad < l1/2 % 如果低于阈值
        ball_rad = l1/2; % 设置为下限
    end
    n_limit = floor(pi*sqrt(ball_rad^2 + rad_tip^2)/(2*ball_rad)); % 计算允许弯曲臂限制
    if n_limit < n % 检查用户选择的弯曲臂数量是否在允许范围内
        error('不可行设计：尝试使用更少数量的弯曲臂');
    end

end

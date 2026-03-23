function [opt_var, side1, side2, A_err, flex_oth, min_dist] = curve_func(x,vars)
% 曲线函数 - 计算蛇形弯曲臂的目标函数值
% Curve Function - calculates objective function value for serpentine flexure

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
    edge = [side1; flip(side2)];

    %% 优化变量选项
    %% Optimization Variable Options

    %% 与其他弯曲臂的接近度 v2.0
    %% Closeness to other flexures v2.0
    theta = 2*pi/num_flex; % 每个弯曲臂的角度偏移
    M = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]; % 旋转矩阵
    % side2在左侧，side1在右侧
    flex_oth = [side1 zeros(size(side1,1),1)];
    flex_oth = M*flex_oth'; % 通过theta旋转一侧来构建"相邻弯曲臂"
    flex_oth = flex_oth(1:2,:)';
    dist = 100*ones(1,size(side1,1));

    for i = 1:size(side1,1) % 对于一条边上的每个点
        for j = 1:size(side1,1) % 遍历另一条边上的每个点
            d = norm(flex_oth(j,:) - side2(i,:)); % 计算两点之间的距离
            if d < dist(i)
                dist(i) = d; % 保存一个点与另一条边之间的最小距离
                if d < 2*step
                    break; % 如果线条太近/相交，跳出循环
                end
            end
        end
    end
    min_dist = min(dist); % 选择整体最小距离
    min_dist_sq = sqrt(min_dist);

    %% 曲率半径
    %% Radius of curvature
%     vecs = [x_n; y_n; zeros(1,length(t))];
%     r_o_c = zeros(size(t));
%     for i = 2:length(t)-1
%         r_o_c(i) = circumcenter(vecs(:,i-1),vecs(:,i),vecs(:,i+1));
%         if r_o_c(i) == Inf
%             r_o_c(i) = 1e9;
%         end
%     end
%     r_o_c(1) = r_o_c(2);
%     r_o_c(end) = r_o_c(end-1);
%     r_int = trapz(t,r_o_c);
    
    %% 曲率
    %% Curvature
    vecs = [x_n; y_n; zeros(1,length(t))]; % 构建中性轴
    r_o_c = zeros(size(t));
    for i = 2:length(t)-1
        r_o_c(i) = circumcenter(vecs(:,i-1),vecs(:,i),vecs(:,i+1)); % 计算曲率半径
        if r_o_c(i) == Inf % 通过分配大值处理无穷大的边界情况
            r_o_c(i) = 1e9;
        end
    end
    r_o_c(1) = r_o_c(2); % 近似起始半径
    r_o_c(end) = r_o_c(end-1); % 近似结束半径
    K = 1./r_o_c; % 计算每个点的曲率

    %% 面积精度
    %% Accuracy of area
    A_err = serp_des - fac_serp;
    
    %% 选择代价函数
    %% Choose the cost
%     opt_var = r_int; % 最大化沿弯曲臂的曲率半径
    opt_var = 1e5/min_dist_sq + sum(K.^2); % 目标：最大化弯曲臂之间的距离并最小化曲率
%     opt_var = sum(K.^2);

end

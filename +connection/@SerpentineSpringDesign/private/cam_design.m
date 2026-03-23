function [cam_profile_mm, deflection_fac, gap, cam_shape_raw_mm] = cam_design(rad_tip,ball_rad,num_flex,tip_load,k,gap)
% 凸轮设计函数 - 数值生成凸轮轮廓，使力沿正确方向施加以近似理想弯曲
% Cam Design - numerically generates a cam profile which will apply forces
% in the correct direction to approximate ideal bending.

dF = 25; % 离散化精度 / discretization fidelity
deflection_fac = 2; % 估计载荷/偏转的乘数因子 / multiplication factor for estimated load/deflection
flag = true; % 检查齿不会太宽的标志 / flag to check that tooth will not be too wide
inc_res = true; % 如果出现故障则增加分辨率的标志 / flag to increase resolution if glitches occur
mult = 1000; % 改变find_itrst中的容差以避免故障 / changes the tolerance in find_itrst to avoid glitches
if isempty(gap)
    gap = .025e-3; % 球与凸轮之间的间隙 [m] / gap between ball and cam
end

while flag || inc_res
    %% 线性近似 - 假设弯曲臂尖端纯粹水平偏转（小角度近似）
    %% Linear Approximation - assumes that the tip of the flexure deflects purely horizontally
    k_lin = k/num_flex/rad_tip^2; % 线性刚度 [N/m] / Linear stiffness
    loads = linspace(0,tip_load*deflection_fac,dF); % 期望载荷范围 [N] / Range of expected loads
    x_lin = loads/k_lin; % 与载荷对应的偏转 [m] / Deflections corresponding to the loads
    tip_locs = [x_lin; rad_tip*ones(1,dF)]'; % 偏转过程中弯曲臂尖端的位置 / Locations of flexure tip
    cont_locs = [tip_locs(:,1)-ball_rad tip_locs(:,2)]; % 偏转过程中接触点的位置 / Locations of contact point


    %% 逐点生成凸轮轮廓
    %% Generate cam profile point-by-point
    % 旋转矩阵作为theta的函数
    rotz = @(theta) [cos(theta) -sin(theta); sin(theta) cos(theta)];
    % 查找创建垂直线的角度
    find_vert = @(theta,point,contact) abs(contact(1) - point(1)*cos(theta) + point(2)*sin(theta));
    p(1,:) = [-ball_rad rad_tip - ball_rad/4];
    % 设置约束和初始化：
    lb = -pi/4;
    ub = pi/4;
    x0 = pi/4;
    total_ang = 0;
    direction_old = [0 1];
    for i = 1:dF-1
        line = [cont_locs(i,:); p(i,:)]; % 从当前点到接触点的线
        next_contact = cont_locs(i+1,:);
        options = optimoptions('fmincon','Display','off');
        % 计算旋转直到线与下一个接触点共线所需的角度
        x1 = fmincon(@(x)find_itrst(x,line',next_contact',mult), x0, [], [], [], [], lb, ub,[],options);
        p = transpose(rotz(x1)*p'); % 旋转轮廓
        direction = next_contact - p(i,:);
        % 如果轮廓斜率变化太陡，以增加优化中的代价重新启动：
        if acos(abs(dot(direction,direction_old))/norm(direction)/norm(direction_old)) > 10*pi/180
            inc_res = true;
            mult = mult*10;
            break
        else
            inc_res = false;
        end
        direction_old = direction; % 重新赋值
        p(i+1,:) = p(i,:) + direction/2; % 添加点到凸轮轮廓
        options = optimoptions('fmincon','Display','off');
        % 计算旋转直到最近的轮廓点(p)与下一个接触点垂直对齐所需的角度
        x2 = fmincon(@(x)find_vert(x,p(i+1,:)',next_contact'), x0, [], [], [], [], lb, ub,[],options);
        p = transpose(rotz(x2)*p'); % 旋转轮廓
        total_ang = total_ang + x1 + x2; % 记录总角度位移供以后使用
    end
    direction = next_contact - p(end,:);
    p(end+1,:) = p(end,:) + direction*2; % 创建最后一点
    cam_shape = transpose(rotz(-total_ang)*p'); % 将轮廓旋转回原始坐标系
    cam_shape = cam_shape - gap*[ones(size(cam_shape,1),1) zeros(size(cam_shape,1),1)]; % 根据制造精度按间隙输入偏移
    total_defl = total_ang*180/pi;
    
    top_ang = atan2(cam_shape(end,2),cam_shape(end,1)) - pi/2;
    if top_ang < pi/num_flex
        flag = false;
    else
%         if deflection_fac - 0.1 < 1
%             error('This cam design will not allow full deflection of the spring')
%         else
        if 1
            deflection_fac = deflection_fac - 0.1;
            clear p cam_shape cont_locs tip_locs loads x_lin
        end     
    end
end
% 调试用的绘图
% PLOTS FOR DEBUGGING
% figure()
% axis equal
% hold on
% plot(p(:,1),p(:,2),'.')
% plot(cam_shape(:,1),cam_shape(:,2),'.')

%% 在添加之前保存形状
%% Save shape before adding to it
cam_shape_raw_mm = 1000*[cam_shape zeros(size(cam_shape,1),1)];
%% 在凸轮轮廓底部添加圆角
%% Add Fillets at base of cam profile
cam_shape = flip(cam_shape);
fillet_center = cam_shape(end,:) + [ball_rad -2*gap];
[fillet_x,fillet_y] = pol2cart(linspace(pi,3*pi/2,15),ball_rad);
fillet = [fillet_x + fillet_center(1); fillet_y + fillet_center(2)]';
cam_shape = [cam_shape; fillet(2:end,:)];

%% 镜像和圆形图案化
%% Mirror and Circular Pattern
pattern = [cam_shape; flip([-cam_shape(:,1) cam_shape(:,2)])]'; % 镜像
rot_pat = rotz(-2*pi/num_flex); % 创建旋转矩阵
full_cam = pattern;

for j = 1:num_flex-1
    sz = size(full_cam,2);
    for i = 1:size(pattern,2)
        full_cam(:,sz+i) = rot_pat*full_cam(:,i+size(pattern,2)*(j-1));
    end
end
full_cam = full_cam';
full_cam = [full_cam; full_cam(1,:)];
cam_profile_mm = 1000*[full_cam zeros(size(full_cam,1),1)];
% cam_profile_mm = 1000*[zeros(size(full_cam,1),1) full_cam(:,2) full_cam(:,1)]; % 这只是为了将曲线导入测试台凸轮轴CAD
% writematrix((cam_profile_mm),'cam_profile_mm.txt') % flex_uncut
% plot(cam_profile_mm(:,1),cam_profile_mm(:,2))

    %% 求交点函数 - 查找线与接触点共线所需的角度
    function fval = find_itrst(theta,line,contact,mult)
        dx = line(1,2) - line(1,1);
        dy = line(2,2) - line(2,1);
        xc = contact(1);
        yc = contact(2);
        r = xc*dx + yc*dy;
        s = xc*dy - yc*dx;
        t = line(1,1)*dy - line(2,1)*dx;

        fval = abs(r*sin(theta) + s*cos(theta) - t)*mult;
    end
end

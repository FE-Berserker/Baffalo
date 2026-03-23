function [fval,num_flex,ball_rad,theta,rad_tip,defl_straight] = rad_root_calc(rad_root,rad_out,rad_tip,z_thick,num_flex,k,defl_des,design_stress,E,min_ball_rad)
% 根半径计算函数 - 计算并优化弹簧的根半径
% Root Radius Calculation - calculates and optimizes the root radius of the spring

    % 如果尖端半径和弯曲臂数量都未设置
    if isempty(num_flex) && isempty(rad_tip) % if tip radius and flexure number have not been set 
        % 优化接触/尖端半径，最大化弯曲臂数量并计算球/尖端半径
        [rad_tip,num_flex,theta,ball_rad] = opt_rad_num(rad_root,z_thick,num_flex,[],k,design_stress,E,min_ball_rad);
        defl_straight = theta*180/pi; % 直弯曲臂的可能偏转（度）
    else
        % 最大化弯曲臂数量并计算球/尖端半径
        [num_flex,ball_rad,theta] = n_calc(rad_root,rad_tip,z_thick,num_flex,[],k,design_stress,E,min_ball_rad);
        defl_straight = theta*180/pi; % 直弯曲臂的可能偏转（度）
    end

    % 如果未作为输入分配，计算期望偏转
    if isempty(defl_des)
        defl_des = defl_straight + 1;
    end
    
    % 计算期望载荷
    [~,~,tip_load,~] = serp_calc(rad_root,rad_tip,z_thick,num_flex,defl_des,k,E,design_stress); % Calculate the expected load
    
    arc = rad_root*2*pi/num_flex; % 根半径处的弧长
    w = sqrt(6*tip_load*(rad_root-rad_tip)/(z_thick*design_stress)); % 根半径处弯曲臂的宽度
    b = (arc - w)/1.5; % 计算期望的轮缘厚度
    fval = abs(rad_out - rad_root - b); % 目标：rad_out = rad_root + b

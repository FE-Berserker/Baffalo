function [fval,num_flex,ball_rad,theta] = defl_calc(x,vars)
% 偏转计算函数 - 用于遗传算法的适应度函数
% Deflection Calculation - fitness function for genetic algorithm

%     vars = [rad_root z_thick design_stress k E num_flex deflection];
    %% 解包变量
    %% Unpack variables
    rad_root = vars{1,1}; % 根半径
    z_thick = vars{1,2}; % 厚度
    design_stress = vars{1,3}; % 设计应力
    k = vars{1,4}; % 刚度
    E = vars{1,5}; % 杨氏模量
    num_flex = vars{1,6}; % 弯曲臂数量
    deflection = vars{1,7}; % 偏转
    min_ball_rad = vars{1,8}; % 最小球半径
    rad_tip = x; % 尖端半径

    %% 计算目标值
    %% Calculate objective
    % 计算最大允许弯曲臂数量和相应的偏转：
    [num_flex,ball_rad,theta] = n_calc(rad_root,rad_tip,z_thick,num_flex,deflection,k,design_stress,E,min_ball_rad);
    fval = 1/theta; % 通过最小化偏转的倒数来最大化偏转
end

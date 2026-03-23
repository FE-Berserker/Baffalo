function [defl_nom,defl_serp,tip_load,serp_des] = serp_calc(rad_root,rad_tip,z_thick,num_flex,defl,k,E,design_stress)
% 蛇形系数计算函数 - 使用基本应变能计算确定实现期望行为所需的蛇形系数
% Serpentine Factor Calculation - uses basic strain energy calculations
% 更清晰的推导请查看论文

    %% 计算梁的数学参数
    %% Calculate beam math
    peak_strain = design_stress/E; % Pa/(Pa/(m/m)) / 峰值应变
    peak_strain_energy = .5 * peak_strain^2 * E; % Pa / 峰值应变能
    bending_strain_energy = peak_strain_energy * (1/3); % Pa / 弯曲应变能
    
    defl_rad = defl*pi/180; % 目标偏转（弧度）/ target deflection (rad)
    total_target_torque = k*defl_rad; % 目标峰值扭矩 / target peak torque
    tau_Nm = total_target_torque/num_flex; % 每个弯曲臂的扭矩 / torque per flexure
    
    E_J = 0.5*defl_rad*tau_Nm; % 一个弯曲臂的目标弹簧能量 [J] / target spring energy for one flexure
    tip_load = tau_Nm/rad_tip; % 每个弯曲臂上的力 [N] / force on each flexure
    nominal_volume = sqrt(6*z_thick*tip_load/design_stress)*2/3*(rad_root-rad_tip)^(3/2); % 见论文中的弹簧设计
    E_nom = nominal_volume * bending_strain_energy; % 相同承载能力的直梁中存储的弯曲应变能
    defl_nom = sqrt(2*E_nom/k*num_flex)*180/pi; % 直梁的偏转
    defl_serp = sqrt(2*E_J/k*num_flex)*180/pi; % 蛇形梁的偏转
    serp_des = E_J / E_nom; % 基于能量计算的蛇形系数
    
%%%%%%%%%%%%%%% 替代计算方法 %%%%%%%%%%%%%%%%
%     theta = (num_flex*8*z_thick*design_stress^3*(rad_root - rad_tip)^3/(27*E^2*k*rad_tip))^(1/3); % 直梁的偏转
%     E_J = .5* defl_rad * tau_Nm; % 峰值弹簧能量 [J]
%     tip_load = tau_Nm/rad_tip; % 力 [N]
%     nominal_volume = sqrt(6*z_thick*k*theta/rad_tip/num_flex/design_stress)*2/3*(rad_root-rad_tip)^(3/2);
%     E_nom = nominal_volume * bending_strain_energy;
%     defl_nom = 180/pi*theta % 直梁的偏转
%     defl_serp = sqrt(2*E_J/k*num_flex)*180/pi % 蛇形梁的偏转
%     serp_des = E_J / E_nom;

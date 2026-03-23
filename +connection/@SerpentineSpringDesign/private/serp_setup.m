function [profiles,returnVals] = serp_setup(rad_out,z_thick,k,design_stress,E,rad_root,rad_tip,num_flex,pins_num,pins_rad,defl_des,run_time,step,n_ctrl_p,gap,min_ball_rad)
% 蛇形弹簧设置主函数 - 协调所有设计参数并调用优化函数
% Serpentine Spring Setup Main Function - coordinates all design parameters

%% 第0节：如果要以脚本形式运行，请注释掉第3行并取消注释第5-30行
%% Section 0: If you'd like to run as a script, comment out line 3 and uncomment lines 5-30
% % 
% close all
% clear
% clc
% 
% %% 函数输入 %%
% %% Function inputs %%
% % 必需参数 / Required
% % rad_out = 33.5e-3; % (m) 整个弹簧的半径 / radius of the whole spring
% % z_thick = 4.5e-3; % (m) 弹簧盘厚度 / thickness of spring disc
% % k = 150; % (Nm/rad) 期望刚度 / desired stiffness
% % design_stress = 912e6; % (Pa) 许用应力百分比 / percentage of yield stress
% % E = 200e9; % (Pa) 杨氏模量 / Young's Modulus
% 
% % 可选参数 / Optional
% % rad_root = [];%31e-3; % (m) 根半径，弯曲臂与轮缘交汇处的半径
% % rad_tip = [];%6e-3; % (m) 弯曲臂尖端到弹簧中心的距离
% % num_flex = [];%24; % 弹簧中的弯曲臂数量
% % pins_num = [];%24; % 外轮缘上的销孔数量
% % pins_rad = [];%1.5e-3; % (m) 销孔半径
% % defl_des = 15; % (deg) 期望偏转角
% % run_time = 15; % (s) 蛇形形状计算器的允许运行时间
% 
% % 高级参数 / Advanced
% % step = []; % (m) 中心线上绘制点之间的距离
% % n_ctrl_p = []; % 用于定义中心样条的控制点数量
% % gap = []; % (m) 球与凸轮之间的间隙
% % min_ball_rad = 0.375e-3; % (m) 球弯曲臂尖端的最小允许半径

%% 第1节：计算可选参数
%% Section 1: Calculate optional parameters
% 如果根半径已设置
if ~isempty(rad_root) % if root radius has been set
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
else % 如果根半径未设置
    % 设置边界和初始猜测：
    x0 = rad_out*0.95;
    lb = rad_out*0.5;
    ub = rad_out;

    % 计算根半径，优化接触/尖端半径，最大化弯曲臂数量并计算球/尖端半径
    options = optimoptions('fmincon','Display','off');
    rad_root = fmincon(@(x)rad_root_calc(x,rad_out,rad_tip,z_thick,num_flex,k,defl_des,design_stress,E,min_ball_rad),x0,[],[],[],[],lb,ub,[],options);
    [~,num_flex,ball_rad,theta,rad_tip,defl_straight] = rad_root_calc(rad_root,rad_out,rad_tip,z_thick,num_flex,k,defl_des,design_stress,E,min_ball_rad);
end

% 如果未给定目标偏转，在直弯曲臂偏转值上加1度：
if isempty(defl_des)
    defl_des = defl_straight + 1;
end
%% 第2节：优化弯曲臂几何形状
%% Section 2: Optimize flexure geometry
% 如果期望偏转大于直弯曲臂偏转，优化弯曲臂几何形状（将是蛇形）
if defl_straight < defl_des % if desired deflection is greater than the straight-flexure deflection
    [side_left, side_right, step, tip_load, min_dist, n_ctrl_p, x_flag] = spring_design(rad_root,rad_tip,z_thick,num_flex,defl_des,k,design_stress,E,run_time,step,n_ctrl_p);
elseif defl_straight >= defl_des % 如果期望偏转小于直弯曲臂偏转
    % 在这种情况下，可以设计更小的弹簧，使用蛇形弯曲臂仍能满足刚度和偏转要求
    defl_des = defl_straight;
    [side_left, side_right, step, tip_load, min_dist, n_ctrl_p, x_flag] = spring_design(rad_root,rad_tip,z_thick,num_flex,defl_des,k,design_stress,E,run_time,step,n_ctrl_p);
end

if x_flag <= 0
    profiles = [];
    returnVals = struct('Flag',x_flag);
else
    
    %% 第3节：为弯曲臂添加尖端/圆角并创建凸轮
    %% Section 3: Add tip/fillets to flexure and create cam
    [raw_mm,pattern_mm,wedge_mm,inner_mm,outer_mm,pins_rad,pins_num] = create_geometry([side_left side_right],rad_out,rad_root,rad_tip,num_flex,step,ball_rad,pins_num,pins_rad);
    [cam_profile_mm, deflection_fac, gap, cam_raw_mm] = cam_design(rad_tip,ball_rad,num_flex,tip_load,k,gap);
    
    %% 打包返回变量：
    %% Package return variables:
    profiles = struct('raw',raw_mm,'pattern',pattern_mm,'wedge',wedge_mm, ...
        'inner',inner_mm,'outer',outer_mm,'cam_profile',cam_profile_mm,'cam_raw',cam_raw_mm);
    returnVals = struct('RootRadius',rad_root,'ContactRadius',rad_tip, ...
        'NumberFlexures',num_flex,'NumberPins',pins_num,'PinRadius',pins_rad, ...
        'DesiredDeflection',defl_des,'RunTime',run_time,'StepSize',step, ...
        'NumControlPoints',n_ctrl_p,'TipCamGap',gap,'MinTipRadius',ball_rad, ...
        'AllowableDeflection',defl_des,'FlexureCloseness',min_dist,'Flag',x_flag);
end


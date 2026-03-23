function [rad_tip,num_flex,theta,ball_rad] = opt_rad_num(rad_root,z_thick,num_flex,deflection,k,design_stress,E,min_ball_rad)
% 优化尖端半径和弯曲臂数量函数
% Optimize Tip Radius and Flexure Number

% rad_root = 26.0e-3; % m / 根半径
% z_thick = 4.5e-3; % m / 厚度
% num_flex = []; % 弹簧中弯曲臂的数量
% deflection = []; % deg / 偏转
% k = 150; % Nm/rad / 刚度
% design_stress = 912e6; %1225e6*.85; % Pa / 设计应力
% E = 200e9; % Pa (杨氏模量)

lb = rad_root/30; % 尖端/接触半径的下限
ub = rad_root; % 尖端/接触半径的上限
vars = {rad_root z_thick design_stress k E num_flex deflection min_ball_rad}; % 为优化器打包相关变量

%% 设置遗传算法(GA)以优化尖端/接触半径
%% Set up GA to optimize tip/contact radius
num_generations = 100; % 代数
initial_guess = linspace(lb,ub,30)'; % 初始猜测
num_population = length(initial_guess); % 种群数量
options = optimoptions('ga','InitialPopulation',initial_guess,'PopulationSize',num_population,'Generations',num_generations,'Display','off');
[x, ~] = ga(@(x)defl_calc(x,vars),1,[],[],[],[],lb,ub,[],[],options); % 优化尖端/接触半径

rad_tip = x; % 优化的尖端/接触半径
[~,num_flex,ball_rad,theta] = defl_calc(x,vars); % 重新运行以提取其他重要变量

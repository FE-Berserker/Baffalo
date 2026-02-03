% Test SingleDegreeOfFreedom component
% 基础隔震单自由度分析测试
% 单位系统: ton, mm, MPa


% 清除工作空间
clear all
close all

disp('==========================================');
disp('  SingleDegreeOfFreedom 组件测试');
disp('  单位系统: ton, mm, MPa');
disp('==========================================');
disp(' ');

%% 测试用例1：典型的叠层橡胶支座隔震建筑
disp('--- 测试用例1：典型的叠层橡胶支座隔震建筑 ---');

% 输入参数 (新单位系统: ton, mm, MPa)
input1.M = 500;             % 上部结构总质量 500 ton
input1.K = 20000;           % 隔震层刚度 20000 N/mm (20 MN/m)
input1.C = 1000;             % 隔震层阻尼系数 1000 N·s/mm (1 MN·s/m)
input1.ground_acc = 3.0;    % 地面运动加速度 3.0 m/s² (约0.3g)
input1.soil_freq = 15.0;     % 场地土特征频率 15 rad/s
input1.height = 30000;        % 建筑高度 30000 mm (30m)

% 参数设置
params1.material_type = '叠层橡胶支座';
params1.elastic_modulus = 5.0;     % MPa
params1.shear_modulus = 1.0;       % MPa
params1.calc_method = '频域';
params1.Echo = true;

% 基准值（根据隔震设计规范设定）
baseline1.min_freq_ratio = 1.414;   % 频率比最小要求
baseline1.acc_ratio_min = 0.06;      % 加速度衰减比下限
baseline1.acc_ratio_max = 0.33;      % 加速度衰减比上限
baseline1.max_displacement = 500;     % 最大允许位移 500 mm
baseline1.min_safety_factor = 1.2;   % 最小安全系数要求

% 创建组件实例
obj1 = method.SDOFIsolation(params1, input1, baseline1);

% 显示初始参数
disp('初始参数:');
disp(['  上部结构质量: ' num2str(obj1.input.M) ' ton']);
disp(['  隔震层刚度: ' num2str(obj1.input.K) ' N/mm (' num2str(obj1.input.K/1000) ' kN/mm)']);
disp(['  隔震层阻尼系数: ' num2str(obj1.input.C) ' N·s/mm']);
disp(['  地面运动加速度: ' num2str(obj1.input.ground_acc/9.81) ' g']);
disp(['  场地土特征频率: ' num2str(obj1.input.soil_freq) ' rad/s']);
disp(['  建筑高度: ' num2str(obj1.input.height) ' mm (' num2str(obj1.input.height/1000) ' m)']);
disp(['  频率比最小要求: ' num2str(obj1.baseline.min_freq_ratio)]);
disp(' ');

% 执行计算
obj1 = obj1.solve();

% 安全校核
obj1.checkSafety();

disp(' ');

%% 输出结果汇总
disp('--- 输出结果汇总 ---');
fprintf('  自振频率 ω_n = %.3f rad/s\n', obj1.output.natural_freq);
fprintf('  阻尼比 ξ = %.4f (%.2f%%)\n', ...
        obj1.output.damping_ratio, obj1.output.damping_ratio*100);
fprintf('  频率比 r = ω/ω_n = %.3f\n', obj1.output.freq_ratio);
fprintf('  加速度衰减比 R_a = %.4f\n', obj1.output.acc_attenuation_ratio);
fprintf('  位移衰减比 R_d = %.4f\n', obj1.output.disp_attenuation_ratio);
fprintf('  最大位移反应 D_s = %.3f mm\n', obj1.output.max_displacement);
fprintf('  隔震效果: %s\n', obj1.output.isolation_effect);
fprintf('  预计降低地震烈度: %.1f 度\n', obj1.output.seismic_reduction);
disp(' ');

disp('--- 安全系数 ---');
fprintf('  频率比安全裕度: %.3f / 1.000 %s\n', ...
        obj1.capacity.freq_ratio_margin, ...
        pass_fail(obj1.capacity.freq_ratio_margin >= 1));
fprintf('  加速度衰减比符合性: %s\n', ...
        iif_str(obj1.capacity.acc_ratio_compliance, '满足', '不满足'));
fprintf('  位移安全系数: %.3f / %.3f %s\n', ...
        obj1.capacity.disp_safety_factor, ...
        obj1.baseline.min_safety_factor, ...
        pass_fail(obj1.capacity.disp_safety_factor >= obj1.baseline.min_safety_factor));
fprintf('  共振风险: %s\n', ...
        iif_str(obj1.capacity.resonance_risk, '存在', '不存在'));
fprintf('  综合安全判断: %s\n', ...
        iif_str(obj1.capacity.overall_safety, '满足', '不满足'));
fprintf('  综合安全系数: %.3f / %.3f %s\n', ...
        obj1.capacity.safety_factor, ...
        obj1.baseline.min_safety_factor, ...
        pass_fail(obj1.capacity.safety_factor >= obj1.baseline.min_safety_factor));

disp(' ');

%% 绘制图表
disp('--- 绘制分析图表 ---');
disp('  绘制加速度衰减比、位移响应、安全系数对比等图表...');
obj1.PlotCapacity();
disp(' ');

%% 测试用例2：频率比接近阈值的临界情况
disp('==========================================');
disp('--- 测试用例2：频率比接近阈值的临界情况 ---');

% 调整参数使频率比接近1.414
input2.M = 300;             % ton
input2.K = 20000;           % N/mm
input2.C = 800;             % N·s/mm
input2.ground_acc = 3.0;     % m/s²
input2.soil_freq = 10.0;     % rad/s
input2.height = 25000;        % mm (25m)

params2.material_type = '叠层橡胶支座';
params2.elastic_modulus = 5.0;
params2.shear_modulus = 1.0;
params2.calc_method = '频域';
params2.Echo = true;

baseline2.min_freq_ratio = 1.414;
baseline2.acc_ratio_min = 0.06;
baseline2.acc_ratio_max = 0.33;
baseline2.max_displacement = 500;
baseline2.min_safety_factor = 1.2;

obj2 = method.SDOFIsolation (params2, input2, baseline2);
obj2 = obj2.solve();
obj2.checkSafety();

disp('--- 输出结果 ---');
fprintf('  频率比: %.3f (阈值: %.3f)\n', ...
        obj2.output.freq_ratio, obj2.baseline.min_freq_ratio);
fprintf('  隔震效果: %s\n', obj2.output.isolation_effect);
fprintf('  综合安全系数: %.3f / %.3f %s\n', ...
        obj2.capacity.safety_factor, ...
        obj2.baseline.min_safety_factor, ...
        pass_fail(obj2.capacity.safety_factor >= obj2.baseline.min_safety_factor));
disp(' ');

%% 测试用例3：存在共振风险的情况
disp('==========================================');
disp('--- 测试用例3：存在共振风险的情况 ---');

% 设置参数使频率比接近1
input3.M = 500;             % ton
input3.K = 112000;          % N/mm (112 MN/m)
input3.C = 200;             % N·s/mm
input3.ground_acc = 3.0;     % m/s²
input3.soil_freq = 15.0;     % rad/s
input3.height = 35000;        % mm (35m)

params3.material_type = '叠层橡胶支座';
params3.elastic_modulus = 5.0;
params3.shear_modulus = 1.0;
params3.calc_method = '频域';
params3.Echo = true;

baseline3.min_freq_ratio = 1.414;
baseline3.acc_ratio_min = 0.06;
baseline3.acc_ratio_max = 0.33;
baseline3.max_displacement = 500;
baseline3.min_safety_factor = 1.2;

obj3 = method.SDOFIsolation (params3, input3, baseline3);
obj3 = obj3.solve();
obj3.checkSafety();

disp('--- 输出结果 ---');
fprintf('  自振频率: %.3f rad/s\n', obj3.output.natural_freq);
fprintf('  场地频率: %.3f rad/s\n', obj3.input.soil_freq);
fprintf('  频率比: %.3f\n', obj3.output.freq_ratio);
fprintf('  加速度衰减比: %.4f (放大!)\n', obj3.output.acc_attenuation_ratio);
fprintf('  隔震效果: %s\n', obj3.output.isolation_effect);
fprintf('  共振风险: %s\n', ...
        iif_str(obj3.capacity.resonance_risk, '存在', '不存在'));
disp(' ');

%% 测试用例4：隔震效果良好的设计
disp('==========================================');
disp('--- 测试用例4：隔震效果良好的设计 ---');

% 优化设计：低刚度、适中阻尼
input4.M = 500;             % ton
input4.K = 10000;           % N/mm (10 MN/m)
input4.C = 500;             % N·s/mm
input4.ground_acc = 3.0;     % m/s²
input4.soil_freq = 15.0;     % rad/s
input4.height = 30000;        % mm (30m)

params4.material_type = '叠层橡胶支座';
params4.elastic_modulus = 5.0;
params4.shear_modulus = 1.0;
params4.calc_method = '频域';
params4.Echo = true;

baseline4.min_freq_ratio = 1.414;
baseline4.acc_ratio_min = 0.06;
baseline4.acc_ratio_max = 0.33;
baseline4.max_displacement = 800;   % 允许更大位移
baseline4.min_safety_factor = 1.2;

obj4 = method.SDOFIsolation (params4, input4, baseline4);
obj4 = obj4.solve();
obj4.checkSafety();

disp('--- 输出结果 ---');
fprintf('  自振频率: %.3f rad/s\n', obj4.output.natural_freq);
fprintf('  频率比: %.3f\n', obj4.output.freq_ratio);
fprintf('  加速度衰减比: %.4f\n', obj4.output.acc_attenuation_ratio);
fprintf('  最大位移: %.3f mm\n', obj4.output.max_displacement);
fprintf('  隔震效果: %s\n', obj4.output.isolation_effect);
fprintf('  预计降低地震烈度: %.1f 度\n', obj4.output.seismic_reduction);
fprintf('  综合安全系数: %.3f / %.3f %s\n', ...
        obj4.capacity.safety_factor, ...
        obj4.baseline.min_safety_factor, ...
        pass_fail(obj4.capacity.safety_factor >= obj4.baseline.min_safety_factor));
disp(' ');

%% 测试用例5：启动交互式UI
disp('==========================================');
disp('--- 测试用例5：交互式UI ---');
disp('  启动交互式界面...');

input5.M = 500;             % ton
input5.K = 15000;           % N/mm
input5.C = 800;             % N·s/mm
input5.ground_acc = 3.0;     % m/s²
input5.soil_freq = 15.0;     % rad/s
input5.height = 30000;        % mm

params5.material_type = '叠层橡胶支座';
params5.elastic_modulus = 5.0;
params5.shear_modulus = 1.0;
params5.calc_method = '频域';
params5.Echo = false;

baseline5.min_freq_ratio = 1.414;
baseline5.acc_ratio_min = 0.06;
baseline5.acc_ratio_max = 0.33;
baseline5.max_displacement = 500;
baseline5.min_safety_factor = 1.2;

obj5 = method.SDOFIsolation(params5, input5, baseline5);
obj5.InteractiveUI();

%% 测试用例6：不同阻尼比对比分析
disp('==========================================');
disp('--- 测试用例6：不同阻尼比对比分析 ---');

% 固定其他参数，只改变阻尼
input6_base.M = 500;             % ton
input6_base.K = 15000;           % N/mm
input6_base.ground_acc = 3.0;     % m/s²
input6_base.soil_freq = 15.0;     % rad/s
input6_base.height = 30000;        % mm

params6_base.material_type = '叠层橡胶支座';
params6_base.elastic_modulus = 5.0;
params6_base.shear_modulus = 1.0;
params6_base.calc_method = '频域';
params6_base.Echo = false;

baseline6.min_freq_ratio = 1.414;
baseline6.acc_ratio_min = 0.06;
baseline6.acc_ratio_max = 0.33;
baseline6.max_displacement = 500;
baseline6.min_safety_factor = 1.2;

damping_ratios = [0.02, 0.05, 0.10, 0.15, 0.20];  % 不同阻尼比
results = [];

disp('  阻尼比 | 加速度衰减比 | 位移安全系数 | 综合安全系数');
disp('  -----------------------------------------------------------');

for i = 1:length(damping_ratios)
    xi = damping_ratios(i);
    omega_n = sqrt(input6_base.K * 1000 / (input6_base.M * 1000));
    C = 2 * xi * input6_base.M * 1000 * omega_n / 1000;  % N·s/mm

    input6 = input6_base;
    input6.C = C;

    obj = method.SDOFIsolation(params6_base, input6, baseline6);
    obj = obj.solve();

    fprintf('  %.2f   |     %.4f    |     %.3f     |     %.3f\n', ...
            xi, obj.output.acc_attenuation_ratio, ...
            obj.capacity.disp_safety_factor, obj.capacity.safety_factor);

    results(i,:) = [xi, obj.output.acc_attenuation_ratio, ...
                    obj.capacity.disp_safety_factor, obj.capacity.safety_factor];
end

disp(' ');

%% 测试用例7：参数敏感性分析 - 隔震层刚度
disp('==========================================');
disp('--- 测试用例7：参数敏感性分析 - 隔震层刚度 ---');

input7_base.M = 500;             % ton
input7_base.C = 500;             % N·s/mm
input7_base.ground_acc = 3.0;     % m/s²
input7_base.soil_freq = 15.0;     % rad/s
input7_base.height = 30000;        % mm

params7_base.material_type = '叠层橡胶支座';
params7_base.elastic_modulus = 5.0;
params7_base.shear_modulus = 1.0;
params7_base.calc_method = '频域';
params7_base.Echo = false;

baseline7.min_freq_ratio = 1.414;
baseline7.acc_ratio_min = 0.06;
baseline7.acc_ratio_max = 0.33;
baseline7.max_displacement = 500;
baseline7.min_safety_factor = 1.2;

stiffness_values = [5000, 10000, 15000, 20000, 25000];  % N/mm

disp('  刚度 (N/mm) | 自振频率 | 频率比 | 加速度衰减比 | 最大位移 (mm)');
disp('  ------------------------------------------------------------');

for i = 1:length(stiffness_values)
    K = stiffness_values(i);

    input7 = input7_base;
    input7.K = K;

    obj = method.SDOFIsolation(params7_base, input7, baseline7);
    obj = obj.solve();

    fprintf('  %10.0f  |  %6.2f  | %5.2f  |     %.4f     |     %7.2f\n', ...
            K, obj.output.natural_freq, obj.output.freq_ratio, ...
            obj.output.acc_attenuation_ratio, obj.output.max_displacement);
end

disp(' ');

%% 测试完成
disp('==========================================');
disp('  所有测试完成');
disp('==========================================');

%% 辅助函数
function result = pass_fail(condition)
    if condition
        result = '✓';
    else
        result = '✗';
    end
end

function result = iif_str(condition, trueValue, falseValue)
    if condition
        result = trueValue;
    else
        result = falseValue;
    end
end

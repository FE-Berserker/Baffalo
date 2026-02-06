% test_SDOFIsolation_Report.m
% 测试 SDOFIsolation.Report() 函数

% 添加方法目录到路径
addpath('D:/Qsync/Baffalo/dep/framework');

% 创建输入参数
inputStruct.M = 1000;           % 上部结构质量 [ton]
inputStruct.K = 50000;         % 隔震层刚度 [N/mm]
inputStruct.C = 500;           % 隔震层阻尼系数 [N·s/mm]
inputStruct.ground_acc = 3.0;  % 地面加速度 [m/s²]
inputStruct.soil_freq = 15;    % 场地频率 [rad/s]
inputStruct.height = 20000;    % 建筑高度 [mm]

% 创建参数结构
paramsStruct.calc_method = '频域';
paramsStruct.Echo = true;
paramsStruct.Name = 'MyIsolationProject';  % 设置项目名称

% 创建 SDOFIsolation 对象
obj = method.SDOFIsolation(paramsStruct, inputStruct);

% 执行计算
obj = obj.solve();

% 生成报告
obj = obj.Report();

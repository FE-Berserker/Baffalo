%% Demo_066_RectangularRubberStack
% 矩形橡胶堆设计演示
% Author: Xie Yu
% Date: 2026-02-02

clear; clc; close all;

%% 2. 设置参数
% Params (仅需设置橡胶硬度)
paramsStruct = struct(...
    'HS', 60, ...         % 橡胶硬度
    'Echo', true ...      % 是否输出计算过程
);

% Input - 目标刚度和载荷
inputStruct = struct(...
    'Kz_target', 2000, ...     % 目标垂向刚度 (N/mm)
    'Kx_target', 300, ...      % 目标x向水平刚度 (N/mm)
    'Ky_target', 300, ...      % 目标y向水平刚度 (N/mm)
    'Fz_max', 50000, ...       % 最大垂向载荷 (N)
    'Fx_max', 5000, ...        % 最大x向水平力 (N)
    'Fy_max', 5000, ...        % 最大y向水平力 (N)
    'n', 4, ...                % 橡胶层数
    'a', 100, ...              % 矩形橡胶长边 (mm)
    'b', 80, ...               % 矩形橡胶短边 (mm)
    'h', 10, ...               % 每层橡胶原有高度 (mm)
    't_plate_mid', 2, ...      % 中间隔层钢板厚度 (mm)
    't_plate_end', 8, ...      % 端板厚度 (mm)
    'a_max', 150, ...          % 长边最大允许尺寸 (mm)
    'b_max', 120 ...           % 短边最大允许尺寸 (mm)
);

% Baseline - 安全约束条件
baselineStruct = struct(...
    'min_Kz_ratio', 1.0, ...               % 垂向刚度安全系数最低要求
    'min_Kx_ratio', 1.0, ...               % x向水平刚度安全系数最低要求
    'min_Ky_ratio', 1.0, ...               % y向水平刚度安全系数最低要求
    'max_compression_strain', 0.15, ...   % 最大允许压缩应变
    'max_h_to_a_ratio', 0.2 ...            % 最大h/a比值约束
);

%% 3. 创建矩形橡胶堆对象并求解
rubberStack = support.RectangularRubberStack(paramsStruct, inputStruct, baselineStruct);
rubberStack = rubberStack.solve();

%% 4. 安全校核
rubberStack.checkSafety();

%% 5. 显示结果
fprintf('\n========================================\n');
fprintf('  计算结果汇总\n');
fprintf('========================================\n');
fprintf('橡胶承载面积 Ac = %.2f mm^2\n', rubberStack.output.Ac);
fprintf('形状因子 S = %.4f\n', rubberStack.output.S);
fprintf('垂向形状系数 mu1 = %.4f\n', rubberStack.output.mu1);
fprintf('垂向刚度 Kz = %.2f N/mm (目标: %.2f N/mm)\n', ...
        rubberStack.output.Kz_calc, rubberStack.input.Kz_target);
fprintf('x向水平总刚度 Kx = %.2f N/mm (目标: %.2f N/mm)\n', ...
        rubberStack.output.Kx_total, rubberStack.input.Kx_target);
fprintf('y向水平总刚度 Ky = %.2f N/mm (目标: %.2f N/mm)\n', ...
        rubberStack.output.Ky_total, rubberStack.input.Ky_target);
fprintf('x向剪切刚度 = %.2f N/mm\n', rubberStack.output.Kx_shear);
fprintf('y向剪切刚度 = %.2f N/mm\n', rubberStack.output.Ky_shear);
fprintf('x向弯曲刚度 = %.2f N/mm\n', rubberStack.output.Kbx);
fprintf('y向弯曲刚度 = %.2f N/mm\n', rubberStack.output.Kby);
fprintf('压缩应变 = %.2f%%\n', rubberStack.output.compression_strain * 100);
fprintf('========================================\n');

%% 6. 绘制图表
rubberStack.PlotCapacity();

%% 7. 测试不同橡胶硬度的影响
fprintf('\n\n========================================\n');
fprintf('  测试不同橡胶硬度的影响\n');
fprintf('========================================\n');

HS_values = [40, 50, 60, 70, 80];
Kz_values = zeros(size(HS_values));
Kx_values = zeros(size(HS_values));
Ky_values = zeros(size(HS_values));

for i = 1:length(HS_values)
    paramsTest.HS = HS_values(i);
    paramsTest.Echo = false;
    rubberTest = support.RectangularRubberStack(paramsTest, inputStruct, baselineStruct);
    rubberTest = rubberTest.solve();
    Kz_values(i) = rubberTest.output.Kz_calc;
    Kx_values(i) = rubberTest.output.Kx_total;
    Ky_values(i) = rubberTest.output.Ky_total;
    fprintf('HS = %d: Kz = %.2f N/mm, Kx = %.2f N/mm, Ky = %.2f N/mm\n', ...
            HS_values(i), Kz_values(i), Kx_values(i), Ky_values(i));
end

%% 8. 绘制橡胶硬度对刚度的影响
figure;
subplot(3,1,1);
plot(HS_values, Kz_values, 'o-', 'LineWidth', 2);
grid on;
xlabel('橡胶硬度 HS');
ylabel('垂向刚度 (N/mm)');
title('橡胶硬度对垂向刚度的影响');

subplot(3,1,2);
plot(HS_values, Kx_values, 's-', 'LineWidth', 2, 'Color', [0.2 0.6 0.8]);
grid on;
xlabel('橡胶硬度 HS');
ylabel('x向水平刚度 (N/mm)');
title('橡胶硬度对x向水平刚度的影响');

subplot(3,1,3);
plot(HS_values, Ky_values, '^-', 'LineWidth', 2, 'Color', [0.8 0.4 0.2]);
grid on;
xlabel('橡胶硬度 HS');
ylabel('y向水平刚度 (N/mm)');
title('橡胶硬度对y向水平刚度的影响');

sgtitle('橡胶硬度对刚度的影响');

fprintf('\n演示完成！\n');


Plot3D(rubberStack)
ANSYS_Output(rubberStack.output.Assembly)
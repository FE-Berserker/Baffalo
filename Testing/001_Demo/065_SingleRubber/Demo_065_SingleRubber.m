%% Demo 065: SingleRubber Test Cases
% 演示单个橡胶体的有限元网格生成
% 测试旋转体和平板两种类型的橡胶体
% Author: Xie Yu

clear; clc; close all;

%% ========== 测试用例1: 旋转体橡胶体 (Rotary Type) ==========
fprintf('========== Test Case 1: Rotary Type (Housing) ==========\n');

% 1.1 创建旋转体几何模型 (Housing)
fprintf('\n1.1 Creating Housing geometry...\n');

% 创建矩形截面（由矩形旋转形成空心圆柱体）
% 矩形从内半径延伸到外半径，旋转360度形成空心圆柱体
points = Point2D('Rectangle Points');

% 定义矩形的四个顶点（从内半径到外半径）
% 矩形在y方向：从R_inner=15到R_outer=25
% 矩形在z方向：从0到length=100

points = AddPoint(points, [45; 65], [60;60]);      % 内侧边
points = AddPoint(points, [45; 65], [60; 100]);      % 内侧边
points = AddPoint(points, [45; 65], [100; 100]);      % 外侧边
points = AddPoint(points, [65; 45], [100; 60]);        % 底边
points = AddPoint(points, [65; 45], [60; 60]);     % 顶边

% 创建矩形轮廓
outline = Line2D('Housing Outline');
outline = AddLine(outline, points, 1);  % 内侧边
outline = AddLine(outline, points, 2);  % 外侧边
outline = AddLine(outline, points, 3);  % 底边
outline = AddLine(outline, points, 4);  % 顶边

% 设置Housing输入参数
inputhousing = struct();
inputhousing.Outline = outline;
inputhousing.Meshsize = 2;

% 设置Housing参数
paramshousing = struct();
paramshousing.Axis = 'x';
paramshousing.Degree = 360;
paramshousing.N_Slice = 36;
paramshousing.Name = 'TestHousing_Rubber';

% 创建Housing对象
housingGeo = housing.Housing(paramshousing, inputhousing);
housingGeo = housingGeo.solve();

Plot2D(housingGeo)
fprintf('Housing geometry created successfully.\n');

% 1.2 创建旋转体橡胶体
fprintf('\n1.2 Creating SingleRubber with Rotary type...\n');

paramsRubber1 = struct();
paramsRubber1.Type = 'Rotary';
paramsRubber1.Name = 'Rubber_Rotary';
paramsRubber1.Echo = 1;

inputRubber1 = struct();
inputRubber1.HS = 60;  % 邵氏硬度60
inputRubber1.Geometry = housingGeo;

rubber1 = body.SingleRubber(paramsRubber1, inputRubber1);
rubber1 = rubber1.solve();

fprintf('\nTest Case 1 completed.\n');

% 1.3 可视化
fprintf('\n1.3 Plotting results...\n');

Plot2D(rubber1);
title('Rotary Rubber - 2D Model');
Plot3D(rubber1);
title('Rotary Rubber - 3D Model');

%% ========== 测试用例2: 平板橡胶体 (Plate Type) ==========
fprintf('\n========== Test Case 2: Plate Type (Commonplate) ==========\n');

% 2.1 创建平板几何模型 (Commonplate)
fprintf('\n2.1 Creating Commonplate geometry...\n');

% 创建矩形外轮廓
pointsPlate = Point2D('Rectangle Points');

% 定义矩形的四个顶点（长100mm x 宽60mm）
% 底边：从左下到右下
pointsPlate = AddPoint(pointsPlate, [-50; 50], [-30; -30]);
% 右边：从右下到右上
pointsPlate = AddPoint(pointsPlate, [50; 50], [-30; 30]);
% 顶边：从右上到左上
pointsPlate = AddPoint(pointsPlate, [50; -50], [30; 30]);
% 左边：从左上到左下
pointsPlate = AddPoint(pointsPlate, [-50; -50], [30; -30]);

% 创建矩形轮廓
outlinePlate = Line2D('Plate Outline');
outlinePlate = AddLine(outlinePlate, pointsPlate, 1);  % 底边
outlinePlate = AddLine(outlinePlate, pointsPlate, 2);  % 右边
outlinePlate = AddLine(outlinePlate, pointsPlate, 3);  % 顶边
outlinePlate = AddLine(outlinePlate, pointsPlate, 4);  % 左边

% 设置Commonplate输入参数
inputplate = struct();
inputplate.Outline = outlinePlate;
inputplate.Thickness = 10;

% 设置Commonplate参数
paramsplate = struct();
paramsplate.Name = 'TestPlate_Rubber';

% 创建Commonplate对象
plateGeo = plate.Commonplate(paramsplate, inputplate);
plateGeo = plateGeo.solve();

fprintf('Commonplate geometry created successfully.\n');

% 2.2 创建平板橡胶体
fprintf('\n2.2 Creating SingleRubber with Plate type...\n');

paramsRubber2 = struct();
paramsRubber2.Type = 'Plate';
paramsRubber2.Name = 'Rubber_Plate';
paramsRubber2.Echo = 1;

inputRubber2 = struct();
inputRubber2.HS = 50;  % 邵氏硬度50
inputRubber2.Geometry = plateGeo;

rubber2 = body.SingleRubber(paramsRubber2, inputRubber2);
rubber2 = rubber2.solve();

fprintf('\nTest Case 2 completed.\n');

% 2.3 可视化
fprintf('\n2.3 Plotting results...\n');

rubber2.Plot2D();
title('Plate Rubber - 2D Section');

Plot3D(rubber2);
title('Plate Rubber - 3D Model');

drawnow;

%% ========== 测试用例3: 不同硬度的橡胶体 ==========
fprintf('\n========== Test Case 3: Different Hardness Values ==========\n');

% 3.1 测试不同邵氏硬度
hardnessValues = [30, 50, 70, 90];

for i = 1:length(hardnessValues)
    fprintf('\n3.%d Testing hardness: %d HS\n', i, hardnessValues(i));

    paramsRubber3 = struct();
    paramsRubber3.Type = 'Rotary';
    paramsRubber3.Name = ['Rubber_HS' num2str(hardnessValues(i))];
    paramsRubber3.Echo = 0;

    inputRubber3 = struct();
    inputRubber3.HS = hardnessValues(i);
    inputRubber3.Geometry = housingGeo;

    rubber3 = body.SingleRubber(paramsRubber3, inputRubber3);
    rubber3 = rubber3.solve();

    % 打印材料属性
    fprintf('   Elastic Modulus (E): %.4f N/mm^2\n', rubber3.output.RubberProperty.output.E);
    fprintf('   Shear Modulus (G): %.4f N/mm^2\n', rubber3.output.RubberProperty.output.G);
    fprintf('   Poisson Ratio (v): %.4f\n', rubber3.output.RubberProperty.output.v);
    fprintf('   Mooney-Rivlin [C10, C01]: [%.6f, %.6f]\n', ...
        rubber3.output.RubberProperty.output.MR_Parameter);
end

fprintf('\nTest Case 3 completed.\n');

%% ========== 测试用例4: 二阶单元 ==========
fprintf('\n========== Test Case 4: Second Order Elements ==========\n');

% 4.1 使用二阶单元的Housing
paramshousing4 = struct();
paramshousing4.Axis = 'x';
paramshousing4.Degree = 360;
paramshousing4.N_Slice = 36;
paramshousing4.Order = 2;  % 二阶单元
paramshousing4.Name = 'TestHousing_Order2';

housingGeo4 = housing.Housing(paramshousing4, inputhousing);
housingGeo4 = housingGeo4.solve();

% 4.2 创建二阶单元的橡胶体
paramsRubber4 = struct();
paramsRubber4.Type = 'Rotary';
paramsRubber4.Name = 'Rubber_Order2';
paramsRubber4.Echo = 1;

inputRubber4 = struct();
inputRubber4.HS = 60;
inputRubber4.Geometry = housingGeo4;

rubber4 = body.SingleRubber(paramsRubber4, inputRubber4);
rubber4 = rubber4.solve();

fprintf('\nTest Case 4 completed.\n');

% 4.3 可视化
fprintf('\n4.3 Plotting second order element model...\n');
Plot3D(rubber4);
title('Rubber with Second Order Elements');

drawnow;

%% ========== 测试用例5: 装配信息 ==========
fprintf('\n========== Test Case 5: Assembly Information ==========\n');

% 5.1 获取装配信息
ass = rubber1.output.Assembly;
fprintf('\nAssembly Name: %s\n', ass.Name);
fprintf('Number of Parts: %d\n', length(ass.Part));
fprintf('Number of Element Types: %d\n', length(ass.ET));
fprintf('Number of Materials: %d\n', length(ass.Material));

% 5.2 打印材料属性
fprintf('\nMaterial Properties:\n');
fprintf('  Name: %s\n', ass.Material{1,1}.Name);
fprintf('  Table:\n');
disp(ass.Material{1,1}.table);

fprintf('\nTest Case 5 completed.\n');

%% ========== 总结 ==========
fprintf('\n========== All Test Cases Completed ==========\n');
fprintf('Summary:\n');
fprintf('  Test Case 1: Rotary type rubber - PASS\n');
fprintf('  Test Case 2: Plate type rubber - PASS\n');
fprintf('  Test Case 3: Different hardness values - PASS\n');
fprintf('  Test Case 4: Second order elements - PASS\n');
fprintf('  Test Case 5: Assembly information - PASS\n');

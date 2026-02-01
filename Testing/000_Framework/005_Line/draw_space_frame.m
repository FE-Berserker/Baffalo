% 绘制空间框架结构（立方体框架）
% Author: Claude Code
% Date: 2026-02-01

%% 清除工作区
clear; close all; clc;

%% 1. 创建 Line 对象（框架线条）
Frame = Line('SpaceFrame', 'Echo', 1);

%% 2. 定义立方体顶点坐标（列向量）
% 底面 (z=0)
v1 = [0;  0;  0];   % 顶点1
v2 = [10; 0;  0];   % 顶点2
v3 = [10; 10; 0];   % 顶点3
v4 = [0;  10; 0];   % 顶点4

% 顶面 (z=10)
v5 = [0;  0;  10];  % 顶点5
v6 = [10; 0;  10];  % 顶点6
v7 = [10; 10; 10];  % 顶点7
v8 = [0;  10; 10];  % 顶点8

%% 3. 定义直线的 NURBS 参数（包含权重）
% 每条线使用 2 个控制点，seg=2（只输出起点和终点）
knots_line = [0, 0, 1, 1];  % 二阶（线性）节点向量

%% 4. 添加框架边（使用 AddNurb 创建直线）

% 底面边框 (4条边)
Frame = AddNurb(Frame, [v1, v2; 1, 1]', knots_line, 'seg', 2);  % 边1: 顶点1->2
Frame = AddNurb(Frame, [v2, v3; 1, 1]', knots_line, 'seg', 2);  % 边2: 顶点2->3
Frame = AddNurb(Frame, [v3, v4; 1, 1]', knots_line, 'seg', 2);  % 边3: 顶点3->4
Frame = AddNurb(Frame, [v4, v1; 1, 1]', knots_line, 'seg', 2);  % 边4: 顶点4->1

% 顶面边框 (4条边)
Frame = AddNurb(Frame, [v5, v6; 1, 1]', knots_line, 'seg', 2);  % 边5: 顶点5->6
Frame = AddNurb(Frame, [v6, v7; 1, 1]', knots_line, 'seg', 2);  % 边6: 顶点6->7
Frame = AddNurb(Frame, [v7, v8; 1, 1]', knots_line, 'seg', 2);  % 边7: 顶点7->8
Frame = AddNurb(Frame, [v8, v5; 1, 1]', knots_line, 'seg', 2);  % 边8: 顶点8->5

% 竖直边 (4条边)
Frame = AddNurb(Frame, [v1, v5; 1, 1]', knots_line, 'seg', 2);  % 边9:  顶点1->5
Frame = AddNurb(Frame, [v2, v6; 1, 1]', knots_line, 'seg', 2);  % 边10: 顶点2->6
Frame = AddNurb(Frame, [v3, v7; 1, 1]', knots_line, 'seg', 2);  % 边11: 顶点3->7
Frame = AddNurb(Frame, [v4, v8; 1, 1]', knots_line, 'seg', 2);  % 边12: 顶点4->8

%% 5. 添加对角线（增强框架）

% 底面对角线 (2条)
Frame = AddNurb(Frame, [v1, v3; 1, 1]', knots_line, 'seg', 2);  % 对角线1: 顶点1->3
Frame = AddNurb(Frame, [v2, v4; 1, 1]', knots_line, 'seg', 2);  % 对角线2: 顶点2->4

% 顶面对角线 (2条)
Frame = AddNurb(Frame, [v5, v7; 1, 1]', knots_line, 'seg', 2);  % 对角线3: 顶点5->7
Frame = AddNurb(Frame, [v6, v8; 1, 1]', knots_line, 'seg', 2);  % 对角线4: 顶点6->8

% 空间对角线 (4条)
Frame = AddNurb(Frame, [v1, v7; 1, 1]', knots_line, 'seg', 2);  % 对角线5: 顶点1->7
Frame = AddNurb(Frame, [v2, v8; 1, 1]', knots_line, 'seg', 2);  % 对角线6: 顶点2->8
Frame = AddNurb(Frame, [v3, v5; 1, 1]', knots_line, 'seg', 2);  % 对角线7: 顶点3->5
Frame = AddNurb(Frame, [v4, v6; 1, 1]', knots_line, 'seg', 2);  % 对角线8: 顶点4->6

%% 6. 绘制框架
fprintf('\n=== 绘制空间框架结构 ===\n');
fprintf('总边数: %d\n', GetNcrv(Frame));
fprintf('- 底面边框: 4条\n');
fprintf('- 顶面边框: 4条\n');
fprintf('- 竖直边: 4条\n');
fprintf('- 面对角线: 4条\n');
fprintf('- 空间对角线: 4条\n');

% 绘制框架
Plot(Frame, 'grid', 1, 'color', 1, 'clabel', 0);

title('空间框架结构 (Space Frame Structure)');
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');

%% 7. 导出为 VTK 文件
VTKWrite(Frame);
fprintf('\n已导出 VTK 文件: SpaceFrame.vtk\n');

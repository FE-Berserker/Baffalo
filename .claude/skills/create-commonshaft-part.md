# Create Commonshaft (轴类零件)

当用户要求创建轴类零件（如：轴、阶梯轴、传动轴、主轴等）时，使用此skill。

## 概述

`Commonshaft` 是一个用于创建阶梯轴（变截面轴）的MATLAB类，支持：
- ✅ 实心轴、空心轴、混合轴
- ✅ 多段阶梯轴
- ✅ 实体模型（四面体网格）
- ✅ 梁模型（梁单元）
- ✅ 面变形功能
- ✅ STL文件导出

## 类位置
```
+shaft/@Commonshaft
```

## 参数说明

### paramsStruct（可选参数）

| 参数 | 类型 | 默认值 | 说明 |
|------|------|---------|------|
| `Material` | struct | 空（钢材） | 材料属性 |
| `N_Slice` | int | 100 | 切片数量（轴向离散化） |
| `Name` | string | 'Commonshaft1' | 轴的名称 |
| `E_Revolve` | int | 40 | 旋转划分数（圆周分段，必须是8的倍数） |
| `Beam_N` | int | 16 | 梁截面圆周分段数 |
| `Order` | int | 1 | 实体单元阶次：1=一阶（185），2=二阶（186） |
| `Echo` | int | 1 | 是否打印信息：0=不打印，1=打印 |

### inputStruct（必需参数）

| 参数 | 类型 | 说明 | 示例 |
|------|------|------|------|
| `Length` | Nx2矩阵 | 各段长度 [起始位置, 结束位置] [mm] | `[115; 120]` 或 `[29; 53; 77; 115]` |
| `ID` | Nx2矩阵 | 各段内径 [起始内径, 结束内径] [mm] | `[0, 0]` 或 `[[0,0]; [6,6]]` |
| `OD` | Nx2矩阵 | 各段外径 [起始外径, 结束外径] [mm] | `[36, 36]` 或 `[[22.5,22.5]; [36,36]]` |
| `Meshsize` | 数值 | 网格尺寸 [mm]，可选 | 0.5, 15 |

## 常用轴类型

### 1. 单段实心轴

```matlab
input.Length = 115;      % 总长度
input.ID = [0, 0];       % 内径为0（实心）
input.OD = [36, 36];      % 外径不变
params = struct();         % 使用默认参数
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 2. 单段空心轴

```matlab
input.Length = 120;
input.ID = [6, 6];       % 内径为6mm
input.OD = [36, 36];      % 外径为36mm
params = struct();
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 3. 多段阶梯轴（实心）

```matlab
% 4段阶梯轴，外径递增
input.Length = [29; 53; 77; 115];
input.ID = [[0,0]; [0,0]; [0,0]; [0,0]];  % 全部实心
input.OD = [[22.5,22.5]; [26.5,26.5]; [29.5,29.5]; [36,36]];
params = struct();
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 4. 空心到实心过渡轴

```matlab
% 5段轴，前3段空心，后2段实心
input.Length = [29; 53; 71; 77; 115];
input.ID = [[6.6,6.6]; [6.6,6.6]; [6.6,6.6]; [0,0]; [0,0]];
input.OD = [[22.5,22.5]; [26.5,26.5]; [29.5,29.5]; [29.5,29.5]; [36,36]];
params = struct();
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 5. 带内径阶梯的空心轴

```matlab
% 5段轴，内径从6.6阶梯到18.5
input.Length = [29; 53; 71; 77; 115];
input.ID = [[6.6,6.6]; [6.6,6.6]; [6.6,6.6]; [18.5,18.5]; [18.5,18.5]];
input.OD = [[22.5,22.5]; [26.5,26.5]; [29.5,29.5]; [29.5,29.5]; [36,36]];
params = struct();
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 6. 复杂轴（含多个实心和空心段）

```matlab
% 9段轴，包含多个实心段
input.Length = [7; 8; 29; 53; 71; 77; 107; 108; 115];
input.ID = [[6.6,6.6]; [6.6,0]; [0,0]; [0,0]; [0,0]; [0,0]; [0,0]; [0,6.6]; [6.6,6.6]];
input.OD = [[22.5,22.5]; [22.5,22.5]; [22.5,22.5]; [26.5,26.5]; [26.5,29.5]; [29.5,29.5]; [36,36]; [36,36]; [36,36]];
input.Meshsize = 0.5;    % 自定义网格尺寸
params = struct();
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 7. 使用二阶网格

```matlab
input.Length = [7; 8; 29; 53; 71; 77; 107; 108; 115];
input.ID = [[6.6,6.6]; [6.6,0]; [0,0]; [0,0]; [0,0]; [0,0]; [0,0]; [0,6.6]; [6.6,6.6]];
input.OD = [[22.5,22.5]; [22.5,22.5]; [22.5,22.5]; [26.5,26.5]; [26.5,29.5]; [29.5,29.5]; [36,36]; [36,36]; [36,36]];
params.Order = 2;  % 二阶网格（186单元）
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 8. 自定义旋转划分数

```matlab
input.Length = [40; 117.7; 201.7; 223.7; 243.7];
input.OD = [[35,35]; [42,42]; [65,65]; [90,90]; [54,54]];
input.ID = [[10,10]; [10,10]; [10,10]; [10,10]; [10,10]];
input.Meshsize = 15;
params.E_Revolve = 60;  % 增加圆周分段数
params.Name = 'CustomShaft';
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

## 输出对象

求解后，`obj.output` 包含：

| 属性 | 说明 |
|------|------|
| `Node` | 轴向节点位置 |
| `ID` | 各节点处的内径 |
| `OD` | 各节点处的外径 |
| `Surface` | 轴的2D截面 |
| `SolidMesh` | 轴的3D实体网格 |
| `BeamMesh` | 轴的梁网格 |
| `Assembly` | 实体模型装配 |
| `Assembly1` | 梁模型装配 |

## 常用方法

### 绘图

```matlab
% 2D截面图
Plot2D(obj);

% 3D图形
Plot3D(obj);

% 绘制指定面
Plot3D(obj, 'faceno', 101);  % 绘制外表面
Plot3D(obj, 'faceno', 301);  % 绘制左端面
```

### 面变形

```matlab
% 定义变形函数
f = @(r) sqrt(250^2 - r.^2) + 22 - sqrt(250^2 - 65^2);

% 变形面102（外表面）
obj = DeformFace(obj, 102, f, 'direction', 'axial', 'Plot', 1);

% 径向变形
g = @(x) 10 + 0.1 * x;  % 半径随x线性增加
obj = DeformFace(obj, 101, g, 'direction', 'radial');
```

### STL导出

```matlab
% 导出STL文件
OutputSTL(obj);
```

### 选择面节点

```matlab
% 选择指定面的节点
[VV, pos] = SelectFaceNode(obj, 101);
% VV: 节点坐标
% pos: 节点索引
```

## 边界标记

| 标记范围 | 说明 |
|----------|------|
| 101-1xx | 外表面（101=第1段外表面，102=第2段，...） |
| 201-2xx | 内表面（201=第1段内表面，202=第2段，...） |
| 301+ | 端面和阶梯面 |

## 使用流程

```matlab
% 1. 定义输入参数
input.Length = [29; 53; 77; 115];
input.ID = [[6.6,6.6]; [6.6,6.6]; [0,0]; [0,0]];
input.OD = [[22.5,22.5]; [26.5,26.5]; [29.5,29.5]; [36,36]];

% 2. 定义可选参数
params = struct();
params.Order = 1;
params.E_Revolve = 40;
params.Meshsize = 0.5;

% 3. 创建对象
obj = shaft.Commonshaft(params, input);

% 4. 求解
obj = obj.solve();

% 5. 绘图
Plot2D(obj);
Plot3D(obj);

% 6. 导出STL（可选）
OutputSTL(obj);
```

## 实际应用示例

### 主轴

```matlab
input.Length = [100; 200; 300; 450];
input.ID = [[0,0]; [0,0]; [0,0]; [0,0]];
input.OD = [[50,50]; [60,60]; [70,70]; [80,80]];
params.Name = 'MainShaft';
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 传动轴

```matlab
input.Length = 500;
input.ID = [25, 25];
input.OD = [60, 60];
params.Name = 'DriveShaft';
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

### 阶梯轴

```matlab
input.Length = [30; 60; 100; 150; 200];
input.ID = [[0,0]; [15,15]; [20,20]; [25,25]; [30,30]];
input.OD = [[30,30]; [40,40]; [50,50]; [60,60]; [70,70]];
params.Name = 'SteppedShaft';
obj = shaft.Commonshaft(params, input);
obj = obj.solve();
```

## 注意事项

1. **E_Revolve 必须是8的倍数**，如果不是会自动修正
2. **Meshsize 不设置时**，会自动使用最小外径的1/10
3. **Material 不设置时**，会自动使用钢材（从材料库获取）
4. **Order=2 时**，使用二阶四面体单元（186），计算量更大但精度更高
5. **梁模型**适用于细长轴，**实体模型**适用于短粗轴或需要详细应力分析

## 故障排除

| 问题 | 解决方法 |
|------|----------|
| 网格生成失败 | 减小 Meshsize |
| 网格太粗糙 | 减小 Meshsize 或增加 E_Revolve |
| 内存不足 | 增大 Meshsize 或使用 Order=1 |
| 边界标记错误 | 检查输入的 ID 和 OD 是否正确 |

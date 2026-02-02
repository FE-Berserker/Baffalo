# 创建旋转体零件 (Housing)

当用户要求创建旋转体零件、壳体、通过截面轮廓旋转生成3D实体时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "创建一个旋转体"
- "创建壳体"
- "生成一个旋转体零件"
- "通过截面轮廓旋转生成3D模型"
- "创建一个环形壳体"
- "建立一个旋转壳体模型"

## 类概述

**类名**: `housing.Housing`
**继承**: `Component`
**作者**: Xie Yu
**用途**: 通过截面轮廓旋转生成3D实体模型（旋转体/壳体）

## 参数说明

### paramsStruct - 参数结构体

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| Material | 结构体 | [] | 材料属性，默认为钢材 |
| N_Slice | 整数 | 36 | 旋转分段数（圆周方向离散化） |
| Degree | 数值 | 360 | 旋转角度 [°] |
| Axis | 字符串 | 'x' | 旋转轴：'x' 或 'y' |
| Name | 字符串 | 'Housing_1' | 壳体的名称 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |
| Order | 整数 | 1 | 单元阶次：1=一阶，2=二阶 |

### inputStruct - 输入结构体

| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| Outline | Line2D对象 | 是 | 截面轮廓 [mm]，使用 Line2D 类创建 |
| Hole | Line2D矩阵 | 否 | 孔几何 [mm]，Nx2矩阵，每个孔是一个 Line2D 对象 |
| Meshsize | 数值 | 否 | 网格尺寸 [mm]，如不设置则自动计算 |

### 输出结果

| 输出 | 类型 | 说明 |
|------|------|------|
| Surface | Surface2D | 壳体截面表面 |
| SolidMesh | Mesh | 壳体3D实体网格 |
| Assembly | Assembly | 实体模型装配 |

## 边界标记

| 标记 | 说明 |
|------|------|
| 101+ | 侧面标记（101=第1条轮廓线旋转形成的面，102=第2条，...） |
| 11 | 非360°旋转时的起始面 |
| 12 | 非360°旋转时的结束面（仅当Degree=180时） |
| 200+ | 当SubOutline=1时的子轮廓标记 |

## 创建轮廓的方法

### 1. 创建圆形/圆弧轮廓

```matlab
b = Line2D('Outline Name');
b = AddCircle(b, radius, point, curveId, 'sang', startAngle, 'ang', sweepAngle);
```

### 2. 创建直线轮廓

```matlab
a = Point2D('Point Name');
a = AddPoint(a, x, y);
b = AddLine(b, a, curveId);
```

## 使用流程

### 标准流程

```matlab
%% 步骤1：创建截面轮廓
outline = Line2D('Housing Outline');
% 使用 AddCircle、AddLine 等函数添加曲线

%% 步骤2：创建孔（可选）
hole = Line2D('Hole');
hole = AddCircle(hole, radius, centerPoint, 1);

%% 步骤3：设置输入
inputhousing.Outline = outline;
inputhousing.Hole = hole;  % 可选
inputhousing.Meshsize = 2;  % 可选

%% 步骤4：设置参数
paramshousing = struct();
paramshousing.Axis = 'x';  % 旋转轴
paramshousing.Degree = 360;  % 旋转角度
paramshousing.N_Slice = 36;  % 圆周分段数

%% 步骤5：创建壳体
obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();

%% 步骤6：可视化
obj.Plot2D();  % 2D视图
Plot3D(obj);   % 3D视图
```

## 常见场景示例

### 场景1：创建简单环形壳体

```matlab
% 创建中心点
center = Point2D('Center');
center = AddPoint(center, 50, 0);

% 创建圆轮廓（作为截面）
outline = Line2D('Housing Outline');
outline = AddCircle(outline, 10, center, 1);

% 设置输入
inputhousing.Outline = outline;
inputhousing.Meshsize = 2;

% 设置参数
paramshousing = struct();
paramshousing.Axis = 'x';  % 绕x轴旋转
paramshousing.Degree = 360;
paramshousing.N_Slice = 36;

% 创建壳体
obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();
```

### 场景2：创建带孔的环形壳体

```matlab
% 创建截面轮廓
outline = Line2D('Housing Outline');
outline = AddCircle(outline, 10, centerPoint, 1);

% 创建孔
hole = Line2D('Hole');
hole = AddCircle(hole, 3, holeCenter, 1);

inputhousing.Outline = outline;
inputhousing.Hole = hole;
inputhousing.Meshsize = 2;

paramshousing = struct();
obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();
```

### 场景3：绕y轴旋转

```matlab
outline = Line2D('Housing Outline');
outline = AddCircle(outline, radius, centerPoint, 1);

inputhousing.Outline = outline;

paramshousing = struct();
paramshousing.Axis = 'y';  % 绕y轴旋转
paramshousing.Degree = 360;

obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();
```

### 场景4：非360°旋转（半圆环）

```matlab
outline = Line2D('Housing Outline');
outline = AddCircle(outline, radius, centerPoint, 1);

inputhousing.Outline = outline;

paramshousing = struct();
paramshousing.Degree = 180;  % 旋转180度
paramshousing.N_Slice = 18;

obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();

% 绘制时可以看到起始面和结束面
Plot3D(obj);
```

### 场景5：使用二阶单元

```matlab
outline = Line2D('Housing Outline');
outline = AddCircle(outline, radius, centerPoint, 1);

inputhousing.Outline = outline;

paramshousing = struct();
paramshousing.Order = 2;  % 二阶单元（186单元）
paramshousing.N_Slice = 36;

obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();
```

### 场景6：增加圆周分段数（更精细的网格）

```matlab
outline = Line2D('Housing Outline');
outline = AddCircle(outline, radius, centerPoint, 1);

inputhousing.Outline = outline;

paramshousing = struct();
paramshousing.N_Slice = 72;  % 增加分段数
paramshousing.Meshsize = 1;  # 减小网格尺寸

obj = housing.Housing(paramshousing, inputhousing);
obj = obj.solve();
```

## 常用方法

### 绘图

```matlab
% 2D截面图
obj.Plot2D();

% 3D图形（绘制全部面）
Plot3D(obj);

% 绘制指定面
Plot3D(obj, 'faceno', 101);  % 绘制侧面101
Plot3D(obj, 'faceno', 11);   % 绘制起始面

% 显示面法向量
Plot3D(obj, 'face_normal', 1);
```

### 导出STL文件

```matlab
% 导出STL文件
OutputSTL(obj);
% 生成文件: Housing_1.stl
```

### 面移动

```matlab
% 移动指定面
% Faceno: 要移动的面编号数组
% movement: [dx, dy, dangle] - x位移, y位移, 旋转角度
obj = MoveFace(obj, Faceno, movement);

% 示例：移动第1个面
obj = MoveFace(obj, 1, [10, 0, 0]);  % x方向移动10mm

% 重复移动（创建新面）
obj = MoveFace(obj, 1, [5, 0, 10], 'num', 3);  % 重复3次
```

### 获取面数

```matlab
% 获取表面的面数
nFaces = GetNFace(obj);
```

## 注意事项

### 1. 材料设置

如果未指定材料，系统会使用默认钢材：

```matlab
% 使用默认材料
paramshousing = struct();
obj = housing.Housing(paramshousing, inputhousing);

% 指定材料
S = RMaterial('FEA');
mat = GetMat(S, 1);
paramshousing.Material = mat{1,1};
obj = housing.Housing(paramshousing, inputhousing);
```

### 2. 单位

所有长度单位均为毫米 (mm)，角度为度 (°)

### 3. 网格控制

- `Meshsize`: 控制网格大小，值越小网格越细
- `N_Slice`: 圆周方向分段数，值越大圆周方向越精细
- `Order`: 1=一阶（185单元），2=二阶（186单元），二阶精度更高但计算量更大

### 4. 旋转轴选择

- `Axis = 'x'`: 绕x轴旋转，适用于截面在yz平面
- `Axis = 'y'`: 绕y轴旋转，适用于截面在xz平面

### 5. 非完整旋转

当 `Degree != 360` 时：
- 起始面标记为 11
- 如果 `Degree == 180`，结束面标记为 12

## 与其他类的区别

| 特性 | Housing | Commonshaft | Commonplate |
|------|---------|-------------|-------------|
| 创建方式 | 截面轮廓旋转 | 长度/内外径 | 轮廓拉伸 |
| 适用场景 | 复杂截面旋转体 | 阶梯轴 | 平板 |
| 输入参数 | Outline（Line2D） | Length, ID, OD | Outline（Line2D）, Thickness |
| 旋转角度 | 可调（0-360°） | 360° | 不旋转 |

## 相关文件

- Housing 类定义: `+housing/@Housing/Housing.m`
- 输出实体模型: `+housing/@Housing/OutputSolidModel.m`
- 输出装配文件: `+housing/@Housing/OutputAss.m`
- STL导出: `+housing/@Housing/OutputSTL.m`
- 3D绘图: `+housing/@Housing/Plot3D.m`
- 面移动: `+housing/@Housing/MoveFace.m`

## 相关类

- `Point2D`: 创建点
- `Line2D`: 创建线段和轮廓
- `Surface2D`: 创建二维截面
- `Assembly`: 三维装配体
- `Mesh`: 网格对象

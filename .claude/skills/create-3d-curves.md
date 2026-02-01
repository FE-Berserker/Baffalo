# 创建 3D 曲线（3D Lines/Curves）

当用户要求创建 3D 曲线、三维线条、NURBS 曲线时，使用此技能。

**重要**: 如果用户只需要 2D 曲线（忽略 Z 坐标），应使用 `Line2D` 技能而不是 `Line`。

## 使用场景

当用户提出以下请求时触发此技能：
- "创建 3D 曲线"
- "添加三维线条"
- "创建 3D 圆/椭圆"
- "添加 NURBS 曲线"
- "生成 3D 几何曲线"

## 类概述

**类名**: `Line`
**作者**: Xie Yu
**继承**: `handle`
**用途**: 创建和管理 3D 几何曲线，使用 NURBS（Non-Uniform Rational B-Splines）表示
**位置**: `dep/framework/@Line/`

### 主要属性

| 属性 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| Name | 字符串 | - | Line 对象名称 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |
| Dtol | 数值 | 1e-5 | 距离容差 |
| Cell_Data | cell | {} | 单元数据（用于颜色映射） |
| Nurbs | cell | {} | NURBS 曲线数组 |
| Subd | cell | {} | 曲线细分数量 |
| MP | 矩阵 | - | 曲线中点（用于标签） |

## 使用前准备

### 1. 创建 Point3D 对象（存储点坐标）

```matlab
% 创建 Point3D 对象
Point = Point3D('MyPoints', 'Echo', 1, 'Dtol', 1e-5);

% 添加 3D 点
Point = AddPoint(Point, 0, 0, 0);      % 点1: (0,0,0)
Point = AddPoint(Point, 10, 0, 0);     % 点2: (10,0,0)
Point = AddPoint(Point, 10, 10, 5);    % 点3: (10,10,5)

% 批量添加点
x = [0, 5, 10, 15, 20];
y = [0, 0, 5, 5, 0];
z = [0, 5, 10, 5, 0];
Point = AddPoint(Point, x, y, z);

% 获取点组数量
npts = GetNpts(Point);
```

### 2. 创建 Line 对象

```matlab
% 创建 Line 对象
L3D = Line('My3DLines', ...
    'Echo', 1, ...      % 打印信息
    'Dtol', 1e-5);      % 距离容差
```

## 曲线类型详解

### 1. 直线 (AddLine)

```matlab
% 添加两个端点
Point = Point3D('LinePoints');
Point = AddPoint(Point, 0, 0, 0);      % 起点 (0,0,0)
Point = AddPoint(Point, 10, 5, 3);    % 终点 (10,5,3)

% 添加直线（使用点组1，包含2个点）
L3D = Line('MyLine');
L3D = AddLine(L3D, Point, 1);

% 绘制
Plot(L3D);
```

**数据格式**: `[x1, y1, z1, x2, y2, z2]` - 起点和终点坐标（6个值）

**要求**: 点组必须包含恰好 2 个点

---

### 2. 圆/圆弧 (AddCircle)

```matlab
% 添加圆心点
Point = Point3D('CircleCenter');
Point = AddPoint(Point, 5, 5, 0);  % 圆心在 (5,5,0)

% 添加完整圆
L3D = Line('MyCircle');
L3D = AddCircle(L3D, 3, Point, 1);  % 半径=3，使用点组1

% 添加半圆
L3D = AddCircle(L3D, 3, Point, 1, 'sang', 0, 'ang', 180);

% 添加1/4圆
L3D = AddCircle(L3D, 3, Point, 1, 'sang', 0, 'ang', 90);

% 添加指定段数的圆
L3D = AddCircle(L3D, 3, Point, 1, 'seg', 50);

% 旋转圆
L3D = AddCircle(L3D, 3, Point, 1, 'rot', [30, 45, 0]);  % 绕X旋转30°，Y旋转45°，Z旋转0°
```

**参数**:
- `radius`: 半径
- `sang`: 起始角度（度，默认0）
- `ang`: 扫描角度（度，默认360，逆时针为正）
- `seg`: 分段数（可选，默认根据角度自动计算）
- `rot`: 旋转角度 `[rx, ry, rz]`（度）

**注意**: 圆默认在 XY 平面上，可以通过 `rot` 参数旋转到任意方向

---

### 3. 椭圆 (AddEllipse)

```matlab
% 添加中心点
Point = Point3D('EllipseCenter');
Point = AddPoint(Point, 10, 5, 0);  % 中心在 (10,5,0)

% 添加椭圆（长半轴=8，短半轴=4）
L3D = Line('MyEllipse');
L3D = AddEllipse(L3D, 8, 4, Point, 1);

% 添加椭圆弧
L3D = AddEllipse(L3D, 8, 4, Point, 1, 'sang', 0, 'ang', 180);

% 旋转椭圆
L3D = AddEllipse(L3D, 8, 4, Point, 1, 'rot', [0, 30, 0]);  % 绕Y轴旋转30°
```

**参数**:
- `a`: 长半轴
- `b`: 短半轴
- `sang`: 起始角度（度，默认0）
- `ang`: 扫描角度（度，默认360）
- `seg`: 分段数（可选）
- `rot`: 旋转角度 `[rx, ry, rz]`（度）

**实现方式**: 通过缩放圆实现（scale factor = [1, b/a]）

---

### 4. 一般曲线 (AddCurve)

```matlab
% 添加多个控制点
Point = Point3D('CurvePoints');
Point = AddPoint(Point, 0, 0, 0);
Point = AddPoint(Point, 2, 1, 1);
Point = AddPoint(Point, 4, 0, 2);
Point = AddPoint(Point, 6, 1, 1);
Point = AddPoint(Point, 8, 0, 0);

% 添加曲线（通过所有点）
L3D = Line('MyCurve');
L3D = AddCurve(L3D, Point, 1);

% 或者批量添加点
x = [0, 2, 4, 6, 8, 10];
y = [0, 1, 0, 1, 0, 1];
z = [0, 1, 2, 1, 0, 1];
Point = AddPoint(Point, x, y, z);
L3D = AddCurve(L3D, Point, 1);
```

**数据格式**: `[x1, y1, z1; x2, y2, z2; ...]` - 多个点形成曲线

**节点向量**: 自动生成 `[0, 0:1/(n-1):1, 1]`

**分段数**: `Subd = 点数 - 1`

---

### 5. NURBS 曲线 (AddNurb)

```matlab
% 定义控制点 (4×n 矩阵，每列一个控制点)
% 格式: [x1, x2, ..., xn;
%        y1, y2, ..., yn;
%        z1, z2, ..., zn;
%        w1, w2, ..., wn]  - 包含权重
coefs = [0, 1, 2, 3, 4;
         0, 2, 1, 2, 0;
         0, 1, 3, 1, 0;
         1, 1, 1, 1, 1];  % 权重均为1

% 定义节点向量
knots = [0, 0, 0, 0.25, 0.5, 0.75, 1, 1, 1];

% 添加 NURBS 曲线
L3D = Line('MyNurb');
L3D = AddNurb(L3D, coefs, knots);

% 指定分段数
L3D = AddNurb(L3D, coefs, knots, 'seg', 100);
```

**参数**:
- `coefs`: 控制点矩阵 (3×n 或 4×n)，第4行为权重（可选）
- `knots`: 节点向量（单调递增，范围 [0, 1]）
- `seg`: 分段数（可选，默认 = 控制点数 × 8）

**NURBS 结构**: 每条曲线存储为结构体
- `Coefs`: 控制点（4D 齐次坐标）
- `Knots`: 节点向量
- `Order`: 阶数
- `Dim`: 维度

---

## 变换操作

### 1. 平移 (Move)

```matlab
% 平移第1条曲线
L3D = Move(L3D, 1, [10, 5, 3]);  % x平移10, y平移5, z平移3

% 平移并创建新曲线（不修改原曲线）
L3D = Move(L3D, 1, [10, 0, 0], 'new', 1);  % 创建新的副本
```

**参数**:
- `num`: 曲线编号
- `dis`: 位移向量 `[dx, dy, dz]`
- `new`: 是否创建新曲线（可选，默认0=替换原曲线）

---

### 2. 旋转 (Rotate)

```matlab
% 绕原点旋转第1条曲线
L3D = Rotate(L3D, 1, [30, 45, 0]);  % 绕X轴30°, Y轴45°, Z轴0°

% 绕指定点旋转
L3D = Rotate(L3D, 1, [90, 0, 0], 'ori', [5, 5, 5]);  % 绕点(5,5,5)旋转

% 旋转并创建新曲线
L3D = Rotate(L3D, 1, [45, 0, 0], 'new', 1);
```

**参数**:
- `num`: 曲线编号
- `rot`: 旋转角度 `[rx, ry, rz]`（度）
- `ori`: 旋转中心（可选，默认原点 [0,0,0]）
- `new`: 是否创建新曲线（可选，默认0）

**旋转顺序**: 先绕 X 轴，再绕 Y 轴，最后绕 Z 轴

---

### 3. 缩放 (Scale)

```matlab
% 绕原点缩放第1条曲线
L3D = Scale(L3D, 1, [2, 2, 2]);  % 各方向放大2倍

% 非均匀缩放
L3D = Scale(L3D, 1, [2, 1, 1]);  % X方向放大2倍，Y、Z不变

% 绕指定点缩放
L3D = Scale(L3D, 1, [0.5, 0.5, 0.5], 'ori', [5, 5, 5]);  % 绕(5,5,5)缩小一半

% 缩放并创建新曲线
L3D = Scale(L3D, 1, [1.5, 1.5, 1.5], 'new', 1);
```

**参数**:
- `num`: 曲线编号
- `factor`: 缩放因子 `[fx, fy, fz]`
- `ori`: 缩放中心（可选，默认原点 [0,0,0]）
- `new`: 是否创建新曲线（可选，默认0）

---

### 4. 插入节点 (InsertKnots)

```matlab
% 向第1条曲线插入新节点
L3D = InsertKnots(L3D, 1, [0.25, 0.5, 0.75]);
```

**用途**: 增加曲线的控制点数量，用于精细控制曲线形状

---

## 绘图与导出

### 1. MATLAB 绘图 (Plot)

```matlab
% 基本绘图
Plot(L3D);

% 显示网格
Plot(L3D, 'grid', 1);

% 使用等比例显示
Plot(L3D, 'equal', 1);  % 注意：Plot 方法内部自动等比例

% 使用颜色
Plot(L3D, 'color', 1);

% 指定颜色映射
Plot(L3D, 'map', 'lch');

% 设置坐标范围
Plot(L3D, 'xlim', [0, 10], 'ylim', [0, 10], 'zlim', [0, 5]);

% 只绘制特定曲线
Plot(L3D, 'crv', [1, 3, 5]);  % 绘制第1、3、5条曲线

% 显示曲线标签
Plot(L3D, 'clabel', 1);

% 显示控制点
Plot(L3D, 'coefs', 1);

% 指定细分段数
Plot(L3D, 'subd', [100, 50, 75]);  % 各曲线的细分段数

% 自定义样式
styles = {'-', '--', ':', '-.'};
Plot(L3D, 'styles', styles);
```

**Plot 参数**:

| 参数 | 类型 | 默认值 | 说明 |
|------|------|---------|------|
| `grid` | int | 0 | 是否显示网格 |
| `axe` | int | 1 | 是否显示坐标轴 |
| `clabel` | int | 0 | 是否显示曲线标签 |
| `equal` | int | 1 | 是否等比例显示 |
| `color` | int | 0 | 是否使用颜色：0=黑色，1=彩色 |
| `map` | string | 'lch' | 颜色映射类型 |
| `styles` | cell | [] | 线条样式（如{'-', '--', ':', '-.'}） |
| `crv` | vector | [] | 指定绘制的曲线索引 |
| `xlim` | [min, max] | [] | X轴范围 |
| `ylim` | [min, max] | [] | Y轴范围 |
| `zlim` | [min, max] | [] | Z轴范围 |
| `subd` | vector | [] | 各曲线的细分段数 |
| `coefs` | int | 0 | 是否显示控制点（0=否，1=是） |
| `base_size` | double | 1.5 | 图形元素基础大小 |

---

### 2. ParaView 显示 (Plot2)

```matlab
% 导出 VTK 文件并在 ParaView 中打开
Plot2(L3D);
```

**要求**: 需要在项目目录下有 `ParaViewPath.txt` 文件，包含 ParaView 的安装路径

---

### 3. VTK 导出 (VTKWrite)

```matlab
% 导出为 VTK 文件
VTKWrite(L3D);
% 文件名: <Name>.vtk
```

**输出格式**:
- `POINTS`: 所有曲线的离散点坐标
- `CELLS`: 各曲线的点索引
- `CELL_TYPES`: 4（PolyLine）
- `CELL_DATA`: 单元数据（如果有）

---

## 输出数据

### 获取离散点 (OutputPoint)

```matlab
% 获取所有曲线的离散点
PP = OutputPoint(L3D);  % cell 数组，每个元素是一条曲线的点矩阵

% 压缩重复点
PP = OutputPoint(L3D, 'Compress', 1);

% 访问第一条曲线的点
points1 = PP{1};  % N×3 矩阵
```

**返回格式**: cell 数组，每个元素是一个 N×3 矩阵（每行一个点的 x,y,z 坐标）

---

### 获取曲线数量 (GetNcrv)

```matlab
% 获取曲线总数
n = GetNcrv(L3D);
fprintf('Total curves: %d\n', n);
```

---

### 获取曲线中点 (MP)

```matlab
% 曲线中点用于标签位置
midpoint = L3D.MP(1, :);  % 第1条曲线的中点 [x, y, z]
```

---

## 完整示例

### 示例1：基本 3D 直线

```matlab
% 创建点对象
Point = Point3D('LinePoints');

% 添加直线端点
Point = AddPoint(Point, 0, 0, 0);
Point = AddPoint(Point, 10, 5, 3);

% 创建 Line 对象
L3D = Line('My3DLine', 'Echo', 1);

% 添加直线
L3D = AddLine(L3D, Point, 1);

% 绘制
Plot(L3D, 'grid', 1);
```

---

### 示例2：3D 空间中的圆

```matlab
% 创建点对象
Point = Point3D('CircleCenter');
Point = AddPoint(Point, 5, 5, 0);

% 创建 Line 对象
L3D = Line('3DCircles', 'Echo', 1);

% 添加XY平面圆
L3D = AddCircle(L3D, 3, Point, 1);

% 添加旋转圆（垂直）
L3D = AddCircle(L3D, 3, Point, 1, 'rot', [90, 0, 0]);

% 添加半圆
L3D = AddCircle(L3D, 3, Point, 1, 'sang', 0, 'ang', 180, 'rot', [0, 45, 0]);

% 绘制
Plot(L3D, 'grid', 1, 'clabel', 1, 'color', 1);
```

---

### 示例3：螺旋线

```matlab
% 创建点对象
Point = Point3D('HelixPoints');

% 生成螺旋线点
theta = linspace(0, 4*pi, 100);  % 2圈
x = 5 * cos(theta);
y = 5 * sin(theta);
z = linspace(0, 10, 100);
Point = AddPoint(Point, x, y, z);

% 创建 Line 对象
L3D = Line('Helix', 'Echo', 1);

% 添加曲线
L3D = AddCurve(L3D, Point, 1);

% 绘制
Plot(L3D, 'grid', 1);
```

---

### 示例4：椭圆

```matlab
% 创建点对象
Point = Point3D('EllipseCenter');
Point = AddPoint(Point, 0, 0, 0);

% 创建 Line 对象
L3D = Line('Ellipses', 'Echo', 1);

% 添加水平椭圆
L3D = AddEllipse(L3D, 10, 5, Point, 1);

% 添加旋转椭圆
L3D = AddEllipse(L3D, 8, 4, Point, 1, 'rot', [0, 30, 0]);

% 添加椭圆弧
L3D = AddEllipse(L3D, 6, 3, Point, 1, 'sang', 0, 'ang', 180);

% 绘制
Plot(L3D, 'grid', 1, 'equal', 1, 'clabel', 1, 'color', 1);
```

---

### 示例5：NURBS 曲线

```matlab
% 创建 Line 对象
L3D = Line('NurbsCurve', 'Echo', 1);

% 定义控制点（4D 齐次坐标，最后一行为权重）
coefs = [0,  1,  2,  3,  4;
         0,  2,  1,  2,  0;
         0,  1,  3,  1,  0;
         1,  1,  1,  1,  1];  % 均匀权重

% 定义节点向量
knots = [0, 0, 0, 0, 0.25, 0.5, 0.75, 1, 1, 1, 1];

% 添加 NURBS 曲线
L3D = AddNurb(L3D, coefs, knots, 'seg', 100);

% 绘制（包含控制点）
Plot(L3D, 'grid', 1, 'coefs', 1);
```

---

### 示例6：变换操作

```matlab
% 创建点对象
Point = Point3D('TransformPoints');
Point = AddPoint(Point, 0, 0, 0);
Point = AddPoint(Point, 5, 0, 0);

% 创建 Line 对象
L3D = Line('TransformTest', 'Echo', 1);

% 添加原始直线
L3D = AddLine(L3D, Point, 1);

% 平移
L3D = Move(L3D, 1, [5, 0, 0]);

% 旋转
L3D = Rotate(L3D, 2, [0, 0, 90]);  % 绕Z轴旋转90度

% 缩放
L3D = Scale(L3D, 3, [1.5, 1.5, 1.5]);

% 绘制
Plot(L3D, 'grid', 1, 'clabel', 1, 'color', 1);
```

---

### 示例7：组合曲线

```matlab
% 创建点对象
Point = Point3D('ComboPoints');

% 点组1：直线
Point = AddPoint(Point, 0, 0, 0);
Point = AddPoint(Point, 10, 0, 0);

% 点组2：半圆圆心
Point = AddPoint(Point, 10, 0, 0);

% 点组3：另一半圆圆心
Point = AddPoint(Point, 0, 0, 0);

% 创建 Line 对象
L3D = Line('3DTrack', 'Echo', 1);

% 添加直线
L3D = AddLine(L3D, Point, 1);

% 添加上半圆
L3D = AddCircle(L3D, 5, Point, 2, 'sang', 0, 'ang', 180);

% 添加下半圆
L3D = AddCircle(L3D, 5, Point, 3, 'sang', 180, 'ang', 180);

% 绘制
Plot(L3D, 'grid', 1, 'equal', 1, 'clabel', 1, 'color', 1);
```

---

## NURBS 技术细节

### NURBS 结构

每条曲线存储在 `Nurbs{index,1}` 中：

```matlab
nrb = obj.Nurbs{i,1};
% nrb.coefs  - 控制点 (4×n 齐次坐标)
% nrb.knots  - 节点向量
% nrb.order  - 阶数
% nrb.dim    - 维度
```

### 私有辅助函数

| 函数 | 功能 |
|------|------|
| `nrbmak(coefs, knots)` | 构建 NURBS 结构 |
| `nrbeval(nurbs, t)` | 计算 NURBS 在参数 t 处的值 |
| `nrbcirc(radius, center, sang, eang)` | 构建圆弧 NURBS |
| `nrbtform(nurbs, T)` | NURBS 变换 |
| `nrbkntins(nurbs, knots)` | 插入节点 |
| `findspan(u, n, p, U)` | 查找节点跨度 |
| `vectrans(v)` | 平移变换矩阵 |
| `vecrotx(theta)` | 绕 X 轴旋转矩阵 |
| `vecroty(theta)` | 绕 Y 轴旋转矩阵 |
| `vecrotz(theta)` | 绕 Z 轴旋转矩阵 |
| `vecscale(s)` | 缩放变换矩阵 |

---

## 常见问题

### Q: 如何设置曲线颜色？

```matlab
% 设置单元数据（用于颜色映射）
L3D.Cell_Data = [1.2, 3.4, 2.1, 4.5];  % 每条曲线一个值
Plot(L3D, 'color', 1);  % 使用颜色映射
```

### Q: 如何获取曲线的控制点？

```matlab
coefs = L3D.Nurbs{1,1}.Coefs;  % 第1条曲线的控制点
% coefs 是 4×n 矩阵（齐次坐标）
```

### Q: 如何修改曲线的分段数？

```matlab
% 直接修改 Subd 属性
L3D.Subd{1,1} = 100;  % 第1条曲线的分段数
```

### Q: 如何在 ParaView 中查看？

```matlab
% 方法1：自动打开 ParaView
Plot2(L3D);

% 方法2：仅导出 VTK 文件
VTKWrite(L3D);
```

---

## 与 Line2D 的区别

| 特性 | Line2D | Line (3D) |
|------|--------|-----------|
| 坐标维度 | 2D (x, y) | 3D (x, y, z) |
| 曲线类型 | 多种（LINE, CIRCLE, ELLIPSE, BEZIER, BSPLINE, NURB等） | NURBS（统一表示） |
| Point 类 | Point2D | Point3D |
| 变换 | Shift | Move, Rotate, Scale |
| 绘图 | 2D Plot | 3D Plot |
| 导出 | VTK | VTK + ParaView |
| 箭头支持 | 有 | 无 |

**建议**: 对于 3D 场景，使用 `Line` 类；对于 2D 场景，使用 `Line2D` 类。

---

## 文件位置

| 文件 | 路径 |
|------|------|
| Line 类定义 | `dep/framework/@Line/Line.m` |
| AddLine | `dep/framework/@Line/AddLine.m` |
| AddCircle | `dep/framework/@Line/AddCircle.m` |
| AddEllipse | `dep/framework/@Line/AddEllipse.m` |
| AddCurve | `dep/framework/@Line/AddCurve.m` |
| AddNurb | `dep/framework/@Line/AddNurb.m` |
| Move | `dep/framework/@Line/Move.m` |
| Rotate | `dep/framework/@Line/Rotate.m` |
| Scale | `dep/framework/@Line/Scale.m` |
| InsertKnots | `dep/framework/@Line/InsertKnots.m` |
| Plot | `dep/framework/@Line/Plot.m` |
| Plot2 | `dep/framework/@Line/Plot2.m` |
| VTKWrite | `dep/framework/@Line/VTKWrite.m` |
| OutputPoint | `dep/framework/@Line/OutputPoint.m` |
| GetNcrv | `dep/framework/@Line/GetNcrv.m` |
| 私有函数 | `dep/framework/@Line/private/*.m` |

# 生成 3D 点 (Point3D)

当用户要求生成 3D 点、添加三维坐标、创建 Point3D 对象时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "生成3D点"
- "添加三维点"
- "创建 Point3D 对象"
- "批量添加点坐标"
- "生成点云数据"
- "使用 Point 类添加点"
- "添加 (x, y, z) 坐标"

**注意**: 如果用户只需要 2D 点（忽略 Z 坐标），应使用 `Point2D` 技能而不是此技能。

## 类概述

**类名**: `Point3D`
**作者**: Xie Yu
**继承**: `handle`
**用途**: 创建和管理三维点对象，支持批量添加点坐标、向量、法线计算、数据压缩和 VTK 导出

### 与 Point2D 的区别

| 特性 | Point2D | Point3D |
|------|--------|--------|
| 坐标维度 | N×2 | N×3 |
| 批量添加 | AddPoint(x,y) 不支持 | AddPoint(x,y,z) 支持数组 |
| 数据属性 | 无 Point_Data, Point_Vector | 有 Point_Data, Point_Vector |
| 法线支持 | 无 | 有 Normal, NormNormal |
| 法线归一化 | 无 | 有 NormalizeNormals |

**建议**: 对于简单的 2D 场景，使用 `Point2D` 类更合适。对于需要 3D 点云或法线的场景，使用 Point3D 类。

## 类结构

### 主要属性

| 属性 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| Name | 字符串 | - | Point3D 对象名称 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |
| Dtol | 数值 | 1e-5 | 距离容差 |
| P | 矩阵 | [] | 所有点的坐标矩阵（N×3，每行一个点的 x,y,z 坐标） |
| PP | cell 数组 | {} | 点组 cell 数组，存储每次 AddPoint 调用添加的点 |
| NG | 整数 | 0 | 点组数量 |
| NP | 整数 | 0 | 点的总数 |
| n | 整数 | - | 点的数量 |
| Point_Data | - | - | 点数据 |
| Point_Vector | - | - | 点向量 |
| Roughness | 数值 | 1 | 粗糙度 |
| Normal | 矩阵 | - | 法线矩阵 |
| NormNormal | 矩阵 | - | 归一化法线矩阵 |

## 基本用法

### 1. 创建 Point3D 对象

```matlab
a = Point3D('MyPoints', 'Dtol', 1e-5, 'Echo', 1);
```

**参数说明**:
- 第一个参数 `Name` 是对象名称（必需）
- `Dtol`: 距离容差，默认 1e-5
- `Echo`: 控制是否打印调试信息，默认 1

### 2. 添加单个 3D 点

```matlab
% 方法1：使用 AddPoint 函数
a = Point3D('MyPoints');
a = AddPoint(a, 10, 20, 30);  % 添加点 (10, 20, 30)
```

### 3. 批量添加多个 3D 点

**推荐方式**：使用数组输入（性能最优）

```matlab
% 创建 Point3D 对象
a = Point3D('MyPoints');

% 生成点坐标（x, y, z 数组）
x = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120];
y = [15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115];
z = zeros(length(x), 1);  % 如果只需要 2D，z 保持为 0

% 批量添加所有点
a = AddPoint(a, x, y, z);
```

**关键特点**：
- `AddPoint(x, y, z)` 的三个参数都是数组
- 每次添加一个点（每个 x[i], y[i], z[i]）
- 创建多个点组（每个点组 3×1 矩阵）

### 4. 使用 Delta 模式添加连续点

```matlab
% Delta 模式：创建连续递增的点
a = Point3D('SequentialPoints');

x = 0:10:20;  % x 从 0 开始，每次增加 10
y = zeros(size(x), 1);
z = zeros(size(x), 1);

% 使用 delta 参数
for i = 1:10
    a = AddPoint(a, x(i), y(i), z(i));
end
```

### 5. 使用极坐标（球面分布）

```matlab
% 创建 Point3D 对象
a = Point3D('SpherePoints');

% 生成球面点（半径 R = 200）
R = 200;
theta = linspace(0, 2*pi, 10);  % 极角从 0 到 2π
phi = linspace(0, pi, 10);    % 纬角从 0 到 π

for i = 1:10
    for j = 1:10
        % 球面点（R*sin(phi), R*cos(phi)）
        x = R * sin(phi(i));
        y = R * cos(phi(i));
        z = R * sin(phi(j));

        a = AddPoint(a, x, y, z);
    end
end
```

### 6. 添加点向量（用于箭头等）

```matlab
a = Point3D('PointsWithVectors');

% 基点
basePoints = [0, 0, 0];
baseY = [0, 20, 0];
baseZ = [0, 0, 0];

for i = 1:5
    % 计算向量方向
    vecX = [cos(i*pi/6); 0; sin(i*pi/6)];
    vecY = [sin(i*pi/6); cos(i*pi/6)];
    vecZ = zeros(2, 1);

    % 添加基点和向量
    a = AddPoint(a, baseX, baseY, baseZ);

    % 添加向量点
    for j = 1:2
        a = AddPoint(a, baseX(j), baseY(j), baseZ(j));
    end
end
```

**注意**: 需要 Point_Vector 属性来存储向量数据

### 7. 获取点数据和统计

```matlab
a = Point3D('MyPoints');
x = rand(100, 1) * 100;
y = rand(100, 1) * 100;
z = rand(100, 1) * 10;
a = AddPoint(a, x, y, z);

% 统计信息
fprintf('Total points: %d\n', a.n);
fprintf('Total groups: %d\n', a.NG);
```

## 常见使用场景

### 场景1：生成随机散点

```matlab
a = Point3D('RandomCloud');
a = AddPoint(a, rand(100, 1), rand(100, 1), rand(10, 1));
```

**适用**：
- 点云数据生成
- 随机分布点
- 适合 Monte Carlo 模拟

---

### 场景2：生成网格点

```matlab
a = Point3D('GridPoints');

% 定义网格范围
xRange = [-100, 100];
yRange = [-100, 100];
zRange = 10;

% 生成网格点
[xx, yy, zz] = meshgrid(xRange, yRange, zRange);

a = AddPoint(a, xx, yy, zz);
```

**适用**：
- 规则点阵
- 体积数据采样
- 网格优化点阵

---

### 场景3：创建曲线上的点

```matlab
a = Point3D('CurvePoints');

% 创建螺旋曲线点
t = linspace(0, 2*pi, 100);
radius = 50;
pitch = 20;  % 螺距

for i = 1:100
    x = radius * cos(t(i));
    y = radius * sin(t(i));
    z = pitch * t(i) / (2*pi);  % 垂直上升

    a = AddPoint(a, x, y, z);
end
```

**适用**：
- 螺旋点云
- 弹簧建模

---

### 场景4：生成立方体表面点

```matlab
a = Point3D('CubeSurface');

% 立方体尺寸
L = 100;

% 六个面
faces = [
    [0, 0, 0;     % 前面 (Z=0)
    [L, 0, 0;    % 后面 (Z=L)
    [0, L, 0;    % 右面 (X=L)
    [0, 0, L;    % 顶面 (Y=L)
    [0, 0, 0];    % 底面 (Z=-L)
];

for i = 1:size(faces, 1)
    x = faces{i}(:, 1);
    y = faces{i}(:, 2);
    z = faces{i}(:, 3);

    a = AddPoint(a, x, y, z);
end
```

**适用**：
- 表面重建
- 3D 扫描数据生成

---

### 场景5：使用 GetPoint 访问特定点

```matlab
a = Point3D('SelectedPoints');

% 先添加基准点
a = AddPoint(a, 0, 0, 0);

% 添加 10 个目标点
for i = 1:10
    targetX = 50 * cosd(2*pi*i/10);
    targetY = 50 * sind(2*pi*i/10);
    a = AddPoint(a, targetX, targetY, 0);
end
```

---

### 场景6：数据导入导出

#### 从数组导入点

```matlab
% 假设数据
pointData = [
    10, 20, 30, 40, 50;
    15, 25, 35, 45, 55, 65, 75, 85, 95, 105
];

a = Point3D('ImportedPoints');
a = AddPoint(a, pointData(:, 1), pointData(:, 2), zeros(size(pointData, 1));
```

#### 导出到 VTK 文件

```matlab
% 创建 Point3D 对象
a = Point3D('ExportPoints');
a = AddPoint(a, ...);  % 添加所有点

% 导出（使用内置的 VTKWrite 方法）
% 注意：Point3D 类支持 VTK 导出功能
```

## 高级功能

### 1. 点组管理

```matlab
% 获取点统计
fprintf('Total points: %d\n', a.n);
fprintf('Total groups: %d\n', a.NG);
fprintf('Point group count: %d\n', size(a.PP, 1));

% 遍历所有点组
for i = 1:a.NG
    p = GetPoint(a, i);  % 获取第 i 个点组（3×1 矩阵）
    fprintf('Group %d size: %d×1\n', i, size(p, 1));
end
```

### 2. 点数据提取

```matlab
% 提取所有点坐标
allPoints = a.P;  % N×3 矩阵
for i = 1:size(allPoints, 1)
    fprintf('Point %d: (%8.2f, %8.2f, %8.2f)\n', i, allPoints(i, :));
end
```

### 3. 绘制选项

```matlab
figure('Position', [100, 100, 800, 600]);
Plot(a, 'grid', 1);
title('3D Points');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;

% 使用法线绘制
if ~isempty(a.Normal)
    Plot(a, 'Normal', 1, 'VectorScale', 1);  % 显示法线向量
    quiver3(allPoints(:, 1), allPoints(:, 2), allPoints(:, 3));
end
```

## 注意事项

### 1. 坐标维度

Point3D 的 AddPoint 函数支持 (x, y, z) 三个数组：
- 数组长度必须相同
- 每次调用添加一个点

### 2. 点组机制

- 每次 AddPoint 调用创建一个点组
- 点组存储在 `PP` cell 数组中
- 使用 `GetNgpts(obj)` 获取点组总数
- 使用 `GetPoint(obj, id)` 访问特定点组

### 3. 内存管理

对于大量点（数万以上）：
- 考虑分批添加
- 使用 Clear 方法（如果存在）清空现有数据
- 监控 `size(obj.P)` 避免内存溢出

### 4. 与 Point2D 的区别

| 特性 | Point2D | Point3D |
|------|--------|--------|
| 坐标维度 | 2D (N×2) | 3D (N×3) |
| 适用场景 | 平面绘图 | 三维可视化、点云 |
| 法线计算 | 无 | 有 Normal, NormNormal |
| 向量数据 | 无 | 有 Point_Vector |
| VTK 导出 | 无 | 有 VTKWrite |
| 批量添加 | AddPoint(x,y) 不支持 | AddPoint(x,y,z) 支持数组 |

## 相关文件

- Point3D 类定义: `dep/framework/@Point/Point.m`
- AddPoint: `dep/framework/@Point/AddPoint.m`
- GetNpts: `dep/framework/@Point/GetNpts.m`
- DeletePoint: `dep/framework/@Point/DeletePoint.m`
- Dist: `dep/framework/@Point/Dist.m`
- Plot: `dep/framework/@Point/Plot.m`
- AddPointVector: `dep/framework/@Point/AddPointVector.m`
- AddPointData: `dep/framework/@Point/AddPointData.m`
- CalNormals: `dep/framework/@Point/CalNormals.m`
- NormalizeNormals: `dep/framework/@Point/NormalizeNormals.m`
- VTKWrite: `dep/framework/@Point/VTKWrite.m`

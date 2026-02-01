# 生成 2D 点 (Point2D)

当用户要求生成 2D 点、添加点坐标、创建 Point2D 对象时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "生成2D点"
- "添加点到 Point2D"
- "创建 Point2D 对象"
- "使用 Point2D 类添加点"
- "添加点坐标 (x, y)"
- "批量添加点"

## 类概述

**类名**: `Point2D`
**作者**: Xie Yu
**用途**: 创建和管理 2D 点对象，支持点的添加、删除、距离计算、绘制等操作

## 类结构

### 属性

| 属性 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| Name | 字符串 | - | Point2D 对象名称 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |
| Dtol | 数值 | 1e-5 | 距离容差（用于距离比较和合并点） |
| P | 矩阵 | [] | 所有点的坐标矩阵（N×2，每行一个点的 x,y 坐标） |
| PP | cell 数组 | {} | 点组 cell 数组，存储每次 AddPoint 调用添加的点 |
| NG | 整数 | 0 | 点组数量 |
| NP | 整数 | 0 | 点的总数 |
| Point_Data | - | - | 点数据 |
| Point_Vector | - | - | 点向量 |

## 基本用法

### 1. 创建 Point2D 对象

```matlab
a = Point2D('MyPoints', 'Dtol', 1e-5, 'Echo', 1);
```

**参数说明**:
- 第一个参数 `Name` 是对象名称（必需）
- `Dtol`: 距离容差，默认 1e-5
- `Echo`: 控制是否打印调试信息，默认 1

### 2. 添加单个点

```matlab
% 方法1：使用 AddPoint 函数（推荐）
a = Point2D('MyPoints');
a = AddPoint(a, 10, 20);  % 添加点 (10, 20)

% 方法2：直接访问 P 属性（不推荐）
a = Point2D('MyPoints');
a.P = [10, 20];  % 直接添加到矩阵
```

### 3. 添加多个点

#### 方式1：逐个添加

```matlab
a = Point2D('MyPoints');
a = AddPoint(a, 10, 20);
a = AddPoint(a, 30, 40);
a = AddPoint(a, 50, 60);
```

**注意**：每次 `AddPoint` 调用创建一个点组（在 PP cell 数组中），可以使用 `GetPoint` 函数访问：

```matlab
% 获取第1个点组
p = GetPoint(a, 1);

% 获取第2个点组
p = GetPoint(a, 2);
```

#### 方式2：批量添加（数组输入）

```matlab
a = Point2D('MyPoints');
x = [10, 30, 50];
y = [20, 40, 60];
a = AddPoint(a, x, y);
```

**重要**：`x` 和 `y` 的元素数量必须相同（都是 n 个元素），否则会报错：
```
The number of x and y is not match!
```

#### 方式3：添加点对（用于配合 AddLine 使用）

Point2D 的点需要成对组织，每对点形成一条线段。这是与 `Line2D.AddLine` 配合的关键：

```matlab
points = Point2D('RectanglePoints');

% 添加第一对：点1 -> 点2
points = AddPoint(points, [x1, x2], [y1, y2]);

% 添加第二对：点3 -> 点4
points = AddPoint(points, [x3, x4], [y3, y4]);

% 添加第三对：点5 -> 点6
points = AddPoint(points, [x5, x6], [y5, y6]);
```

**关键理解**：
- `x` 和 `y` 必须是**列向量**（n×1），不是行向量
- 每次 `AddPoint` 添加 2×2 矩阵（2个点）
- 这样 `Point2D.PP{index, 1}` 就是 2×2 矩阵，符合 `AddLine` 的要求

### 4. 使用极坐标

```matlab
a = Point2D('MyPoints');

% 添加极坐标点
a = AddPoint(a, 100, 0, 'polar', 'deg');  % 距离100mm，角度0°
a = AddPoint(a, 100, 45, 'polar', 'deg');   % 距离100mm，角度45°
a = AddPoint(a, 100, 90, 'polar', 'deg');   % 距离100mm，角度90°
```

**参数**:
- `'polar', 'rad'`: 使用弧度
- `'polar', 'deg'`: 使用度数

### 5. 添加点数据

```matlab
a = Point2D('MyPoints');
data = [10, 20; 30, 40; 50, 60];  % 数据矩阵
a = AddPointData(a, data);  % 使用 AddPointData 函数
```

### 6. 添加点向量

```matlab
a = Point2D('MyPoints');

% 添加点
a = AddPoint(a, 10, 20);

% 添加向量
u = [20-10, 0];      % u 方向向量
v = [0, 30-20];      % v 方向向量
a = AddPointVector(a, [u; v]);  % 批量添加
```

### 7. 计算点间距离

```matlab
a = Point2D('MyPoints');
a = AddPoint(a, 10, 20);
a = AddPoint(a, 30, 40);

% 计算两点间距离
dist = Dist(a, 1, 2);  % 点组索引，group=1 不分组
disp(['Distance: ' num2str(dist)]);

% 使用距离阈值
if dist < threshold
    % 执行某些操作
end
```

**Dist 函数参数**:
```matlab
dist = Dist(obj, pointIndex1, pointIndex2, varargin);
```

**varargin 参数**:
- `'group', 1`: 将距离分组显示（0=不分组，1=分组）
- 返回值：点间距离

### 8. 绘制点

```matlab
a = Point2D('MyPoints');
a = AddPoint(a, 10, 20);
a = AddPoint(a, 30, 40);

% 绘制点（带网格）
Plot(a, 'grid', 1);  % grid 参数启用网格

% 绘制点（带标签）
a = AddPoint(a, 50, 60);
Plot(a, 'grid', 1, 'plabel', 1);  % plabel 显示点的索引

% 绘制多个点
a = AddPoint(a, 10, 20);
a = AddPoint(a, 30, 40);
a = AddPoint(a, 50, 60);
Plot(a, 'grid', 1);  % 自动分配不同标签给每个点
```

**Plot 函数参数**:
- `'grid', 1`: 显示网格
- `'plabel', 1`: 显示点的索引标签

### 9. 删除点

```matlab
a = Point2D('MyPoints');
a = AddPoint(a, 10, 20);
a = AddPoint(a, 30, 40);

% 删除指定点（使用函数索引）
a = DeletePoint(a, 1);  % 删除第1个点组

% 删除点（使用函数句柄）
a = DeletePoint(a, 1, 'fun', @(p)(p(:,1)+1));  % 删除满足条件的点
```

**DeletePoint 函数**:
```matlab
a = DeletePoint(obj, pointIndex);
a = DeletePoint(obj, pointIndex, 'fun', handle);
```

**参数**:
- `pointIndex`: 点组索引
- `'fun', handle`: 函数句柄，用于删除满足条件的点
- 返回：删除后的 Point2D 对象

### 10. 压缩点

```matlab
a = Point2D('MyPoints');
a = AddPoint(a, 10, 20);
a = AddPoint(a, 30, 40);
a = AddPoint(a, 50, 60);

% 压缩点（合并接近的点）
a = CompressNpts(a, 'all');  % 'all' 压缩所有点
```

**CompressNpts 函数**:
```matlab
a = CompressNpts(obj, type);
```

**type 参数**:
- `'all'`: 压缩所有点
- `'unique'`: 只保留唯一点
- `'reduced'`: 减少冗余点

## 常见使用场景

### 场景1：创建简单的点集

```matlab
% 创建 Point2D 对象
a = Point2D('MyPoints');

% 添加多个点
a = AddPoint(a, [10, 20; 30, 40; 50, 60]);

% 绘制
Plot(a, 'grid', 1);

% 获取点数据
disp(['Total points: ' num2str(a.NP)]);
```

---

### 场景2：创建带标签的点集

```matlab
% 创建 Point2D 对象
a = Point2D('MyPoints', 'Echo', 1);

% 添加点（每个点有标签）
x = [10, 30, 50, 70];
y = [20, 40, 60, 80];
labels = ['A'; 'B'; 'C'; 'D'];

% 添加点
a = AddPoint(a, x, y);

% 绘制带标签
Plot(a, 'grid', 1, 'plabel', 1);

% 输出点数据
disp(['Points added: ' num2str(length(labels))]);
```

---

### 场景3：从数组批量添加点

```matlab
% 从现有数据添加点
xData = [10, 20, 30, 40, 50];
yData = [15, 25, 35, 45, 55];

% 创建 Point2D 并批量添加
a = Point2D('MyPoints');
a = AddPoint(a, xData, yData);

% 验证
fprintf('Added %d points from arrays\n', length(xData));
```

---

### 场景4：创建点对（用于直线）

```matlab
% 创建 Point2D 对象，用于与 Line2D 配合
points = Point2D('LinePoints');

% 添加点对（列向量格式）
% 点对1: (0,0) -> (10,0)
points = AddPoint(points, [0, 10], [0, 0]);

% 点对2: (10,0) -> (20,10)
points = AddPoint(points, [10, 20], [10, 10]);

% 点对3: (20,10) -> (20,0)
points = AddPoint(points, [20, 20], [20, 0]);

% 点对4: (20,0) -> (0,0)
points = AddPoint(points, [0, 20], [0, 0]);

% 用于 Line2D.AddLine
line = Line2D('MyLine');
line = AddLine(line, points, 1);  % 使用第1个点对
line = AddLine(line, points, 2);  % 使用第2个点对
```

**关键点**：
- `x` 和 `y` 必须是**列向量** `[x1; x2]` 和 `[y1; y2]`
- 每次 `AddPoint` 添加 2×2 矩阵（2个点）
- 这样 `points.PP{index, 1}` 就是 2×2 格式，符合 AddLine 要求

---

### 场景5：查找最近点

```matlab
% 创建点集
a = Point2D('SearchPoints');
a = AddPoint(a, 0, 0);
a = AddPoint(a, 10, 20);
a = AddPoint(a, 20, 30);
a = AddPoint(a, 30, 40);
a = AddPoint(a, 50, 60);

% 目标点
targetX = 25;
targetY = 35;
a = AddPoint(a, targetX, targetY);

% 计算到所有点的距离
distances = zeros(a.NG - 1, 1);
for i = 1:(a.NG - 1)
    dist = Dist(a, i, a.NG);
    distances(i) = dist;
end

% 找到最近的点
[~, minIdx] = min(distances);
nearestPoint = GetPoint(a, minIdx);

fprintf('Nearest point is at (%.2f, %.2f) with distance %.2f\n', ...
    GetPoint(a, minIdx)(:,1), GetPoint(a, minIdx)(:,2), min(distances));
```

---

### 场景6：极坐标网格

```matlab
% 创建极坐标网格
a = Point2D('PolarGrid');
angles = 0:15:360;
radii = [10, 20, 30, 40, 50, 60];

for r = radii
    for ang = angles
        x = r * cosd(ang);
        y = r * sind(ang);
        a = AddPoint(a, x, y);
    end
end

Plot(a, 'grid', 1);
fprintf('Created polar grid with %d points\n', a.NP);
```

---

### 场景7：从文件导入点

```matlab
% 假设数据文件格式
% 每行：x, y
data = load('points.txt');  % 返回 N×2 矩阵

% 创建 Point2D 并添加所有点
a = Point2D('ImportedPoints');
x = data(:, 1);
y = data(:, 2);
a = AddPoint(a, x, y);

fprintf('Imported %d points from file\n', size(data, 1));
```

---

### 场景8：导出点数据

```matlab
% 创建 Point2D 对象
a = Point2D('ExportPoints');
a = AddPoint(a, [10, 20; 30, 40; 50, 60]);

% 访问点坐标
points = a.P;  % N×2 矩阵

% 导出到 CSV 文件
writematrix(points, 'points.csv', 'delimiter', ',');

fprintf('Exported %d points to points.csv\n', size(points, 1));
```

## 常见错误及解决方法

### 错误1：x 和 y 元素数量不匹配

**错误信息**:
```
The number of x and y is not match!
```

**原因**：`x` 和 `y` 的元素数量不同

**解决方法**：
```matlab
% 错误示例
x = [10, 20, 30];      % 3个元素
y = [20, 40];           % 2个元素

% 正确示例
x = [10, 20, 30];      % 3个元素
y = [20, 40, 30];      % 3个元素
```

---

### 错误2：点对格式不正确

**错误信息**（在配合 AddLine 时）：
```
The Line only contains 2 points
```

**原因**：AddLine 期望 `Point2D.PP{index, 1}` 是 2×2 矩阵，但实际传入的是 1×4 或其他格式

**解决方法**：
确保使用列向量格式：
```matlab
% 错误示例
points = AddPoint(points, [x1, x2], [y1, y2]);  % 1×4 矩阵

% 正确示例
points = AddPoint(points, [x1, x2], [y1; y2]);  % 2×2 矩阵
points = AddPoint(points, [x1; x2], [y1; y2]);  % 第2个点对

% 或者
x = [x1; x2];
y = [y1; y2];
points = AddPoint(points, x, y);
```

---

### 错误3：点索引超出范围

**错误信息**：
```
Index in position 1 exceeds array bounds (must not exceed 1)
```

**原因**：使用 GetPoint 或 DeletePoint 时索引超出了点组数量

**解决方法**：
```matlab
% 检查点组数量
totalGroups = size(obj.PP, 1);
if index > totalGroups
    error(['Point index ' num2str(index) ' exceeds available groups (' num2str(totalGroups) ')']);
end
```

## 最佳实践

### 1. 使用有意义的命名

```matlab
% 推荐
a = Point2D('GridPoints', 'Echo', 1);
a = Point2D('HoleCenters', 'Echo', 1);
a = Point2D('CornerPoints', 'Echo', 1);
```

### 2. 适当设置 Dtol

```matlab
% 对于精度要求高的场景
a = Point2D('HighPrecisionPoints', 'Dtol', 1e-6);
a = Point2D('LowPrecisionPoints', 'Dtol', 1e-3);
```

### 3. 合理使用 Echo 参数

```matlab
% 开发时保持 Echo=1
% 生产环境设置 Echo=0 减少输出
a = Point2D('ProductionPoints', 'Echo', 0);
```

### 4. 分离不同功能的点对象

```matlab
% 外轮廓点
outlinePoints = Point2D('OutlinePoints');
outlinePoints = AddPoint(outlinePoints, x1, y1);
outlinePoints = AddPoint(outlinePoints, x2, y2);

% 孔中心点
holeCenters = Point2D('HoleCenters');
for i = 1:numHoles
    holeCenters = AddPoint(holeCenters, hx(i), hy(i));
end
```

## 相关文件

- Point2D 类定义: `dep/framework/@Point2D/Point2D.m`
- AddPoint 函数: `dep/framework/@Point2D/AddPoint.m`
- GetPoint 函数: `dep/framework/@Point2D/GetPoint.m`
- DeletePoint 函数: `dep/framework/@Point2D/DeletePoint.m`
- Dist 函数: `dep/framework/@Point2D/Dist.m`
- Plot 函数: `dep/framework/@Point2D/Plot.m`
- AddPointData 函数: `dep/framework/@Point2D/AddPointData.m`
- AddPointVector 函数: `dep/framework/@Point2D/AddPointVector.m`
- CompressNpts 函数: `dep/framework/@Point2D/CompressNpts.m`
- VTKWrite 函数: `dep/framework/@Point2D/VTKWrite.m`

## 测试参考

参考 `Testing/000_Framework/002_Point2D/TestReport_Point2D.md` 获取详细的测试结果和已知问题。

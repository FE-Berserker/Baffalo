# 生成3D 点（Point3D）

当用户要求生成 3D 点、添加三维坐标、创建 Point3D 对象时，使用此技能。

**重要**: 如果用户只需要 2D 点（忽略 Z 坐标），应使用 `Point2D` 技能而不是 `Point3D`。

## 使用场景

当用户提出以下请求时触发此技能：
- "生成 3D 点"
- "添加三维点"
- "创建 Point3D 对象"
- "添加 (x, y, z) 坐标"

## 类概述

**类名**: `Point3D`
**作者**: Xie Yu
**继承**: `handle`
**用途**: 创建和管理三维点对象，支持批量添加点坐标、向量、法线、法线归一化等操作

### 主要属性

| 属性 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| Name | 字符串 | - | Point3D 对象名称 |
| Echo | 整数 | 1 | 是否打印信息 |
| Dtol | 数值 | 1e-5 | 距离容差 |
| P | 矩阵 | [] | 所有点的坐标矩阵 (N×3，每行一个点的 x,y,z 坐标） |
| PP | cell 数组 | {} | 点组 cell 数组，存储每次 AddPoint 调用添加的点 |
| NG | 整数 | 0 | 点组数量 |
| NP | 整数 | 0 | 点的总数 |
| Point_Data | - | 点数据 |
| Point_Vector | - | 点向量 |
| Roughness | 数值 | 1 | 粗糙度 |
| Normal | 矩阵 | - | 法线矩阵 |
| NormNormal | 矩阵 | - 归一化法线矩阵 |

## 基本用法

### 1. 创建 Point3D 对象

```matlab
a = Point3D('MyPoints');
```

**参数说明**:
- 第一个参数 `Name` 是对象名称（必需）

### 2. 添加单个 3D 点

```matlab
% 方法1：使用 AddPoint 函数（推荐）
a = Point3D('MyPoints');
a = AddPoint(a, 10, 20, 30);  % 添加点 (10, 20, 30)
```

### 3. 添加多个 3D 点

#### 方式1：逐个添加

```matlab
a = Point3D('MyPoints');
a = AddPoint(a, 10, 20, 30);
a = AddPoint(a, 15, 25, 45);
a = AddPoint(a, 20, 30, 60);
```

#### 方式2：批量添加（数组输入）

```matlab
a = Point3D('MyPoints');
x = [10, 15, 20, 25, 30, 35, 40, 45];
y = [20, 25, 30, 35, 40, 45, 50];
z = [30, 35, 40, 45, 50, 55];
a = AddPoint(a, x, y, z);
```

### 4. 使用极坐标

```matlab
a = Point3D('PolarPoints');
a = AddPoint(a, 100, 0, 50, 'polar', 'deg');  % 距离100mm，角度0°
a = AddPoint(a, 50, 86.6, 0, 'polar', 'deg');  % 距离50mm，角度86.6°
a = AddPoint(a, 50, 0, 100, 'polar', 'deg');  % 距离50mm，角度0°
```

### 5. 添加点数据

```matlab
a = Point3D('PointWithData');
data = [10, 20, 30];
a = AddPointData(a, data);  % 2×3 矩阵（每行一个点的 x,y,z）
```

### 6. 添加点向量

```matlab
a = Point3D('PointsWithVectors');
% 添加点
a = AddPoint(a, 0, 0, 0);  % 基准点

% 添加向量
u = [50, 0, 0];  % X 方向向量
v = [0, 50, 0];  % Y 方向向量
a = AddPointVector(a, [u; v]);

% 另一基点
basePoint = Point2D('BasePoint');
basePoint = AddPoint(basePoint, 50, 0, 0);
basePoint = AddPoint(basePoint, 100, 50, 0);

% 创建向量
a = AddPointVector(a, [basePoint.P(1); basePoint.P(2); zeros(3));
```

### 7. 访算点间距离

```matlab
a = Point3D('Points');
p1 = GetPoint(a, 1);
p2 = GetPoint(a, 2);
dist = Dist(a, 1, 2, 'group', 1);
fprintf('Distance: %f mm\n', dist);
```

**Dist 函数**:
```matlab
dist = Dist(obj, pointIndex1, pointIndex2, varargin);
```

**varargin 参数**:
- `'group'` - 分组显示：0=不分组，1=分组

### 8. 删除点

```matlab
a = Point3D('Points');
a = AddPoint(a, 10, 20, 30);
a = DeletePoint(a, 1);  % 删除第1个点
```

### 9. 绘制点

```matlab
a = Point3D('Points');
a = AddPoint(a, 10, 20, 30);
Plot(a, 'grid', 1);  % 带网格
Plot(a, 'plabel', 1);  % 显示点的索引
```

## 常见错误及解决方法

### 错误1：坐标数量不匹配
```
The number of x, y and z is not match!
```

**原因**: AddPoint 三个数组元素数量必须相同

**解决方法**:
```matlab
% 错误示例
x = [10, 20, 30];      % 3个元素
y = [20, 30, 40];      % 3个元素
z = [30, 40, 50];      % 3个元素

% 正确示例
x = [10, 20, 30;      % 3个元素
y = [20, 30, 40];      % 3个元素
z = [30, 40, 50];      % 3个元素
```

---

## 高级功能

### 1. 点数据管理
- AddPointData - 添加点数据字段到 Point_Data 属性
- GetPoint - 从 PP 访问特定点
- GetNpts - 获取点总数

### 2. 法线计算
- CalNormals - PCA 法线计算
- NormalizeNormals - 法线归一化
- CompressNpts - 点压缩

### 3. 可视化
- Plot - 3D 散点图
- Plot2 - 并行视图绘制
- 支持网格、标签显示

### 4. VTK 导出
- VTKWrite - VTK 格式文件导出

## 重要注意事项

### 1. 与 Point2D 的区别

| 特性 | Point2D | Point3D |
|------|--------|--------|
| 坐标维度 | 2D (N×2) | 3D (N×3) |
| 点数据 | 无 | 有 Point_Data, Point_Vector | 有 |
| 法线 | 无 | 有 Normal, NormNormal |
| VTK 导出 | 无 | 有 VTKWrite |
| 向量支持 | 无 | 有 AddPointVector |

**建议**: 对于简单的 2D 场景，使用 `Point2D` 类。

### 2. 点组管理

Point3D 使用 PP cell 数组管理点组，每个点组可以包含多个点（例如，向量数据的多个点）。

### 3. 文件命名

**测试目录**: `dep\framework\@Point/` - Point3D 类定义和主要函数
**测试目录**: `Testing\000_Framework\003_Point/` - Point3D 测试

## 相关代码文件

- Point3D 类定义: `dep\framework\@Point/Point.m`
- AddPoint: `dep\framework\@Point/AddPoint.m`
- GetNpts: `dep/framework\@Point/GetNpts.m`
- GetPoint: `dep/framework\@Point/GetPoint.m` 或 `dep/framework\@Point2D/GetPoint.m`
- DeletePoint: `dep\@Point/DeletePoint.m`
- Dist: `dep/framework\@Point/Dist.m`
- Plot: `dep\@Point/Point/Plot.m`
- AddPointData: `dep\framework\@Point/AddPointData.m`
- AddPointVector: `dep\@Point/AddPointVector.m`
- CalNormals: `dep\@Point/CalNormals.m`
- NormalizeNormals: `dep\framework/@Point/NormalizeNormals.m`
- VTKWrite: `dep\framework\@Point/VTKWrite.m`

# 生成 2D 网格 (Mesh2D)

当用户要求生成2D网格、创建2D有限元模型、网格划分时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "生成2D网格"
- "创建2D有限元模型"
- "网格划分"
- "生成三角形网格"
- "生成四边形网格"
- "创建圆形网格"
- "创建环形网格"
- "创建平板网格"

## 类概述

**类名**: `Mesh2D`
**作者**: Xie Yu
**用途**: 创建和管理2D有限元网格，支持三角形、四边形网格生成，以及各种几何形状的网格划分

## 类结构

### 属性

| 属性 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| Name | 字符串 | - | Mesh2D 对象名称 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |
| N | 矩阵 | [] | 边界节点 |
| E | 矩阵 | [] | 边界边 |
| Cb | 矩阵 | [] | 单元边界标记 |
| Vert | 矩阵 | [] | 顶点坐标 (N×2) |
| Face | 矩阵 | [] | 面/单元 (M×3 或 M×4) |
| Dual | 结构体 | {} | 对偶网格数据 |
| Size | 矩阵 | [] | 网格边大小 |
| CNode | 矩阵 | [] | 内部约束节点 |
| CEdge | 矩阵 | [] | 内部约束边 |
| G | 结构体 | {} | MRST 几何对象 |
| Boundary | 矩阵 | [] | 边界节点索引 |
| Cell_Data | 矩阵 | [] | 单元数据（用于可视化） |
| Point_Data | 矩阵 | [] | 点数据（用于可视化） |
| Point_Vector | 矩阵 | [] | 点向量数据（用于可视化） |
| Meshoutput | 结构体 | {} | 结构化网格输出 |

## 基本用法

### 1. 创建 Mesh2D 对象

```matlab
mesh = Mesh2D('MyMesh', 'Echo', 1);
```

**参数说明**:
- 第一个参数 `Name` 是对象名称（必需）
- `Echo`: 控制是否打印调试信息，默认 1

### 2. 从 Surface2D 创建网格

```matlab
% 创建表面
surface = Surface2D('MySurface', 'Echo', 0);

% 添加边界线
points = Point2D('CornerPoints');
points = AddPoint(points, [-10, 10], [-10, -10]);  % 底边
points = AddPoint(points, [10, 10], [-10, 10]);    % 右边
points = AddPoint(points, [10, -10], [10, 10]);    % 顶边
points = AddPoint(points, [-10, -10], [10, -10]);  % 左边

lines = Line2D('Boundary', 'Echo', 0);
lines = AddLine(lines, points, 1);
lines = AddLine(lines, points, 2);
lines = AddLine(lines, points, 3);
lines = AddLine(lines, points, 4);

surface = AddBoundaryLine(surface, lines);

% 添加到 Mesh2D 并生成网格
mesh = Mesh2D('MyMesh');
mesh = AddSurface(mesh, surface);
mesh = Mesh(mesh);
```

### 3. 使用 Mesh 方法的参数

```matlab
mesh = Mesh(mesh, ...
    'kind', 'delfront', ...  % 网格类型：'delaunay' 或 'delfront'
    'ref1', 'refine', ...    % 第一步细化策略：'refine' 或 'preserve'
    'ref2', 'refine', ...    % 第二步细化策略
    'siz1', 1.333, ...      % 第一步网格尺寸参数
    'siz2', 1.3);           % 第二步网格尺寸参数
```

### 4. 设置网格尺寸

```matlab
mesh = SetSize(mesh, 0.5);  % 设置目标网格尺寸为 0.5
mesh = Mesh(mesh);
```

### 5. 添加约束（内部边）

```matlab
% 添加约束节点
cnode = [0, 0; 0, 5];
mesh = AddCNode(mesh, cnode);

% 添加约束边
cedge = [1, 2];
mesh = AddCEdge(mesh, cedge);

% 生成带约束的网格
mesh = Mesh(mesh);
```

## 预定义网格类型

### 1. 矩形平板网格 (MeshQuadPlate)

```matlab
mesh = Mesh2D('PlateMesh');

% 创建矩形平板网格
plateDim = [100, 50];      % 板的尺寸 [宽, 高]
plateEl = [20, 10];        % 单元划分 [x方向单元数, y方向单元数]

mesh = MeshQuadPlate(mesh, plateDim, plateEl);

% 绘制
Plot(mesh);
```

### 2. 圆形网格 (MeshQuadCircle)

```matlab
mesh = Mesh2D('CircleMesh');

% 创建圆形网格（四边形单元）
mesh = MeshQuadCircle(mesh, ...
    'n', 8, ...     % 中心网格的细分层数
    'r', 10, ...    % 半径
    'f', 0.5);      % 中心区域与整体的比例

% 绘制
Plot(mesh);
```

### 3. 环形网格 (MeshRing)

```matlab
mesh = Mesh2D('RingMesh');

% 创建环形网格
IR = 5;   % 内半径
OR = 10;  % 外半径

mesh = MeshRing(mesh, IR, OR, ...
    'Num', 3, ...           % 径向单元层数
    'Seg', 16, ...          # 每层的分段数
    'ElementType', 'tri');  % 单元类型：'tri' 或 'quad'

% 绘制
Plot(mesh);
```

### 4. 笛卡尔网格 (MeshGrid)

```matlab
mesh = Mesh2D('CartesianMesh');

% 创建笛卡尔网格
n = [10, 10];    % 网格单元数
l = [10, 10];    # 网格尺寸

mesh = MeshGrid(mesh, n, l, 'twist', []);

% 绘制
Plot(mesh);
```

### 5. 张量网格 (MeshTensorGrid)

```matlab
mesh = Mesh2D('TensorGridMesh');

% 创建张量网格（可指定非均匀坐标）
x = [0, 2, 5, 10, 15, 20];  % x 方向坐标
y = [0, 5, 10, 15];         % y 方向坐标

mesh = MeshTensorGrid(mesh, x, y);

% 绘制
Plot(mesh);
```

### 6. 凸包网格 (Convhull)

```matlab
mesh = Mesh2D('ConvexHullMesh');

% 从点集创建凸包网格
points = Point2D('RandomPoints');
x = rand(20, 1) * 10 - 5;
y = rand(20, 1) * 10 - 5;
points = AddPoint(points, x, y);

mesh = Convhull(mesh, points);

% 绘制
Plot(mesh);
```

### 7. 凹形网格 (Convcave)

```matlab
mesh = Mesh2D('ConcaveMesh');

% 创建凹形网格
points = Point2D('ConcavePoints');
points = AddPoint(points, [0, 5, 5, 0], [0, 0, 5, 5]);
points = AddPoint(points, 1, 1);  % 内部点

% 指定哪些点应该是内部空洞
logic = [false, false, false, false, true];
mesh = Convcave(mesh, points, 'logic', logic);

% 绘制
Plot(mesh);
```

## 网格修改

### 1. 添加单元 (AddElements)

```matlab
mesh = Mesh2D('ExtendedMesh');

% 添加单元到现有网格
newElements = [1, 2, 3];
mesh = AddElements(mesh, newElements);

% 在指定位置添加
mesh = AddElements(mesh, newElements, 'position', 1);  % 在开头添加
```

### 2. 边缘细化 (MeshEdge)

```matlab
% 获取边缘组
[groups, sizes] = EdgeGroup(mesh);

% 细化第1条边
mesh = MeshEdge(mesh, 1);
```

### 3. 添加边缘层 (MeshLayerEdge)

```matlab
% 在指定边上添加网格层
mesh = MeshLayerEdge(mesh, ...
    1, ...        % 边编号
    2, ...        # 厚度
    'Num', 3, ... # 层数
    'ElementType', 'tri', ...  # 单元类型
    'Dir', 1);   % 方向：1=向外，-1=向内
```

### 4. 合并节点 (MergeNode)

```matlab
% 合并重复节点
[~,~,~,indFix] = MergeNode(mesh);
```

### 5. 平滑网格 (SmoothFace)

```matlab
% 使用 Laplacian 平滑
mesh = SmoothFace(mesh, 10);  % 平滑10次
```

### 6. 缩放网格 (ScaleMesh)

```matlab
% 缩放网格
cell = ScaleMesh(mesh, 1.5);  % 放大1.5倍
```

### 7. 四边形转三角形 (Quad2Tri)

```matlab
% 将四边形网格转换为三角形网格
mesh = Quad2Tri(mesh, 'type', 'a');
% 'type': 'a' = 对角线方向交替，'b' = 反向，'f' = 正向
```

### 8. 转换为二阶单元 (Convert2Order2)

```matlab
% 将一阶单元转换为二阶单元
mesh = Convert2Order2(mesh);
```

### 9. 删除无效单元 (DelNullElement)

```matlab
% 删除包含 NaN 的单元
mesh = DelNullElement(mesh);
```

## 网格分析

### 1. 查找边界 (FindBoundary)

```matlab
% 获取边界边
boundary = FindBoundary(mesh);
fprintf('Boundary edges: %d\n', size(boundary, 1));
```

### 2. 边缘分组 (EdgeGroup)

```matlab
% 将边界边分组为连续边缘
[G, GroupSize] = EdgeGroup(mesh);
fprintf('Found %d boundary groups\n', max(G));
```

### 3. 计算几何特性 (CalculateGeometry)

```matlab
% 计算网格的几何特性
[Area, Center, Ixx, Iyy, Ixy] = CalculateGeometry(mesh);
fprintf('Total Area: %.2f\n', Area);
fprintf('Centroid: (%.2f, %.2f)\n', Center(1), Center(2));
```

### 4. 单元中心 (CenterCal)

```matlab
% 计算每个单元的中心
centers = CenterCal(mesh);
```

### 5. 边界中心 (PatchBoundaryCentre)

```matlab
% 获取边界边的中点
centers = PatchBoundaryCentre(mesh);
```

## 可视化

### 1. 基本绘制 (Plot)

```matlab
% 基本绘制
Plot(mesh);

% 带网格
Plot(mesh, 'grid', 1);

% 等比例显示
Plot(mesh, 'equal', 1);

% 不显示约束边
Plot(mesh, 'constraint', 0);

% 设置坐标范围
Plot(mesh, 'xlim', [-10, 10], 'ylim', [-10, 10]);
```

### 2. ParaView 绘制 (Plot2)

```matlab
% 在 ParaView 中打开（需要 ParaViewPath.txt 文件）
Plot2(mesh);
```

### 3. MRST 网格绘制 (PlotG)

```matlab
% 绘制 MRST 网格
PlotG(mesh, 'grid', 1);

% 按体积着色
PlotG(mesh, 'volume', 1);
```

### 4. 对偶网格绘制 (PlotDual)

```matlab
% 绘制对偶网格
PlotDual(mesh, 'area', 1);  % 按面积着色
PlotDual(mesh, 'center', 1); % 显示单元中心
```

## 数据导出

### 1. VTK 导出 (VTKWrite)

```matlab
% 导出为 VTK 格式
VTKWrite(mesh);
% 生成文件: MyMesh.vtk
```

### 2. VTK G 导出 (VTKWriteG)

```matlab
% 导出 MRST 网格为 VTK 格式
VTKWriteG(mesh);
```

### 3. STL 导出 (WriteSTL)

```matlab
% 导出为 STL 格式
WriteSTL(mesh);
% 生成文件: MyMesh.stl
```

## 数据附加

### 1. 添加单元数据

```matlab
% 添加标量单元数据（用于可视化）
data = rand(size(mesh.Face, 1), 1);
mesh = AddCellData(mesh, data);
```

### 2. 添加点数据

```matlab
% 添加标量点数据
pointData = rand(size(mesh.Vert, 1), 1);
mesh = AddPointData(mesh, pointData);
```

### 3. 添加点向量

```matlab
% 添加向量点数据
pointVector = rand(size(mesh.Vert, 1), 3);
mesh = AddPointVector(mesh, pointVector);
```

## 高级功能

### 1. 对偶网格 (MeshDual)

```matlab
% 创建对偶网格
mesh = MeshDual(mesh);

% 计算对偶网格几何
[pc, ac] = ComputeGeometryDual(mesh);
```

### 2. MRST 几何计算 (ComputeGeometryG)

```matlab
% 计算 MRST 网格几何
mesh = ComputeGeometryG(mesh);
```

### 3. 删除 MRST 单元 (RemoveCells)

```matlab
% 删除指定的 MRST 单元
mesh = RemoveCells(mesh, [5, 10, 15]);
```

### 4. 加载 Msh 文件 (LoadMsh)

```matlab
% 从 .msh 文件加载网格
mesh = LoadMsh(mesh, 'mesh.msh');
```

## 常见场景示例

### 场景1：创建简单矩形网格

```matlab
% 创建矩形平板网格
mesh = Mesh2D('SimpleRect');
mesh = MeshQuadPlate(mesh, [20, 10], [10, 5]);

% 绘制
Plot(mesh, 'grid', 1);

% 导出
VTKWrite(mesh);
```

### 场景2：创建带孔的圆形网格

```matlab
% 创建圆形网格
mesh = Mesh2D('CircleWithHole');

% 外轮廓
center = Point2D('Center');
center = AddPoint(center, [0], [0]);

outerLine = Line2D('Outer');
outerLine = AddCircle(outerLine, 10, center, 1);

innerLine = Line2D('Inner');
innerLine = AddCircle(innerLine, 5, center, 1);

% 创建表面
surface = Surface2D('RingSurface', 'Echo', 0);
surface = AddBoundaryLine(surface, outerLine);
surface = AddBoundaryLine(surface, innerLine);

% 添加到 Mesh2D
mesh = AddSurface(mesh, surface);
mesh = SetSize(mesh, 0.5);
mesh = Mesh(mesh);

% 绘制
Plot(mesh);
```

### 场景3：创建复杂形状网格

```matlab
% 创建多边形
points = Point2D('PolygonPoints');
points = AddPoint(points, [0, 5, 5, 3, 0], [0, 0, 3, 5, 3]);

lines = Line2D('Polygon', 'Echo', 0);
lines = AddLine(lines, points, 1);
lines = AddLine(lines, points, 2);
lines = AddLine(lines, points, 3);
lines = AddLine(lines, points, 4);
lines = AddLine(lines, points, 5);

% 创建表面
surface = Surface2D('PolygonSurface', 'Echo', 0);
surface = AddBoundaryLine(surface, lines);

% 生成网格
mesh = Mesh2D('PolygonMesh');
mesh = AddSurface(mesh, surface);
mesh = Mesh(mesh);

% 绘制
Plot(mesh);
```

### 场景4：网格细化

```matlab
% 创建初始网格
mesh = Mesh2D('RefinedMesh');
mesh = MeshQuadPlate(mesh, [20, 10], [5, 5]);

% 细化特定边缘
[groups, sizes] = EdgeGroup(mesh);
fprintf('Boundary groups: %d\n', max(groups));

% 细化第1组边（假设是较长边）
mesh = MeshEdge(mesh, 1);

% 平滑网格
mesh = SmoothFace(mesh, 5);

# 绘制
Plot(mesh);
```

## 参数说明

### Mesh 方法参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `kind` | 字符串 | 'delfront' | 网格类型：'delaunay' 或 'delfront' |
| `ref1` | 字符串 | 'refine' | 第一步细化：'refine' 或 'preserve' |
| `ref2` | 字符串 | 'refine' | 第二步细化：'refine' 或 'preserve' |
| `siz1` | 数值 | 1.333 | 第一步网格尺寸参数 |
| `siz2` | 数值 | 1.3 | 第二步网格尺寸参数 |

### Plot 方法参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `grid` | 整数 | 0 | 是否显示网格 |
| `axe` | 整数 | 1 | 是否显示坐标轴 |
| `equal` | 整数 | 1 | 是否等比例显示 |
| `base_size` | 数值 | 1 | 线宽基数 |
| `xlim` | [min, max] | [] | X 轴范围 |
| `ylim` | [min, max] | [] | Y 轴范围 |
| `constraint` | 整数 | 1 | 是否显示约束边 |

## 注意事项

1. **约束节点和边**: 使用约束时，必须同时定义 CNode 和 CEdge
2. **网格尺寸**: SetSize 控制网格细化程度，值越小网格越密
3. **单元阶次**: Convert2Order2 将一阶单元转换为二阶，提高精度但增加计算量
4. **单位**: 所有长度单位保持一致（通常为毫米）
5. **网格质量**: SmoothFace 可改善网格质量，但过度平滑可能改变几何形状

## 相关文件

- Mesh2D 类定义: `dep/framework/@Mesh2D/Mesh2D.m`
- Mesh 函数: `dep/framework/@Mesh2D/Mesh.m`
- Plot 函数: `dep/framework/@Mesh2D/Plot.m`
- VTKWrite 函数: `dep/framework/@Mesh2D/VTKWrite.m`

## 相关类

- `Point2D`: 创建点
- `Line2D`: 创建线和轮廓
- `Surface2D`: 创建2D表面
- `Point3D`: 创建3D点

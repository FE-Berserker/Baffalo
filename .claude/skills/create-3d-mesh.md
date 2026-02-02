# 生成 3D 网格 (Mesh)

当用户要求生成3D网格、创建3D有限元模型、3D网格划分时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "生成3D网格"
- "创建3D有限元模型"
- "创建立方体网格"
- "创建球体网格"
- "创建圆柱体网格"
- "创建四面体网格"
- "创建六面体网格"
- "拉伸网格"
- "旋转网格"

## 类概述

**类名**: `Mesh`
**作者**: Xie Yu
**继承**: `handle`
**用途**: 创建和管理3D有限元网格，支持四面体、六面体、棱柱、金字塔等基本形状，以及拉伸、旋转等复杂生成方式

## 类结构

### 属性

| 属性 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| Name | 字符串 | - | Mesh 对象名称 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |
| Vert | 矩阵 | [] | 顶点坐标 (N×3) |
| Face | 矩阵 | [] | 面索引 (M×3 或 M×4) |
| El | 矩阵 | [] | 单元索引 |
| Cb | 矩阵 | [] | 面边界标记 |
| G | 结构体 | {} | MRST 几何对象 |
| Point_Data | 矩阵 | [] | 点数据（用于可视化） |
| Point_Vector | 矩阵 | [] | 点向量数据（用于可视化） |
| Cell_Data | 矩阵 | [] | 单元数据（用于可视化） |
| Voronoi | 结构体 | {} | Voronoi 图数据 |
| Boundary | 矩阵 | [] | 边界节点索引 |
| Meshoutput | 结构体 | {} | 结构化网格输出 |

## 基本用法

### 1. 创建 Mesh 对象

```matlab
mesh = Mesh('MyMesh', 'Echo', 1);
```

**参数说明**:
- 第一个参数 `Name` 是对象名称（必需）
- `Echo`: 控制是否打印调试信息，默认 1

## 预定义网格类型

### 1. 立方体网格 (MeshCube)

```matlab
mesh = Mesh('CubeMesh');

% 创建立方面网格
cubeDim = [10, 10, 10];     % 立方体尺寸 [长, 宽, 高]
cubeEl = [5, 5, 5];         % 各方向单元数

% 使用八节点六面体
mesh = MeshCube(mesh, cubeDim, cubeEl, 'ElementType', 'hex8');

% 使用二十节点六面体（二阶）
mesh = MeshCube(mesh, cubeDim, cubeEl, 'ElementType', 'hex20');

% 绘制
PlotElement(mesh);
```

**参数**:
- `cubeDim`: 立方体尺寸 [Lx, Ly, Lz]
- `cubeEl`: 各方向单元数 [nx, ny, nz]
- `ElementType`: 单元类型，'hex8'（八节点）或 'hex20'（二十节点）

---

### 2. 球体网格 (MeshSphere)

```matlab
mesh = Mesh('SphereMesh');

% 创建四面体球体网格
n = 3;     % 细化等级（越大越精细）
r = 5;     % 半径
mesh = MeshSphere(mesh, n, r);

% 指定球体类型（可选）
mesh = MeshSphere(mesh, n, r, 'icosa');  % 二十面体
mesh = MeshSphere(mesh, n, r, 'octa');   % 八面体

% 绘制
PlotElement(mesh);
```

**参数**:
- `n`: 细化等级
- `r`: 球体半径
- `solidType`: 球体类型（可选）

---

### 3. 地理球体网格 (MeshGeoSphere)

```matlab
mesh = Mesh('GeoSphereMesh');

% 创建地理球体（四面体面）
n = 3;     % 细化等级
r = 5;     % 半径

mesh = MeshGeoSphere(mesh, n, r, 'Type', 4);  % 四面体

% 绘制
PlotFace(mesh);
```

**参数**:
- `n`: 细化等级
- `r`: 半径
- `Type`: 面类型，3=三角形，4=四面体

---

### 4. 圆柱体网格 (MeshCylinder)

```matlab
mesh = Mesh('CylinderMesh');

% 创建圆柱体网格
esize = 0.5;   % 单元尺寸
Radius = 5;     % 半径
Height = 10;    % 高度

% 使用三角形面
mesh = MeshCylinder(mesh, esize, Radius, Height, 'ElementType', 'tri');

% 使用四边形面
mesh = MeshCylinder(mesh, esize, Radius, Height, 'ElementType', 'quad');

% 不封闭上下底面
mesh = MeshCylinder(mesh, esize, Radius, Height, 'close', 0);

% 绘制
PlotFace(mesh);
```

**参数**:
- `esize`: 单元尺寸
- `Radius`: 圆柱半径
- `Height`: 圆柱高度
- `ElementType`: 面单元类型，'tri' 或 'quad'
- `close`: 是否封闭，1=封闭，0=不封闭

---

### 5. 棱柱网格 (MeshPrism)

```matlab
mesh = Mesh('PrismMesh');

n = 6;         % 边数（正多边形边数）
l = 10;        % 边长
height = 15;    % 高度

% 使用默认网格尺寸
mesh = MeshPrism(mesh, n, l, height);

% 指定网格尺寸
mesh = MeshPrism(mesh, n, l, height, 'Meshsize', 0.5);

% 绘制
PlotElement(mesh);
```

**参数**:
- `n`: 正多边形边数
- `l`: 边长
- `height`: 高度
- `Meshsize`: 网格尺寸（可选）

---

### 6. 金字塔网格 (MeshPyramid)

```matlab
mesh = Mesh('PyramidMesh');

n = 4;         % 底面边数
l = 10;        % 底面边长
height = 8;     % 高度

% 类型0：正棱锥（直接拉伸）
mesh = MeshPyramid(mesh, n, l, height, 'Type', 0);

% 类型1：正棱锥（旋转生成）
mesh = MeshPyramid(mesh, n, l, height, 'Type', 1);

% 指定网格尺寸
mesh = MeshPyramid(mesh, n, l, height, 'Meshsize', 0.5);

% 绘制
PlotElement(mesh);
```

**参数**:
- `n`: 底面边数
- `l`: 底面边长
- `height`: 高度
- `Type`: 生成方式，0或1
- `Meshsize`: 网格尺寸（可选）

---

### 7. 八面体网格 (MeshOctahedron)

```matlab
mesh = Mesh('OctahedronMesh');

% 创建八面体
mesh = MeshOctahedron(mesh);

% 绘制
PlotElement(mesh);
```

---

### 8. 四边形球体网格 (MeshQuadSphere)

```matlab
mesh = Mesh('QuadSphereMesh');

n = 4;     % 中心网格的细分层数
r = 5;     % 半径

mesh = MeshQuadSphere(mesh, n, r);

% 平滑球体
mesh = Smoothface(mesh, 50);

% 绘制
PlotElement(mesh);
```

**参数**:
- `n`: 中心网格的细分层数
- `r`: 半径

---

### 9. 半球体网格 (MeshHemiSphere)

```matlab
mesh = Mesh('HemiSphereMesh');

Radius = 5;        % 半径
MantelNum = 10;     % 地幔层数

% 实心半球体
mesh = MeshHemiSphere(mesh, Radius, MantelNum);

% 空心半球体（指定核心半径）
mesh = MeshHemiSphere(mesh, Radius, MantelNum, 'coreRadius', 2, 'hollow', 1);

% 指定输出结构类型
mesh = MeshHemiSphere(mesh, Radius, MantelNum, 'outputStructType', 2);

% 指定平滑步数
mesh = MeshHemiSphere(mesh, Radius, MantelNum, 'smoothstep', 50);

% 绘制
PlotElement(mesh);
```

**参数**:
- `Radius`: 半径
- `MantelNum`: 地幔层数
- `coreRadius`: 核心半径（默认 Radius/2）
- `hollow`: 是否空心，0=实心，1=空心
- `outputStructType`: 输出结构类型
- `smoothstep`: 平滑步数

---

### 10. 张量网格 (MeshTensorGrid)

```matlab
mesh = Mesh('TensorGridMesh');

% 创建张量网格
x = [0, 0.5, 1, 2, 5];   % x 方向坐标（可非均匀）
y = [0, 0.2, 0.5, 1];     % y 方向坐标
z = [0, 1, 2, 3, 5];     % z 方向坐标

mesh = MeshTensorGrid(mesh, x, y, z);

% 绘制
PlotElement(mesh);
```

---

### 11. 三重周期极小曲面 (MeshTriplyPeriodicMinimalSurface)

```matlab
mesh = Mesh('TPMSSurface');

% 创建三重周期极小曲面
mesh = MeshTriplyPeriodicMinimalSurface(mesh);

% 绘制
PlotElement(mesh);
```

---

### 12. 旋节曲面 (MeshSpinodoid)

```matlab
mesh = Mesh('SpinodoidMesh');

% 创建旋节曲面
mesh = MeshSpinodoid(mesh);

% 绘制
PlotElement(mesh);
```

---

### 13. 随机微观结构 (MeshStochasticMicroStructure)

```matlab
mesh = Mesh('StochasticMicro');

% 创建随机微观结构
mesh = MeshStochasticMicroStructure(mesh);

% 绘制
PlotElement(mesh);
```

## 几何变换生成

### 1. 拉伸2D网格成3D实体 (Extrude2Solid)

```matlab
% 首先创建2D网格
mesh2d = Mesh2D('BaseSurface');
% ... 设置 mesh2d 的面和顶点 ...

% 创建3D Mesh 对象
mesh = Mesh('ExtrudedMesh');

% 拉伸成3D实体
height = 5;      % 拉伸高度
levels = 10;     % 拉伸层数

mesh = Extrude2Solid(mesh, mesh2d, height, levels);

% 绘制
PlotElement(mesh);
```

**参数**:
- `mesh2d`: 2D网格对象
- `height`: 拉伸高度（可以是标量或向量）
- `levels`: 拉伸层数
- `Cb`: 只拉伸指定边界的面（可选）

**注意**: 如果 `height` 是向量，`levels` 会被忽略

---

### 2. 旋转2D网格成3D实体 (Revolve2Solid)

```matlab
% 首先创建2D网格
mesh2d = Mesh2D('Profile');
% ... 设置 mesh2d 的面和顶点 ...

% 创建3D Mesh 对象
mesh = Mesh('RevolvedMesh');

% 绕X轴旋转
mesh = Revolve2Solid(mesh, mesh2d, 'Type', 1, 'Slice', 36);

% 绕Y轴旋转
mesh = Revolve2Solid(mesh, mesh2d, 'Type', 2, 'Slice', 36);

% 指定旋转角度（非完整旋转）
mesh = Revolve2Solid(mesh, mesh2d, 'Degree', 180, 'Slice', 18);

% 指定间隙（非均匀旋转）
mesh = Revolve2Solid(mesh, mesh2d, 'Gap', [30, 60, 90, 180]);

% 绘制
PlotElement(mesh);
```

**参数**:
- `mesh2d`: 2D网格对象
- `Slice`: 切片数
- `Type`: 旋转轴，1=X轴，2=Y轴
- `Degree`: 旋转角度（默认360）
- `Gap`: 旋转间隙向量（可选）

---

### 3. NURBS 曲面 (NurbSurf)

```matlab
mesh = Mesh('NurbSurface');

% 定义4条边界NURBS曲线（使用Line类）
coefs1 = [0, 1, 2, 3, 4;
          0, 0, 1, 0, 0;
          0, 0, 0, 0, 0;
          1, 1, 1, 1, 1];
knots1 = [0, 0, 0, 0.25, 0.5, 0.75, 1, 1, 1];

L = Line('Boundaries', 'Echo', 0);
L = AddNurb(L, coefs1, knots1);
L = AddNurb(L, coefs2, knots2);
L = AddNurb(L, coefs3, knots3);
L = AddNurb(L, coefs4, knots4);

% 创建NURBS曲面
mesh = NurbSurf(mesh, L, [1, 2, 3, 4]);

% 绘制
PlotFace(mesh);
```

**参数**:
- `L`: Line对象，包含4条边界曲线
- `boundaries`: 边界曲线索引数组 [U方向曲线, V方向曲线]

---

### 4. 4边界NURBS曲面 (Nurb4Surf)

```matlab
mesh = Mesh('Nurb4Surface');

% 定义4条边界曲线
L = Line('Boundaries', 'Echo', 0);
% ... 添加4条边界曲线 ...

% 创建NURBS曲面
mesh = Nurb4Surf(mesh, L);

% 绘制
PlotFace(mesh);
```

**参数**:
- `L`: Line对象，包含4条边界曲线

---

### 5. 直纹曲面 (NurbRuled)

```matlab
mesh = Mesh('RuledSurface');

% 定义2条边界曲线
L = Line('Boundaries', 'Echo', 0);
% ... 添加2条边界曲线 ...

% 创建直纹曲面
mesh = NurbRuled(mesh, L, [1, 2]);

% 绘制
PlotFace(mesh);
```

**参数**:
- `L`: Line对象，包含边界曲线
- `boundaries`: 2条边界曲线的索引

---

### 6. 旋转成壳体 (Rot2Shell)

```matlab
mesh = Mesh('ShellMesh');

% 旋转成壳体
mesh = Rot2Shell(mesh, ...);

% 绘制
PlotElement(mesh);
```

## 3D四面体网格生成 (Mesh3D)

### 从封闭表面生成四面体网格

```matlab
% 首先创建封闭的表面网格
mesh = Mesh('SurfaceMesh');

% 设置表面面和顶点
mesh.Face = faces;   % N×3 或 N×4 矩阵
mesh.Vert = vertices; % M×3 矩阵

% 设置边界标记（可选）
mesh.Cb = markers;   % 每个面的标记

% 生成3D四面体网格
mesh = Mesh3D(mesh, 'stringOpt', '-pq1.2AaY');

% 指定最小区域标记
mesh = Mesh3D(mesh, 'minRegionMarker', 2);

% 添加额外节点
extraNodes = [0, 0, 0; 1, 1, 1];
mesh = Mesh3D(mesh, 'AddedNodes', extraNodes);

% 绘制
PlotElement(mesh);
```

**TetGen 选项参数**:
- `stringOpt`: TetGen命令行选项，默认 '-pq1.2AaY'
  - p: 输入是表面
  - q: 生成四面体网格
  - #: 生成单元数量估计
  - o1: 输出节点
  - o2: 输出单元
  - a: 输出所有区域
  - A: 为每个区域指定属性
  - Y: 抑制边界标记
  - i: 使用额外节点

- `minRegionMarker`: 最小区域标记
- `AddedNodes`: 额外节点坐标矩阵

**输出**: `obj.Meshoutput` 包含节点、单元、面等数据

## 网格操作

### 1. 重新网格化 (Remesh)

```matlab
% 重新网格化（细化）
mesh = Remesh(mesh, 0.5);

% 绘制
PlotElement(mesh);
```

---

### 2. 平滑网格 (Smoothface)

```matlab
% 平滑网格
mesh = Smoothface(mesh, 50);  % 平滑50次

% 绘制
PlotElement(mesh);
```

---

### 3. 删除单元 (RemoveCells)

```matlab
% 删除指定单元（MRST结构）
mesh = RemoveCells(mesh, [5, 10, 15]);

% 绘制
PlotElement(mesh);
```

---

### 4. 删除无效单元 (DelNullElement)

```matlab
% 删除包含 NaN 的单元
mesh = DelNullElement(mesh);

% 绘制
PlotElement(mesh);
```

---

### 5. 合并面和节点 (MergeFaceNode)

```matlab
% 合并重复的面和节点
mesh = MergeFaceNode(mesh);

% 绘制
PlotElement(mesh);
```

---

### 6. 保留指定组 (KeepGroup)

```matlab
% 只保留指定标记的组
mesh = KeepGroup(mesh, [1, 3]);

% 绘制
PlotElement(mesh);
```

---

### 7. 钻孔 (DrillHole)

```matlab
% 在指定位置钻圆柱孔
mesh = DrillHole(mesh, [5, 5, 5], 1, 3, 10, 36);
% 参数: 中心, 半径, 边数, 高度, 方向角

% 绘制
PlotElement(mesh);
```

---

### 8. 钻通孔 (DrillThroughHole)

```matlab
% 钻通孔
mesh = DrillThroughHole(mesh, ...);

% 绘制
PlotElement(mesh);
```

---

### 9. 四边形转三角形 (Quad2tri)

```matlab
% 将四边形单元转换为三角形
mesh = Quad2tri(mesh);

% 绘制
PlotElement(mesh);
```

---

### 10. 转换为二阶单元 (Convert2Order2)

```matlab
% 将一阶单元转换为二阶单元
mesh = Convert2Order2(mesh);

% 绘制
PlotElement(mesh);
```

---

### 11. 反转法向量 (ReverseNormals)

```matlab
% 反转面的法向量方向
mesh = ReverseNormals(mesh);

% 绘制
PlotElement(mesh);
```

---

## 几何计算

### 1. 计算MRST几何 (ComputeGeometryG)

```matlab
% 计算MRST几何信息
mesh = ComputeGeometryG(mesh);

% 访问几何数据
volumes = mesh.G.cells.volumes;    % 单元体积
centers = mesh.G.cells.centroids;    % 单元中心
faces = mesh.G.cells.faces;          % 单元面

% 绘制带体积的网格
PlotG(mesh, 'volume', 1);
```

---

### 2. 计算中心 (CenterCal)

```matlab
% 计算每个单元的中心
centers = CenterCal(mesh);
```

---

### 3. 计算体积 (VolumeCal)

```matlab
% 计算网格总体积
volume = VolumeCal(mesh);
fprintf('Total volume: %.2f\n', volume);
```

---

### 4. 获取面法向量 (GetFaceNormal)

```matlab
% 获取面法向量
normals = GetFaceNormal(mesh);
```

---

### 5. 查找边界 (FindBoundary)

```matlab
% 查找边界面
boundary = FindBoundary(mesh);
fprintf('Boundary faces: %d\n', size(boundary, 1));
```

---

### 6. 判断点是否在网格内 (IsInMesh)

```matlab
% 判断点是否在网格内
point = [1, 1, 1];
isInside = IsInMesh(mesh, point);
if isInside
    fprintf('Point is inside the mesh\n');
end
```

---

### 7. 计算面中心 (PatchCenter)

```matlab
% 计算每个面的中心
centers = PatchCenter(mesh);
```

## Voronoi 操作

### 1. 三角形转Voronoi (Tri2Voronoi)

```matlab
% 将三角网格转换为Voronoi图
mesh = Tri2Voronoi(mesh);

% 绘制Voronoi
PlotVoronoi(mesh);
```

---

### 2. 绘制Voronoi (PlotVoronoi)

```matlab
% 绘制Voronoi图
PlotVoronoi(mesh);

% 使用ParaView绘制
PlotVoronoi2(mesh);
```

---

### 3. Voronoi到VTK (VTKWriteVoronoi)

```matlab
% 导出Voronoi图为VTK
VTKWriteVoronoi(mesh);
```

## 数据处理

### 1. 添加单元数据 (AddCellData)

```matlab
% 添加标量单元数据（用于可视化）
data = rand(size(mesh.El, 1), 1);
mesh = AddCellData(mesh, data);
```

---

### 2. 添加点数据 (AddPointData)

```matlab
% 添加标量点数据
pointData = rand(size(mesh.Vert, 1), 1);
mesh = AddPointData(mesh, pointData);
```

---

### 3. 添加点向量 (AddPointVector)

```matlab
% 添加向量点数据
pointVector = rand(size(mesh.Vert, 1), 3);
mesh = AddPointVector(mesh, pointVector);
```

## 可视化

### 1. 绘制单元 (PlotElement)

```matlab
% 基本绘制
PlotElement(mesh);

% 绘制面
PlotFace(mesh);

% 使用ParaView绘制
PlotElement2(mesh);
PlotFace2(mesh);
```

---

### 2. 绘制MRST几何 (PlotG)

```matlab
% 绘制MRST网格
mesh = ComputeGeometryG(mesh);
PlotG(mesh, 'volume', 1);

% 使用ParaView绘制
PlotG2(mesh);
```

---

### 3. VTK输出

```matlab
% 输出单元到VTK
VTKWriteElement(mesh);

% 输出面到VTK
VTKWriteFace(mesh);

% 输出MRST几何到VTK
mesh = ComputeGeometryG(mesh);
VTKWriteG(mesh);

% 输出到STL
STLWrite(mesh);
```

---

### 4. 输入STP文件 (InputSTP)

```matlab
% 从STP文件导入
mesh = InputSTP(mesh, 'model.stp');
```

## 常见场景示例

### 场景1：创建立方体并计算体积

```matlab
% 创建立方体
mesh = Mesh('CubeMesh');
cubeDim = [10, 10, 10];
cubeEl = [5, 5, 5];
mesh = MeshCube(mesh, cubeDim, cubeEl, 'ElementType', 'hex8');

% 计算体积
volume = VolumeCal(mesh);
fprintf('Cube volume: %.2f\n', volume);

% 绘制
PlotElement(mesh);

% 导出VTK
VTKWriteElement(mesh);
```

---

### 场景2：拉伸2D网格

```matlab
% 创建2D圆形表面
points = Point2D('CircleCenter');
points = AddPoint(points, [0], [0]);

line = Line2D('Circle', 'Echo', 0);
line = AddCircle(line, 5, points, 1);

surface = Surface2D('CircleSurface', 'Echo', 0);
surface = AddBoundaryLine(surface, line);

mesh2d = Mesh2D('CircleBase', 'Echo', 0);
mesh2d = AddSurface(mesh2d, surface);
mesh2d = SetSize(mesh2d, 0.5);
mesh2d = Mesh(mesh2d);

% 拉伸成3D圆柱
mesh = Mesh('ExtrudedCylinder');
mesh = Extrude2Solid(mesh, mesh2d, 10, 20);

% 绘制
PlotElement(mesh);

% 导出
VTKWriteElement(mesh);
```

---

### 场景3：旋转2D截面成3D实体

```matlab
% 创建2D矩形截面
points = Point2D('RectPoints');
points = AddPoint(points, [0, 5], [0, 0]);
points = AddPoint(points, [2, 5], [2, 0]);

line = Line2D('RectBoundary', 'Echo', 0);
line = AddLine(line, points, 1);
line = AddLine(line, points, 2);

surface = Surface2D('RectSurface', 'Echo', 0);
surface = AddBoundaryLine(surface, line);

mesh2d = Mesh2D('RectBase', 'Echo', 0);
mesh2d = AddSurface(mesh2d, surface);
mesh2d = SetSize(mesh2d, 0.5);
mesh2d = Mesh(mesh2d);

% 绕Y轴旋转成圆环
mesh = Mesh('Torus');
mesh = Revolve2Solid(mesh, mesh2d, 'Type', 2, 'Slice', 36);

% 绘制
PlotElement(mesh);

% 导出
VTKWriteElement(mesh);
```

---

### 场景4：创建球体并添加数据

```matlab
% 创建球体
mesh = Mesh('SphereWithData');
mesh = MeshSphere(mesh, 3, 5);

% 计算MRST几何
mesh = ComputeGeometryG(mesh);

% 添加单元数据（距离中心的距离）
centers = mesh.G.cells.centroids;
distances = sqrt(sum(centers.^2, 2));
mesh = AddCellData(mesh, distances);

% 绘制带数据的网格
PlotG2(mesh);
```

---

### 场景5：创建复杂几何

```matlab
% 创建组合几何
mesh = Mesh('Complex');

% 方法1：拉伸
mesh2d = Mesh2D('Base', 'Echo', 0);
% ... 设置 mesh2d ...
mesh = Mesh('ExtrudedPart');
mesh = Extrude2Solid(mesh, mesh2d, 5, 10);

% 方法2：添加其他几何（使用Layer类）
% ... 合并多个部分 ...

% 绘制
PlotElement(mesh);
```

---

### 场景6：网格平滑和质量优化

```matlab
% 创建初始网格
mesh = Mesh('RefinedMesh');
mesh = MeshCube(mesh, [10, 10, 10], [3, 3, 3]);

% 平滑网格
mesh = Smoothface(mesh, 20);

% 删除无效单元
mesh = DelNullElement(mesh);

% 合并节点
mesh = MergeFaceNode(mesh);

% 绘制
PlotElement(mesh);
```

## 参数说明

### MeshCube 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `cubeDimensions` | [Lx, Ly, Lz] | - | 立方体尺寸 |
| `cubeElementNumbers` | [nx, ny, nz] | - | 各方向单元数 |
| `ElementType` | 'hex8' 或 'hex20' | 'hex8' | 单元类型 |

### MeshCylinder 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `esize` | 数值 | - | 单元尺寸 |
| `Radius` | 数值 | - | 圆柱半径 |
| `Height` | 数值 | - | 圆柱高度 |
| `ElementType` | 'tri' 或 'quad' | 'tri' | 面单元类型 |
| `close` | 0 或 1 | 1 | 是否封闭 |

### Revolve2Solid 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `Slice` | 整数 | 36 | 旋转切片数 |
| `Type` | 1 或 2 | 1 | 旋转轴：1=X, 2=Y |
| `Degree` | 数值 | 360 | 旋转角度 |
| `Gap` | 向量 | [] | 旋转间隙 |

### Extrude2Solid 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `height` | 数值或向量 | - | 拉伸高度（或每层高度） |
| `levels` | 整数 | - | 拉伸层数 |
| `Cb` | 标量 | [] | 只拉伸指定边界的面 |

## 注意事项

1. **单元类型**: MeshCube 支持 'hex8'（一阶）和 'hex20'（二阶）六面体
2. **网格尺寸**: esize 和 Meshsize 控制网格密度，值越小网格越密
3. **TetGen 选项**: Mesh3D 使用 TetGen 生成四面体网格，stringOpt 参数控制网格质量
4. **封闭表面**: 使用 Mesh3D 前，必须确保表面是封闭的
5. **单位**: 所有长度单位保持一致
6. **内存**: 大型网格可能消耗大量内存，注意控制单元数量
7. **Voronoi**: Voronoi 操作仅对三角网格有效

## 相关文件

- Mesh 类定义: `dep/framework/@Mesh/Mesh.m`
- MeshCube: `dep/framework/@Mesh/MeshCube.m`
- MeshSphere: `dep/framework/@Mesh/MeshSphere.m`
- MeshCylinder: `dep/framework/@Mesh/MeshCylinder.m`
- Mesh3D: `dep/framework/@Mesh/Mesh3D.m`
- Extrude2Solid: `dep/framework/@Mesh/Extrude2Solid.m`
- Revolve2Solid: `dep/framework/@Mesh/Revolve2Solid.m`
- ComputeGeometryG: `dep/framework/@Mesh/ComputeGeometryG.m`
- VTKWriteElement: `dep/framework/@Mesh/VTKWriteElement.m`
- PlotElement: `dep/framework/@Mesh/PlotElement.m`
- TetGen: `dep/framework/@Mesh/tetGen/`

## 外部工具

### TetGen (tetGen/)
- 四面体网格生成器
- 支持多种网格质量选项
- 位置: `dep/framework/@Mesh/tetGen/win64/tetgen.exe` (Windows)
- 位置: `dep/framework/@Mesh/tetGen/lin64/tetgen` (Linux)
- 位置: `dep/framework/@Mesh/tetGen/mac64/tetgen` (Mac)

### Geogram (geogram/)
- Voronoi 图生成器
- 位置: `dep/framework/@Mesh/geogram/win64/vorpalite.exe` (Windows)
- 位置: `dep/framework/@Mesh/geogram/lin64/vorpalite` (Linux)
- 位置: `dep/framework/@Mesh/geogram/mac64/vorpalite` (Mac)

## 相关类

- `Point3D`: 创建3D点
- `Line`: 创建3D曲线（用于NURBS曲面边界）
- `Mesh2D`: 创建2D网格（可用于拉伸和旋转）
- `Point2D`: 创建2D点
- `Line2D`: 创建2D线（用于拉伸和旋转的2D截面）
- `Surface2D`: 创建2D表面（用于拉伸和旋转的2D截面）

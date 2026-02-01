# 创建平板零件 (Commonplate)

当用户要求创建平板零件、带孔板件、板类零件时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "创建一个平板"
- "建立一个板件"
- "创建带孔的板"
- "建立一个平板模型"
- "创建板类有限元模型"

## 类概述

**类名**: `plate.Commonplate`
**继承**: `Component`
**用途**: 创建和分析带孔的板件模型，支持实体模型和壳模型两种有限元分析方式

## 参数说明

### paramsStruct - 参数结构体

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| Material | 结构体 | [] | 材料属性，默认为钢材 |
| N_Slice | 整数 | 3 | 高度方向的单元层数 |
| Name | 字符串 | 'Commonplate1' | 板的名称 |
| Order | 整数 | 1 | 单元阶次：1=一阶，2=二阶 |
| Offset | 字符串 | "Mid" | 壳单元偏移：Mid=中面，Top=上面，Bottom=下面 |
| Echo | 整数 | 1 | 是否打印信息：0=不打印，1=打印 |

### inputStruct - 输入结构体

| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| Outline | Line2D对象 | 是 | 轮廓 [mm]，使用 Line2D 类创建 |
| Hole | Line2D矩阵 | 否 | 孔 [mm]，Nx2矩阵，每个孔是一个 Line2D 对象 |
| Thickness | 数值 | 是 | 厚度 [mm] |
| Meshsize | 数值 | 否 | 网格尺寸 [mm] |

### 输出结果

| 输出 | 类型 | 说明 |
|------|------|------|
| Surface | Surface2D | 板截面表面 |
| SolidMesh | Mesh | 板3D实体网格 |
| ShellMesh | Mesh | 板3D壳网格 |
| Assembly | Assembly | 实体模型装配 |
| Assembly1 | Assembly | 壳模型装配 |

## 创建轮廓的方法

### 1. 创建圆形/圆弧轮廓

使用 `AddCircle` 函数添加圆弧：

```matlab
b = Line2D('Outline Name');
b = AddCircle(b, radius, point, curveId, 'sang', startAngle, 'ang', sweepAngle);
```

**参数**:
- `radius`: 圆半径 [mm]
- `point`: 圆心，Point2D 对象
- `curveId`: 曲线编号
- `sang`: 起始角度 [度]
- `ang`: 扫掠角度 [度]

### 2. 创建直线轮廓

使用 `AddLine` 函数添加直线：

```matlab
a = Point2D('Point Name');
a = AddPoint(a, x, y);
b = AddLine(b, a, curveId);
```

**重要**: Point2D 中的点需要成对添加，每对点形成一条线。x 和 y 必须是列向量。

### 3. 创建圆角

使用 `CreateRadius` 函数创建圆角：

```matlab
b = CreateRadius(b, curveId, radius);
```

### 4. 创建圆角多边形

使用 `AddRoundPolygon` 函数快速创建圆角多边形：

```matlab
b = Line2D('Round Polygon');
b = AddRoundPolygon(b, size, numSides, radius, 'sang', startAngle);
```

**参数**:
- `size`: 外接圆到边的距离
- `numSides`: 边数
- `radius`: 圆角半径
- `sang`: 起始角度（可选）

### 5. 创建孔

创建孔使用 `Line2D` 对象和 `AddCircle`：

```matlab
h = Line2D('Hole Name');
h = AddCircle(h, radius, centerPoint, 1);
```

## 使用流程

### 标准流程

```matlab
%% 步骤1：创建外轮廓
b = Line2D('Outline');
b = AddCircle(b, 100, centerPoint, 1, 'sang', 0, 'ang', 360);

%% 步骤2：创建孔（可选）
h = Line2D('Hole');
h = AddCircle(h, 20, centerPoint, 1);

%% 步骤3：设置输入
inputplate.Outline = b;
inputplate.Hole = h;  % 可选
inputplate.Thickness = 10;

%% 步骤4：设置参数（可选）
paramsplate = struct();
paramsplate.Order = 2;  % 使用二阶单元

%% 步骤5：创建板件
obj = plate.Commonplate(paramsplate, inputplate);
obj = obj.solve();

%% 步骤6：可视化
obj.Plot2D();  % 2D视图
Plot3D(obj);   % 3D视图
```

## 常见场景示例

### 场景1：创建简单圆形板

```matlab
% 创建中心点
center = Point2D('Center');
center = AddPoint(center, 0, 0);

% 创建圆轮廓
outline = Line2D('Round Plate');
outline = AddCircle(outline, 50, center, 1);

% 设置输入
inputplate.Outline = outline;
inputplate.Thickness = 5;

% 创建板件
paramsplate = struct();
obj = plate.Commonplate(paramsplate, inputplate);
obj = obj.solve();
```

### 场景2：创建带中心孔的圆形板

```matlab
center = Point2D('Center');
center = AddPoint(center, 0, 0);

% 外轮廓
outline = Line2D('Outer Outline');
outline = AddCircle(outline, 100, center, 1);

% 中心孔
hole = Line2D('Center Hole');
hole = AddCircle(hole, 20, center, 1);

inputplate.Outline = outline;
inputplate.Hole = hole;
inputplate.Thickness = 10;

paramsplate = struct();
obj = plate.Commonplate(paramsplate, inputplate);
obj = obj.solve();
```

### 场景3：创建矩形板

```matlab
% 创建点对（Point2D中的点按成对方式组织）
points = Point2D('Rectangle Points');

% 底边：左下 -> 右下
points = AddPoint(points, [-250; 250], [-200; -200]);

% 右边：右下 -> 右上
points = AddPoint(points, [250; 250], [-200; 200]);

% 顶边：右上 -> 左上
points = AddPoint(points, [250; -250], [200; 200]);

% 左边：左上 -> 左下
points = AddPoint(points, [-250; -250], [200; -200]);

% 创建轮廓
outline = Line2D('Rectangular Plate');
outline = AddLine(outline, points, 1);  % 底边
outline = AddLine(outline, points, 2);  % 右边
outline = AddLine(outline, points, 3);  % 顶边
outline = AddLine(outline, points, 4);  % 左边

inputplate.Outline = outline;
inputplate.Thickness = 10;

paramsplate = struct();
obj = plate.Commonplate(paramsplate, inputplate);
obj = obj.solve();
```

### 场景4：创建带多个无干涉孔的板

```matlab
% 生成无干涉的孔位置
for i = 1:numHoles
    attempts = 0;
    while attempts < maxAttempts
        % 随机生成一个位置
        x = centerRegionXL + rand() * (centerRegionXH - centerRegionXL);
        y = centerRegionYL + rand() * (centerRegionYH - centerRegionYL);

        % 检查是否与现有孔干涉
        interferes = false;
        for j = 1:(i-1)
            dx = x - holePositions(j, 1);
            dy = y - holePositions(j, 2);
            distance = sqrt(dx^2 + dy^2);

            % 干涉判断：距离 < 2 * 半径（留2mm间隙）
            minDistance = 2 * holeRadius + 2;
            if distance < minDistance
                interferes = true;
                break;
            end
        end

        if ~interferes
            holePositions(i, :) = [x, y];
            break;
        end

        attempts = attempts + 1;
    end
end
```

## 高级功能

### 1. 实体模型 vs 壳模型

```matlab
% 实体模型（默认）
solidAss = obj.output.Assembly;
Plot(solidAss);

% 壳模型
shellAss = obj.output.Assembly1;
Plot(shellAss);
```

### 2. 导出 STL 文件

```matlab
OutputSTL(obj);
% 生成文件: Commonplate1.stl
```

### 3. 面变形

**注意**: 变形函数必须避免产生复数值

```matlab
% 正确的变形函数（避免复数）
f = @(r)(sqrt(max(360^2 - r.^2, 0)) - 360);
obj = DeformFace(obj, f, 1);  % 变形第1个面
```

## 注意事项

### 1. 材料设置

如果未指定材料，系统会使用默认钢材：

```matlab
% 使用默认材料
paramsplate = struct();
obj = plate.Commonplate(paramsplate, inputplate);

% 指定材料
S = RMaterial('FEA');
mat = GetMat(S, 1);
paramsplate.Material = mat{1,1};
obj = plate.Commonplate(paramsplate, inputplate);
```

### 2. 单位

所有长度单位均为毫米 (mm)

### 3. 网格控制

- `Meshsize`: 控制网格大小，值越小网格越细
- `Order`: 1=一阶（线性），2=二阶（二次），二阶精度更高但计算量更大
- `N_Slice`: 厚度方向的层数，影响实体网格精度

### 4. Point2D 点格式

**重要**: AddPoint 调用中，x 和 y 参数必须是列向量：

```matlab
% 正确：使用列向量
points = AddPoint(points, [x1; x2], [y1; y2]);

% 错误：使用行向量（会创建 1×4 矩阵，而非 2×2）
points = AddPoint(points, [x1, x2], [y1, y2]);
```

AddLine 函数期望 PP{P,1} 是一个 2×2 矩阵（2个点）。

## 相关文件

- Commonplate 类定义: `+plate/@Commonplate/Commonplate.m`
- 测试示例: `Testing/001_Demo/004_Commonplate/Demo_004_Commonplate.m`
- 测试报告: `Testing/001_Demo/004_Commonplate/TestReport_Commonplate.md`
- 文档: `Document/Commonplate.pdf`

## 相关类

- `Point2D`: 创建点
- `Line2D`: 创建线段和轮廓
- `Surface2D`: 创建二维截面
- `Assembly`: 三维装配体
- `Mesh`: 网格对象

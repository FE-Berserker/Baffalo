# Create 2D Lines (2D线条)

当用户要求创建2D线条（如：直线、圆弧、贝塞尔曲线、样条曲线等）时，使用此skill。

## 概述

`Line2D` 是一个用于创建和管理2D几何曲线的MATLAB类，支持：
- ✅ 直线 (LINE)
- ✅ 圆/圆弧 (CIRCLE)
- ✅ 椭圆 (ELLIPSE)
- ✅ 贝塞尔曲线 (BEZIER)
- ✅ B样条曲线 (BSPLINE)
- ✅ 样条曲线 (SPLINE)
- ✅ 抛物线 (PARABOLA)
- ✅ 双曲线 (HYPERBOLA)
- ✅ NURBS曲线 (NURB)
- ✅ 多边形 (POLYGON)
- ✅ 曲线求交
- ✅ 曲线长度计算
- ✅ 点压缩
- ✅ 箭头标注

## 类位置
```
dep/framework/@Line2D
```

## 使用前准备

### 1. 创建Point2D对象（存储点坐标）

```matlab
% 创建Point2D对象
Point = Point2D('MyPoints', 'Echo', 1, 'Dtol', 1e-5);

% 添加点 - 直角坐标
Point = AddPoint(Point, [0, 10], [0, 0]);  % 添加两个点：(0,0) 和 (10,0)

% 添加点 - 极坐标（弧度）
Point = AddPoint(Point, [5, 10], [0, pi/2], 'polar', 'rad');

% 添加点 - 极坐标（度）
Point = AddPoint(Point, [5, 10], [0, 90], 'polar', 'deg');

% 获取点数量
ng = GetNgpts(Point);  % 点组数量
np = GetNpts(Point);   % 总点数
```

### 2. 创建Line2D对象

```matlab
% 创建Line2D对象
L2D = Line2D('MyLines', ...
    'Echo', 1, ...       % 打印信息
    'Gtol', 0.04, ...    % 几何容差 h/d
    'Dtol', 1e-5, ...    % 距离容差
    'Atol', 1e-4, ...    % 绝对容差
    'Rtol', 1e-3, ...    % 相对容差
    'Adfac', 0.1, ...    % 箭头大小系数
    'Compress', 1, ...   % 是否压缩点
    'Arrow', [], ...     % 箭头样式
    'Form', 3);          % 箭头形式
```

## 曲线类型详解

### 1. 直线 (AddLine)

```matlab
% 添加点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0, 10], [0, 0]);  % 点1: (0,0), 点2: (10,0)

% 添加直线（使用点组1）
L2D = Line2D('MyLine');
L2D = AddLine(L2D, Point, 1);

% 绘制
Plot(L2D);
```

**数据格式**: `[x1, y1, x2, y2]` - 起点和终点坐标

---

### 2. 圆/圆弧 (AddCircle)

```matlab
% 添加圆心点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0], [0]);  % 圆心在 (0,0)

% 添加完整圆
L2D = Line2D('MyCircle');
L2D = AddCircle(L2D, 5, Point, 1);  % 半径=5，使用点组1

% 添加圆弧（指定起始角度和扫描角度）
L2D = AddCircle(L2D, 5, Point, 1, 'sang', 0, 'ang', 180);  % 半圆

% 添加1/4圆
L2D = AddCircle(L2D, 5, Point, 1, 'sang', 0, 'ang', 90);

% 指定分段数
L2D = AddCircle(L2D, 5, Point, 1, 'sang', 0, 'ang', 360, 'seg', 50);
```

**参数**:
- `r`: 半径
- `sang`: 起始角度（度，默认0）
- `ang`: 扫描角度（度，默认360）
- `seg`: 分段数（可选）

**数据格式**: `[r, xc, yc, sang, ang]`

---

### 3. 椭圆 (AddEllipse)

```matlab
% 添加中心点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0], [0]);  % 中心在 (0,0)

% 添加椭圆
L2D = Line2D('MyEllipse');
L2D = AddEllipse(L2D, 10, 6, 0, Point, 1);  % 长半轴=10，短半轴=6

% 添加椭圆弧
L2D = AddEllipse(L2D, 10, 6, 0, Point, 1, 'sang', 0, 'ang', 180);

% 旋转椭圆（旋转30度）
L2D = AddEllipse(L2D, 10, 6, 30, Point, 1);
```

**参数**:
- `a`: 长半轴
- `b`: 短半轴
- `rot`: 旋转角度（度，默认0）
- `sang`: 起始角度（度）
- `ang`: 扫描角度（度）

---

### 4. 贝塞尔曲线 (AddBezier)

```matlab
% 添加控制点
Point = Point2D('MyPoints');
% 二次贝塞尔（3个控制点）
Point = AddPoint(Point, [0, 2, 4], [0, 3, 0]);

% 三次贝塞尔（4个控制点）
Point = AddPoint(Point, [0, 1, 3, 4], [0, 2, 2, 0]);

% 添加贝塞尔曲线
L2D = Line2D('MyBezier');
L2D = AddBezier(L2D, Point, 1);  % 使用点组1
```

**要求**: 至少3个控制点

---

### 5. B样条曲线 (AddBspline)

```matlab
% 添加控制点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0, 1, 2, 3, 4], [0, 1, -0.5, 1, 0]);

% 添加B样条
L2D = Line2D('MyBspline');
knots = [0, 0, 0, 0.25, 0.5, 0.75, 1, 1, 1];  % 节点向量
L2D = AddBspline(L2D, 3, knots, Point, 1);  % 阶数=3，使用点组1
```

**参数**:
- `order`: B样条阶数
- `knots`: 节点向量

---

### 6. 样条曲线 (AddSpline)

```matlab
% 添加控制点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0, 1, 2, 3, 4], [0, 1, 0.5, -0.5, 0]);

% 添加样条曲线
L2D = Line2D('MySpline');
L2D = AddSpline(L2D, Point, 1);  % 使用点组1
```

---

### 7. 抛物线 (AddParabola)

```matlab
% 添加顶点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0], [0]);  % 顶点在 (0,0)

% 添加抛物线
L2D = Line2D('MyParabola');
L2D = AddParabola(L2D, 2, Point, 1);  % 焦距参数=2

% 指定参数范围
L2D = AddParabola(L2D, 2, Point, 1, 't1', -2, 't2', 2);
```

**参数**:
- `f`: 焦距参数
- `t1`, `t2`: 参数范围

---

### 8. 双曲线 (AddHyperbola)

```matlab
% 添加中心点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0], [0]);  % 中心在 (0,0)

% 添加双曲线
L2D = Line2D('MyHyperbola');
L2D = AddHyperbola(L2D, 3, 2, 0, Point, 1);  % a=3, b=2, 旋转=0

% 指定参数范围
L2D = AddHyperbola(L2D, 3, 2, 0, Point, 1, 't1', -1.5, 't2', 1.5);
```

**参数**:
- `a`: 横向半轴
- `b`: 纵向半轴
- `rot`: 旋转角度（度）
- `t1`, `t2`: 参数范围

---

### 9. NURBS曲线 (AddNurb)

```matlab
% 添加NURBS曲线
L2D = Line2D('MyNurb');

% 控制点 (x, y) 每列一个控制点
coefs = [0, 1, 2, 3, 4;
         0, 1, 0.5, 1, 0];

% 节点向量
knots = [0, 0, 0, 0.25, 0.5, 0.75, 1, 1, 1];

% 添加NURBS
L2D = AddNurb(L2D, coefs, knots, 'seg', 50);
```

**参数**:
- `coefs`: 控制点矩阵 (2×n 或 3×n)
- `knots`: 节点向量
- `seg`: 分段数（可选）

---

### 10. 多边形 (AddPolygon)

```matlab
% 添加顶点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0, 1, 1, 0], [0, 0, 1, 1]);  % 矩形

% 添加多边形
L2D = Line2D('MyPolygon');
L2D = AddPolygon(L2D, Point, 1);
```

---

### 11. 圆角多边形 (AddRoundPolygon)

```matlab
% 添加顶点
Point = Point2D('MyPoints');
Point = AddPoint(Point, [0, 5, 5, 0], [0, 0, 5, 5]);

% 添加圆角多边形
L2D = Line2D('MyRoundPolygon');
L2D = AddRoundPolygon(L2D, 0.5, Point, 1);  % 圆角半径=0.5
```

---

### 12. 星形 (AddStar)

```matlab
% 添加星形（不需要Point2D对象）
L2D = Line2D('MyStar');
L2D = AddStar(L2D, 5, 5, 'sang', -90);  % 5角星，半径=5，起始角度=-90度（从顶部开始）

% 7角星
L2D = AddStar(L2D, 7, 5, 'sang', -90);

% 6角星
L2D = AddStar(L2D, 6, 5, 'sang', -90);
```

**参数**:
- `N`: 顶点数量（5=五角星，6=六角星，7=七角星...）
- `r`: 半径
- `sang`: 起始角度（度，默认0）
- `close`: 是否闭合（默认1）

**注意**: AddStar通过内部算法生成星形图案，不需要单独指定内外半径。如需自定义内外半径，请使用填充星形脚本 `draw_filled_star.m`。

---

## 绘图选项

### 基本绘图

```matlab
% 基本绘图
Plot(L2D);

% 显示网格
Plot(L2D, 'grid', 1);

% 等比例显示
Plot(L2D, 'equal', 1);

% 不显示坐标轴
Plot(L2D, 'axe', 0);

% 使用颜色
Plot(L2D, 'color', 1);

% 指定颜色映射
Plot(L2D, 'map', 'lch');

% 设置坐标范围
Plot(L2D, 'xlim', [0, 10], 'ylim', [0, 10]);

% 只绘制特定曲线
Plot(L2D, 'crv', [1, 3, 5]);  % 绘制第1、3、5条曲线
```

### 曲线标签

```matlab
% 显示曲线标签
Plot(L2D, 'clabel', 1);

% 自定义样式
styles = {'-', '--', ':', '-.'};
Plot(L2D, 'clabel', 1, 'styles', styles);
```

### 箭头标注

```matlab
% 创建带箭头的曲线
L2D = Line2D('MyLine', 'Arrow', [1, 3], 'Form', 3);  % 第1和第3条曲线加箭头
L2D = AddLine(L2D, Point, 1);
L2D = AddLine(L2D, Point, 2);
L2D = AddLine(L2D, Point, 3);

% 绘制
Plot(L2D);
```

**箭头形式**:
- `1`: 实线箭头
- `2`: 空心箭头
- `3`: 实心箭头（默认）

---

## 高级功能

### 1. 曲线长度

```matlab
% 获取曲线数量
N = GetNcrv(L2D);

% 获取特定曲线
c = GetCurve(L2D, 1);  % 获取第1条曲线
% c.type: 曲线类型
% c.data: 曲线数据

% 曲线长度存储在对象中
fprintf('Curve 1 length: %g\n', L2D.CL(1));
fprintf('Curve 1 segments: %d\n', L2D.CN(1));
fprintf('Curve 1 max h/d: %g\n', L2D.CHD(1));
```

### 2. 曲线求交

```matlab
% 计算两条曲线的交点
L2D = Line2D('IntersectionTest');
L2D = AddCircle(L2D, 5, Point, 1);
L2D = AddLine(L2D, Point, 2);

% 计算交点
intersections = CurveIntersection(L2D, 1, 2);
```

### 3. 曲线平移

```matlab
% 平移所有曲线
L2D = Shift(L2D, [10, 5]);  % x方向平移10，y方向平移5
```

### 4. 删除曲线

```matlab
% 删除指定曲线
L2D = DeleteCurve(L2D, 2);  % 删除第2条曲线
```

### 5. 重构曲线

```matlab
% 重构曲线（改变分段数）
L2D = RebuildCurve(L2D, 1, 'seg', 100);  # 重构第1条曲线为100段
```

### 6. 边界框

```matlab
% 获取所有曲线的边界框
bbox = BoundingBox(L2D);
% bbox: [xmin, ymin, xmax, ymax]
```

### 7. 边界

```matlab
% 获取边界曲线
boundary = Boundary(L2D);
```

### 8. 圆弧拟合

```matlab
% 拟合圆弧到点集
Point = Point2D('FittedPoints');
% 添加点...
L2D = Line2D('Fitted');
[center, radius, residual] = CircleFit(L2D, Point);
```

### 9. 拱形拟合

```matlab
% 拟合拱形
[arch_data] = ArchFit(L2D, points, tolerance);
```

---

## 完整示例

### 示例1：绘制基本几何图形

```matlab
% 创建点对象
Point = Point2D('GeometryPoints');

% 添加直线端点
Point = AddPoint(Point, [0, 10], [0, 0]);

% 添加圆心
Point = AddPoint(Point, [5], [5]);

% 添加椭圆中心
Point = AddPoint(Point, [15], [5]);

% 创建Line2D对象
L2D = Line2D('BasicGeometry', 'Echo', 1);

% 添加直线
L2D = AddLine(L2D, Point, 1);

% 添加圆
L2D = AddCircle(L2D, 3, Point, 2);

% 添加椭圆
L2D = AddEllipse(L2D, 4, 2, 0, Point, 3);

% 绘制
Plot(L2D, 'grid', 1, 'equal', 1, 'color', 1);
```

### 示例2：绘制贝塞尔曲线和样条

```matlab
% 创建控制点
Point = Point2D('ControlPoints');

% 贝塞尔控制点
Point = AddPoint(Point, [0, 2, 4, 6], [0, 3, -2, 1]);

% 样条控制点
Point = AddPoint(Point, [0, 1, 2, 3, 4, 5], [0, 1, 0.5, -0.5, 0.8, 0]);

% 创建Line2D对象
L2D = Line2D('Curves', 'Echo', 1);

% 添加贝塞尔曲线
L2D = AddBezier(L2D, Point, 1);

% 添加样条曲线
L2D = AddSpline(L2D, Point, 2);

% 绘制
Plot(L2D, 'grid', 1, 'clabel', 1, 'styles', {'-', '--'});
```

### 示例3：绘制圆角矩形

```matlab
% 创建顶点
Point = Point2D('Rectangle');
Point = AddPoint(Point, [0, 10, 10, 0], [0, 0, 8, 8]);

% 创建Line2D对象
L2D = Line2D('RoundedRect', 'Echo', 1);

% 添加圆角矩形
L2D = AddRoundPolygon(L2D, 1, Point, 1);

% 绘制
Plot(L2D, 'equal', 1, 'grid', 1);
```

### 示例4：绘制NURBS曲线

```matlab
% 创建Line2D对象
L2D = Line2D('NurbsCurve', 'Echo', 1);

% 定义控制点
coefs = [0, 0.5, 1, 1.5, 2, 2.5, 3;
         0, 1,   0, 0.5, 0, 0.5, 0];

% 定义节点向量
knots = [0, 0, 0, 0, 0.25, 0.5, 0.75, 1, 1, 1, 1];

% 添加NURBS曲线
L2D = AddNurb(L2D, coefs, knots, 'seg', 100);

% 绘制
Plot(L2D, 'grid', 1);
```

### 示例5：多条曲线组合

```matlab
% 创建点对象
Point = Point2D('ComboPoints');

% 点组1：直线
Point = AddPoint(Point, [0, 5], [0, 0]);

% 点组2：半圆
Point = AddPoint(Point, [5], [0]);

% 点组3：另一半圆
Point = AddPoint(Point, [0], [0]);

% 创建Line2D对象（带箭头）
L2D = Line2D('Combo', 'Echo', 1, 'Arrow', [1, 2, 3], 'Form', 3);

% 添加曲线
L2D = AddLine(L2D, Point, 1);
L2D = AddCircle(L2D, 2.5, Point, 2, 'sang', 0, 'ang', 180);
L2D = AddCircle(L2D, 2.5, Point, 3, 'sang', 180, 'ang', 180);

% 绘制
Plot(L2D, 'equal', 1, 'clabel', 1, 'color', 1);
```

### 示例6：抛物线和双曲线

```matlab
% 创建点对象
Point = Point2D('ConicPoints');

% 抛物线顶点
Point = AddPoint(Point, [0], [0]);

% 双曲线中心
Point = AddPoint(Point, [10], [0]);

% 创建Line2D对象
L2D = Line2D('ConicSections', 'Echo', 1);

% 添加抛物线
L2D = AddParabola(L2D, 1, Point, 1, 't1', -2, 't2', 2);

% 添加双曲线
L2D = AddHyperbola(L2D, 2, 1.5, 0, Point, 2, 't1', -1, 't2', 1);

% 绘制
Plot(L2D, 'grid', 1, 'equal', 1, 'clabel', 1);
```

---

## 导出功能

### VTK导出

```matlab
% 导出为VTK文件
L2D.VTKWrite = 1;
L2D = VTKWrite(L2D, 'output.vtk');
```

---

## 输出网格

```matlab
% 设置输出到Mesh
L2D.Meshoutput = 1;
L2D = Meshoutput(L2D);
```

---

## 参数说明

### 构造函数参数 (Line2D)

| 参数 | 类型 | 默认值 | 说明 |
|------|------|---------|------|
| `Echo` | int | 1 | 是否打印信息：0=不打印，1=打印 |
| `Gtol` | double | 0.04 | 几何容差 h/d（曲线平滑度） |
| `Dtol` | double | 1e-5 | 距离容差（点重复检测） |
| `Atol` | double | 1e-4 | 绝对容差（对象比较） |
| `Rtol` | double | 1e-3 | 相对容差（数值计算） |
| `Adfac` | double | 0.1 | 箭头大小系数 |
| `Compress` | int | 1 | 是否压缩重复点：0=不压缩，1=压缩 |
| `Arrow` | vector | [] | 需要添加箭头的曲线索引 |
| `Form` | int | 3 | 箭头形式：1=实线，2=空心，3=实心 |

### Plot参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|---------|------|
| `grid` | int | 0 | 是否显示网格 |
| `axe` | int | 1 | 是否显示坐标轴 |
| `clabel` | int | 0 | 是否显示曲线标签 |
| `equal` | int | 0 | 是否等比例显示 |
| `color` | int | 0 | 是否使用颜色：0=黑色，1=彩色 |
| `map` | string | 'lch' | 颜色映射类型 |
| `styles` | cell | [] | 线条样式（如{'-', '--', ':', '-.'}） |
| `crv` | vector | [] | 指定绘制的曲线索引 |
| `xlim` | [min, max] | [] | X轴范围 |
| `ylim` | [min, max] | [] | Y轴范围 |

---

## 常见问题

### Q: 如何获取曲线上的点？

```matlab
% 获取曲线的多项式近似
[x, y] = PolyCurve(L2D, 1);  % 获取第1条曲线的点
```

### Q: 如何检查曲线是否自相交？

```matlab
% 曲线自相交检测存储在L2D.CJ中
if L2D.CJ(1) == false
    fprintf('Curve 1 is self-intersecting\n');
end
```

### Q: 如何设置曲线颜色？

```matlab
% 设置单元数据（用于颜色映射）
L2D = AddCellData(L2D, [1, 2, 3, 4, 5]);  % 为每条曲线设置值
Plot(L2D, 'color', 1);  % 使用颜色映射
```

### Q: 如何获取曲线中点？

```matlab
% 曲线中点用于标签位置，存储在L2D.MP中
mp = L2D.MP(1, :);  % 第1条曲线的中点
```

---

## 注意事项

1. **Point2D与Line2D的关系**: Line2D依赖于Point2D对象来存储点坐标
2. **点索引**: AddCurve函数使用Point2D中的点组索引（第几个PP）
3. **曲线编号**: 曲线按添加顺序编号，从1开始
4. **容差设置**: Dtol过小可能导致点压缩失败，Gtol过小可能导致曲线分段过多
5. **自相交**: 某些曲线类型可能自相交，检查L2D.CJ属性
6. **封闭曲线**: 使用checkCurveClose检查曲线是否形成封闭环

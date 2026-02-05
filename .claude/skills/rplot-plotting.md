# Rplot 绘图框架

当用户要求绘制图表、可视化数据、创建图形时，优先使用此框架中的 Rplot 类。

## 使用场景

当用户提出以下请求时触发此技能：
- "绘制...图"
- "可视化...数据"
- "创建图表"
- "plot", "figure", "graph"
- 绘制散点图、折线图、柱状图、箱线图等

## 类概述

**类名**: `Rplot`
**作者**: Yu Xie 2023
**路径**: `dep\framework\@Rplot\Rplot.m`
**用途**: 灵感来源于 R 的 ggplot2 的绘图框架，支持语法化的数据可视化

### 核心概念

Rplot 使用"图形语法"（Grammar of Graphics）的理念，通过以下元素构建图表：
1. **Data** - 数据（通过 aes 参数传递）
2. **Aesthetics (aes)** - 美学映射（x, y, color, size, marker, linestyle 等）
3. **Geoms** - 几何图层（geom_point, geom_line, geom_bar 等）
4. **Stats** - 统计变换（stat_smooth, stat_boxplot 等）
5. **Facets** - 分面（facet_grid, facet_wrap）

## 基本用法

### 1. 创建 Rplot 对象

```matlab
% 基本语法
obj = Rplot('x', x, 'y', y);

% 带颜色映射
obj = Rplot('x', x, 'y', y, 'color', colorVar);

% 带多重美学映射
obj = Rplot('x', x, 'y', y, ...
    'color', colors, ...
    'size', sizes, ...
    'marker', markers);
```

**参数说明**:
- `'x'` - x 轴数据（数值数组或 cell 数组）
- `'y'` - y 轴数据（数值数组）
- `'color'` - 颜色映射数据
- `'lightness'` - 亮度映射数据
- `'linestyle'` - 线型映射数据
- `'size'` - 大小映射数据
- `'marker'` - 标记形状映射数据
- `'group'` - 分组数据
- `'label'` - 标签文本
- `'row'`, `'column'` - 分面行列数据

### 2. 添加几何图层

```matlab
% 散点图
obj = obj.geom_point();

% 折线图
obj = obj.geom_line();

% 柱状图
obj = obj.geom_bar();

% 组合图层
obj = obj.geom_point();
obj = obj.geom_line();
```

### 3. 绘制图形

```matlab
% 绘制图形
obj.draw();

% 带分面的绘图
obj.facet_grid('row_var', 'col_var');
obj.draw();

% 包裹分面
obj.facet_wrap('col_var');
obj.draw();
```

## 常见图表类型

### 散点图

```matlab
obj = Rplot('x', x, 'y', y, 'color', categories);
obj = obj.geom_point();
obj.draw();
```

### 折线图

```matlab
obj = Rplot('x', x, 'y', y, 'linestyle', lineTypes);
obj = obj.geom_line();
obj.draw();
```

### 带平滑曲线的折线图

```matlab
obj = Rplot('x', x, 'y', y, 'color', colors);
obj = obj.geom_point();
obj = obj.stat_smooth();
obj.draw();
```

### 箱线图

```matlab
obj = Rplot('x', categories, 'y', values, 'color', groups);
obj = obj.stat_boxplot();
obj.draw();
```

### 密度图

```matlab
obj = Rplot('x', data, 'color', groups);
obj = obj.stat_density();
obj.draw();
```

### 小提琴图

```matlab
obj = Rplot('x', categories, 'y', values, 'color', groups);
obj = obj.stat_violin();
obj.draw();
```

## 可用的几何图层 (geom)

| 函数 | 说明 |
|------|------|
| `geom_point` | 散点图 |
| `geom_line` | 折线图 |
| `geom_bar` | 柱状图 |
| `geom_polygon` | 多边形 |
| `geom_label` | 标签 |
| `geom_jitter` | 抖动散点图 |
| `geom_raster` | 光栅图/热力图 |
| `geom_interval` | 区间图（误差条） |

## 可用的统计变换 (stat)

| 函数 | 说明 |
|------|------|
| `stat_smooth` | 平滑曲线（loess, glm） |
| `stat_boxplot` | 箱线图 |
| `stat_density` | 密度估计 |
| `stat_violin` | 小提琴图 |
| `stat_ellipse` | 椭圆（置信区间） |
| `stat_summary` | 统计汇总 |
| `stat_bin` | 直方图分箱 |
| `stat_bin2d` | 二维直方图 |
| `stat_qq` | Q-Q 图 |

## 自定义选项

### 颜色选项

```matlab
obj = obj.set_color_options('map', 'lch', 'legend', 'merge');
```

### 点选项

```matlab
obj = obj.set_point_options('markers', {'o', 's', 'd', '^', 'v'});
```

### 线选项

```matlab
obj = obj.set_line_options('styles', {'-', '--', ':', '-.'});
```

### 文本选项

```matlab
obj = obj.set_text_options('font', 'Arial', 'base_size', 12);
```

### 布局选项

```matlab
obj = obj.set_layout_options('gap', [0.02, 0.02], ...
    'margin_height', [0.05, 0.1], ...
    'margin_width', [0.05, 0.1]);
```

### 标题

```matlab
obj = obj.set_title('My Plot Title');
```

## 分面功能

### 网格分面 (facet_grid)

```matlab
obj = obj.facet_grid('rowVar', 'colVar');
```

### 包裹分面 (facet_wrap)

```matlab
obj = obj.facet_wrap('colVar');
obj.wrap_ncols = 3;  % 每行3个子图
```

## 连续颜色映射

```matlab
obj = Rplot('x', x, 'y', y, 'color', continuousValue);
obj = obj.set_continuous_color('active', true, 'colormap', parula);
obj = obj.geom_point();
obj.draw();
```

## 3D 绘图

```matlab
obj = Rplot('x', x, 'y', y, 'z', z, 'color', colorVar);
obj = obj.geom_point();
obj.draw();
```

## 与 MATLAB 原生绘图的对比

| 功能 | MATLAB 原生 | Rplot |
|------|------------|-------|
| 散点图 | `scatter(x,y)` | `Rplot('x',x,'y',y).geom_point().draw()` |
| 折线图 | `plot(x,y)` | `Rplot('x',x,'y',y).geom_line().draw()` |
| 颜色分组 | 需要循环 | 直接映射 `'color'` 参数 |
| 分面图 | 使用 `subplot` | 使用 `facet_grid`/`facet_wrap` |
| 美学映射 | 手动设置 | 统一的 aes 系统 |
| 图例 | 需要手动管理 | 自动生成 |

## 最佳实践

1. **优先使用 Rplot** - 对于大多数数据可视化任务，Rplot 提供了更一致的语法和更强大的功能

2. **链式调用** - Rplot 方法返回对象本身，支持链式调用：
   ```matlab
   Rplot('x', x, 'y', y, 'color', colorVar).geom_point().draw();
   ```

3. **美学映射** - 通过 aes 参数控制视觉属性，而不是手动设置颜色/标记

4. **分面** - 使用 `facet_grid` 或 `facet_wrap` 创建多子图，而不是手动使用 `subplot`

5. **图层叠加** - 可以添加多个 geom 层来组合不同类型的图形

## 何时使用 MATLAB 原生绘图

仅在某些特殊情况下使用 MATLAB 原生绘图函数：
- 需要极低级别的图形控制
- 与现有代码紧密集成的场景
- Rplot 不支持的特殊图形类型

## 保存图形

使用 `save_image` 方法保存图形到文件：

```matlab
obj = Rplot('x', x, 'y', y);
obj = geom_line(obj);
obj = obj.set_title('My Plot');
draw(obj);
obj.save_image('output.png');                    % 保存为PNG
obj.save_image('output.jpg', 'format', 'jpg');   % 保存为JPG
obj.save_image('output.pdf', 'format', 'pdf');   % 保存为PDF
obj.save_image('output.png', 'resolution', '600');  % 高分辨率 (600 DPI)
obj.save_image('output.png', 'closefig', true);  % 保存后关闭图形
```

**支持的格式**: PNG, JPG, JPEG, TIF/TIFF, BMP, EPS, PDF, SVG, FIG

**参数**:
- `filename` - 文件名（可以是相对或绝对路径）
- `format` - 图片格式（默认根据扩展名自动检测）
- `resolution` - 分辨率：'screen', '150', '300', '600', '1200' 或数值DPI
- `closefig` - 保存后是否关闭图形（默认 false）

## 常见错误和陷阱

### 1. 必须指定几何图层 (geom)

**错误示例**:
```matlab
g = Rplot('x', x, 'y', y);
draw(g);  % 错误：没有几何图层，图形为空
```

**正确示例**:
```matlab
g = Rplot('x', x, 'y', y);
g = geom_line(g);  % 必须添加几何图层
draw(g);
```

### 2. draw() 的正确语法

**错误示例**:
```matlab
g = geom_line(g);
g = g.draw();  % 错误：draw() 不返回值，不能赋值
```

**正确示例**:
```matlab
g = geom_line(g);
draw(g);  % 使用函数调用语法
```

注意：`draw()` 函数不返回对象，使用 `draw(g)` 而非 `g.draw()` 或 `g = g.draw()`。

### 3. geom_ 函数的正确语法

**推荐语法**:
```matlab
g = Rplot('x', x, 'y', y);
g = geom_line(g);  % 函数调用语法
draw(g);
```

虽然 `g = g.geom_line()` 链式调用也可用，但函数调用 `geom_line(g)` 更可靠。

### 4. save_image 必须在 draw() 之后调用

```matlab
g = Rplot('x', x, 'y', y);
g = geom_line(g);
draw(g);            % 先绘制
g.save_image('out.png');  % 后保存
```

## 重要提示

- Rplot 位于 `dep\framework\@Rplot\` 目录
- 私有辅助函数在 `dep\framework\@Rplot\private\` 目录
- 遵循项目的 MATLAB 编码规范（使用 `%` 注释，字符串用双引号）
- 类继承自 `matlab.mixin.Copyable`，支持对象复制
- **必须指定 geom 类型**：`geom_line`, `geom_point`, `geom_bar` 等，否则图形为空
- **使用 draw(g) 而非 g.draw()**：draw 函数不返回值

---
name: create-function-document
description: 为 MATLAB 函数/类创建符合格式的说明文档
---

# 创建函数说明文档

当用户要求为函数或类创建说明文档时使用此技能。

## 文档格式要求

参考案例文件: `.claude\skills\Document\reference\Example.md`

### 标准模板结构

```markdown
---
tags:
  - Baffalo_Component
---
# 函数名称

<center>作者</center>

## 介绍

类/函数的基本说明

## 原理

[可选] 原理说明

## 类结构

![图表](./文件名.assets/FigX.jpg)

==输入 input:==

* input1 : 输入参数说明

==参数 params:==

* param1 : 参数说明

==输出 output :==

* output1 : 输出说明

==基准 Baseline：==

* baseline1 : 基准说明

==安全裕度 Capacity :==

* capacity1 : 容量说明

## 案例

### 案例名称

案例介绍：

图表：

源代码：

``` matlab
% 代码示例
```

## 参考文献

[1] 参考文献1

[2] 参考文献2
```

## 执行步骤

### 第一步：询问函数的路径

使用 `AskUserQuestion` 工具询问用户要文档化的函数路径。

```
请提供要创建文档的函数/类路径（例如：dep/framework/@Component/Component.m）
```

如果用户提供的路径是相对路径或不存在，使用 `Glob` 工具搜索文件。

### 第二步：读取函数代码

使用 `Read` 工具读取函数代码，分析：
- 函数/类名称
- 作者信息
- 属性列表（input, params, output, baseline, capacity）
- 主要方法

### 第三步：询问案例所在路径

使用 `AskUserQuestion` 工具询问用户案例文件的位置。

```
请提供案例文件路径（例如：Testing/001_Demo/066_RectangularRubberStack/test.m）
```

### 第四步：读取案例代码

使用 `Read` 工具读取案例代码，提取：
- 输入参数设置
- 函数调用示例
- 可视化代码（Plot2D, Plot3D 等）
- 输出结果

### 第五步：生成文档

根据模板和提取的信息生成 Markdown 文档：
1. 文档标题使用函数/类名称
2. 作者信息从代码注释中提取
3. 填充各个结构部分
4. 包含案例代码示例
5. 添加图表占位符（使用 `![图表](./文件夹名.assets/FigX.jpg)` 格式）

### 第六步：确定保存路径

默认保存到 `Document/` 目录，文件名为 `{类名}.md`。
如果该目录不存在，创建目录。

### 第七步：写入文档

使用 `Write` 工具创建文档文件。

## 注意事项

1. **图表占位符**：使用 `./文件夹名.assets/FigX.jpg` 格式，`文件夹名` 是文档对应的文件夹名称（去掉 .md 后缀）
2. **作者信息**：从代码注释中提取，格式为 `<center>作者</center>`
3. **字段说明**：从代码注释中提取每个字段的说明文字
4. **案例代码**：使用 MATLAB 语法高亮
5. **参考文献**：如果代码中有引用参考文献，添加到文档末尾

## 示例交互

```
用户：给 Component 类创建说明文档

助手：请提供要创建文档的函数/类路径（例如：dep/framework/@Component/Component.m）
用户：dep/framework/@Component/Component.m

[读取代码...]

助手：请提供案例文件路径（例如：Testing/001_Demo/066_RectangularRubberStack/test.m）
用户：Testing/002_Module/test_plot_save.m

[读取案例...]

[生成文档...]

助手：文档已创建：Document/Component.md
```

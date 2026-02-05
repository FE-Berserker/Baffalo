# MarkdownReport 报告生成

当用户要求为程序添加输出报告、生成分析报告、导出结果文档时，使用此技能中的 MarkdownReport 类。

## 使用场景

当用户提出以下请求时触发此技能：
- "为程序添加输出报告功能"
- "生成分析报告"
- "导出结果为Markdown"
- "创建技术文档"
- "添加图表到报告"
- "生成测试报告"
- "导出计算结果"

## 类概述

**类名**: `MarkdownReport`
**作者**: Xie Yu
**路径**: `dep\framework\@MarkdownReport\MarkdownReport.m`
**用途**: 生成 Markdown 格式的技术报告，支持标题、表格、图片、列表、代码块等内容

**设计特点**:
- **独立基类** - 不继承自 Component（文档生成 vs 工程计算用途不同）
- **链式调用** - 所有添加方法返回 `obj`，支持流畅接口
- **自动编号** - 图片自动编号（Figure 1, Figure 2, ...）
- **Rplot 集成** - 无缝集成 Rplot 绘图框架
- **双语支持** - 支持中文和英文混合文本

## 核心属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| content | cell数组 | {} | 报告内容 |
| title | 字符串 | '' | 报告标题 |
| author | 字符串 | '' | 报告作者 |
| date | 字符串 | 当前日期 | 报告日期 |
| filepath | 字符串 | '' | 输出文件路径 |
| filename | 字符串 | 'report.md' | 输出文件名 |
| imageDir | 字符串 | 'images' | 图片目录 |
| imageCounter | 整数 | 0 | 图片计数器 |
| autoNumberImages | 逻辑值 | true | 自动编号图片 |
| autoSave | 逻辑值 | false | 导出时自动保存 |

## 内容添加方法

### 1. addTitle - 添加标题

```matlab
report = report.addTitle('标题文本', level);
```

**参数**:
- `titleText`: 标题文本（字符串）
- `level`: 标题级别（1-5，默认 1）
  - 1: `#` - 主标题
  - 2: `##` - 副标题
  - 3: `###` - 三级标题
  - 4: `####` - 四级标题
  - 5: `#####` - 五级标题

**示例**:
```matlab
report = report.addTitle('项目概述', 2);
report = report.addTitle('Project Overview', 3);
```

### 2. addParagraph - 添加段落

```matlab
report = report.addParagraph(text);
```

**参数**:
- `text`: 段落文本（字符串或 cell 数组）

**示例**:
```matlab
% 单行段落
report = report.addParagraph('这是一个测试段落。');

% 多行段落
report = report.addParagraph({...
    '第一行文本', ...
    '第二行文本', ...
    'Third line of text' ...
});
```

### 3. addHorizontalRule - 添加水平分割线

```matlab
report = report.addHorizontalRule();
```

生成: `---`

**示例**:
```matlab
report = report.addParagraph('上面部分');
report = report.addHorizontalRule();
report = report.addParagraph('下面部分');
```

### 4. addList - 添加列表

```matlab
report = report.addList(items, isOrdered);
```

**参数**:
- `items`: 列表项（cell 数组）
- `isOrdered`: 是否为有序列表（默认 false）

**示例**:
```matlab
% 无序列表
items = {'项目A', '项目B', '项目C'};
report = report.addList(items, false);

% 有序列表
steps = {'步骤1：初始化', '步骤2：计算', '步骤3：输出'};
report = report.addList(steps, true);
```

### 5. addBold / addItalic - 文本格式化

```matlab
report = report.addBold('粗体文本');
report = report.addItalic('斜体文本');
```

**示例**:
```matlab
report = report.addBold('重要提示');
report = report.addItalic('参考说明');
```

### 6. addCodeBlock - 添加代码块

```matlab
report = report.addCodeBlock(code, language);
```

**参数**:
- `code`: 代码内容（字符串或 cell 数组）
- `language`: 语言标识符（默认 'matlab'）

**支持的语法高亮**: matlab, python, javascript, c, cpp, java, bash 等

**示例**:
```matlab
% 单行代码
report = report.addCodeBlock('x = 1:10;', 'matlab');

% 多行代码
codeLines = {
    'x = 1:10;',
    'y = sin(x);',
    'plot(x, y);'
};
report = report.addCodeBlock(codeLines, 'matlab');
```

### 7. addInlineCode - 添加行内代码

```matlab
report = report.addInlineCode('inline code');
```

**示例**:
```matlab
report = report.addParagraph('使用 `addTitle` 方法添加标题。');
```

### 8. addQuote - 添加引用块

```matlab
report = report.addQuote(text);
```

**示例**:
```matlab
report = report.addQuote('这是一个重要的引用内容。');
```

## 表格方法

### 1. addTable - 从 MATLAB table 添加表格

```matlab
report = report.addTable(matlabTable, caption);
```

**参数**:
- `matlabTable`: MATLAB table 对象
- `caption`: 表格标题（可选）

**示例**:
```matlab
% 创建 MATLAB table
dataTable = table(
    [1.23; 4.56; 7.89],
    [10; 20; 30],
    'VariableNames', {'Parameter', 'Value'}
);

% 添加到报告
report = report.addTable(dataTable, '测试数据');
```

### 2. addTableFromStruct - 从结构体添加表格

```matlab
report = report.addTableFromStruct(structData, keyLabel, valueLabel);
```

**参数**:
- `structData`: 结构体数据
- `keyLabel`: 键列标签（默认 'Parameter'）
- `valueLabel`: 值列标签（默认 'Value'）

**示例**:
```matlab
% 创建参数结构体
params = struct(...
    'Material', 'Steel', ...
    'Thickness', 30, ...
    'Length', 1000, ...
    'Width', 500 ...
);

% 添加到报告（自定义列标题）
report = report.addTableFromStruct(params, '参数', '值');
```

### 3. addCustomTable - 添加自定义表格

```matlab
report = report.addCustomTable(headers, data, alignments, caption);
```

**参数**:
- `headers`: 列标题（cell 数组）
- `data`: 数据（cell 数组或矩阵，行×列）
- `alignments`: 对齐标记（cell 数组，可选）
  - `:---`: 左对齐
  - `:---:`: 居中对齐
  - `---:`: 右对齐
- `caption`: 表格标题（可选）

**示例**:
```matlab
% 创建自定义表格
headers = {'名称', '数值', '单位'};
data = {
    '测试A', 10.5, 'mm';
    '测试B', 20.3, 'mm';
    '测试C', 30.7, 'mm'
};
alignments = {':---', ':---:', '---:'};

report = report.addCustomTable(headers, data, alignments, '测试结果');
```

## 图片方法

### 1. addImage - 添加图片链接

```matlab
[obj, imagePath] = report.addImage(imagePath, caption, altText);
```

**参数**:
- `imagePath`: 图片路径（相对或绝对路径）
- `caption`: 图片标题（可选）
- `altText`: 替代文本（可选，默认 'Image'）

**路径格式**: 使用相对于 .md 文件的路径，推荐使用 `images/` 子目录

**示例**:
```matlab
report = report.addImage('images/result.png', '应力分布图', '应力云图');
```

### 2. addImageFromRplot - 从 Rplot 对象添加图片

```matlab
[obj, imagePath] = report.addImageFromRplot(rplotObj, caption, varargin);
```

**参数**:
- `rplotObj`: Rplot 对象
- `caption`: 图片标题
- `varargin`: 可选参数
  - `'filename'`: 自定义文件名（不含扩展名）
  - `'format'`: 图片格式（默认 'png'）
  - `'resolution'`: 分辨率（默认 'screen'）

**功能**:
- 自动创建图片目录（默认 `images/`）
- 自动编号图片文件名
- 保存 Rplot 图形
- 添加图片链接到报告

**示例**:
```matlab
% 创建 Rplot 图形
x = 1:10;
y = sin(x);
g = Rplot('x', x, 'y', y);
g = g.geom_line();
g = g.set_title('Sine Wave');
draw(g);

% 添加到报告
[report, path] = report.addImageFromRplot(g, '正弦波图');
close(gcf);
```

**带自定义参数**:
```matlab
% 高分辨率保存
[report, path] = report.addImageFromRplot(g, '高精度图', ...
    'filename', 'high_res', ...
    'format', 'png', ...
    'resolution', '600');
```

### 3. addImageFromFigure - 从 MATLAB figure 添加图片

```matlab
[obj, imagePath] = report.addImageFromFigure(figHandle, caption, varargin);
```

**参数**:
- `figHandle`: Figure 句柄（默认当前图形）
- `caption`: 图片标题
- `varargin`: 可选参数
  - `'filename'`: 自定义文件名
  - `'format'`: 图片格式（默认 'png'）
  - `'resolution'`: 分辨率（默认 300 DPI）

**示例**:
```matlab
% 创建 MATLAB figure
fig = figure('Name', 'My Plot');
plot(1:10, sin(1:10));
xlabel('x');
ylabel('y');
title('Sine Wave');

% 添加到报告（自动保存 figure）
[report, path] = report.addImageFromFigure(fig, '正弦波');
% 图形保持打开状态
```

**使用当前 figure**:
```matlab
% 直接使用当前 figure
plot(1:10, cos(1:10));
[report, path] = report.addImageFromFigure(gcf, '余弦波');
```

**带分辨率控制**:
```matlab
[report, path] = report.addImageFromFigure(fig, '高精度图', ...
    'filename', 'output', ...
    'format', 'jpg', ...
    'resolution', 600);
```

## 报告生成方法

### 1. getContent - 获取报告内容

```matlab
contentStr = report.getContent();
```

返回报告的完整内容字符串。

**示例**:
```matlab
% 获取报告内容
reportContent = report.getContent();
fprintf('%s\n', reportContent);
```

### 2. preview - 预览报告

```matlab
report.preview(numLines);
```

**参数**:
- `numLines`: 预览行数（默认所有行）

**示例**:
```matlab
% 预览前 20 行
report.preview(20);
```

### 3. export - 导出报告

```matlab
report.export(filepath);
```

**参数**:
- `filepath`: 输出文件路径（可选，默认使用 `obj.filename`）

**示例**:
```matlab
% 使用默认文件名导出
report.export();

% 指定文件名导出
report.export('my_report.md');

% 指定完整路径导出
report.export('output/reports/analysis_report.md');
```

### 4. clear - 清除内容

```matlab
report = report.clear();
```

清除所有内容，保留标题、作者、日期等元信息。

## 实用方法

### 1. getLength - 获取内容行数

```matlab
numLines = report.getLength();
```

### 2. merge - 合并报告

```matlab
report = report.merge(otherReport);
```

将另一个报告的内容合并到当前报告。

## 静态方法

### 1. createFromTemplate - 从模板创建

```matlab
report = MarkdownReport.createFromTemplate(title, templatePath);
```

**参数**:
- `title`: 报告标题
- `templatePath`: 模板文件路径

**示例**:
```matlab
% 从模板创建报告
report = MarkdownReport.createFromTemplate(...
    '工程分析报告', ...
    'templates/report_template.md');
```

### 2. structToMarkdown - 结构体转 Markdown

```matlab
markdownStr = MarkdownReport.structToMarkdown(structData, title);
```

**参数**:
- `structData`: 结构体数据
- `title`: 表格标题（可选）

**返回**: Markdown 格式的表格字符串

**示例**:
```matlab
% 转换结构体为 Markdown 表格
params = struct('A', 1, 'B', 2, 'C', 3);
mdTable = MarkdownReport.structToMarkdown(params, '参数表');
```

## 完整使用流程

### 基本报告流程

```matlab
%% 步骤1：创建报告对象
report = MarkdownReport(...
    'title', '工程分析报告', ...
    'author', 'Xie Yu', ...
    'filename', 'analysis_report.md', ...
    'imageDir', 'images' ...
);

%% 步骤2：添加章节
report = report.addTitle('1. 项目概述', 2);
report = report.addParagraph('本报告呈现了复合板组件的结构分析结果。');

%% 步骤3：添加参数表格
params = struct('Material', 'Steel', 'Thickness', '30 mm');
report = report.addTitle('2. 设计参数', 2);
report = report.addTableFromStruct(params, '参数', '值');

%% 步骤4：添加图形
report = report.addTitle('3. 分析结果', 2);
x = 1:10;
y = sin(x);
g = Rplot('x', x, 'y', y);
g = g.geom_line();
draw(g);
[report, path] = report.addImageFromRplot(g, '应力分布');
close(gcf);

%% 步骤5：导出报告
report.export();
```

### 使用链式调用

```matlab
% 链式调用示例
report = MarkdownReport('title', '工程报告')
    .addTitle('概述', 2)
    .addParagraph('工程分析报告。')
    .addHorizontalRule()
    .addTitle('参数表', 2)
    .addTableFromStruct(params)
    .export();
```

### 带多个图形的报告

```matlab
% 创建报告
report = MarkdownReport('title', '对比分析', 'filename', 'comparison.md');

% 图形1：正弦波
x = 1:10;
y = sin(x);
g1 = Rplot('x', x, 'y', y);
g1 = g1.geom_line();
g1 = g1.set_title('Sine Wave');
draw(g1);
[report, p1] = report.addImageFromRplot(g1, '正弦波');
close(gcf);

% 图形2：余弦波
y2 = cos(x);
g2 = Rplot('x', x, 'y', y2);
g2 = g2.geom_line();
g2 = g2.set_title('Cosine Wave');
draw(g2);
[report, p2] = report.addImageFromRplot(g2, '余弦波');
close(gcf);

% 添加结论
report = report.addTitle('结论', 2);
report = report.addParagraph('两种波形特征已成功分析。');

% 导出报告
report.export();
```

### 添加代码块和列表

```matlab
% 创建报告
report = MarkdownReport('title', '算法说明', 'filename', 'algorithm.md');

% 添加代码块
report = report.addTitle('算法实现', 2);
code = {
    'function result = myAlgorithm(x, y)',
    '    % 计算结果',
    '    result = x .^ 2 + y .^ 2;',
    'end'
};
report = report.addCodeBlock(code, 'matlab');

% 添加使用步骤
report = report.addTitle('使用步骤', 2);
steps = {
    '步骤1：准备输入数据',
    '步骤2：调用 myAlgorithm 函数',
    '步骤3：解析输出结果'
};
report = report.addList(steps, true);

% 导出报告
report.export();
```

## 常见场景示例

### 场景1：为 Component 子类添加报告功能

当为现有的 Component 子类（如 BossPlate, Commonplate）添加报告输出功能时：

```matlab
% 在 solve() 方法末尾添加报告生成
function obj = solve(obj)
    % 原有的求解代码
    obj = OutputSolidModel(obj);
    obj = OutputAss(obj);

    %% 添加报告输出
    % 创建报告
    report = MarkdownReport(...
        'title', [obj.params.Name ' 分析报告'], ...
        'filename', [obj.params.Name '_report.md'] ...
    );

    % 添加设计参数
    report = report.addTitle('设计参数', 2);
    report = report.addTableFromStruct(obj.input, '参数', '值');

    % 添加结果
    report = report.addTitle('计算结果', 2);
    results = struct(...
        '节点数', size(obj.output.SolidMesh.P, 1), ...
        '单元数', size(obj.output.SolidMesh.T, 1) ...
    );
    report = report.addTableFromStruct(results, '指标', '数值');

    % 添加图形
    report = report.addTitle('可视化', 2);
    Plot3D(obj);  % 调用 Component 的绘图方法
    [report, path] = report.addImageFromFigure(gcf, '3D 模型', ...
        'filename', '3d_model', 'resolution', 300);
    close(gcf);

    % 导出报告
    report.export();
end
```

### 场景2：生成测试报告

```matlab
% 测试报告生成脚本
function generateTestReport(testResults)
    % 创建报告
    report = MarkdownReport(...
        'title', '测试报告', ...
        'author', 'Test Automation', ...
        'filename', sprintf('test_report_%s.md', datestr(now, 'yyyymmdd')) ...
    );

    % 添加测试摘要
    report = report.addTitle('测试摘要', 2);
    summary = struct(...
        '总测试数', testResults.total, ...
        '通过', testResults.passed, ...
        '失败', testResults.failed, ...
        '成功率', sprintf('%.1f%%', testResults.passed / testResults.total * 100) ...
    );
    report = report.addTableFromStruct(summary, '指标', '数值');

    % 添加详细结果
    report = report.addTitle('详细测试结果', 2);
    for i = 1:length(testResults.cases)
        caseName = testResults.cases{i}.name;
        passed = testResults.cases{i}.passed;

        report = report.addTitle(sprintf('Case %d: %s', i, caseName), 3);

        if passed
            report = report.addParagraph('**状态**: ✅ PASSED');
        else
            report = report.addParagraph('**状态**: ❌ FAILED');
            report = report.addParagraph(['**错误**: ' testResults.cases{i}.error]);
        end

        report = report.addHorizontalRule();
    end

    % 导出报告
    report.export();
end
```

### 场景3：批量分析报告

```matlab
% 为多个组件生成报告
function generateBatchReports(componentList)
    % 创建汇总报告
    report = MarkdownReport(...
        'title', '批量分析汇总', ...
        'filename', 'batch_summary.md' ...
    );

    report = report.addTitle('组件列表', 2);
    report = report.addParagraph(sprintf('共 %d 个组件进行分析。', length(componentList)));

    % 为每个组件添加摘要
    for i = 1:length(componentList)
        comp = componentList{i};
        report = report.addTitle(sprintf('%d. %s', i, comp.params.Name), 3);

        % 关键参数
        params = struct(...
            '材料', comp.params.Material.Name, ...
            '厚度', comp.input.Thickness ...
        );
        report = report.addTableFromStruct(params, '参数', '值');
    end

    % 导出汇总报告
    report.export();
end
```

## 注意事项

### 1. 图片路径

- **相对路径 vs 绝对路径**：推荐使用相对路径（如 `images/figure.png`）便于移植
- **路径分隔符**：Markdown 推荐使用正斜杠 `/`（兼容所有平台）
- **图片目录**：`addImageFromRplot` 和 `addImageFromFigure` 会自动创建目录

### 2. Rplot 集成

```matlab
% 正确的 Rplot 使用流程
g = Rplot('x', x, 'y', y);
g = geom_line(g);      % 必须添加 geom
g = g.set_title('Title');
draw(g);                % 绘制图形
[report, path] = report.addImageFromRplot(g, 'Caption');
close(gcf);             % 关闭图形
```

**注意**:
- 必须先添加 `geom` 图层（如 `geom_line`, `geom_point`）
- 使用 `draw(g)` 而非 `g.draw()`（draw 函数不返回对象）
- 调用 `addImageFromRplot` 后手动关闭图形（除非需要进一步编辑）

### 3. 字符串格式

```matlab
% 字符串使用双引号
report = report.addTitle('标题', 2);
report = report.addParagraph('段落文本');

% Cell 数组用于多行
report = report.addParagraph({'行1', '行2', '行3'});
```

### 4. 双语文本

MarkdownReport 完全支持中英文混合文本：

```matlab
report = report.addTitle('项目概述 / Project Overview', 2);
report = report.addParagraph('本报告呈现分析结果。');
```

### 5. 链式调用限制

`export()` 方法不返回对象，不能在链式调用后继续添加内容：

```matlab
% 正确
report = report.addTitle('Section', 2).addParagraph('Text');
report.export();

% 错误 - export() 后不能继续链式
report = report.addTitle('Section', 2).export().addParagraph('Text');
```

## 相关文件

- MarkdownReport 类定义: `dep\framework\@MarkdownReport\MarkdownReport.m`
- 测试脚本: `dep\framework\@MarkdownReport\test_MarkdownReport.m`
- 参考报告格式: `Testing/001_Demo/004_Commonplate/TestReport_Commonplate.md`

## 相关类

- `Rplot`: 绘图框架，用于生成可视化图表
- `Component`: 工程计算基类（MarkdownReport 不继承此类）

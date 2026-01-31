# MATLAB Coding Standards

## MATLAB 注释规范

### 注释符号
- **只能使用 `%` 作为注释符号**
- ❌ **不要使用 `#`** （这是Python/Shell的注释符号，MATLAB不支持）
- ✅ 正确示例：
  ```matlab
  % 这是一个注释
  x = 10;  % 行尾注释
  ```
- ❌ 错误示例：
  ```matlab
  # 这是错误的注释
  x = 10;  # 这也是错误的
  ```

### 注释风格
1. **中文注释**：在中文环境下，使用中文添加代码注释
2. **函数头注释**：遵循标准格式
   ```matlab
   function [output1, output2] = functionName(input1, input2)
   % FunctionName - 函数功能描述
   % 详细说明函数的作用和用途
   % Author: 作者名
   %
   % Inputs:
   %   input1 - 第一个输入参数的说明
   %   input2 - 第二个输入参数的说明
   %
   % Outputs:
   %   output1 - 第一个输出参数的说明
   %   output2 - 第二个输出参数的说明
   ```

3. **分段注释**：使用 `%%` 创建代码分段
   ```matlab
   %% 初始化变量
   x = 10;

   %% 计算结果
   y = x * 2;
   ```

4. **特殊注释（抑制警告）**：
   ```matlab
   %#ok<AGROW>  % 抑制变量增长的警告
   ```

## MATLAB 语法规范

### 字符串定义
- MATLAB中字符串用双引号 `"` 定义
- 字符数组用单引号 `'` 定义

```matlab
% 字符串（推荐）
str = "hello";

% 字符数组
charArray = 'hello';
```

### 索引和比较
- MATLAB索引从1开始（不是0）
- 使用 `==` 比较，`&&` 和 `||` 进行逻辑运算

```matlab
% 正确
if x == 10 && y > 5
    % code
end

% 错误（不要使用 === 或 || 等JavaScript风格的符号）
```

### 数组操作
- 矩阵/数组索引使用圆括号 `()`
- 单元格数组索引使用花括号 `{}`

```matlab
% 普通数组
x = [1, 2, 3];
value = x(1);  % 获取第一个元素

% 单元格数组
cellArray = {1, 'text', [1,2,3]};
value = cellArray{1};  % 获取第一个单元格的内容
```

## MATLAB 特定注意事项

### 输入解析
使用 `inputParser` 处理可选参数：

```matlab
function result = myFunction(varargin)
    p = inputParser;
    addParameter(p, 'option1', 'default', @char);
    addParameter(p, 'option2', 0, @numeric);
    parse(p, varargin{:});
    opts = p.Results;

    % 使用 opts.option1 和 opts.option2
end
```

### 面向对象编程
- 类定义在 `@ClassName` 文件夹中的 `ClassName.m` 文件
- 私有方法放在 `@ClassName/private` 文件夹中
- 属性使用 `properties`、`methods` 等关键字

### 函数式编程
- 函数句柄：`f = @(x) x.^2;`
- 匿名函数：适合简单的单行函数

## MATLAB vs 其他语言

| 特性 | MATLAB | Python | JavaScript |
|------|---------|---------|------------|
| 注释符号 | `%` | `#` | `//` 或 `/* */` |
| 索引起始 | 1 | 0 | 0 |
| 数组索引 | `()` | `[]` | `[]` |
| 矩阵乘法 | `*` 或 `.*` | `@` 或 `*` | - |
| 逻辑与 | `&&` | `and` / `&` | `&&` |
| 逻辑或 | `\|\|` | `or` / `\|` | `\|\|` |
| 字符串定义 | `"` | `"` 或 `'` | `` ` `` 或 `'` 或 `"` |

## 常见错误

### 1. 使用错误的注释符号
```matlab
% ❌ 错误
x = 10;  # 这是Python注释

% ✅ 正确
x = 10;  % 这是MATLAB注释
```

### 2. 索引从0开始
```matlab
% ❌ 错误
x = [10, 20, 30];
value = x(0);  % 索引越界

% ✅ 正确
x = [10, 20, 30];
value = x(1);  % 获取第一个元素
```

### 3. 混淆字符串和字符数组
```matlab
% 字符串（推荐）
str = "hello";  % string类型

% 字符数组（传统）
charArray = 'hello';  % char类型
```

### 4. 逻辑运算符混淆
```matlab
% ❌ 错误（不要使用 `and`, `or`）
if x > 10 and y < 20
% 或
if x > 10 & y < 20  % 这是逐元素与，不是短路与

% ✅ 正确（使用 `&&` 进行短路逻辑运算）
if x > 10 && y < 20
```

## 编辑MATLAB代码时的检查清单

1. **注释**：确保所有注释使用 `%` 而不是 `#`
2. **字符串**：确认字符串使用双引号 `"`
3. **索引**：检查数组索引从1开始
4. **逻辑运算**：使用 `&&` 和 `||` 而不是 `&` 和 `|`
5. **分段**：合理使用 `%%` 分隔代码块
6. **函数头**：遵循标准的注释格式

## MATLAB 文件编码

- 保存文件时使用 **UTF-8** 编码
- 如果使用中文注释，确保文件以UTF-8 without BOM保存
- 避免使用特殊字符在变量名中

## 示例：完整的函数注释

```matlab
function [result, info] = calculateShaftDiameter(length, radius, varargin)
% calculateShaftDiameter - 计算轴的直径
% 根据长度和半径计算轴的直径，支持多种单位转换
% Author: Your Name
%
% Inputs:
%   length  - 轴的长度 [mm]
%   radius  - 轴的半径 [mm]
%
% Optional Parameters (varargin):
%   'Unit'   - 输出单位：'mm'(默认), 'cm', 'm'
%   'IncludeTolerance' - 是否包含公差，默认false
%
% Outputs:
%   result  - 计算得到的直径
%   info    - 包含附加信息的结构体
%             .originalRadius - 原始半径
%             .tolerance    - 公差值（如果计算）
%
% Examples:
%   [diam, inf] = calculateShaftDiameter(100, 5);
%   [diam, inf] = calculateShaftDiameter(100, 5, 'Unit', 'cm');

%% 解析输入参数
p = inputParser;
addParameter(p, 'Unit', 'mm', @char);
addParameter(p, 'IncludeTolerance', false, @logical);
parse(p, varargin{:});
opts = p.Results;

%% 计算直径
result = 2 * radius;

%% 单位转换
switch opts.Unit
    case 'cm'
        result = result / 10;
    case 'm'
        result = result / 1000;
end

%% 构建输出信息
info.originalRadius = radius;
if opts.IncludeTolerance
    info.tolerance = result * 0.01;  % 1%公差
end

end
```

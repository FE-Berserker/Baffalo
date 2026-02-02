---
name: matlab-component
description: 创建遵循 Component 框架的 MATLAB 程序
---

# MATLAB Component 框架规则

当创建 MATLAB 程序时，需要遵循 Aisssoft 机械设计工具的 Component 框架规范。

## 核心要求

### 类结构
- 编写的每一个 MATLAB 程序需要继承 `Component` 基类
- 组件类必须位于 MATLAB 包目录或项目目录中

### 属性说明

| 属性 | 类型 | 说明 |
|------|------|------|
| `input` | struct | 设计输入参数，由外部提供的设计数据 |
| `output` | struct | 设计输出结果，包含刚度、频率、阻尼比等计算结果 |
| `params` | struct | 材料参数或设置，如材料属性、计算配置等 |
| `baseline` | struct | **安全系数最低要求**，根据工程经验和规范设定的限制值 |
| `capacity` | struct | 计算得到的实际安全系数/容量指标 |

### 必须实现的抽象属性

所有子类必须定义以下抽象属性，指定预期字段名称：

- `inputExpectedFields` - 输入参数的预期字段列表
- `outputExpectedFields` - 输出结果的预期字段列表
- `paramsExpectedFields` - 参数的预期字段列表
- `baselineExpectedFields` - 基准值的预期字段列表

### 必须实现的抽象方法

- `solve()` - 核心计算方法，实现具体的机械设计计算逻辑

### 可用方法

| 方法 | 说明 |
|------|------|
| `PlotStruct()` | 可视化组件结构 |
| `PlotCapacity()` | 绘制容量与基准比率图 |
| `Check()` | 验证输入完整性，检查必需字段是否存在 |
| `Help()` | 打开相关文档文件 |

### 开发规范

1. **代码组织**
   - 将具体实现放在项目目录或测试目录中
   - 示例参考 `Testing/ComponentModule.m`

2. **路径设置**
   - 使用 `setAisssoftPath.m` 添加项目路径到 MATLAB 搜索路径
   - 确保框架依赖可被找到

3. **Baseline 理解与使用**

   **Baseline 的工程意义**:
   - `baseline` 是根据结构重要性、使用年限、安全规范等工程经验设定的**最低要求值**
   - 不是参数的参考范围，而是安全校核的判断标准

   **Capacity 与 Baseline 的关系**:
   - `capacity` 包含计算得到的实际安全系数（如承载安全系数、位移安全系数等）
   - `baseline` 包含工程要求的最低安全系数（如最小安全系数、最大允许位移等）

   **校核逻辑**:
   ```
   if capacity.safety_factor >= baseline.min_safety_factor
       % 满足要求
   else
       % 输出警告，需要重新设计
   end
   ```

   **设计示例**:
   ```
   场景: 橡胶支撑设计
   --------------------------
   计算步骤:
   1. 计算承载力 = 1000 N
   2. 材料极限承载力 = 1100 N
   3. capacity.load_capacity = 1100 / 1000 = 1.1

   校核步骤:
   4. baseline.min_safety_factor = 1.2（根据结构重要性设定）
   5. 1.1 < 1.2，不满足要求
   6. 输出警告: "承载安全系数 1.1 小于工程要求 1.2"
   7. 需要增大截面或选择更高强度材料
   ```

   **典型 Baseline 字段**:
   - `min_safety_factor` - 综合安全系数最低要求（默认 1.0）
   - `max_displacement` - 最大允许位移
   - `max_stress` - 最大允许应力
   - `min_natural_freq` - 最小固有频率要求
   - `max_resonance_amp` - 最大共振放大倍数限制

### 示例

```matlab
classdef MyComponent < Component
    properties (Constant)
        paramsExpectedFields = {'Material', 'Echo'};
        inputExpectedFields = {'Force', 'Length'};
        outputExpectedFields = {'Assembly', 'SafetyFactor'};
        baselineExpectedFields = {'MinSafetyFactor'};
    end

    methods
        function obj = solve(obj)
            % 1. 计算实际值
            actualStress = obj.input.Force / obj.input.Length;

            % 2. 存储到 output
            obj.output.Stress = actualStress;

            % 3. 计算安全系数 (capacity)
            obj.output.SafetyFactor = obj.baseline.MinSafetyFactor / actualStress;

            % 4. 存储到 capacity (用于 PlotCapacity 比较)
            obj.capacity.StressRatio = obj.output.SafetyFactor;
        end
    end
end
```

**安全校核示例代码**:

```matlab
function checkSafety(obj)
    % 检查是否满足安全要求

    if obj.capacity.StressRatio < obj.baseline.MinSafetyFactor
        warning(['安全系数 %.2f 小于要求 %.2f，需要重新设计'], ...
                 obj.capacity.StressRatio, ...
                 obj.baseline.MinSafetyFactor);
    else
        disp(['安全系数 %.2f 满足要求 (%.2f)'], ...
              obj.capacity.StressRatio, ...
              obj.baseline.MinSafetyFactor);
    end
end
```

## 框架位置

- Component 基类位于: `dep/framework/@Component/Component.m`
- 路径设置脚本: `setAisssoftPath.m`
- 示例实现: `Testing/ComponentModule.m`

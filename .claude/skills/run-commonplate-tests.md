# Commonplate 测试技能

当用户要求运行 Commonplate 测试并生成报告时，使用此技能。

## 使用场景

当用户提出以下请求时触发此技能：
- "测试 Commonplate"
- "运行 Commonplate 测试"
- "生成 Commonplate 测试报告"
- "测试 Testing/001_Demo/004_Commonplate 路径下的代码"
- "生成所有 case 的测试报告"

## 测试概述

**测试路径**: `Testing/001_Demo/004_Commonplate/`
**测试文件**: `Demo_004_Commonplate.m`

**包含的测试用例**:
1. **Case 1**: Plate with holes and face deformation - 带孔板件和面变形测试
2. **Case 2**: Order 2 elements with subdivision - 二阶单元与轮廓细分测试
3. **Case 3**: Shell mesh output - 壳网格输出测试
4. **Case 4**: STL file output - STL文件导出与导入测试
5. **Case 5**: Face deformation - 面变形测试（双面）

## 执行步骤

### 1. 运行自动化测试

使用 MATLAB 执行自动化测试脚本：

```bash
matlab -batch "run('Testing/001_Demo/004_Commonplate/RunAllTests.m')"
```

### 2. 生成测试报告

测试脚本会自动生成两个报告文件：
- `TestReport_Commonplate.txt` - 文本格式报告
- `TestReport_Commonplate.md` - Markdown 格式报告

## 已知问题

### Case 5 - Face deformation 测试失败

**错误信息**: "不支持复数值" (Complex values not supported)

**根本原因**:
```matlab
f1 = @(r)(sqrt(360^2 - r.^2) - 360)
```
当 `r > 360` 时：
- `360^2 - r.^2` 变为负数
- `sqrt(负数)` 产生复数结果
- 问题位置: DeformFace 函数调用时

**建议修复**:
在 DeformFace 函数中添加复数检查或修改变形函数：

```matlab
% 方案1: 限制输入范围
f1 = @(r)(sqrt(max(360^2 - r.^2, 0)) - 360);

% 方案2: 在函数内部检查
f1 = @(r)safeSqrt(360^2 - r.^2) - 360;

function y = safeSqrt(x)
    if x < 0
        y = 0;
    else
        y = sqrt(x);
    end
end
```

## 相关文件

- Commonplate 类定义: `+plate/@Commonplate/Commonplate.m`
- 测试脚本: `Testing/001_Demo/004_Commonplate/Demo_004_Commonplate.m`
- 自动化测试: `Testing/001_Demo/004_Commonplate/RunAllTests.m`
- 测试文档: `Document/Commonplate.pdf`

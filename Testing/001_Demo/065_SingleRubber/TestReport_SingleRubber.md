# SingleRubber 测试报告

## 测试信息

| 项目 | 内容 |
|------|------|
| 测试日期 | 2026-02-02 |
| 测试文件 | `Demo_065_SingleRubber.m` |
| 测试类 | `body.SingleRubber` |
| 测试结果 | ✅ 全部通过 |

---

## 测试用例概览

| 用例 | 测试内容 | 结果 |
|------|----------|------|
| 1 | 旋转体橡胶体 (Rotary + Housing) | ✅ PASS |
| 2 | 平板橡胶体 (Plate + Commonplate) | ✅ PASS |
| 3 | 不同邵氏硬度 (30, 50, 70, 90 HS) | ✅ PASS |
| 4 | 二阶单元测试 | ✅ PASS |
| 5 | 装配信息检查 | ✅ PASS |

---

## 详细测试结果

### 用例1: 旋转体橡胶体 (Rotary Type)

**几何模型：** 矩形截面旋转形成的空心圆柱体
- 截面类型：矩形
- 内半径：45 mm
- 外半径：65 mm
- 长度：60 mm
- 旋转轴：x轴
- 旋转角度：360°
- 网格尺寸：2 mm

**橡胶参数：**
- 邵氏硬度：60 HS
- 类型：Rotary

**测试输出：**
```
Successfully create surface .
Successfully Output Solid mesh .
Successfully output solid assembly .
Successfully output solid assembly .
Successfully create single rubber mesh .
```

**结果：** ✅ PASS

---

### 用例2: 平板橡胶体 (Plate Type)

**几何模型：** 矩形平板
- 尺寸：100 mm × 60 mm
- 厚度：10 mm
- 网格尺寸：默认

**橡胶参数：**
- 邵氏硬度：50 HS
- 类型：Plate

**测试输出：**
```
Successfully output solid mesh .
Successfully output shell mesh .
Successfully output solid mesh assembly .
Successfully output shell mesh assembly .
Successfully output solid assembly .
Successfully create single rubber mesh .
```

**结果：** ✅ PASS

---

### 用例3: 不同邵氏硬度测试

| HS | 弹性模量 E (N/mm²) | 剪切模量 G (N/mm²) | 泊松比 v | Mooney-Rivlin [C10, C01] |
|-----|---------------------|---------------------|----------|-----------------------|
| 30  | 2.4699              | 0.2692               | 0.5000   | [0.329320, 0.082330]  |
| 50  | 4.6559              | 0.8032               | 0.5000   | [0.620787, 0.155197]  |
| 70  | 7.6419              | 1.7372               | 0.5000   | [1.018920, 0.254730]  |
| 90  | 11.4279             | 3.0712               | 0.5000   | [1.523720, 0.380930]  |

**材料属性计算验证：**
- ✅ 弹性模量随硬度增加而增加
- ✅ 剪切模量随硬度增加而增加
- ✅ 泊松比正确限制为0.5
- ✅ Mooney-Rivlin参数计算正确

**结果：** ✅ PASS

---

### 用例4: 二阶单元测试

**几何模型：** 矩形截面旋转体
- 单元阶次：Order=2（186单元）

**测试输出：**
```
Successfully create surface .
Successfully Output Solid mesh .
Successfully output solid assembly .
Successfully output solid assembly .
Successfully create single rubber mesh .
```

**验证：**
- ✅ 二阶单元（186）正确设置
- ✅ 网格生成成功

**结果：** ✅ PASS

---

### 用例5: 装配信息检查

**装配信息（以用例1为例）：**

| 属性 | 值 |
|------|-----|
| 装配名称 | Rubber_Rotary |
| 部件数量 | 1 |
| 单元类型数量 | 1 |
| 材料数量 | 1 |

**材料属性表：**

| 属性 | 值 | 单位 |
|------|-----|------|
| DENS | 0.0012098 | g/mm³ |
| EX | 6.0489 | N/mm² |
| NUXY | 0.5 | - |
| GXY | 1.2202 | N/mm² |
| C10 | 0.80652 | N/mm² |
| C01 | 0.20163 | N/mm² |

**验证：**
- ✅ 装配名称正确
- ✅ 单元类型正确设置（185/186）
- ✅ 材料属性完整（DENS、EX、NUXY、GXY、C10、C01）
- ✅ 材料名称包含硬度信息（Rubber_HS60）

**结果：** ✅ PASS

---

## 功能验证

### 基本功能
| 功能 | 状态 | 说明 |
|------|------|------|
| 旋转体类型支持 | ✅ | 正确使用Housing几何模型 |
| 平板类型支持 | ✅ | 正确使用Commonplate几何模型 |
| 材料属性计算 | ✅ | 调用RubberProperty类正确计算 |
| 实体网格生成 | ✅ | 从几何模型继承SolidMesh |
| 装配创建 | ✅ | 正确设置单元类型和材料 |

### 辅助功能
| 功能 | 状态 | 说明 |
|------|------|------|
| Plot2D | ✅ | 绘制2D截面图 |
| Plot3D | ✅ | 绘制3D模型 |
| Echo参数 | ✅ | 正确控制打印信息 |

---

## 代码质量

### 遵循规范
- ✅ 继承自 `Component` 基类
- ✅ 定义 `paramsExpectedFields`、`inputExpectedFields`、`outputExpectedFields`
- ✅ 使用默认值（`default_Name`、`default_Echo`）
- ✅ 函数命名与 `Commonshaft` 风格一致

### 代码结构
- ✅ `SingleRubber.m`: 主类文件
- ✅ `OutputAss.m`: 装配输出方法
- ✅ `CalculateRubberProperty`: 内部方法计算材料属性

---

## 结论

### 测试总结
所有5个测试用例全部通过，`SingleRubber` 类功能完整且符合设计要求。

### 功能覆盖
- ✅ 旋转体橡胶体（Housing）
- ✅ 平板橡胶体（Commonplate）
- ✅ 橡胶材料属性计算
- ✅ 装配生成
- ✅ 可视化功能

### 待改进项
暂无

---

## 相关文件

| 文件路径 | 说明 |
|----------|------|
| `+body/@SingleRubber/SingleRubber.m` | 主类文件 |
| `+body/@SingleRubber/OutputAss.m` | 装配输出方法 |
| `Testing/001_Demo/065_SingleRubber/Demo_065_SingleRubber.m` | 测试用例 |

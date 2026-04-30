# Assembly 类 Cheat Sheet

## 类概述
`Assembly` 是一个用于有限元分析装配体建模的 MATLAB 类，主要与 ANSYS 求解器配合使用。该类支持结构分析、热分析、接触分析、多体动力学等多种有限元分析类型。

**作者**: Xie Yu  
**父类**: `handle` & `matlab.mixin.Copyable`

---

## 创建 Assembly 对象

```matlab
% 基本创建
obj = Assembly('模型名称');

% 带参数创建
obj = Assembly('模型名称', 'Echo', 1, 'T_Ref', 20);
```

**参数说明**:
- `Name`: 装配体名称
- `Echo`: 是否打印信息 (默认: 1)
- `T_Ref`: 参考温度，默认 20℃

---

## 核心属性

### 基本属性
| 属性 | 类型 | 说明 |
|------|------|------|
| `Name` | char | 装配体名称 |
| `Echo` | logical | 是否输出打印信息 |
| `T_Ref` | double | 参考温度 (℃) |

### 几何属性
| 属性 | 类型 | 说明 |
|------|------|------|
| `Part` | cell | 零件数组 |
| `V` | double | 所有节点坐标 |
| `Id` | double | 零件编号计数器 |

### 材料与截面
| 属性 | 类型 | 说明 |
|------|------|------|
| `Material` | cell | 材料属性数组 |
| `Section` | cell | 截面属性数组 |
| `ET` | cell | 单元类型数组 |

### 边界条件与载荷
| 属性 | 类型 | 说明 |
|------|------|------|
| `Boundary` | cell | 边界条件数组 |
| `Load` | cell | 载荷数组 |
| `Displacement` | cell | 位移数组 |
| `SF` | cell | 表面载荷数组 |

### 连接与约束
| 属性 | 类型 | 说明 |
|------|------|------|
| `Connection` | cell | 连接关系 |
| `Master` | cell | 主节点 (RBE2/RBE3) |
| `Slaver` | cell | 从节点 |
| `Cnode` | double | 连接节点 |
| `Spring` | cell | 弹簧单元 |
| `Joint` | cell | 运动副 (MPC184) |
| `Bearing` | cell | 轴承 |
| `ContactPair` | cell | 接触对 |

### 其他
| 属性 | 类型 | 说明 |
|------|------|------|
| `Sensor` | cell | 传感器 (时间历程) |
| `Sensor1` | cell | 传感器 (POST26) |
| `Solu` | cell | 求解设置 |
| `CS` | cell | 坐标系 |
| `Temperature` | cell | 温度载荷 |

---

## 主要方法分类

### 1. 几何建模方法

#### AddPart - 添加零件
```matlab
obj = AddPart(obj, Meshoutput, varargin);
```
**参数**:
- `Meshoutput`: 网格输出结构体
- `position`: [x,y,z,rx,ry,rz] 位置和旋转角度 (默认: [0,0,0,0,0,0])
- `Seq`: 旋转序列 (默认: 'ZYX')

**示例**:
```matlab
obj = AddPart(obj, mesh, 'position', [100, 0, 0, 0, 0, 90]);
```

---

### 2. 材料与截面方法

#### AddMaterial - 添加材料
```matlab
obj = AddMaterial(obj, opt);
```
**参数** (`opt` 结构体):
- `Name`: 材料名称
- `table`: 材料属性表 (温度, 弹性模量, 泊松比, 密度等)
- `TBlab`: TB标签
- `TBtable`: TB表
- `FC`: 失效准则
- `FCType`: 失效准则类型

**示例**:
```matlab
opt.table = [
    20, 210e9, 0.3, 7850;  % 温度, E, 泊松比, 密度
    100, 200e9, 0.3, 7850
];
opt.Name = 'Steel';
obj = AddMaterial(obj, opt);
```

#### AddSection - 添加截面
```matlab
obj = AddSection(obj, opt);
```
**参数**: 截面属性结构体

---

### 3. 边界条件与载荷方法

#### AddBoundary - 添加边界条件
```matlab
obj = AddBoundary(obj, Numpart, varargin);
```
**参数**:
- `Numpart`: 零件编号 (0 表示全局节点)
- `No`: 边界标记编号
- `locx`, `locy`, `locz`: 位置坐标选择
- `Dtol`: 位置容差 (默认: 1e-5)

**示例**:
```matlab
% 通过边界标记
obj = AddBoundary(obj, 1, 'No', 1);

% 通过位置选择
obj = AddBoundary(obj, 1, 'locx', 0, 'Dtol', 1e-3);

% 全局节点
obj = AddBoundary(obj, 0, 'No', [1, 2, 3]);
```

#### AddLoad - 添加载荷
```matlab
obj = AddLoad(obj, Numpart, varargin);
```
**参数**: 与 AddBoundary 类似

#### AddDisplacement - 添加位移
```matlab
obj = AddDisplacement(obj, Numpart, varargin);
```

---

### 4. 连接与约束方法

#### AddMaster - 添加主节点
```matlab
obj = AddMaster(obj, PartNum, NodeNum, varargin);
```

#### AddSlaver - 添加从节点
```matlab
obj = AddSlaver(obj, varargin);
```

#### AddRigidLink - 添加刚性连接
```matlab
obj = AddRigidLink(obj, varargin);
```

#### AddSpring - 添加弹簧
```matlab
obj = SetSpring(obj, varargin);
```

#### AddRevoluteJoint - 添加旋转副
```matlab
obj = AddRevoluteJoint(obj, varargin);
```

---

### 5. 传感器方法

#### AddSensor1 - 添加 POST26 传感器
```matlab
obj = AddSensor1(obj, varargin);
```
**参数**:
- `Name`: 传感器名称
- `Ux`, `Uy`, `Uz`: 位移分量
- `Node`: 节点编号

**示例**:
```matlab
obj = AddSensor1(obj, 'Name', 'Disp_X', 'Ux', 1, 'Node', 100);
```

---

### 6. 求解方法

#### ANSYSSolve - ANSYS 求解
```matlab
ANSYSSolve(obj, varargin);
```
**参数**:
- `Name`: 数据库文件名 (可选)

---

### 7. 可视化方法

#### Plot - 绘制装配体
```matlab
Plot(obj, varargin);
```
**常用参数**:
- `Part`: 指定零件数组
- `load`: 是否显示载荷 (默认: 0)
- `boundary`: 是否显示边界 (默认: 0)
- `connection`: 是否显示连接 (默认: 0)
- `view`: 视图角度 (默认: [-37.5, 30])
- `face_alpha`: 面透明度 (默认: 1)

**示例**:
```matlab
% 基本绘图
Plot(obj);

% 显示载荷和边界
Plot(obj, 'load', 1, 'boundary', 1);

% 指定零件
Plot(obj, 'Part', [1, 3, 5]);
```

---

## Get 方法 (查询方法)

### GetN* 方法 - 获取数量
```matlab
n = GetNPart(obj);      % 零件数量
n = GetNMaterial(obj);  % 材料数量
n = GetNSection(obj);   % 截面数量
n = GetNLoad(obj);      % 载荷数量
n = GetNBoundary(obj);  % 边界数量
n = GetNNode(obj);      % 节点数量
n = GetNEl(obj);        % 单元数量
n = GetNSensor(obj);    % 传感器数量
n = GetNJoint(obj);     % 运动副数量
n = GetNSpring(obj);    % 弹簧数量
```

### GetNodeCoor - 获取节点坐标
```matlab
coor = GetNodeCoor(obj, PartNum, NodeNum);
```

---

## Set 方法 (设置方法)

### Set* 方法 - 设置属性
```matlab
obj = SetMaterial(obj, PartNum, MaterialNum);
obj = SetSection(obj, PartNum, SectionNum);
obj = SetET(obj, PartNum, ET_Num);
obj = SetLoad(obj, varargin);
obj = SetBoundaryType(obj, varargin);
```

---

## 统计信息

### Summary 属性
```matlab
obj.Summary.Total_Part       % 零件总数
obj.Summary.Total_Node       % 节点总数
obj.Summary.Total_El         % 单元总数
obj.Summary.Total_Load       % 载荷总数
obj.Summary.Total_Boundary   % 边界总数
obj.Summary.Total_Sensor     % 传感器总数
```

---

## 典型工作流程

### 基本分析流程
```matlab
% 1. 创建装配体
asm = Assembly('ExampleModel');

% 2. 添加零件
asm = AddPart(asm, mesh1);
asm = AddPart(asm, mesh2, 'position', [100, 0, 0, 0, 0, 0]);

% 3. 添加材料
opt.table = [20, 210e9, 0.3, 7850];
opt.Name = 'Steel';
asm = AddMaterial(asm, opt);

% 4. 分配材料和截面
asm = SetMaterial(asm, 1, 1);
asm = SetSection(asm, 1, 1);

% 5. 添加边界条件
asm = AddBoundary(asm, 1, 'No', 1);

% 6. 添加载荷
asm = AddLoad(asm, 2, 'No', 2);

% 7. 添加传感器
asm = AddSensor1(asm, 'Name', 'Monitor', 'Uz', 1, 'Node', 100);

% 8. 可视化
Plot(asm, 'load', 1, 'boundary', 1);

% 9. 求解
ANSYS_Output(asm);
ANSYSSolve(asm);

% 10. 后处理
asm = ImportResult(asm);
asm = ReadSensor(asm);
PlotResult(asm);
```

---

## 绘图设置属性

| 属性 | 默认值 | 说明 |
|------|--------|------|
| `fontSize` | 20 | 字体大小 |
| `faceAlpha1` | 0.8 | 面透明度 |
| `markerSize` | 40 | 标记大小 |
| `lineWidth` | 3 | 线宽 |

---

## 常见使用技巧

### 1. 节点选择方式
```matlab
% 方式1: 通过边界标记
obj = AddBoundary(obj, 1, 'No', 1);

% 方式2: 通过位置坐标
obj = AddBoundary(obj, 1, 'locx', 0, 'Dtol', 1e-3);

% 方式3: 直接指定节点编号
obj = AddBoundary(obj, 0, 'No', [1, 2, 3, 4, 5]);
```

### 2. 零件变换
```matlab
% 平移和旋转
obj = AddPart(obj, mesh, ...
    'position', [x, y, z, rx, ry, rz], ...
    'Seq', 'ZYX');
```

### 3. 查询模型信息
```matlab
fprintf('总节点数: %d\n', GetNNode(obj));
fprintf('总单元数: %d\n', GetNEl(obj));
fprintf('总零件数: %d\n', GetNPart(obj));
```

---

## 注意事项

1. **节点编号**: 添加零件后，节点会自动重新编号
2. **累积计数**: 使用 `GetN*` 方法获取当前数量后再添加新项
3. **单位一致性**: 确保所有物理量使用统一单位制
4. **边界标记**: 使用网格生成软件预定义的边界标记
5. **Echo 设置**: 设置 `Echo=0` 可以关闭过程打印
6. **温度参考**: 默认参考温度为 20℃，可根据需要修改

---

## 相关文件

- 类定义: [Assembly.m](dep/framework/@Assembly/Assembly.m)
- 核心方法: [dep/framework/@Assembly/](dep/framework/@Assembly/)
- 私有方法: [dep/framework/@Assembly/private/](dep/framework/@Assembly/private/)

---

## 版本信息

- 创建日期: 2026-04-15
- 作者: Xie Yu
- 框架: Baffalo Framework

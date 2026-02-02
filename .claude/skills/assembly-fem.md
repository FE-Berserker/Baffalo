# Assembly 有限元分析装配框架

当用户要求进行有限元分析、装配体建模、设置边界载荷、ANSYS 求解时，优先使用此框架中的 Assembly 类。

## 使用场景

当用户提出以下请求时触发此技能：
- "创建装配体"
- "添加零件/部件"
- "设置边界条件"
- "添加载荷"
- "有限元分析"
- "FEA"
- "ANSYS 求解"
- "添加材料/截面"
- "设置连接/约束"

## 类概述

**类名**: `Assembly`
**作者**: Xie Yu
**路径**: `dep\framework\@Assembly\Assembly.m`
**继承**: `handle & matlab.mixin.Copyable`
**用途**: 有限元分析装配体管理，支持零件组装、边界载荷设置、求解和后处理

### 核心概念

Assembly 类使用模块化的方式管理有限元模型：
1. **Parts (零件)** - 网格化的部件
2. **Materials (材料)** - 材料属性
3. **Sections (截面)** - 梁/壳截面定义
4. **Boundaries (边界)** - 约束条件
5. **Loads (载荷)** - 力、力矩等载荷
6. **Connections (连接)** - 零件间的连接关系
7. **Sensors (传感器)** - 后处理数据提取

## 基本用法

### 1. 创建 Assembly 对象

```matlab
% 基本用法
asm = Assembly('MyAssembly');

% 带参数
asm = Assembly('MyAssembly', 'Echo', 1, 'T_Ref', 20);
```

**参数说明**:
- `Name` - 装配体名称（必需）
- `Echo` - 是否打印信息，默认 1
- `T_Ref` - 参考温度，默认 20℃

### 2. 添加零件

```matlab
% 基本用法
asm = AddPart(asm, meshOutput);

% 带位置和旋转
asm = AddPart(asm, meshOutput, ...
    'position', [x, y, z, rx, ry, rz], ...  % 位置和旋转角度
    'Seq', 'ZYX');  % 旋转顺序
```

**参数说明**:
- `meshOutput` - 网格输出对象（包含 nodes, elements 等）
- `position` - [x, y, z, rx, ry, rz]：位置和欧拉角
- `Seq` - 旋转顺序：'ZYX'（默认）或 'XYZ'

### 3. 添加材料

```matlab
% 定义材料选项
matOpts.Name = 'Steel';
matOpts.table = [200e3, 0.3, 7850];  % E,泊松比,密度

% 添加材料
asm = AddMaterial(asm, matOpts);
```

**材料属性**:
- `Name` - 材料名称
- `table` - 基本属性 [E, v, density]
- `TBlab` - 温度标签
- `TBtable` - 温度相关属性表
- `FC` - 失效准则参数
- `FCType` - 失效准则类型

### 4. 设置边界条件

```matlab
% 通过边界号添加
asm = AddBoundary(asm, partNum, 'No', 1);

% 通过坐标选择节点
asm = AddBoundary(asm, partNum, 'locx', 0);
asm = AddBoundary(asm, partNum, 'locy', [10, 20]);  % y在10-20之间的节点

% 设置边界类型（固定、简支等）
asm = SetBoundaryType(asm, 'ALL', 0);  % 0=固定
```

**参数说明**:
- `partNum` - 零件编号，0 表示全局节点
- `No` - 边界编号（需要网格有 boundaryMarker）
- `locx/locy/locz` - 通过坐标选择节点
- `Dtol` - 坐标容差，默认 1e-5

### 5. 添加载荷

```matlab
% 添加力载荷
asm = AddLoad(asm, partNum, 'No', nodeNumbers);
asm = SetLoad(asm, loadNum, ...
    'amp', [Fx, Fy, Fz, Mx, My, Mz], ...
    'time', [0, 1], ...
    'type', 'Force');

% 添加面载荷
asm = AddSF(asm, partNum, 'No', boundaryNum, ...
    'amp', [Px, Py, Pz], ...
    'type', 'SF');
```

**载荷类型**:
- `Force` - 力 (FX, FY, FZ) + 力矩 (MX, MY, MZ)
- `SF` - 面载荷（压力）
- `Displacement` - 强制位移

## 连接与约束

### RBE2/RBE3 连接

```matlab
% 添加主节点
asm = AddMaster(asm, [part1, part2], [node1, node2]);

% 设置 RBE3
asm = SetRbe3(asm, masterNum, slaveNodes);

% 设置 RBE2
asm = SetRbe2(asm, masterNum, slaveNodes);
```

### 弹簧连接

```matlab
% 添加弹簧
asm = AddSpring(asm, node1, node2, partNum1, partNum2);

% 设置弹簧刚度
asm = SetSpring(asm, springNum, ...
    'K', [kx, ky, kz], ...  % 平动刚度
    'C', [cx, cy, cz], ...  % 平动阻尼
    'Krot', [krx, kry, krz]);  % 转动刚度
```

### 旋转关节

```matlab
asm = AddRevoluteJoint(asm, part1, part2, ...
    node1, node2, ...
    'axis', [0, 0, 1]);  % 旋转轴
```

### 滑动连接

```matlab
asm = AddSlider(asm, part1, part2, ...
    node1, node2, ...
    'axis', [1, 0, 0]);  % 滑动方向
```

## 传感器与后处理

### 添加传感器

```matlab
% 位移传感器
asm = AddSensor(asm, 'U', 'Set', 1, 'Name', 'Displacement');

% 应力传感器
asm = AddSensor(asm, 'Stress', partNum, ...
    'Set', 1, ...
    'Sys', 0, ...  % 坐标系
    'Name', 'Stress');

% 应变传感器
asm = AddSensor(asm, 'Strain', partNum, 'Set', 1);

% 失效传感器
asm = AddSensor(asm, 'FAIL', partNum, ...
    'Set', 1, ...
    'Part', partNum);

% 频率传感器
asm = AddSensor(asm, 'Freq', [1, 2, 3]);  % 获取模态频率
```

### 传感器类型

| 类型 | 参数 | 说明 |
|------|------|------|
| `U` | `Set`, `Name` | 位移 |
| `Stress` | `Part`, `Set`, `Sys`, `Corner`, `Name` | 应力 |
| `Strain` | `Part`, `Set`, `Sys`, `Corner`, `Name` | 应变 |
| `FAIL` | `Part`, `Set`, `Lab` | 失效 |
| `Freq` | `Freq` | 模态频率 |
| `SENE` | `Part`, `Mode` | 模态应变能 |
| `Etable` | `Part`, `Option`, `TableNum`, `Set` | 元素表 |

## 其他功能

### 截面设置

```matlab
% 添加梁截面
asm = AddSection(asm, 'Type', 'Beam', ...
    'Data', [h, b, tf, tw], ...  % 截面参数
    'Material', matNum);
```

### 端部释放

```matlab
asm = AddEndRelease(asm, partNum, elementNum, releaseCode);
% releaseCode: 释放的自由度
```

### 坐标系

```matlab
asm = AddCS(asm, partNum, [x, y, z], [a, b, c]);
```

### 零件分组

```matlab
asm = SetGroup(asm, groupName, [part1, part2, part3]);
```

## 可视化

### 绘制装配体

```matlab
% 基本绘制
asm.Plot();

% 显示载荷
asm.Plot('load', 1, 'load_scale', 0.9);

% 显示边界
asm.Plot('boundary', 1);

% 显示位移
asm.Plot('dis', 1, 'dis_scale', 1);

% 显示连接
asm.Plot('connection', 1);

% 显示端部释放
asm.Plot('endrelease', 1);

% 组合显示
asm.Plot('load', 1, 'boundary', 1, 'connection', 1);
```

**Plot 参数**:
- `Part` - 指定零件编号
- `Group` - 指定组名称
- `grid` - 显示网格，默认 0
- `equal` - 等比例显示，默认 1
- `alpha` - 透明度
- `face_alpha` - 面透明度
- `load` - 显示载荷
- `load_scale` - 载荷显示缩放
- `dis` - 显示位移
- `dis_scale` - 位移显示缩放
- `boundary` - 显示边界约束
- `connection` - 显示连接
- `view` - 视角，默认 [-37.5, 30]

### 爆炸视图

```matlab
asm.PlotExplod();
```

### 绘制传感器

```matlab
asm.PlotSensor(sensorNum);
```

## ANSYS 求解

```matlab
% 基本求解
asm.ANSYSSolve();

% 指定文件名
asm.ANSYSSolve('Name', 'MyModel');
```

**前提条件**:
- 需要先使用 `VTKWriteParts` 或相关函数导出 ANSYS 输入文件
- 需要配置 `ANSYSPath.txt` 指定 ANSYS 可执行文件路径

## 导出功能

```matlab
% 导出 VTK 格式
asm.VTKWriteParts();
asm.VTKWriteParts2();
asm.VTKWriteSensor();
```

## Summary 统计

Assembly 维护各种元素的计数，可通过 `asm.Summary` 访问：

| 统计项 | 说明 |
|--------|------|
| `Total_Part` | 零件总数 |
| `Total_Node` | 节点总数 |
| `Total_El` | 单元总数 |
| `Total_Boundary` | 边界总数 |
| `Total_Load` | 载荷总数 |
| `Total_Displacement` | 位移总数 |
| `Total_Sensor` | 传感器总数 |
| `Total_Material` | 材料总数 |
| `Total_Section` | 截面总数 |
| `Total_Master` | 主节点总数 |
| `Total_Connection` | 连接总数 |
| `Total_Spring` | 弹簧总数 |
| `Total_Contact` | 接触对总数 |

## 完整工作流程示例

```matlab
%% 创建装配体
asm = Assembly('BracketAssembly', 'Echo', 1);

%% 添加零件
asm = AddPart(asm, mesh1, 'position', [0, 0, 0, 0, 0, 0]);
asm = AddPart(asm, mesh2, 'position', [100, 50, 0, 0, 0, 90]);

%% 添加材料
matOpts.Name = 'Aluminum';
matOpts.table = [70e3, 0.33, 2700];
asm = AddMaterial(asm, matOpts);

%% 设置边界
% 固定底座
asm = AddBoundary(asm, 1, 'No', 1);
asm = SetBoundaryType(asm, 'ALL', 0);  % 完全固定

%% 添加载荷
asm = AddLoad(asm, 2, 'No', [100, 200]);
asm = SetLoad(asm, 1, ...
    'amp', [0, 0, -1000, 0, 0, 0], ...  % Fz = -1000 N
    'type', 'Force');

%% 添加连接
asm = AddMaster(asm, [1, 2], [50, 25]);
asm = SetRbe3(asm, 1, [100, 150, 200, 250]);  % 从节点

%% 添加传感器
asm = AddSensor(asm, 'U', 'Set', 1, 'Name', 'NodeDisplacement');
asm = AddSensor(asm, 'Stress', 2, 'Set', 1, 'Name', 'BracketStress');

%% 绘制模型
asm.Plot('load', 1, 'boundary', 1, 'connection', 1);

%% 导出和求解
asm.VTKWriteParts();
asm.ANSYSSolve();

%% 后处理
asm = ImportResult(asm);
asm.PlotResult();
```

## 关键方法列表

### 添加类方法

| 方法 | 功能 |
|------|------|
| `AddPart` | 添加零件 |
| `AddMaterial` | 添加材料 |
| `AddSection` | 添加截面 |
| `AddLoad` | 添加载荷 |
| `AddBoundary` | 添加边界 |
| `AddDisplacement` | 添加强制位移 |
| `AddSF` | 添加面载荷 |
| `AddCnode` | 添加连接节点 |
| `AddMaster` | 添加主节点 |
| `AddSpring` | 添加弹簧 |
| `AddRevoluteJoint` | 添加旋转关节 |
| `AddSlider` | 添加滑动连接 |
| `AddRigidLink` | 添加刚性连接 |
| `AddSensor` | 添加传感器 |
| `AddIStress` | 添加初始应力 |
| `AddBeamPreload` | 添加梁预紧力 |
| `AddNodeMass` | 添加节点质量 |
| `AddEndRelease` | 添加端部释放 |
| `AddCS` | 添加坐标系 |
| `AddTable` | 添加表格数据 |

### 设置类方法

| 方法 | 功能 |
|------|------|
| `SetBoundaryType` | 设置边界类型 |
| `SetLoad` | 设置载荷值 |
| `SetSF` | 设置面载荷 |
| `SetMaterial` | 设置材料 |
| `SetSection` | 设置截面 |
| `SetET` | 设置单元类型 |
| `SetRbe2` | 设置 RBE2 连接 |
| `SetRbe3` | 设置 RBE3 连接 |
| `SetSpring` | 设置弹簧参数 |
| `SetBearing` | 设置轴承参数 |
| `SetLUTBearing` | 设置查表轴承参数 |
| `SetGroup` | 设置零件组 |

### 获取类方法

| 方法 | 功能 |
|------|------|
| `GetNPart` | 获取零件数量 |
| `GetNNode` | 获取节点数量 |
| `GetNEl` | 获取单元数量 |
| `GetNMaterial` | 获取材料数量 |
| `GetNSection` | 获取截面数量 |
| `GetNLoad` | 获取载荷数量 |
| `GetNBoundary` | 获取边界数量 |
| `GetNMaster` | 获取主节点数量 |
| `GetNSensor` | 获取传感器数量 |
| `GetNSpring` | 获取弹簧数量 |
| `GetNodeCoor` | 获取节点坐标 |

### 可视化方法

| 方法 | 功能 |
|------|------|
| `Plot` | 绘制装配体 |
| `PlotExplod` | 爆炸视图 |
| `PlotResult` | 绘制结果 |
| `PlotSensor` | 绘制传感器数据 |
| `PlotSection` | 绘制截面 |
| `PlotCon` | 绘制连接 |

### 导出与求解

| 方法 | 功能 |
|------|------|
| `VTKWriteParts` | 导出 VTK 格式 |
| `VTKWriteSensor` | 导出传感器 VTK |
| `ANSYSSolve` | ANSYS 批处理求解 |
| `ImportResult` | 导入结果文件 |

## 重要注意事项

1. **节点编号**: 每个添加的零件会累积节点编号，`Part{i}.acc_node` 保存了节点偏移量

2. **边界选择**: 可以通过 `boundaryMarker` 或坐标位置选择边界节点

3. **连接节点 (Cnode)**: 用于连接不同零件或施加边界/载荷的特殊节点

4. **主从关系**: RBE2/RBE3 使用主节点 (Master) 控制多个从节点 (Slave)

5. **坐标系**: 支持局部坐标系，通过 `ESYS` 和 `CS` 属性管理

6. **文件路径**:
   - 类定义: `dep\framework\@Assembly\Assembly.m`
   - 私有函数: `dep\framework\@Assembly\private\`

7. **与 Mesh 类的配合**: 需要先使用 Mesh 框架生成网格，然后添加到 Assembly

## 相关代码文件

### 类定义
- `Assembly.m` - 主类定义

### 添加方法
- `AddPart.m`
- `AddMaterial.m`
- `AddLoad.m`
- `AddBoundary.m`
- `AddSensor.m`
- `AddMaster.m`
- `AddSpring.m`
- 等

### 设置方法
- `SetBoundaryType.m`
- `SetLoad.m`
- `SetET.m`
- `SetRbe3.m`
- `SetSpring.m`
- 等

### 可视化
- `Plot.m`
- `PlotExplod.m`
- `PlotResult.m`
- `PlotSensor.m`

### 私有函数
- `private/element2patch.m`
- `private/patchcenter.m`
- `private/Boundary.m`
- 等

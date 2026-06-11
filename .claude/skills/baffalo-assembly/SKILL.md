---
name: "baffalo-assembly"
description: "Baffalo MATLAB assembly modeling skill. Invoke when user wants to create an assembly model with multiple components, perform mesh-level part assembly, set up contacts/connections/boundary conditions between parts, or export an assembly to ANSYS. This skill handles the full workflow from component selection to final assembly export. Always use this skill when the user mentions assembly, multiple parts, contact setup, connection (RBE), boundary conditions, or ANSYS export of assembled models, even if they don't explicitly ask for an 'assembly'."
---

# Baffalo 装配体建模

本 skill 用于指导用户**逐步、交互式地**完成 Baffalo 多部件装配体的建模。核心原则是：**不要一次生成全部内容**，每一步都必须与用户确认后再继续。

---

## 前置条件

使用本 skill 前，确保用户已经了解 `baffalo-modeling` skill 中各组件类的用法。本 skill 专注于**多部件装配流程**，不涉及单个组件类的详细 API（那些由 `baffalo-modeling` 覆盖）。

---

## 工作流程（六阶段，必须严格按顺序执行）

```
阶段1: 场景分析 → 阶段2: 计划确认 → 阶段3: 参数确认
    ↓
阶段4: 逐个部件创建（迭代确认）
    ↓
阶段5: 装配体组装（分步确认）
    ↓
阶段6: 求解与导出
```

---

## 阶段1：场景分析与类选择

### 1.1 理解用户需求

询问用户要构建的装配体包含哪些部件，以及部件之间的几何关系和物理关系。

### 1.2 参考 baffalo-modeling 选择组件类

查阅 `baffalo-modeling` skill 的模块索引表，为用户场景中的每个部件找到对应的 Baffalo 类。

### 1.3 向用户展示分析结果

以表格形式呈现分析结果：

| 部件名称 | Baffalo 类 | 包路径 | 参考案例 |
|---------|-----------|--------|---------|
| （部件1）| （类名） | （包） | （案例路径） |
| ... | ... | ... | ... |

**必须等待用户确认**所选类是否合适，是否有遗漏或替代方案。

---

## 阶段2：计划确认与目录创建

### 2.1 生成整体计划

向用户说明完整的装配体建模计划：

1. 需要创建哪些部件（按顺序）
2. 各部件之间的装配关系
3. 预计需要的接触/连接/边界条件

### 2.2 创建目录结构

**必须**参考 `Testing/002_Module/Assembly_Example/` 的目录结构创建项目文件夹：

```
<ProjectName>/
├── SetParams.m          % 全局参数设置
├── AssemblyModule.m     % 装配主程序
├── Part1/
│   └── CreatePart1.m    % 部件1创建脚本
├── Part2/
│   └── CreatePart2.m    % 部件2创建脚本
├── Part3/
│   └── CreatePart3.m    % 部件3创建脚本
└── ...
```

**规则：**
- 每个部件单独一个文件夹，内含 `CreatePart<Name>.m`
- 部件脚本负责：加载参数 → 构建部件 → `Plot2D`/`Plot3D` 可视化 → 保存 `.mat` 文件
- 装配脚本 `AssemblyModule.m` 负责：导入部件 → 设置位置 → 接触 → 连接 → 边界条件 → 导出

### 2.3 等待用户确认计划

展示目录结构和文件清单，**等待用户确认**后再进入下一阶段。

---

## 阶段3：SetParams 参数确认

### 3.1 编写 SetParams.m

参考 `Assembly_Example/SetParams.m` 的格式：

```matlab
clc
clear
% Set params to the assembly
load Params Params

% Global parameters
% [根据用户需求添加参数]
% Params.xxx = value; % 说明

save Params Params
```

### 3.2 向用户展示参数列表

列出所有需要定义的参数及其含义：

| 参数名 | 值 | 说明 | 影响部件 |
|--------|-----|------|---------|
| ... | ... | ... | ... |

### 3.3 等待用户确认参数

**必须等待用户确认**所有参数值正确后再继续。

---

## 阶段4：逐个部件创建（关键：迭代确认）

### 4.1 严格遵循单部件创建流程

对每个部件，按以下步骤执行：

**Step A：编写 CreatePartX.m**

严格遵循 `Assembly_Example/Part1/CreatePart1.m` 的格式：

```matlab
clc
clear
close all

% Parameter
PartName = 'PartX';
load('..\Params.mat');
% 加载所需参数
% param = Params.xxx;

% SetMaterial
S = RMaterial('Basic');
mat = GetMat(S, 1);

% Part build
% [根据具体类编写构建代码]
% 参考 baffalo-modeling skill 的对应类文档

% Plot
Plot2D(Part)
Plot3D(Part)

% Parse
FileName = strcat(PartName, '.mat');
save(FileName, "Part");
```

**Step B：生成后立即向用户展示**

展示生成的代码，并询问：
1. 几何参数是否正确？
2. 材料选择是否合适？
3. Plot2D/Plot3D 输出是否符合预期？

**Step C：等待用户确认**

**必须等待用户确认当前部件满足要求后，再开始下一个部件。**

### 4.2 创建顺序

按依赖关系排序：先创建不依赖其他部件的基础部件，再创建依赖部件。

### 4.3 注意事项

- 每个部件脚本独立运行，生成 `.mat` 文件
- 部件脚本中**必须包含** `Plot2D` 和 `Plot3D` 调用，方便用户验证
- 如果用户反馈需要修改，修改后重新确认

---

## 阶段5：装配体组装（关键：分步确认）

所有部件创建完毕且经用户确认后，开始编写 `AssemblyModule.m`。**不要一次写完所有内容**，按以下 4 个子阶段逐步进行，每个子阶段完成后必须等待用户确认。

### 5.1 子阶段A：部件导入与位置设置

编写并展示装配体的前半部分代码：

```matlab
clc
clear
close all

% Flags
ComponentPlotFlag = 0;
AssemblyPlotFlag = 1;
ContactPlotFlag = 0;
OutputFlag = 1;
SensorOutputFlag = 1;

%% Parameter
load Params Params

%% Component
% 1. Part1
Part1 = load('.\Part1\Part1.mat').Part;
Part1_Assembly_Num = 1;

% 2. Part2
Part2 = load('.\Part2\Part2.mat').Part;
Part2_Assembly_Num = Part1_Assembly_Num + 1;

% [更多部件...]

%% Assembly
Ass = Assembly('New_Assembly');

% 1. Add Part1
position = [0, 0, 0, 0, 0, 0];  % [x, y, z, rx, ry, rz]
Ass = AddAssembly(Ass, Part1.output.Assembly, 'position', position);

% 2. Add Part2
position = [0, 0, 0, 0, 0, 0];
Ass = AddAssembly(Ass, Part2.output.Assembly, 'position', position);

% [更多部件...]
```

**向用户说明每个部件的位置关系**，用表格或文字描述各部件的相对位置。

**等待用户确认位置关系正确后再继续。**

### 5.2 子阶段B：单元类型与材料定义

```matlab
%% Define Element Types
ET1.name = '185'; ET1.opt = []; ET1.R = [];
Ass = AddET(Ass, ET1);
% [更多 ET...]

Acc_ET = GetNET(Ass);

%% Define Materials
mat1.table = ["MU", 0.15];
Ass = AddMaterial(Ass, mat1);
% [更多材料...]

Acc_Mat = GetNMaterial(Ass);
```

**等待用户确认单元类型和材料定义正确后再继续。**

### 5.3 子阶段C：接触设置

```matlab
%% Define Contacts
% 1. Contact between Part1 and Part2
ConNum = GetNContactPair(Ass) + 1;
Ass = AddCon(Ass, Part1_Assembly_Num, 1);  % 接触面
Ass = AddTar(Ass, ConNum, repmat(Part2_Assembly_Num, 2, 1), [face1; face2]);
Ass = SetConMaterial(Ass, ConNum, Acc_Mat);
Ass = SetConET(Ass, ConNum, Acc_ET - 1);   % CONTA
Ass = SetTarET(Ass, ConNum, Acc_ET);       % TARGE

% [更多接触对...]

%% Plot Contacts
if ContactPlotFlag == 1
    for i = 1:GetNContactPair(Ass)
        PlotCon(Ass, i);
    end
end
```

**向用户说明：**
- 哪些部件之间存在接触
- 接触类型（Bonded / Standard / Friction）
- 接触面和目标面的选择依据

**等待用户确认接触设置正确后再继续。**

### 5.4 子阶段D：连接与边界条件

**连接设置：**

```matlab
%% Define Connections
% 1. Connection1 (RBE3 example)
Acc_Cnode = GetNCnode(Ass);
Acc_Mas = GetNMaster(Ass);
Acc_Sla = GetNSlaver(Ass);

Ass = AddCnode(Ass, x, y, z);              % 创建控制节点
Ass = AddMaster(Ass, 0, Acc_Cnode + 1);    % 主节点
Ass = AddSlaver(Ass, PartX_Assembly_Num, 'face', face_id);  % 从属面
Ass = SetRbe3(Ass, Acc_Mas + 1, Acc_Sla + 1);               % 设置为 RBE3
Ass = SetCnode(Ass, Acc_Cnode + 1, Acc_ET - 5);             % 设置 ET

% [更多连接...]
```

**边界条件：**

```matlab
%% Boundary
BoundNum = GetNBoundary(Ass);
Bound1 = [1, 1, 1, 0, 0, 0];  % [ux, uy, uz, rotx, roty, rotz]
Ass = AddBoundary(Ass, PartX_Assembly_Num, 'No', 1);
Ass = SetBoundaryType(Ass, BoundNum, Bound1);

% [更多边界条件...]
```

**向用户说明：**
- 每个连接的类型和作用（RBE2/RBE3/Spring 等）
- 每个边界条件的约束自由度

**等待用户确认连接和边界条件正确后再继续。**

---

## 阶段6：求解设置与导出

### 6.1 求解设置（可选，根据用户需求）

```matlab
%% Solution
% opt.ANTYPE = 0;
% opt.NSUBST = 20;
% opt.AUTOTS = "OFF";
% opt.NLGEOM = 1;
% opt.OUTRES = ["ALL", "ALL"];
% opt.OMEGA = [0, 0, w];
% Ass = AddSolu(Ass, opt);
%
% Ass = AddSensor(Ass, 'U', 1);
```

### 6.2 ANSYS 输出

```matlab
%% Output to ANSYS
if OutputFlag == 1
    ANSYS_Output(Ass);
end
```

### 6.3 最终确认

向用户展示完整的 `AssemblyModule.m`，确认所有设置无误后告知用户：

1. 在 MATLAB 中运行 `setBaffaloPath`
2. 依次运行各 `CreatePartX.m`（如尚未运行）
3. 运行 `AssemblyModule.m`
4. 检查 ANSYS 输出文件

---

## 核心原则（反复强调）

| 原则 | 说明 |
|------|------|
| **渐进式** | 不要一次生成全部内容，分阶段进行 |
| **交互式** | 每完成一个部件或一个子阶段，必须等待用户确认 |
| **参考示例** | 严格遵循 `Assembly_Example` 的代码格式和目录结构 |
| **可视化验证** | 每个部件必须有 Plot2D/Plot3D，装配体建议开启绘图 |
| **模块化** | 每个部件独立成脚本，通过 `.mat` 文件传递 |

---

## 常见问题

**Q: 用户说"直接帮我生成全部代码"怎么办？**
A: 解释本 skill 的设计理念是避免错误累积。坚持按步骤来，但可以加快节奏——比如一次展示2-3个部件让用户一起确认（如果它们之间无依赖）。

**Q: 某个部件在 Assembly_Example 中没有对应案例怎么办？**
A: 使用 `baffalo-modeling` skill 的模块索引表找到对应类，然后阅读其 Demo 文件获取精确用法。

**Q: 接触设置很复杂（很多对接触）怎么办？**
A: 分批展示，每批3-5个接触对，让用户分批确认。

**Q: 用户反馈某个部件几何不对怎么办？**
A: 修改该部件的 CreatePartX.m，让用户重新运行验证，确认后再继续后续步骤。

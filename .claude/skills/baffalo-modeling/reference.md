# Baffalo Component 参考文档

本文档列出所有继承 Component 基类的核心类的 input、params 和 output 字段定义。

---

## +shaft 轴系

### Commonshaft — 通用阶梯轴

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料，默认钢材 |
| N_Slice | 100 | 轴向切片数量 |
| Name | 'Commonshaft1' | 名称 |
| E_Revolve | 40 | 旋转划分数（必须是8的倍数） |
| Beam_N | 16 | 梁截面圆周分段数 |
| Order | 1 | 单元阶次：1=一阶，2=二阶 |
| Echo | 1 | 是否打印信息 |

**input:**

| 字段 | 说明 |
|------|------|
| Length | 各段长度 [mm]，Nx2矩阵 [起始位置, 结束位置] |
| ID | 各段内径 [mm]，Nx2矩阵 [起始内径, 结束内径] |
| OD | 各段外径 [mm]，Nx2矩阵 [起始外径, 结束外径] |
| Meshsize | 网格尺寸 [mm]，为空则自动计算 |

**output:**

| 字段 | 说明 |
|------|------|
| Node | 轴向节点位置 |
| ID | 各节点处内径 |
| OD | 各节点处外径 |
| Surface | 2D截面 (Surface2D) |
| SolidMesh | 3D实体网格 (Mesh) |
| BeamMesh | 梁网格 (Mesh) |
| Assembly | 实体模型装配 (Assembly) |
| Assembly1 | 梁模型装配 (Assembly) |

---

### ShaftSupport — 轴支座

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料，默认钢材 |
| Name | 'ShaftSupport_1' | 名称 |
| E_Revolve | 40 | 旋转分段数 |
| Order | 1 | 单元阶次 |
| Type | 1 | 支座类型（1-4） |
| Echo | 1 | 是否打印 |

**input:**

| 字段 | 说明 |
|------|------|
| N | 壁厚 [mm] |
| L | 长度 [mm] |
| D | 轴直径 [mm] |
| H | 底板尺寸 [mm] |
| T | 底板厚度 [mm] |
| d1 | 孔直径 [mm] |
| P | 孔分布圆直径 [mm] |
| NH | 孔数量 |
| K | Type=2：方孔边长 |
| W | Type=3,4：方孔宽度 |
| F | Type=4：方孔间距 |

**output:**

| 字段 | 说明 |
|------|------|
| SolidMesh | 3D网格 (Mesh) |
| Assembly | 装配体 (Assembly) |

---

### OilSeal — 油封

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'Oilsea_1l' | 名称 |
| Pressure | 0.03 | 接触压力 [MPa] |
| Rou | 0.9e-9 | 油密度 [t/mm³] |
| Vis | 40 | 运动粘度 [mm²/s] |
| Method | 1 | 1=AGMA ISO 14179-1, 2=NOK |

**input:**

| 字段 | 说明 |
|------|------|
| Length | 油封长度 [mm] |
| ID | 内径 [mm] |
| OD | 外径 [mm] |
| Rot_Speed | 转速 [rpm] |
| Fr | 内径粗糙度 |

**output:**

| 字段 | 说明 |
|------|------|
| Node | 节点位置 |
| ID | 内径 |
| OD | 外径 |
| Ts | 摩擦扭矩 [Nmm] |
| Line_Velocity | 线速度 [mm/s] |
| f | 摩擦系数 |
| G | 参数G |
| T2 | 发热量 |

---

### ToothShaft — 花键轴

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | 'ToothShaft_1' | 名称 |
| Echo | 1 | 打印 |
| Order | 1 | 单元阶次 |
| ToothType | 1 | 齿类型 |
| SlotType | 1 | 槽类型：1=平槽, 2=圆槽 |
| ToothSlice | 5 | 齿旋转分段数 |
| SlotSlice | 5 | 槽旋转分段数 |
| LeftLimit | [] | 左限位 |

**input:**

| 字段 | 说明 |
|------|------|
| Outline | 截面轮廓 (Line2D) |
| Meshsize | 网格尺寸 [mm] |
| ToothNum | 齿数 |
| ToothPos | 齿位置 [mm] |
| ToothWidth | 齿宽 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 壳网格 (Mesh) |
| Assembly | 装配体 (Assembly) |
| Divider | 几何分割 |

---

## +housing 壳体

### Housing — 旋转体壳体

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料，默认钢材 |
| N_Slice | 36 | 旋转分段数 |
| Degree | 360 | 旋转角度 [°] |
| Axis | 'x' | 旋转轴：'x'或'y' |
| Name | 'Housing_1' | 名称 |
| Echo | 1 | 打印 |
| Order | 1 | 单元阶次 |

**input:**

| 字段 | 说明 |
|------|------|
| Outline | 截面轮廓 (Line2D) |
| Hole | 孔几何 (Line2D矩阵) |
| Meshsize | 网格尺寸 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| Assembly | 装配体 (Assembly) |

**注意事项：**

- `input.Hole` 是指**截面上的孔**（2D），旋转后形成环形槽或轴向通孔
- Hole 应为 Line2D 矩阵（Nx1），每行是一个孔的轮廓
- 法兰面上沿圆周分布的多个螺栓孔需通过其他方式（如布尔运算）在 3D 实体上创建

**Hole 定义示例：**
```matlab
h1 = Line2D('Hole1');
h1 = AddCircle(h1, radius, pointObj, 1);

h2 = Line2D('Hole2');
h2 = AddCircle(h2, radius, pointObj, 1);

input.Hole = [h1; h2];  % 矩阵形式
```

---

### SlotHousing — 开槽壳体

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料，默认钢材 |
| Name | 'SlotHousing_1' | 名称 |
| Echo | 1 | 打印 |
| Order | 1 | 单元阶次 |
| ToothType | 1 | 齿类型 |
| SlotType | 1 | 槽类型：1=平槽, 2=圆槽 |
| ToothSlice | 5 | 齿旋转分段数 |
| SlotSlice | 5 | 槽旋转分段数 |
| LeftLimit | [] | 左限位 |
| RightLimit | [] | 右限位 |

**input:**

| 字段 | 说明 |
|------|------|
| Outline | 截面轮廓 (Line2D) |
| Meshsize | 网格尺寸 [mm] |
| SlotNum | 槽数量 |
| SlotPos | 槽位置 [mm]，Nx2矩阵 |
| SlotWidth | 槽宽度 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 壳网格 (Mesh) |
| Assembly | 装配体 (Assembly) |
| Divider1 | 几何分割1 |
| Divider2 | 几何分割2 |

---

### PolygonHousing — 多边形壳体

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料，默认钢材 |
| Name | 'PolygonHousing_1' | 名称 |
| Echo | 1 | 打印 |
| Order | 1 | 单元阶次 |
| Slice | 8 | 边分段数 |

**input:**

| 字段 | 说明 |
|------|------|
| Outline | 截面轮廓 (Line2D) |
| Meshsize | 网格尺寸 [mm] |
| r | 边圆角半径 [mm]（默认1） |
| EdgeNum | 边数 |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 壳网格 (Mesh) |
| Assembly | 装配体 (Assembly) |

---

### CompositeRing — 复合环

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 复合材料属性（必须指定） |
| Name | 'CompositeRing_1' | 名称 |
| Echo | 1 | 打印 |
| NRot | 144 | 旋转方向单元数（必须是4的倍数） |
| NHeight | 40 | 高度方向单元数 |
| T | 20 | 温度 [℃] |
| Order | 1 | 单元阶次 |

**input:**

| 字段 | 说明 |
|------|------|
| Di | 内径 [mm] |
| Thickness | 各层厚度 [mm] |
| Angle | 各层角度 [°] |
| MatNum | 各层材料编号 |
| Height | 环段高度 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| TotalThickness | 总厚度 [mm] |
| SolidMesh | 3D网格 (Mesh) |
| Assembly | 装配体 (Assembly) |
| Matrix | 刚度矩阵 |

---

### WindturbineTower — 风电塔筒

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料，默认钢材 |
| N_Slice | 72 | 旋转分段数 |
| Degree | 360 | 旋转角度 [°] |
| Name | 'WindturbineTower_1' | 名称 |
| Echo | 1 | 打印 |
| Order | 1 | 单元阶次 |
| Offset | "MID" | 壳偏移：MID/BOT/TOP |

**input:**

| 字段 | 说明 |
|------|------|
| Length | 各段长度 [mm] |
| Diameter | 各段直径 [mm] |
| Thickness | 各段壁厚 [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| ShellMesh | 壳网格 (Mesh) |
| BeamMesh | 梁网格 (Mesh) |
| Matrix | 刚度矩阵 |
| Assembly | 壳装配 (Assembly) |
| Assembly1 | 梁装配 (Assembly) |

---

## +plate 板

### Commonplate — 通用板

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| N_Slice | 3 | 高度方向单元层数 |
| Name | 'Commonplate1' | 名称 |
| Order | 1 | 单元阶次 |
| Offset | "Mid" | 壳偏移：Mid/Top/Bottom |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Outline | 轮廓 (Line2D) |
| Hole | 孔 (Line2D矩阵) |
| Thickness | 厚度 [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 壳网格 (Mesh) |
| Assembly | 实体装配 (Assembly) |
| Assembly1 | 壳装配 (Assembly) |

---

### BossPlate — 带凸台板

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | 'BossPlate1' | 名称 |
| Order | 1 | 单元阶次 |
| Type | 1 | 1=内侧凸台, 2=外侧凸台 |
| HoleSeg | 16 | 孔边分段数 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| OutLine | 外轮廓 (Line2D) |
| MidLine | 中间轮廓 (Line2D) |
| InnerLine | 内轮廓 (Line2D) |
| InnerHole | 内部孔 |
| OuterHole | 外部孔 |
| BossHeight | 凸台高度 [mm] |
| PlateThickness | 板厚 [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| PlateNode | 平板侧节点 |
| SolidMesh | 3D网格 (Mesh) |
| Assembly | 装配体 (Assembly) |

---

### CouplingMembrane — 联轴器膜片

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| N_Slice | 3 | 高度方向层数 |
| Name | 'CouplingMembrane_1' | 名称 |
| Order | 1 | 单元阶次 |
| Offset | "BOT" | 壳偏移 |
| Type | 1 | 几何类型 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| GeomData | Type=1: [D1,D2,D3,D4] |
| HoleNum | 孔数 |
| Thickness | 厚度 [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 壳网格 (Mesh) |
| Assembly | 实体装配 (Assembly) |
| Assembly1 | 壳装配 (Assembly) |

---

### Laminate — 层合板

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'Laminate_1' | 名称 |
| Echo | 1 | 打印 |
| Criterion | 0 | 失效准则：1=Max Stress, 2=Max Strain, 3=Tsai-Hill, 4=Hoffman, 5=Tsai-Wu, 6=Hashin, 7=Puck |
| Material | [] | 复合材料属性（必须指定） |

**input:**

| 字段 | 说明 |
|------|------|
| Orient | 铺层角度 [°] |
| Plymat | 铺层材料编号 |
| Tply | 铺层厚度 [mm] |
| Load | 载荷（Type=1应变/曲率, Type=2力/力矩） |

**output:**

| 字段 | 说明 |
|------|------|
| Plymat | 铺层材料属性 |
| Safety | 安全系数 (MoS) |
| LamResult | 层合板计算结果 |
| Geometry | 几何信息 |

---

### LaminatePlate — 层合板网格

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料（必须指定） |
| Name | 'LaminatePlate_1' | 名称 |
| Order | 1 | 单元阶次 |
| Offset | "Bot" | 壳偏移 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Outline | 轮廓 (Line2D) |
| Hole | 孔 (Line2D矩阵) |
| Meshsize | 网格尺寸 [mm] |
| Orient | 铺层角度 [°] |
| Plymat | 铺层材料编号 |
| Tply | 铺层厚度 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 壳网格 (Mesh) |
| Assembly | 实体装配 (Assembly) |
| Assembly1 | 壳装配 (Assembly) |

---

## +bolt 螺栓

### Bolt — 螺栓

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | — | 名称 |
| Order | — | 单元阶次 |
| Type | — | 1=最大预紧力, 2=最小预紧力 |
| BoltType | — | 0=自定义, 1=ISO 4762, 2=ISO 4014, 3=ISO 4017 |
| NutType | — | 1=ISO 4032 |
| WasherType | — | 1=DIN 7089 |
| ThreadType | — | 1=标准螺纹, 2=细牙螺纹 |
| Washer | — | 1=有垫圈, 0=无垫圈 |
| Nut | — | 1=有螺母, 0=无螺母 |
| Echo | — | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| d | 螺栓直径 [mm] |
| l | 总长度（不含头部）[mm] |
| lk | 夹紧长度 [mm] |
| dh | 孔直径 [mm] |
| dha | 倒角直径 [mm] |
| d0 | 空心螺栓内径 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| As | 应力截面积 [mm²] |
| FMmax | 最大装配预紧力 [N] |
| FMmin | 最小装配预紧力 [N] |
| MA | 拧紧扭矩 [Nmm] |
| P | 螺距 [mm] |
| Surface | 截面表面 (Surface2D) |
| Assembly | 装配体 (Assembly) |
| ... | 其他螺纹参数 |

---

### BoltJoint — 螺栓连接

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | 'BoltJoint1' | 名称 |
| JointType | 'SV1' | 连接类型 SV1~SV6 |
| MuT | 0.15 | 零件间摩擦系数 |
| qF | 1 | — |
| ConShear | 0 | 是否考虑剪切 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Bolt | Bolt对象 |
| Clamping | [高度, 材料编号] |
| DA | 外径 [mm] |
| DA1 | 外部支撑直径 [mm] |
| lA | 连接体长度 [mm] |
| ak | 连接体间距 [mm] |
| FAmax | 最大轴向力 [N] |
| FAmin | 最小轴向力 [N] |
| FQ | 剪切力 [N] |
| MT | 扭矩 [Nmm] |
| ra | 摩擦半径 [mm] |
| Nz | 循环次数 |
| n | 螺栓数量 |

**output:**

| 字段 | 说明 |
|------|------|
| deltap | 被连接件柔度 |
| deltapzu | 附加柔度 |
| deltas | 螺栓柔度 |
| n | 载荷比 |
| Phin | 预紧力系数 |

---

### FlangeBolt — 法兰螺栓

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | 'FlangeBolt_1' | 名称 |
| FlangeType | 1 | 法兰类型 |
| MuT | 0.15 | 摩擦系数 |
| ConShear | 0 | 是否考虑剪切 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Bolt | Bolt对象 |
| Clamping | [高度, 材料编号] |
| FQ | 剪切力 [N] |
| Nz | 循环次数 |
| FAmax | 最大轴向力 [N] |
| FAmin | 最小轴向力 [N] |
| MT | 扭矩 [Nmm] |
| nB | 螺栓数量 |
| Geom | Type=1: [dt,da,di] |

**output:** 与 BoltJoint 相同

---

## +bearing 轴承

### RadialPMB — 径向磁轴承

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'RadialPMB_1' | 名称 |
| Echo | 1 | 打印 |
| Material | [] | 磁体材料（必须指定） |
| MeshNum | [10,10] | 每块磁体[径向数,高度数] |
| N_Slice | 36 | 旋转分段数 |
| Order | 1 | 单元阶次 |
| SecNum | 16 | 刚度计算截面数 |

**input:**

| 字段 | 说明 |
|------|------|
| StatorR | 定子半径 [Ri,Ro] |
| RotorR | 转子半径 [Ri,Ro] |
| Height | 各段高度 [H1,H2,...] |
| StatorDir | 定子磁化方向 [角度] |
| RotorDir | 转子磁化方向 [角度] |

**output:**

| 字段 | 说明 |
|------|------|
| Assembly | 网格装配 (Assembly) |
| SolidMesh | 实体网格 (Mesh) |
| ShellMesh | 截面网格 (Mesh) |
| Stiffness | 刚度曲线 |

---

### TaperPMB — 锥形磁轴承

**params:** 与 RadialPMB 相同，额外：

| 字段 | 默认值 | 说明 |
|------|--------|------|
| TaperAngle | 0 | 锥角 [°] |

**input:** 与 RadialPMB 相同

**output:** 比 RadialPMB 多 Stator/Rotor 分离的 Assembly/SolidMesh/ShellMesh，以及 StiffnessX/StiffnessY

---

## +gear 齿轮

### SingleGear — 单齿轮

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Echo | 1 | 打印 |
| Name | 'SingleGear_1' | 名称 |
| Material | [] | 材料 |
| Order | 1 | 单元阶次 |
| Type | 1 | 1=外齿轮标准, 2=外齿轮有倒角, 3=内齿轮有倒角 |
| h_fp | 1.25 | 齿根高系数 |
| rho_fp | 0.38 | 齿根圆角系数 |
| h_ap | 1 | 齿顶高系数 |
| Lsize1 | [128;32;16] | 壳网格线尺寸 |
| Lsize2 | [64;16;8] | 实体网格线尺寸 |
| MeshNTooth | 5 | 壳网格齿数 |
| NWidth | 10 | 实体网格齿宽分段 |
| Helix | 'Right' | 旋向 |
| NMaster | 3 | 主点数量 |

**input:**

| 字段 | 说明 |
|------|------|
| mn | 法向模数 [mm] |
| alphan | 压力角 [°] |
| beta | 螺旋角 [°] |
| ID | 内径 [mm] |
| Z | 齿数 |
| b | 齿宽 [mm] |
| x | 变位系数 |
| Tool | 刀具参数 |

**output:**

| 字段 | 说明 |
|------|------|
| d | 分度圆直径 [mm] |
| db | 基圆直径 [mm] |
| da | 齿顶圆直径 [mm] |
| df | 齿根圆直径 [mm] |
| ToolCurve | 刀具曲线 |
| GearCurve | 齿形曲线 |
| ShellMesh | 壳网格 (Mesh) |
| SolidMesh | 实体网格 (Mesh) |
| Assembly | 实体装配 (Assembly) |
| Assembly1 | 壳装配 (Assembly) |
| MasterPoint | 主点 |

---

### WormGear — 蜗轮蜗杆

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Echo/Name/Material/Order/h_fp/rho_fp/h_ap/Type | 同SingleGear | |
| Lsize1 | [40;12;6] | 蜗杆实体网格线尺寸 |
| Lsize2 | [32;8;4] | 蜗轮实体网格线尺寸 |
| NWidth1 | 40 | 蜗杆齿宽分段 |
| NWidth2 | 10 | 蜗轮齿宽分段 |
| Helix | 'Right' | 旋向 |
| H | 25000 | 要求使用寿命 [h] |
| KA | 1 | 使用系数 |

**input:**

| 字段 | 说明 |
|------|------|
| mx | 轴向模数 [mm] |
| alphan | 压力角 [°] |
| ID1 | 蜗杆内径 [mm] |
| ID2 | 蜗轮内径 [mm] |
| Z1 | 蜗杆头数 |
| Z2 | 蜗轮齿数 |
| b1 | 蜗杆齿宽 [mm] |
| b2H | 蜗轮齿宽 [mm] |
| x | 变位系数 |
| a | 中心距 [mm] |
| Tool | 刀具参数 |
| P1/P2 | 功率 [kW] |
| T1/T2 | 扭矩 [Nm] |
| n1/n2 | 转速 [RPM] |

**output:** 包含蜗杆/蜗轮几何参数、SolidMesh、Assembly、SpringStiffness 等

---

## +beam 梁

### IBeam / CBeam / LBeam — 工字梁/C梁/L梁

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | 'IBeam1'/'CBeam1'/'LBeam1' | 名称 |
| Order | 1 | 单元阶次 |
| Echo | 1 | 打印 |

**input (IBeam/CBeam):**

| 字段 | 说明 |
|------|------|
| t | 翼缘厚度 [mm] |
| h | 高度 [mm] |
| r | 倒角 [mm] |
| d | 腰厚 [mm] |
| b | 腿宽度 [mm] |
| l | 长度 [mm] |
| Stiffnr | 肋板位置、厚度 [mm] |
| Meshsize | 网格尺寸 [mm] |

**input (LBeam):**

| 字段 | 说明 |
|------|------|
| r | 倒角 [mm] |
| d | 翼缘厚度 [mm] |
| b | 腿宽度 [mm] |
| l | 长度 [mm] |
| Stiffnr | 肋板位置、厚度 [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Surface | 截面表面 (Surface2D) |
| Stiffner_Surface | 肋板表面 (Surface2D) |
| SolidMesh | 实体网格 (Mesh) |
| Assembly | 装配体 (Assembly) |

---

## +body 几何体

### Body — 参数化几何体

**params:** Material, Name, Echo

**input:**

| 字段 | 说明 |
|------|------|
| Space | 空间尺寸 [lx,ly,lz] [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:** Times, OriginSolidMesh (Mesh), SolidMesh (Mesh), Assembly (Assembly)

---

### CommonBody — 通用几何体

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Name | 'CommonBody_1' | 名称 |
| Order | 1 | 单元阶次 |
| Type | 1 | 1=长方体, 2=圆柱, 3=球, 4=棱柱, 5=棱锥 |
| ConnectionType | 'Rbe2' | 连接类型 |
| Freq | [0,100000] | 频率范围 |
| NMode | 50 | 模态数 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| GeometryData | Type=1:[L,W,H], 2:[R,H], 3:[R], 4:[N,E,H], 5:[N,E,H] |
| Meshsize | 网格尺寸 [mm] |
| Marker | 标记点 [x,y,z] |

**output:** Assembly, SolidMesh, SubStr

---

### STLBody — STL导入体

**params:** Name, Echo, Material, Position=[0,0,0,0,0,0]

**input:**

| 字段 | 说明 |
|------|------|
| STLFile | STL文件名（不含.stl后缀） |

**output:** SolidMesh (Mesh), Assembly (Assembly)

---

### SingleRubber — 橡胶件

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Type | — | 'Rotary'或'Plate' |
| Name | 'SingleRubber_1' | 名称 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| HS | 邵氏硬度 |
| Geometry | Housing或Commonplate对象 |

**output:** RubberProperty, SolidMesh (Mesh), Assembly (Assembly)

---

## +dome 穹顶

### Dome — 穹顶

**params:** Material, E_Revolve=72, Name, Echo, Order, Offset="BOT", Dtol

**input:**

| 字段 | 说明 |
|------|------|
| Curve | 穹顶曲线 (Line) |
| Thickness | 厚度 [mm] |
| Meshsize | 网格尺寸 [mm] |

**output:** Matrix, ShellMesh (Mesh), Assembly (Assembly)

---

## +connection 连接

### Pin — 销钉

**params:** Material, Name, Order, ConnectionType='Rbe2', Freq=[0,2000], NMode=50, Echo

**input:** R (半径), Length (长度), Meshsize, Marker (标记高度)

**output:** Assembly, SolidMesh, Surface (Surface2D), SubStr

---

### Rod — 连杆

**params:** Material, Name, Order, Type=1(方/圆/半圆), N_Slice=3, ConnectionType, Freq, NMode, Echo

**input:** GeometryData=[L,W,T], Meshsize, Hole=[x,y,r]

**output:** Assembly, SolidMesh, Surface (Surface2D), SubStr

---

### MagnetCoupling — 磁力耦合

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name/Echo/Material | — | 材料=[磁体,轴,壳体] |
| MeshNum | [10,5] | 每块磁体网格数 |
| Pos1/Pos2 | 0.5 | 内/外位置比 |
| Dx/Dy | 0 | 位移 |
| Rot | 0 | 旋转角 [°] |
| WidthNum | 10 | 长度方向网格数 |

**input:**

| 字段 | 说明 |
|------|------|
| Pair | 磁极对数 |
| A | 轴内径 |
| B | 轴外径 |
| C | 壳体内径 |
| D | 壳体外径 |
| OuterMagnetSize | [长度,厚度] |
| InnerMagnetSize | [长度,厚度] |
| Width | 耦合宽度 |

**output:** Assembly, Section, SolidMesh, ShellMesh, Number, Surface, FEA_Force

---

## +structure 结构

### Bracket — 支架

**params:** Material, Name, Section, Echo

**input:** Layer, SectionNum, Meshsize, Rotate

**output:** Matrix, BeamMesh, Assembly

---

### Grid — 结构网格

**params:** Material, Name, Section, Type, Boundary, Echo, JointType, BoundaryType, LoadPosition, Gravity

**input:** lx, ly, lz, nx, ny, PLoad (永久载荷), VLoad (可变载荷)

**output:** Matrix, Shape, BeamMesh, Assembly

---

### ShellGrid — 壳网格

**params:** Material, Name, Section, Type, JointType, BoundaryType, Echo, Gravity

**input:** f (矢高), span (跨度), kn, nx, PP (永久压力), VP (可变压力)

**output:** Matrix, Shape, BeamMesh, Assembly

---

## +foil 翼型

### Foil — 翼型分析

**params:** Re=1e6, Name, Mach=0.2, Echo, N=160, Iter=100

**input:** Alpha (攻角数组), FoilName (NACA字符串或文件名)

**output:** Coor (坐标), Data (气动力数据)

---

### FoilGen — 翼型3D生成

**params:** Name, Echo, Origin

**input:** Foil (Foil对象或坐标), Dx, Dy, Dz, Rotx, Roty, Rotz, Scale, SizeZ

**output:** Layer, Mesh

---

## +solve 求解

### RotDyn — 转子动力学

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Material | [] | 材料 |
| Damping | [] | 阻尼 |
| Name | 'RotDyn1' | 名称 |
| Modopt | 'QRDAMP' | 模态分析选项 |
| NMode | 12 | 模态数 |
| Freq | [0,2000] | 频率范围 |
| Coriolis | 1 | 科氏力 |
| Type | 2 | 2=模态, 3=谐响应, 4=稳态, 5=加速 |
| Solver | 'ANSYS' | 'ANSYS'或'Local' |
| Rayleigh | [0,0] | Rayleigh阻尼 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Shaft | 轴对象 |
| Housing | 壳体对象 |
| MaterialNum | 材料编号 |
| Speed | 转速 [RPM] |
| SpeedRange | 转速范围 (Type=5) |
| Discs | [节点号, 外径, 内径, 长度, 材料号] |
| PointMass | [节点号, m, JT, JD] |
| BCNode | [节点号, ux,uy,uz,rotx,roty,rotz] |
| Bearing | [节点号, kx, K11,K22,K12,K21, Cx,C11,C22,C12,C21] |
| TorBearing | [节点号, krot, Crot] |
| LUTBearing | [节点号, 表号] |
| KeyNode | 关键节点号 |
| UnBalanceForce | [节点号, me] |
| Time/TimeSeries | 时间序列 |
| PIDController | PID控制器 |

**output:**

| 字段 | 说明 |
|------|------|
| Assembly | 装配体 |
| RotorSystem | 转子系统 |
| Campbell | Campbell数据 |
| Shape | 模态振型 |
| CriticalSpeed | 临界转速 |
| Mass | 总质量 |
| FRFResult | 频响结果 |
| ModeResult | 模态结果 |
| TimeSeriesResult | 时间序列结果 |

---

### SubStr — 子结构

**params:** Name, Freq=[0,100000], NMode=50, CMSMethod="FIX"

**input:** SubStr (Assembly), Master [PartNum, NodeNum, Type]

**output:** Nodes, Geom, Path

---

### SubModel — 子模型

**params:** Name

**input:** Coarse (粗模型Assembly), Sub (子模型Assembly)

**output:** 无

---

### Optimization — 优化

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'Optimization1' | 名称 |
| Parameter | [] | 优化算法参数 |
| Method | 'PSO' | 优化方法：PSO（粒子群） |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| LBound | 参数下边界 |
| UBound | 参数上边界 |
| Constraint | 约束方程 |
| Goal | 目标函数 |

**output:**

| 字段 | 说明 |
|------|------|
| Fmin | 最优值 |
| GBest | 最优个体 |
| G_Iteration | 迭代最优个体记录 |
| F_Iteration | 迭代最优值记录 |

---

## +signal 信号

### SignalAnalysis — 信号分析

**params:** Name, Echo, Material (信号数据相关参数)

**input:** 信号数据

**output:** 分析结果

---

### EventAnalysis — 事件分析

**params:** Name, Echo

**input:** 事件数据

**output:** 分析结果

---

### ForceLoad — 力载荷

**params:** Name, Echo, Material

**input:** 载荷文件

**output:** 载荷数据

---

## +method 方法

### ISO1940 — 动平衡

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'ISO1940_1' | 名称 |
| Echo | 1 | 打印 |
| Ratio | 0.0001 | 不平衡质量比 |
| G | 2.5 | 平衡品质等级 G |

**input:**

| 字段 | 说明 |
|------|------|
| LA | A端距离 [mm] |
| LB | B端距离 [mm] |
| n | 转速 [RPM] |
| Mass | 质量 [ton] |

**output:**

| 字段 | 说明 |
|------|------|
| Uper | 总许用不平衡量 [gmm] |
| UperA | A端许用不平衡量 [gmm] |
| UperB | B端许用不平衡量 [gmm] |
| MA | A端等效质量 [ton] |
| MB | B端等效质量 [ton] |
| DisA | A端偏心距 [mm] |
| DisB | B端偏心距 [mm] |

---

### RotatingDisc — 旋转盘应力

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'RotatingDisc_1' | 名称 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Ri | 内径 [mm] |
| Ro | 外径 [mm] |
| Location | 应力输出位置 [mm] |
| Omega | 转速 [RPM] |
| Rho | 密度 [kg/m³] |
| v | 泊松比 |

**output:**

| 字段 | 说明 |
|------|------|
| Stress | [径向应力, 环向应力, 等效应力] [MPa] |

---

### Margin — 安全系数

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'Margin1' | 名称 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Component | Component对象系列（cell数组） |

**output:**

| 字段 | 说明 |
|------|------|
| Factor | 安全系数名称列表（cell数组） |

**注：** baseline 和 capacity 属性中存储各 Component 的基准值和容量值，可通过 `PlotCapacity` 方法可视化。

---

### AirProperty — 空气属性

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'AirProperty_1' | 名称 |
| Echo | 1 | 打印 |
| xCO2 | 0.0004 | CO₂摩尔分数 |

**input:**

| 字段 | 说明 |
|------|------|
| t | 温度 [℃]（默认15） |
| p | 气压 [hPa]（默认1013.25） |
| h | 相对湿度 0~100 |

**output:**

| 字段 | 说明 |
|------|------|
| rho | 密度 [kg/m³] |
| mu | 动力粘度 [N·s/m²] |
| k | 导热系数 [W/(m·K)] |
| c_p | 定压比热 [J/(kg·K)] |
| c_v | 定容比热 [J/(kg·K)] |
| gamma | 比热比 |
| c | 声速 [m/s] |
| nu | 运动粘度 [m²/s] |
| alpha | 热扩散率 [m²/s] |
| Pr | 普朗特数 |
| M | 摩尔质量 [kg/mol] |
| R | 气体常数 [J/(kg·K)] |

---

### DNVGL_0361 — DNVGL SN曲线

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Beta_k | 1 | 缺口系数 |
| Gamma_m | 1.265 | 材料安全系数 |
| Sps | 2/3 | 存活概率 |
| j0 | 0 | 初始值 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Mat | 材料属性（含FKM数据） |
| t | 壁厚 [mm] |
| deff | 有效直径 [mm] |
| Rz | 表面粗糙度 |
| R | 应力比 |
| Sigma_m | 平均应力 [MPa] |
| j | 参数 |

**output:**

| 字段 | 说明 |
|------|------|
| Sigma_b | 抗拉强度 [MPa] |
| Sigma_0d2 | 屈服强度 [MPa] |
| Ft | 技术系数 |
| Fo | 表面粗糙度系数 |
| Fot | 综合表面技术系数 |
| Fotk | 总影响系数 |
| m1 | SN曲线斜率1 |
| m2 | SN曲线斜率2 |
| Sigma_w | 抛光试件疲劳强度 [MPa] |
| M | 平均应力敏感度 |
| Sigma_wk | 构件疲劳强度 [MPa] |
| Sigma_A | SN曲线拐点应力幅 [MPa] |
| Delta_Sigma_1 | 疲劳上限应力范围 [MPa] |
| Delta_Sigma_A | 拐点应力范围 [MPa] |
| Sd | 质量等级 |
| St | 壁厚相关系数 |
| S | 总提升系数 |
| ND | 拐点循环数 |
| N1 | 上限循环数 |

---

### FRFGen — 频响函数生成

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'FRFGen_1' | 名称 |
| Echo | true | 打印 |
| GenerationMode | 'ModeBased' | 模式：ModeBased / ResidueKai / ResidueAltintas |
| FStart | 0 | 起始频率 [Hz] |
| FEnd | 3000 | 结束频率 [Hz] |
| dF | 0.5 | 频率分辨率 [Hz] |

**input:**

| 字段 | 说明 |
|------|------|
| Wn | 固有频率数组 [rad/s] |
| Zeta | 阻尼比数组 |
| K | 模态刚度数组 [N/m]（ModeBased模式） |
| Residue | 残差数组（复数）[m/N]（Residue模式） |

**output:**

| 字段 | 说明 |
|------|------|
| FRF | 复数FRF数据 |
| Freq | 频率向量 [Hz] |
| FRFReal | FRF实部 |
| FRFImag | FRF虚部 |
| FRFMag | FRF幅值 |

---

### Vis_cal — 粘度计算

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Echo | 1 | 打印 |
| Material | [] | 润滑油材料（必须指定，含v40、v100、Dens字段） |

**input:**

| 字段 | 说明 |
|------|------|
| T | 温度 [℃] |

**output:**

| 字段 | 说明 |
|------|------|
| A | 粘温系数A（ISO/TR 6336-22） |
| B | 粘温系数B（ISO/TR 6336-22） |
| Vis1 | 运动粘度 [mm²/s] |
| Vis2 | 动力粘度 [Ns/mm²] |
| Rou | 密度 [g/cm³] |

---

### FKM_Cal — FKM疲劳计算

**params:**

| 字段 | 默认值 | 说明 |
|------|--------|------|
| Name | 'FKM_Cal_1' | 名称 |
| KA | 1 | 使用系数 |
| Echo | 1 | 打印 |

**input:**

| 字段 | 说明 |
|------|------|
| Mat | 材料属性（含FKM数据） |
| deff | 有效直径 [mm] |

**output:**

| 字段 | 说明 |
|------|------|
| Mat_Output | 输出材料属性（含修正后的Rm、Rp） |
| KA | 使用系数 |
| Kdm | 尺寸系数（拉压） |
| Kdp | 尺寸系数（弯曲） |

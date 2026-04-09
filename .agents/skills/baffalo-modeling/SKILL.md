---
name: "baffalo-modeling"
description: "Baffalo MATLAB mechanical system modeling toolkit. Invoke when user asks to model mechanical components, create FEM meshes, perform rotor dynamics, bolt analysis, bearing design, gear design, signal analysis, or any engineering simulation using Baffalo."
---

# Baffalo 建模辅助

Baffalo 是开源 MATLAB 工具箱，用于机械系统建模分析，提供网格、绘图和工程计算功能，可直接进行网格层级的部件装配，并导出到 ANSYS 和 Simpack。

当用户要求使用 Baffalo 进行建模时，**不要凭记忆编写代码**，必须严格按以下五步流程执行。

---

## 第一步：模块检索与确认

根据用户需求，在下表中找到对应的模块，然后**询问用户**确认要使用的核心类。

### 模块索引表

| 用户需求关键词 | 模块包 | 核心类 | 源码路径 | 案例路径 |
|---|---|---|---|---|
| 轴、Commonshaft、阶梯轴 | +shaft | Commonshaft | `+shaft/@Commonshaft/Commonshaft.m` | `Testing/001_Demo/001_Commonshaft/` |
| SubStr、子结构 | +solve | SubStr | `+solve/@SubStr/SubStr.m` | `Testing/001_Demo/002_SubStr/` |
| 转子动力学、Campbell、模态、RotDyn | +solve | RotDyn | `+solve/@RotDyn/RotDyn.m` | `Testing/001_Demo/006_RotDyn/` |
| 板、Commonplate、开孔板 | +plate | Commonplate | `+plate/@Commonplate/Commonplate.m` | `Testing/001_Demo/004_Commonplate/` |
| BossPlate、带凸台板 | +plate | BossPlate | `+plate/@BossPlate/BossPlate.m` | `Testing/001_Demo/008_BossPlate/` |
| 联轴器膜片、CouplingMembrane | +plate | CouplingMembrane | `+plate/@CouplingMembrane/` | `Testing/001_Demo/009_CouplingMembrane/` |
| 层合板、Laminate、复合材料 | +plate | Laminate | `+plate/@Laminate/Laminate.m` | `Testing/001_Demo/025_Laminate/` |
| LaminatePlate、层合板网格 | +plate | LaminatePlate | `+plate/@LaminatePlate/` | `Testing/001_Demo/061_LaminatePlate/` |
| 翼型、Foil、NACA | +foil | Foil | `+foil/@Foil/Foil.m` | `Testing/001_Demo/007_Foil/` |
| 翼型生成、FoilGen | +foil | FoilGen | `+foil/@FoilGen/FoilGen.m` | `Testing/001_Demo/012_FoilGen/` |
| 壳体、旋转体、Housing | +housing | Housing | `+housing/@Housing/Housing.m` | `Testing/001_Demo/011_Housing/` |
| SlotHousing、开槽壳体 | +housing | SlotHousing | `+housing/@SlotHousing/SlotHousing.m` | `Testing/001_Demo/056_SlotHousing/` |
| PolygonHousing、多边形壳体 | +housing | PolygonHousing | `+housing/@PolygonHousing/` | `Testing/001_Demo/057_PolygonHousing/` |
| CompositeRing、复合环 | +housing | CompositeRing | `+housing/@CompositeRing/` | `Testing/001_Demo/022_CompositeRing/` |
| 风电塔筒、WindturbineTower | +housing | WindturbineTower | `+housing/@WindturbineTower/` | `Testing/001_Demo/016_WindturbineTower/` |
| 轴承支撑、ShaftSupport | +shaft | ShaftSupport | `+shaft/@ShaftSupport/ShaftSupport.m` | `Testing/001_Demo/013_ShaftSupport/` |
| 油封、OilSeal | +shaft | OilSeal | `+shaft/@OilSeal/OilSeal.m` | `Testing/001_Demo/036_OilSeal/` |
| 花键轴、ToothShaft | +shaft | ToothShaft | `+shaft/@ToothShaft/ToothShaft.m` | `Testing/001_Demo/055_ToothShaft/` |
| Body、几何体 | +body | Body | `+body/@Body/Body.m` | `Testing/001_Demo/014_Body/` |
| STLBody、STL导入 | +body | STLBody | `+body/@STLBody/STLBody.m` | `Testing/001_Demo/063_STLBody/` |
| SingleRubber、橡胶件 | +body | SingleRubber | `+body/@SingleRubber/SingleRubber.m` | `Testing/001_Demo/065_SingleRubber/` |
| 穹顶、Dome | +dome | Dome | `+dome/@Dome/Dome.m` | `Testing/001_Demo/015_Dome/` |
| 螺栓、Bolt | +bolt | Bolt | `+bolt/@Bolt/Bolt.m` | `Testing/001_Demo/028_Bolt/` |
| 螺栓连接、BoltJoint、预紧力 | +bolt | BoltJoint | `+bolt/@BoltJoint/BoltJoint.m` | `Testing/001_Demo/029_BoltJoint/` |
| 法兰螺栓、FlangeBolt | +bolt | FlangeBolt | `+bolt/@FlangeBolt/FlangeBolt.m` | `Testing/001_Demo/031_FlangeBolt/` |
| 齿轮、SingleGear | +gear | SingleGear | `+gear/@SingleGear/SingleGear.m` | `Testing/001_Demo/046_SingleGear/` |
| 蜗轮蜗杆、WormGear | +gear | WormGear | `+gear/@WormGear/WormGear.m` | `Testing/001_Demo/062_WormGear/` |
| 径向磁轴承、RadialPMB | +bearing | RadialPMB | `+bearing/@RadialPMB/RadialPMB.m` | `Testing/001_Demo/032_RadialPMB/` |
| 锥形磁轴承、TaperPMB | +bearing | TaperPMB | `+bearing/@TaperPMB/TaperPMB.m` | `Testing/001_Demo/060_TaperPMB/` |
| 梁、CBeam、工字梁 | +beam | CBeam, IBeam, LBeam | `+beam/@CBeam/`, `+beam/@IBeam/`, `+beam/@LBeam/` | `Testing/001_Demo/018_IBeam/`, `019_CBeam/`, `020_LBeam/` |
| Pin、销钉 | +connection | Pin | `+connection/@Pin/Pin.m` | — |
| Rod、连杆 | +connection | Rod | `+connection/@Rod/Rod.m` | — |
| 磁力耦合、MagnetCoupling | +connection | MagnetCoupling | `+connection/@MagnetCoupling/` | `Testing/001_Demo/045_MagnetCoupling/` |
| Bracket、支架 | +structure | Bracket | `+structure/@Bracket/Bracket.m` | `Testing/001_Demo/047_Bracket/` |
| Grid、结构网格 | +structure | Grid | `+structure/@Grid/Grid.m` | `Testing/001_Demo/048_Grid/` |
| ShellGrid、壳网格 | +structure | ShellGrid | `+structure/@ShellGrid/ShellGrid.m` | `Testing/001_Demo/049_ShellGrid/` |
| 信号分析、FFT、小波、SignalAnalysis | +signal | SignalAnalysis | `+signal/@SignalAnalysis/` | `Testing/001_Demo/069_SignalAnalysis/` |
| 事件分析、EventAnalysis | +signal | EventAnalysis | `+signal/@EventAnalysis/` | `Testing/001_Demo/070_EventAnalysis/` |
| 力载荷、ForceLoad | +signal | ForceLoad | `+signal/@ForceLoad/ForceLoad.m` | `Testing/001_Demo/010_ForceLoad/` |
| 优化、PSO、粒子群 | +solve | Optimization | `+solve/@Optimization/Optimization.m` | — |
| SubModel、子模型 | +solve | SubModel | `+solve/@SubModel/SubModel.m` | `Testing/001_Demo/035_SubModel/` |
| ISO1940、动平衡 | +method | ISO1940 | `+method/@ISO1940/ISO1940.m` | `Testing/001_Demo/003_ISO1940/` |
| 旋转盘、RotatingDisc | +method | RotatingDisc | `+method/@RotatingDisc/` | `Testing/001_Demo/030_RotatingDisc/` |
| Margin、安全系数 | +method | Margin | `+method/@Margin/Margin.m` | `Testing/000_Framework/001_Margin/` |
| 空气属性、AirProperty | +method | AirProperty | `+method/@AirProperty/AirProperty.m` | `Testing/001_Demo/053_AirProperty/` |
| DNVGL_0361 | +method | DNVGL_0361 | `+method/@DNVGL_0361/DNVGL_0361.m` | `Testing/001_Demo/037_DNVGL_0361/` |
| FRF、频响函数 | +method | FRFGen | `+method/@FRFGen/FRFGen.m` | — |
| 粘度、Vis_cal | +method | Vis_cal | `+method/@Vis_cal/Vis_cal.m` | `Testing/001_Demo/039_Vis_cal/` |
| FKM疲劳 | +method | FKM_Cal | `+method/@FKM/@FKM_Cal/FKM_Cal.m` | — |

---

## 第二步：阅读参考文档

用户确认核心类后，阅读参考文档 `reference.md`（与本文件同目录），了解该类的 **input、params、output** 字段定义及含义。

文档按包分组，每个核心类都有完整的字段表格。阅读后即可掌握该类需要哪些输入参数、有哪些可调参数、以及输出结果的结构。

---

## 第三步：阅读源码和案例

在了解字段定义的基础上，按以下优先级阅读源文件以获取精确的 API 用法：

### 阅读顺序（按优先级排列）

1. **案例文件（最高优先级）** — 先阅读 `Testing/` 下对应的 Demo 文件，了解完整的使用流程和参数传递方式
2. **构造函数** — 阅读类的构造函数 `.m` 文件（与类同名的 `.m`），了解对象的创建方式和参数
3. **核心方法** — 使用 SearchCodebase 搜索类名下的方法，了解可用的操作

### 检索方法

使用 SearchCodebase 工具搜索相关代码，例如：
- 搜索类定义：`"classdef ClassName"`
- 搜索方法：`"function result = MethodName"`
- 使用 Grep 搜索特定模式

---

## 第四步：编写代码

### 编码规范

1. **网格输出约定** — 组件的 `output` 中通常包含 `Surface`（Surface2D）、`SolidMesh`（Mesh）、`Assembly`（Assembly）三个字段
2. **路径设置** — 使用前需运行 `setBaffaloPath` 设置 ANSYS/Simpack/ParaView 路径

### 代码风格

- 不添加注释（除非用户要求）
- 遵循 MATLAB 包命名约定（`+` 前缀目录）
- 使用链式调用风格（方法返回对象本身）
- 数值单位默认为 mm（长度）、MPa（应力）、kg（质量）

---

## 第五步：验证

编写完成后，建议用户：
1. 在 MATLAB 中运行 `setBaffaloPath`
2. 运行生成的代码
3. 检查 `Plot3D` / `Plot2D` 输出是否正确
4. 如需 ANSYS 求解，确认 ANSYS 路径已设置

---

## 注意事项

- 编写代码前**必须先检索并阅读源码**，不要凭记忆猜测 API
- 如果模块索引表中没有覆盖用户需求，使用 SearchCodebase 在整个项目中搜索
- 优先参考 Testing 目录中的案例文件，它们展示了最准确的用法

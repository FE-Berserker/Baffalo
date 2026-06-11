# Baffalo

## 项目说明

Baffalo 是开源 MATLAB 机械系统建模分析工具箱，提供网格、绘图和工程计算功能，可直接进行网格层级的部件装配，并导出到 ANSYS 和 Simpack。

## 重要工作流程

**在编写任何脚本或代码之前，务必先咨询用户的建议。**

任何自动化脚本、工具脚本或批处理文件的创建都需要：
1. 先向用户说明脚本的目的和用途
2. 等待用户确认后再开始编写
3. 编写完成后再次确认是否符合需求

---

## Baffalo 建模注意事项

### 绘图相关

**Baffalo 组件类已内置绘图方法，无需额外添加 MATLAB 原生绘图代码。**

| 场景 | 使用方法 | 避免 |
|------|----------|------|
| 截面/轮廓绘制 | `Plot(line2D_obj)` | figure, axis, grid, xlabel, ylabel, title |
| 2D 结果绘制 | `Plot2D(component_obj)` | figure, axis 等 |
| 3D 结果绘制 | `Plot3D(component_obj)` | figure, axis 等 |

### Line2D 相关

- **AddLine** - 添加直线段，每次 `AddPoint` 应只添加两个点（线段端点）
- **AddCurve** - 添加曲线段，用于多点曲线
- **AddCircle** - 添加圆/圆弧

使用示例：
```matlab
a = Point2D('Points');
a = AddPoint(a, [x1; x2], [y1; y2]);  % 每次添加一条线段的两个端点

b = Line2D('Outline');
b = AddLine(b, a, 1);  % 使用第1组点
```

import matlab.engine
import numpy as np

# 启动 MATLAB 引擎（不使用后台模式）
print("正在启动 MATLAB 引擎...")
eng = matlab.engine.start_matlab()
print("MATLAB 引擎已启动")

# 示例1: 计算平方根
result = eng.sqrt(4.0)
print(f"sqrt(4) = {result}")

# 示例2: 计算正弦值
x = np.linspace(0, 2 * np.pi, 100)
y = [eng.sin(float(xi)) for xi in x]
print(f"sin(pi/2) = {eng.sin(float(np.pi / 2))}")

# 关闭 MATLAB 引擎
eng.quit()
print("MATLAB 引擎已关闭")

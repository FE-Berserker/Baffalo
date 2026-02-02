function [C10,C01] = MR_Estimate(obj)
% Mooney-Rivlin parameter estimate (Mooney-Rivlin参数估计)
% Author : Xie Yu
%
% 功能说明：
% 根据弹性模量E，使用Mooney-Rivlin模型的简化公式估计C10和C01参数。
% Mooney-Rivlin模型用于描述橡胶材料的超弹性应力-应变关系。
%
% 简化公式：
%   C10 = E / 6 / (1 + Ratio)
%   C01 = C10 * Ratio
% 其中：
%   E = 弹性模量 [N/mm²]
%   Ratio = C01/C10 (设定为0.25)
%
% 输出：
%   C10 - Mooney-Rivlin第一变形常数 [N/mm²]
%   C01 - Mooney-Rivlin第二变形常数 [N/mm²]
%
% 注意：
%   - 这是一个简化的估计方法，实际Mooney-Rivlin模型更复杂
%   - Ratio值0.25是经验值，可根据实际材料特性调整

E=obj.output.E;       % 获取弹性模量 [N/mm²]
Ratio=0.25;           % 设定C01与C10的比值为0.25
C10=E/6/(1+Ratio);  % 计算C10: E/(6*(1+Ratio))
C01=C10*Ratio;         % 计算C01: C10*Ratio
end


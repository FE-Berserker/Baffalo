function PlotStressStrainCurve(obj)
% 应力-应变曲线绘制 (Stress-Strain Curve Plotting)
% Author : Xie Yu
%
% 功能说明：
% 根据Mooney-Rivlin模型参数(C10, C01)，绘制橡胶材料的应力-应变曲线。
% 使用Neo-Hookean模型计算工程应力，绘制单向拉伸下的应力-应变关系。
%
% 理论基础：
% Neo-Hookean模型应变能密度函数：
%   W = C10*(I1 - 3) + C01*(I2 - 3)
%   其中 I1 = λ1² + λ2² + λ3² - 1
%        I2 = λ1^2 * λ2^2 * λ3^2
%        λ1, λ2, λ3 为主伸长比
%
% 工程应力计算：
%   σ = 2*(λ1 - 1/λ1) * (C10 + 2*C01/λ1²)
%
% 输出：
%   绘制应力-应变曲线图
%
% 应用场景：
%   用于材料力学分析、有限元验证、参数反演等

C10=obj.output.MR_Parameter(1);  % 获取Mooney-Rivlin第一参数 C10 [N/mm²]
C01=obj.output.MR_Parameter(2);  % 获取Mooney-Rivlin第二参数 C01 [N/mm²]

epsilon=0:0.05:1;               % 应变范围 [0到1，步长0.05]
Sigma=(C10+C01./(1+epsilon)).*2.*(1+epsilon-1./(1+epsilon)).^2;  % 计算工程应力 [N/mm²]

g=Rplot('x',epsilon,'y',Sigma);     % 创建绘图对象：x轴=应变，y轴=应力
g=geom_line(g);                      % 设置为线图
g=set_axe_options(g,'grid',1);       % 显示网格
g=set_names(g,'column','Origin','x',"Strain",'y','Stress');  % 设置坐标轴名称
g=set_title(g,'Stress-strain curve'); % 设置图表标题
figure('Position',[100 100 800 600]);  % 设置图形窗口位置和大小
draw(g);                            % 绘制图形

end

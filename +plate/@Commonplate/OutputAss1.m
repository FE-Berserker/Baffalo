function obj = OutputAss1(obj)
% OutputAss1 - 输出壳模型装配
% 为板的壳网格创建装配对象，并设置单元类型、截面和材料属性
% Author: Xie Yu

%% 检查壳网格是否存在
if isempty(obj.output.ShellMesh)
    obj=OutputShellModel(obj);
end

%% 创建装配对象
Ass=Assembly(obj.params.Name,'Echo',0);

%% 添加板的壳网格
% 初始位置和姿态
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.ShellMesh.Meshoutput,'position',position);

%% 设置单元类型(ET)
% Order=2时使用281单元（二次壳单元）
% Order=1时使用181单元（一次壳单元）
if obj.params.Order==2
    ET1.name='281';ET1.opt=[];ET1.R=[];
else
    ET1.name='181';ET1.opt=[];ET1.R=[];
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);

%% 设置材料属性
% 板的材料参数：密度、弹性模量、泊松比、热膨胀系数
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

%% 设置截面属性
% 壳单元需要设置截面参数
Sec.type="shell";
Sec.data=[obj.input.Thickness,1,3];  % [厚度, 单元编号, 集成点数]
Sec.offset=obj.params.Offset;             % 偏移位置：Mid/Top/Bottom
Ass=AddSection(Ass,Sec);
Ass=SetSection(Ass,1,1);

%% 保存到输出
obj.output.Assembly1=Ass;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output shell mesh assembly .\n');
end
end

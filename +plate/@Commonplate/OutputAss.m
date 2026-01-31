function obj = OutputAss(obj)
% OutputAss - 输出实体模型装配
% 为板的实体网格创建装配对象，并设置单元类型和材料属性
% Author: Xie Yu

%% 创建装配对象
Ass=Assembly(obj.params.Name,'Echo',0);

%% 添加板的实体网格
% 初始位置和姿态
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput,'position',position);

%% 设置单元类型(ET)
% Order=2时使用186单元（二次四面体）
% Order=1时使用185单元（一次四面体）
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
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

%% 保存到输出
obj.output.Assembly=Ass;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end

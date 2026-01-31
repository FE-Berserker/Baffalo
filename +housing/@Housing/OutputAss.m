function obj = OutputAss(obj)
% OutputAss - 输出壳体装配文件
% 创建用于有限元分析的装配文件
% Author : Xie Yu

%% 检查是否已生成实体网格
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

%% 创建装配对象
Ass=Assembly(obj.params.Name,'Echo',0);

%% 添加壳体部件
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput);

%% 定义单元类型（ET）
% 185: 一阶四面体单元（C3D4）
% 186: 二阶四面体单元（C3D10）
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
end

Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);

%% 定义材料属性
mat1.Name=obj.params.Material.Name;

% 支持各向异性材料（E1,E2,E3）和各向同性材料（E）
if isfield(obj.params.Material,"E1")
    % 各向异性材料
    mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E1;"EY",obj.params.Material.E2;"EZ",obj.params.Material.E3;...
        "PRXY",obj.params.Material.v12;"PRYZ",obj.params.Material.v23;"PRXZ",obj.params.Material.v13;...
        "GXY",obj.params.Material.G12;"GYZ",obj.params.Material.G23;"GXZ",obj.params.Material.G13];
else
    % 各向同性材料
    mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
        "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
end

Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

%% 保存结果
obj.output.Assembly=Ass;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output solid assembly .\n');
end
end


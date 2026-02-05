function obj=OutputAss(obj)
% OutputAssembly - 输出装配体信息
% 创建轴支座的ANSYS装配体，包括单元类型、材料属性等
% Author : Xie Yu

% 创建装配体对象，名称使用参数中指定的名称，关闭回显
Ass=Assembly(obj.params.Name,'Echo',0);

% 创建部件 - 将轴支座网格添加到装配体中
position=[0,0,0,0,0,0];  % 位置参数 [x,y,z,rx,ry,rz]，默认原点
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput,'position',position);

% 定义单元类型(ET)
% ANSYS SOLID185: 3D 8节点结构实体单元
% ANSYS SOLID186: 3D 20节点高阶结构实体单元
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];  % 二阶单元：SOLID186
else
    ET1.name='185';ET1.opt=[];ET1.R=[];  % 一阶单元：SOLID185
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);  % 为部件1设置单元类型1

% 定义材料属性
% ANSYS材料属性包括：密度(DENS)、弹性模量(EX)、泊松比(NUXY)、热膨胀系数(ALPX)
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;...  % 密度 [kg/m³]
    "EX",obj.params.Material.E;...                % 弹性模量 [Pa]
    "NUXY",obj.params.Material.v;...              % 泊松比
    "ALPX",obj.params.Material.a];               % 热膨胀系数 [1/K]
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);  % 为部件1设置材料1

%% 保存结果
obj.output.Assembly=Ass;

%% 打印提示信息
if obj.params.Echo
    fprintf('Successfully output solid assembly .\n');
end
end


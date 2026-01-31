function obj=OutputAss1(obj)
% OutputAss1 - 输出梁模型装配
% 为轴的梁网格创建装配对象，并设置单元类型、材料和截面属性
% Author: Xie Yu

%% 创建装配对象
Ass=Assembly(obj.params.Name,'Echo',0);

%% 添加轴的梁网格
position=[0,0,0,0,0,0]; % 初始位置和姿态
Ass=AddPart(Ass,obj.output.BeamMesh.Meshoutput,'position',position);

%% 设置单元类型(ET)
% 使用188梁单元（3D梁单元，考虑剪切变形）
ET.name='188';ET.opt=[3,2];ET.R=[];
Ass=AddET(Ass,ET);
Ass=SetET(Ass,1,1);

%% 计算梁的刚度矩阵
Ass=BeamK(Ass,1);

%% 设置材料属性
mat1.Name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

%% 设置截面属性
% 将每个梁单元段作为独立的部件，分别设置截面
Section=obj.output.BeamMesh.Section;
Ass=DividePart(Ass,1,mat2cell((1:size(Section,1))',ones(1,size(Section,1))));
for i=1:size(Section,1)
    % 添加截面（实心圆或空心圆）
    Ass=AddSection(Ass,Section{i,1});
    % 将截面分配给对应部件
    Ass=SetSection(Ass,i,i);
end

%% 保存到输出
obj.output.Assembly1=Ass;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output beam model .\n');
end
end

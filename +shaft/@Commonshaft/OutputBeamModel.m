function obj=OutputBeamModel(obj)
% OutputBeamModel - 生成梁模型
% 为轴创建梁单元网格和截面定义
% Author: Xie Yu

%% 创建节点
a=Point2D('Point1','Echo',0);
% 轴向节点位置（x坐标）
x=obj.output.Node;
% y坐标设为0（轴位于x轴上）
y=zeros(size(x,1),1);
a=AddPoint(a,x,y);

%% 创建线
b=Line2D('Line1','Echo',0);
b=AddCurve(b,a,1);
b=Meshoutput(b); % 生成网格输出
obj.output.BeamMesh.Meshoutput=b.Meshoutput;

%% 创建截面定义
% 梁单元的截面数量 = 节点数 - 1
SecNum=size(obj.output.ID,1)-1;
Section=cell(SecNum,1);

for i=1:SecNum
    Section{i,1}.type="beam";
    % 计算截面的平均内外径
    IR=obj.output.ID(i)/4+obj.output.ID(i+1)/4;  % 内半径
    OR=obj.output.OD(i)/4+obj.output.OD(i+1)/4;  % 外半径

    if IR==0
        % 实心圆截面
        Section{i,1}.subtype="CSOLID";
        Section{i,1}.data=[OR,obj.params.Beam_N]; % [半径, 分段数]
    else
        % 空心圆截面（圆管）
        Section{i,1}.subtype="CTUBE";
        Section{i,1}.data=[IR,OR,obj.params.Beam_N]; % [内半径, 外半径, 分段数]
    end
end

%% 保存到输出
obj.output.BeamMesh.Section=Section;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output beam assembly .\n');
end
end

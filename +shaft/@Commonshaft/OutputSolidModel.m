function obj=OutputSolidModel(obj)
% OutputSolidModel - 生成实体模型
% 为轴创建3D实体网格（四面体单元）
% 支持四种不同的网格生成策略，取决于轴的几何形状
% Author: Xie Yu

%% 设置默认网格尺寸
if isempty(obj.input.Meshsize)
    % 如果未指定网格尺寸，使用最小外径的1/10
    obj.input.Meshsize=min(min(obj.input.OD))/10;
end

%% 根据轴的几何特征选择网格生成策略

%% 情况1: 完全空心轴（所有内径都大于0）
% 使用旋转2D截面生成3D网格
if min(min(obj.input.ID))~=0
     mm=CreateMesh3D2(obj);
end

%% 情况2: 有内径为0的轴（实心或部分实心）
% 需要分情况处理端面形状
if min(min(obj.input.ID))==0
    % 找到内径为0的段
    Temp=sum(obj.input.ID,2);
    [row,~]=find(Temp==0,1);

    if size(obj.input.Length,1)~=1
        % 多段轴
        if row==1
            % 第一段是实心的
            r1=obj.input.OD(row,1)/2;
        else
            r1=obj.input.ID(row-1,2)/2;
        end
    else
        % 单段轴
        r1=obj.input.OD(row,1)/2;
        r2=obj.input.OD(row,2)/2;
    end

    mm=Mesh('Mesh2','Echo',0);

    if size(obj.input.Length,1)~=1
        % 多段轴的处理
        if row==1
            % 从左端面开始的实心段
            mm=CreateMesh3D3(obj,mm,r1);
        else
            % 中间段的实心部分
            mm=CreateMesh3D4(obj,mm,r1,row);
        end
    else
        % 单段轴的处理
        mm=CreateMesh3D1(obj,mm,r1,r2);
    end

    % 使用TetGen生成四面体网格
    mm=Mesh3D(mm);
end

%% 如果需要二阶单元，将一阶网格转换为二阶
if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% 提取网格信息
mm.Cb=mm.Meshoutput.boundaryMarker;   % 边界标记
mm.Face=mm.Meshoutput.facesBoundary;   % 面定义
mm.Vert=mm.Meshoutput.nodes;           % 节点坐标
obj.output.SolidMesh=mm;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end

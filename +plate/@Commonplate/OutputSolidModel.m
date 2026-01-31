function obj=OutputSolidModel(obj,varargin)
% OutputSolidModel - 输出板的实体模型
% 为板生成3D实体网格（四面体单元）
% 支持通过参数控制是否添加子轮廓
% Author: Xie Yu
%
% Inputs:
%   varargin - 可选参数，包含SubOutline选项
%
% Optional Parameters:
%   'SubOutline' - 是否添加子轮廓（外轮廓）到边界标记，默认0

%% 解析输入参数
p=inputParser;
addParameter(p,'SubOutline',0);
parse(p,varargin{:});
opt=p.Results;

%% 创建2D网格对象
m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);

%% 设置网格尺寸
% 如果未指定Meshsize，则自动计算
if isempty(obj.input.Meshsize)
    % 根据表面尺寸自动计算合适的网格尺寸
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.input.Meshsize;
end

m=SetSize(m,Meshsize);

%% 生成2D网格
m=Mesh(m);

%% 创建3D网格对象
mm=Mesh('Mesh2','Echo',0);

%% 拉伸为3D实体
% 通过Extrude2Solid函数将2D截面沿厚度方向拉伸
% 厚度由obj.input.Thickness指定
mm=Extrude2Solid(mm,obj.input.Thickness,obj.params.N_Slices);

%% 计算边界标记
% 获取面中心点和边界标记
Face=mm.Face;
Cb=mm.Meshoutput.boundaryMarker;
Vm=PatchCenter(mm);

%% 计算节点到边界的距离
% 用于确定哪些面属于外轮廓
Temp_Face=Face(Cb==1,:);
Temp_Vm=Vm(Cb==1,:);

dist=NaN(size(Temp_Vm,1),size(obj.output.Surface.Node,1));

% 遍历所有表面节点，计算到边界的最小距离
for i=1:size(obj.output.Surface.Node,1)
    PP1=obj.output.Surface.Node{i,1};
    PP2=[PP1(2:end,:);PP1(1,:)];

    % 计算向量
    k1=Temp_Vm(:,1)*PP1(:,2)';
    k2=PP1(:,1).*PP1(:,2);
    k3=Temp_Vm(:,2)*PP1(:,2);
    k4=PP1(:,1).*PP1(:,2);
    k2=repmat(k2,size(Temp_Vm1,1),1);
    k4=repmat(k4,size(Temp_Vm1,1),1);
    k5=Temp_Vm(:,2)*PP1(:,2);
    k3=repmat(k3,size(Temp_Vm1,1),1);
    k6=PP1(:,2).*PP1(:,2);
    k5=repmat(k5,size(Temp_Vm1,1),1);

    % 计算二次式距离
    k=min(abs(k1+k2+k3-k4-k5-k6),[],2);
    dist(:,i)=k;
end

%% 找到最小距离
mindist=min(dist,[],2);

%% 判断节点是否在外轮廓上
% 如果到边界的距离接近0（小于mindist+0.1），则在边界上
Temp=dist-repmat(mindist,1,size(obj.output.Surface.Node,1));
[row,col]=find(Temp==0);

%% 更新边界标记
% 如果opt.SubOutline=1，将外轮廓面标记为200
if opt.SubOutline==1
    Temp_Cb=Cb;
    % 孔的中心点
    line=obj.input.Outline.Point.PP;
    Temp_Vm=Vm(Cb==101,:);

    % 计算到外轮廓的距离
    Cb_Outline=FindOutlineDistance(Temp_Vm,line);

    % 将距离远的面标记为200（子轮廓），距离近的保持为101（主轮廓）
    Cb(Cb_Outline>2)=200;

    % 更新Cb
    mm.Cb=Cb;
end

%% 根据单元阶次转换
% Order=2时使用二阶四面体单元（186）
if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% 保存结果
mm.Cb=mm.Meshoutput.boundaryMarker;
mm.Face=mm.Meshoutput.facesBoundary;
mm.Vert=mm.Meshoutput.nodes;
obj.output.SolidMesh=mm;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

%% 辅助函数：FindOutlineDistance
function Cb=FindOutlineDistance(Vm,line)
    % 计算表面节点到外轮廓线的距离
    % Inputs:
    %   Vm - 边界面的中心点
    %   line - 外轮廓线
    % Output:
    %   Cb - 到外轮廓的距离

    Cb=NaN(size(Vm,1),1);

    for i=1:size(Vm,1)
        V=Vm(i,:);
        % 找到该点到轮廓线上最近的点
        Temp=cellfun(@(x)sort(sqrt((x(:,1)-V(1,1)).^2+(x(:,2)-V(1,2)).^2)),line,'UniformOutput',false);
        Temp=cell2mat(Temp);
        [row,~]=find(Temp==min(Temp));
        Cb(i,1)=Temp(row);
    end
end

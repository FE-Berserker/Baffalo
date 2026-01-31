function obj=OutputSolidModel(obj,varargin)
% OutputSolidModel - 输出壳体实体模型
% 通过旋转2D截面生成3D实体网格
% Author: Xie Yu
%
% Inputs:
%   varargin - 可选参数，包含SubOutline选项
%
% Optional Parameters:
%   'SubOutline' - 是否添加子轮廓到边界标记，默认0

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
m=Mesh(m);

%% 创建3D网格对象
mm=Mesh(obj.params.Name,'Echo',0);

%% 旋转生成实体
% 根据旋转轴选择不同的旋转类型
% Type=1: 绕x轴旋转
% Type=2: 绕y轴旋转
if obj.params.Axis=='x'
    mm=Revolve2Solid(mm,m,'Type',1,'Slice',obj.params.N_Slice,'Degree',obj.params.Degree);
elseif obj.params.Axis=='y'
    mm=Revolve2Solid(mm,m,'Type',2,'Slice',obj.params.N_Slice,'Degree',obj.params.Degree);
end

%% 计算边界标记（Cb）
Cb=mm.Cb;
Vm=PatchCenter(mm);

%% 处理非360度旋转的情况
% 如果旋转角度不是360°，需要标记起始和结束面
if obj.params.Degree~=360
    % 基础面标记
    switch obj.params.Axis
        case 'x'  % 绕x轴旋转
            Temp_Vm=Vm(Vm(:,3)==0,:);
            Temp_Cb=Cb(Vm(:,3)==0,:);
            if obj.input.Outline.Point.P(1,2)>0
                Temp_Cb(Temp_Vm(:,2)>0,:)=11;  % 正y方向标记为11
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,2)<0,:)=12;  % 180度旋转时负y方向标记为12
                end
            else
                Temp_Cb(Temp_Vm(:,2)<0,:)=11;
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,2)>0,:)=12;
                end
            end
        case 'y'  % 绕y轴旋转
            Temp_Vm=Vm(Vm(:,3)==0,:);
            Temp_Cb=Cb(Vm(:,3)==0,:);
            if obj.input.Outline.Point.P(1,1)>0
                Temp_Cb(Temp_Vm(:,1)>0,:)=11;  % 正x方向标记为11
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,1)<0,:)=12;  % 180度旋转时负x方向标记为12
                end
            else
                Temp_Cb(Temp_Vm(:,1)<0,:)=11;
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,1)>0,:)=12;
                end
            end
    end
    Cb(Vm(:,3)==0,:)=Temp_Cb;
end

%% 提取侧面面（排除起始和结束面）
Temp_Vm=Vm(and(Cb~=11,Cb~=12),:);

% 将三维坐标转换为二维（用于距离计算）
switch obj.params.Axis
    case 'x'  % 绕x轴，将(y,z)转换为(r,θ)
        Temp_R=sqrt(Temp_Vm(:,2).^2+Temp_Vm(:,3).^2)...
            ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
        Temp_Vm=[Temp_Vm(:,1),Temp_R];
    case 'y'  % 绕y轴，将(x,z)转换为(r,θ)
        Temp_R=sqrt(Temp_Vm(:,1).^2+Temp_Vm(:,2).^2)...
            ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
        Temp_Vm=[Temp_R,Temp_Vm(:,2)];
end


%% 计算侧面到轮廓线的距离
% 用于确定每个侧面面属于哪个轮廓边界
dist=NaN(size(Temp_Vm,1),size(obj.output.Surface.Node,1));
for i=1:size(obj.output.Surface.Node,1)
    PP1=obj.output.Surface.Node{i,1};  % 第i条轮廓线
    PP2=[PP1(2:end,:);PP1(1,:)];  % 轮廓线的下一点

    % 计算点到直线的距离（使用叉积公式）
    k1=Temp_Vm(:,1)*PP1(:,2)';
    k2=PP1(:,1).*PP2(:,2);
    k2=repmat(k2',size(Temp_Vm,1),1);
    k3=Temp_Vm(:,2)*PP2(:,1)';
    k4=Temp_Vm(:,1)*PP2(:,2)';
    k5=Temp_Vm(:,2)*PP1(:,1)';
    k6=PP1(:,2).*PP2(:,1);
    k6=repmat(k6',size(Temp_Vm,1),1);
    k=min(abs(k1+k2+k3-k4-k5-k6),[],2);  % 最小距离
    dist(:,i)=k;
end

%% 找到最小距离
mindist=min(dist,[],2);
Temp=dist-repmat(mindist,1,size(obj.output.Surface.Node,1));
[row,col]=find(Temp==0);  % 找到每个面最近的轮廓线
[~,I]=sort(row);
col=col(I,:);
Temp_Cb=col+100;  % 边界标记从101开始
Cb(and(Cb~=11,Cb~=12),:)=Temp_Cb;

%% 子轮廓处理
% 如果opt.SubOutline=1，根据到外轮廓的距离标记子轮廓
if opt.SubOutline==1
    line=obj.input.Outline.Point.PP;  % 外轮廓线
    Temp_Vm=Vm(Cb==101,:);  % 外侧面
    switch obj.params.Axis
        case 'x'
            Temp_R=sqrt(Temp_Vm(:,2).^2+Temp_Vm(:,3).^2)...
                ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
            Temp_Vm=[Temp_Vm(:,1),Temp_R];
        case 'y'
            Temp_R=sqrt(Temp_Vm(:,1).^2+Temp_Vm(:,3).^2)...
                ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
            Temp_Vm=[Temp_R,Temp_Vm(:,2)];
    end
    Cb_Outline=FindOutlineDistance(Temp_Vm,line);
    Cb(Cb==101,:)=Cb_Outline;
end

%% 根据单元阶次转换
% Order=2时使用二阶四面体单元（186）
if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% 保存结果
mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
obj.output.SolidMesh=mm;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end

%% 辅助函数：FindOutlineDistance
% 计算表面节点到轮廓线的距离
function Cb=FindOutlineDistance(Vm,line)
    % Inputs:
    %   Vm - 边界面的中心点
    %   line - 轮廓线（cell数组）
    % Output:
    %   Cb - 到轮廓线最近段的索引+200

    Cb=NaN(size(Vm,1),1);
    for i=1:size(Vm,1)
        V=Vm(i,:);
        % 计算该点到每条轮廓线的距离
        Temp=cellfun(@(x)sort(sqrt((x(:,1)-V(1,1)).^2+(x(:,2)-V(1,2)).^2)),line,'UniformOutput',false);
        Temp=cellfun(@(x)min(x),Temp,'UniformOutput',false);
        Temp=cell2mat(Temp);
        [row,~]=find(Temp==min(Temp));
        Cb(i,1)=200+row(1,1);  % 子轮廓标记从200开始
    end
end
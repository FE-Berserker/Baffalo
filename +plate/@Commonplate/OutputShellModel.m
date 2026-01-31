function obj=OutputShellModel(obj,varargin)
% OutputShellModel - 输出壳模型
% 为板生成3D壳网格
% 壳单元适用于薄板分析
% Author: Xie Yu

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

%% 拉伸为3D壳网格
% 通过Extrude2Shell函数将2D截面拉伸为3D壳
% 拉伸方向为z轴（垂直方向）
mm=Extrude2Shell(m,obj.input.Thickness);

%% 计算边界标记
% 获取边界面的中心点
Vm=PatchBoundaryCentre(mm);
Cb=mm.Meshoutput.boundaryMarker;

% 重新标记边界
% 顶部表面（z=厚度）：标记为101
Temp_Vm=Vm(Cb==1,:);
Cb(Temp_Vm,:)=101;

% 底部表面（z=0）：标记为102
Temp_Vm=Vm(Cb==2,:);
Cb(Temp_Vm,:)=102;

% 更新边界标记
mm.Meshoutput.boundaryMarker=Cb;

%% 根据单元阶次转换
% Order=2时使用二次壳单元（281）
% Order=1时使用一次壳单元（181）
if obj.params.Order==2
    mm = Convert2Order2Shell(mm);
end

%% 保存结果
mm.Meshoutput.boundaryMarker=Cb;
obj.output.ShellMesh=mm;

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output shell mesh .\n');
end

%% 辅助函数：PatchBoundaryCentre（如不存在）
% 如果Extrude2Shell函数不返回边界中心，则计算
if exist('PatchBoundaryCentre','file')~=2
    function Cb=PatchBoundaryCentre(mm)
        % 计算每个面的中心点
        Face=mm.Meshoutput.facesBoundary;
        Vert=mm.Meshoutput.nodes;
        Cb=mm.Meshoutput.boundaryMarker;

        % 初始化中心点矩阵
        Vm=NaN(size(Face,1),3);

        for i=1:size(Face,1)
            % 获取该面的所有节点
            faceNodes=unique(Face(i,:));
            % 计算节点坐标平均值作为面中心
            Vm(i,:)=mean(Vert(faceNodes,:),1);
        end
    end
end

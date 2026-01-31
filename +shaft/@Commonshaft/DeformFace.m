function obj=DeformFace(obj,Faceno,fun,varargin)
% DeformFace - 变形指定面的节点
% 根据提供的函数修改指定面上节点的位置
% 注意：只更新实体网格和装配，不更新梁网格
% Author: Xie Yu
%
% Inputs:
%   Faceno - 面编号（边界标记）
%   fun    - 变形函数：
%             轴向变形: fun(r) 返回新的x坐标（r为径向距离）
%             径向变形: fun(x) 返回新的半径（x为轴向位置）
%
% Optional Parameters:
%   'direction' - 变形方向：'axial'(默认) 或 'radial'
%   'Plot'      - 是否绘制变形后的图形，默认1

%% 解析输入参数
p=inputParser;
addParameter(p,'direction','axial');% 'axial' 轴向变形, 'radial' 径向变形
addParameter(p,'Plot',1);            % 是否绘图
parse(p,varargin{:});
opt=p.Results;

%% 选择要变形的节点
[VV,pos] = SelectFaceNode(obj,Faceno);

%% 根据变形方向计算新坐标
if opt.direction=="axial"
    % 轴向变形：x坐标随径向距离变化
    r=sqrt(VV(:,2).^2+VV(:,3).^2);  % 计算径向距离
    VV(:,1)=fun(r);                  % 使用函数计算新的x坐标
elseif opt.direction=="radial"
    % 径向变形：半径随轴向位置变化
    x=VV(:,1);                       % x坐标
    r=sqrt(VV(:,2).^2+VV(:,3).^2);  % 原始径向距离
    rr=fun(x);                       % 使用函数计算新的半径
    ratio=rr./r;                     % 缩放比例
    % 按比例缩放y和z坐标
    VV(:,2)=VV(:,2).*ratio;
    VV(:,3)=VV(:,3).*ratio;
end

%% 更新网格节点
V=obj.output.SolidMesh.Vert;
V(pos,:)=VV;

%% 保存更新的节点坐标
obj.output.SolidMesh.Vert=V;
obj.output.SolidMesh.Meshoutput.nodes=V;
% 重新计算网格
obj.output.SolidMesh=Mesh3D(obj.output.SolidMesh);

%% 更新装配
if ~isempty(obj.output.Assembly)
    obj=OutputAss(obj);
end

%% 绘制变形后的图形
if opt.Plot
    Plot3D(obj,'faceno',Faceno);
end

%% 打印信息
if obj.params.Echo
    fprintf('Successfully deform face .\n');
end
end

function obj=MoveFace(obj,Faceno,movement,varargin)
% MoveFace - 移动面
% 根据指定的移动参数移动指定面上的节点位置
% Author: Xie Yu
%
% Inputs:
%   Faceno   - 面编号（边界标记）
%   movement - 移动方向和距离 [mm]
%               格式：[x移动, y移动, z移动, x旋转, y旋转, z旋转]
% Optional Parameters:
%   num     - 移动数量（默认1），可设置>1实现多次移动
%   Plot     - 是否绘制移动后的图形，默认1

%% 解析输入参数
p=inputParser;
addParameter(p,'num',1);
addParameter(p,'Plot',1);
parse(p,varargin{:});
opt=p.Results;

%% 旋转矩阵（弧度转换为弧度）
% 将角度转换为弧度，用于旋转变换
R_x=[cos(movement(4)/180*pi),-sin(movement(4)/180*pi);   % x轴旋转
R_y=[sin(movement(4)/180*pi),cos(movement(4)/180*pi];   % y轴旋转
R_z=[1,0,0];                                          % z轴旋转

%% 循环进行多次移动
for k=1:opt.num
    %% 选择要移动的面节点
    [VV,pos] = SelectFaceNode(obj,Faceno);  % 选择顶面（faceno=1）

    %% 应用平移
    VV(:,1)=VV(:,1)+movement(1);  % x方向平移
    VV(:,2)=VV(:,2)+movement(2);  % y方向平移
    VV(:,3)=VV(:,3)+movement(3);  % z方向平移

    %% 应用旋转
    % 绕x轴旋转：围绕原点旋转
    if movement(4)~=0
        % 旋转中心（假设在节点平均位置）
        center_mean=mean(VV,1);
        center_y=mean(VV,2);
        center_z=mean(VV(:,3));

        % 平移到原点
        VV(:,1)=VV(:,1)-center_mean;
        VV(:,2)=VV(:,2)-center_y;
        VV(:,3)=VV(:,3)-center_z;

        % 应用旋转（绕z轴旋转）
        VV(:,2)=VV(:,2)*R_y(1)-VV(:,3)*R_y(2); % y旋转
        VV(:,3)=VV(:,2)*R_y(2)+VV(:,1)*R_y(1); % y旋转+ x
        VV(:,1)=VV(:,1)*R_x(1)-VV(:,3)*R_x(2); % x旋转
        VV(:,2)=VV(:,3)*R_x(2)+VV(:,1)*R_x(1); % x旋转+ y
        VV(:,1)=VV(:,1)*R_x(1)+VV(:,2)*R_x(2); % x旋转+y
        VV(:,2)=VV(:,2)*R_z;   % z旋转

        % 平移回原位置
        VV(:,1)=VV(:,1)+center_mean;
        VV(:,2)=VV(:,2)+center_y;
        VV(:,3)=VV(:,3)+center_z;
    end

    %% 更新网格节点
    obj.output.SolidMesh.Vert=V;
    obj.output.SolidMesh.Meshoutput.nodes=V;

    %% 更新面节点索引（保留原始索引）
    pos=pos;  % 使用原始索引
end

%% 重新计算网格
% 使用Mesh3D函数更新网格信息
obj.output.SolidMesh=Mesh3D(obj.output.SolidMesh);

%% 更新装配
if ~isempty(obj.output.Assembly)
    obj=OutputAss(obj);
end

%% 绘制移动后的图形
if opt.Plot
    Plot3D(obj,'faceno',1);
end

%% 打印信息
if obj.params.Echo
    fprintf('Successfully move face .\n');
end
end

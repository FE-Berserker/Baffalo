function obj=MoveFace(obj,Faceno,movement,varargin)
% MoveFace - 移动指定面
% 通过平移和旋转移动壳体的面
% Author : Xie Yu
%
% Inputs:
%   Faceno - 要移动的面编号数组
%   movement - 移动向量 [dx, dy, dangle]
%              dx: x方向位移
%              dy: y方向位移
%              dangle: 旋转角度 [°]
%
% Optional Parameters (varargin):
%   'num' - 重复次数，默认1

%% 解析输入参数
p=inputParser;
addParameter(p,'num',1);
parse(p,varargin{:});
opt=p.Results;

%% 计算旋转矩阵（用于旋转变换）
% movement(3)为旋转角度
R_z=[cos(movement(3)/180*pi),-sin(movement(3)/180*pi);...
    sin(movement(3)/180*pi),cos(movement(3)/180*pi];

Num=size(Faceno,1);

%% 情况1：只移动一次（num=1）
if opt.num==1
    for j=1:Num
        % 获取指定面的节点
        Node=obj.output.Surface.Node{Faceno(j,1),1};
        NumNodes=size(Node,1);

        % 应用旋转和平移变换
        Node=Node*R_z+repmat(movement(:,1:2),NumNodes,1);
        obj.output.Surface.Node{Faceno(j,1),1}=Node;
    end
end

%% 情况2：重复移动（num>1）
% 每次移动都会创建新的面
if opt.num>1
    for i=2:opt.num
        Total_FaceNum = GetNFace(obj);  % 获取当前总面数
        for j=1:Num
            % 获取上一轮移动后的节点
            Node=obj.output.Surface.Node{Total_FaceNum-Num+1,1};
            NumNodes=size(Node,1);

            % 应用旋转和平移变换
            Node=Node*R_z+repmat(movement(:,1:2),NumNodes,1);

            % 创建新的轮廓线（作为孔添加）
            a=Point2D('Temp_Point','Echo',0);
            a=AddPoint(a,Node(:,1),Node(:,2));
            Temp_Line=Line2D('Temp_Line','Echo',0);
            Temp_Line=AddCurve(Temp_Line,a,1);
            obj.output.Surface=AddHole(obj.output.Surface,Temp_Line);
        end
    end
end

%% 重新生成实体模型和装配
obj=OutputSolidModel(obj);
obj=OutputAss(obj);

%% 打印信息
if obj.params.Echo
    fprintf('Successfully move face .\n');
end
end

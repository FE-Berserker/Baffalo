function [VV,pos] = SelectFaceNode(obj,Faceno,varargin)
% SelectFaceNode - 选择指定面的节点
% 根据面编号提取对应的节点坐标和节点索引
% Author: Xie Yu
%
% Inputs:
%   Faceno - 面编号（边界标记）
%   tol    - 容差容差（可选），用于节点筛选
%
% Outputs:
%   VV     - 节点坐标矩阵
%   pos    - 节点索引矩阵

%% 解析输入参数
% p=inputParser;
% addParameter(p,'tol',1);
% parse(p,varargin{:});
% opt=p.Results;

%% 获取网格数据
V=obj.output.SolidMesh.Vert;      % 节点坐标
Face=obj.output.SolidMesh.Face;    % 面定义
Cb=obj.output.SolidMesh.Cb;        % 边界标记

%% 提取指定面的节点
% 找到所有属于该面的面单元
VV=V(unique(Face(Cb==Faceno,:)),:);   % 提取节点坐标（去重）
pos=unique(Face(Cb==Faceno,:));        % 提取节点索引（去重）

%% 节点筛选（可选功能）
% 注释掉的代码：根据内外径差值筛选节点
% 可用于验证提取的节点是否在正确的半径范围内

% R=sqrt(VV(:,2).^2+VV(:,3).^2);
% x=VV(:,1);
% OD=interp1(obj.output.Node,obj.output.OD,...
%     x,'linear');
% ID=interp1(obj.output.Node,obj.output.ID,...
%     x,'linear');
% dev1=abs(OD/2-R);
% dev2=abs(R-ID/2);
% if Faceno>300
%     NN=VV;
% else
%     NN=VV(or(dev1<opt.tol,dev2<opt.tol),:);
%     pos=pos(or(dev1<opt.tol,dev2<opt.tol),:);
% end

%% 打印信息
if obj.params.Echo
    fprintf('Successfully select nodes .\n');
end
end

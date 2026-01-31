%*******************************************************************************
% function:	p_poly_dist
% Description:	计算点到多边形的距离
%              多边形顶点由向量xv和yv指定
% Input:
%    x - 点的x坐标
%    y - 点的y坐标
%    xv - 多边形顶点x坐标向量
%    yv - 多边形顶点y坐标向量
% Output:
%    d - 点到多边形的距离（定义为点到任意多边形边的最小距离
%        如果点在多边形外为正，在多边形内为负）
%    x_poly: 多边形中离(x,y)最近的点的x坐标
%    y_poly: 多边形中离(x,y)最近的点的y坐标
%
% Routines: p_poly_dist.m
% Revision history:
%    03/31/2008 - 返回多边形中离x,y最近的点
%               - 添加对水平或垂直边的测试（Eric Schmitz）
%               - 修改者：Alejandro Weinstein
%    7/9/2006  - 所有投影都在多边形外的情况
%    23/5/2004 - 创建者：Michael Yoshpe
% Remarks:
%*******************************************************************************
function [d,x_poly,y_poly] = p_poly_dist(x, y, xv, yv)

% 如果(xv,yv)未闭合，则闭合它
xv = xv(:);
yv = yv(:);
Nv = length(xv);
if ((xv(1) ~= xv(Nv)) || (yv(1) ~= yv(Nv)))
    xv = [xv ; xv(1)];
    yv = [yv ; yv(1)];
%     Nv = Nv + 1;
end

% 连接顶点的线段的线性参数
% 形式：Ax + By + C = 0
A = -diff(yv);
B =  diff(xv);
C = yv(2:end).*xv(1:end-1) - xv(2:end).*yv(1:end-1);

% 找到点(x,y)在每条边上的投影
AB = 1./(A.^2 + B.^2);
vv = (A*x+B*y+C);
xp = x - (A.*AB).*vv;
yp = y - (B.*AB).*vv;

% 测试多边形边为水平或垂直的情况（来自Eric Schmitz）
id = find(diff(xv)==0);
xp(id)=xv(id);
clear id
id = find(diff(yv)==0);
yp(id)=yv(id);

% 找到投影点在线段内的所有情况
idx_x = (((xp>=xv(1:end-1)) & (xp<=xv(2:end))) | ((xp>=xv(2:end)) & (xp<=xv(1:end-1))));
idx_y = (((yp>=yv(1:end-1)) & (yp<=yv(2:end))) | ((yp>=yv(2:end)) & (yp<=yv(1:end-1))));
idx = idx_x & idx_y;

% 点(x,y)到顶点的距离
dv = sqrt((xv(1:end-1)-x).^2 + (yv(1:end-1)-y).^2);

if(~any(idx)) % 所有投影都在多边形外
   [d,I] = min(dv);
   x_poly = xv(I);
   y_poly = yv(I);
else
   % 点(x,y)到投影的距离
   dp = sqrt((xp(idx)-x).^2 + (yp(idx)-y).^2);
   [min_dv,I1] = min(dv);
   [min_dp,I2] = min(dp);
   [d,I] = min([min_dv min_dp]);
   if I==1 % 最近的点是顶点之一
       x_poly = xv(I1);
       y_poly = yv(I1);
   elseif I==2 % 最近的点是投影之一
       idxs = find(idx);
       x_poly = xp(idxs(I2));
       y_poly = yp(idxs(I2));
   end
end

% 如果点在多边形内，距离取负值
if(inpolygon(x, y, xv, yv))
   d = -d;
end

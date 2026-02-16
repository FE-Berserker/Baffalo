function y0=interpextrap(x,y,x0,flag)
% INTERPEXTRAP: 插值/外推函数
% INTERPEXTRAP: Interpolation/extrapolation function
%
% 功能：在给定数据点 (x,y) 处，计算 x0 位置对应的 y0 值
% Function: Calculate y0 value at position x0 given data points (x,y)
%
% 对于落在 x 边界内的 x0，使用线性插值
% 对于落在 x 边界外的 x0，使用最近线段的外推
% For x0 within x bounds, use linear interpolation
% For x0 outside x bounds, extrapolate using nearest segment
%
% 输入参数:
% x ... 数据点的 x 坐标向量
% y ... 数据点的 y 坐标向量
% x0 ... 待计算 y0 值的 x 位置（可以是标量或向量）
% flag ... 外推标志：1=线性外推，0=水平外推（默认）
%
% 输出:
% y0 ... 计算得到的 y0 值（与 x0 同维度的向量）
% Output:
% y0 ... Calculated y0 values (same dimension as x0)
%
% 作者: CREWES Project
% Author: CREWES Project
%
% 参考：类似于 MATLAB 的 interp1 函数，处理边界外的点
% Reference: Similar to MATLAB interp1 function, handling points outside bounds

% 设置默认标志
if nargin < 4
    flag = 1;  % 默认线性外推
end

% 初始化输出为 NaN
y0 = nan * ones(size(x0));
nx = length(x);

% ========== 简单情况处理 ==========
% Simple case handling

if isscalar(x)
    % 只有一个点，直接返回该 y 值
    y0 = y;
    return;
end

% ========== 端点外推 ==========
% Endpoint extrapolation

% 处理 x(1) 之前的外推点
if x(1) < x(nx)
    ind = find(x0 < x(1));  % 找到 x0 在起始点之前的索引
    if ~isempty(ind)
        if flag
            % 线性外推：使用第一段斜率
            m1 = (y(2) - y(1)) / (x(2) - x(1));
        else
            % 水平外推：斜率为 0
            m1 = 0.0;
        end
        y0(ind) = m1 * (x0(ind) - x(1)) + y(1);
    end
end

% 处理 x(nx) 之后的外推点
ind = find(x0 > x(nx));  % 找到 x0 在结束点之后的索引
if ~isempty(ind)
    if flag
        % 线性外推：使用最后一段斜率
        m2 = (y(nx) - y(nx-1)) / (x(nx) - x(nx-1));
    else
        % 水平外推：斜率为 0
        m2 = 0.0;
    end
    y0(ind) = m2 * (x0(ind) - x(nx)) + y(nx);
end

% ========== 中间段处理 ==========
% Middle segment processing

% 处理 x(1) 和 x(nx) 之间的外推点
ind = find(x0 > x(1));
if ~isempty(ind)
    if flag
        % 线性外推：使用第一段斜率
        m1 = (y(2) - y(1)) / (x(2) - x(1));
    else
        % 水平外推：斜率为 0
        m1 = 0.0;
    end
    y0(ind) = m1 * (x0(ind) - x(1)) + y(1);
end

% 处理 x(1) 和 x(nx) 之间的插值点
ind = find(x0 < x(nx));
if ~isempty(ind)
    if flag
        % 线性插值：使用最后一段斜率
        m2 = (y(nx) - y(nx-1)) / (x(nx) - x(nx-1));
    else
        % 水平插值：斜率为 0
        m2 = 0.0;
    end
    y0(ind) = m2 * (x0(ind) - x(nx)) + y(nx);
end

% ========== 最终填充 ==========
% Final filling

% 使用 PWLINT 进行中间段的插值
ind = isnan(y0);
if any(ind(:))
    % 调用 PWLINT（分段线性插值）填充 NaN 值
    y0(ind) = pwlint(x, y, x0(ind));
end

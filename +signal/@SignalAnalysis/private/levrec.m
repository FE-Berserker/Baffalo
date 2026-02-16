function x = levrec(aa, b)
% LEVREC: 使用莱文森递归求解 Tx = b
%
% x = levrec(aa, b)
%
% 此函数使用莱文森递归求解向量 x 的矩阵方程 Tx = b。
% 对称的托普利兹矩阵 T 假设完全由自相关向量 aa 指定。
%
% aa = 输入自相关向量
%        ( aa(1) aa(2) aa(3) aa(4) ...
%        ( aa(2) aa(1) aa(2) aa(3) aa(4) ...
%     T = ( aa(3) aa(2) aa(1) aa(2) aa(3) aa(4) ...
%        ( aa(4) aa(3) aa(2) aa(1) aa(2) aa(3) aa(4) ...
%        ( ............................................
% aa = 输入自相关向量。如果未归一化到 aa(1) = 1.0，
%      则将会...
% b  = 输入右侧向量（如果还不是列向量，则会转换为列向量）
% x  = 解向量（列向量）


%% 如果需要，将 aa 和 b 转换为列向量
[l, m] = size(b);
if l < m
    b = b';  % 转置为列向量
end
[l, m] = size(aa);
if l < m
    aa = aa';  % 转置为列向量
end

%% 归一化 aa
if aa(1) ~= 1.0
    aa = aa / max(aa);  % 归一化处理
end

%% 检查自相关有效性
if aa(1) ~= max(aa)
    error('Invalid autocorrelation: zero lag not maximum');
end

%% 初始化变量
a = aa(2:length(aa));  % 去除第一个自相关值
n = length(b);          % b 的长度
y = zeros(size(a));     % 预测误差向量
x = zeros(size(b));     % 解向量
z = zeros(size(a));     % 辅助向量

%% 初始条件
y(1) = -a(1);  % 初始预测误差
x(1) = b(1);    % 初始解的第一个值
beta = 1;          % 初始 beta 值
alpha = -a(1);      % 初始 alpha 值

%% 主递归循环
for k = 1:n-1
    % 更新 beta
    beta = (1 - alpha^2) * beta;

    % 计算新的预测值 mu
    mu = (b(k+1) - a(1:k)' * x(k:-1:1)) / beta;

    % 更新 nu 和 x
    nu(1:k) = x(1:k) + mu * y(k:-1:1);
    x(1:k) = nu(1:k);
    x(k+1) = mu;

    % 如果 k < n-1，计算新的 alpha、z、y
    if k < (n-1)
        alpha = -(a(k+1) + a(1:k)' * y(k:-1:1)) / beta;
        z(1:k) = y(1:k) + alpha * y(k:-1:1);
        y(1:k) = z(1:k);
        y(k+1) = alpha;
    end
end

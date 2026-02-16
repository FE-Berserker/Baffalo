function s = convm(r,w,pct)
% CONVM: 卷积后接截断，用于最小相位滤波器
%
% s = convm(r,w,pct)
%
% CONVM 是 MATLAB 工具箱中 'conv' 例程的修改版本
% 这些修改使其更适合地震学用途，输出向量 s 的长度等于
% 第一个输入向量 r 的长度。因此，'r' 可能对应于
% 反射系数估计，需要与小波 'w' 卷积以产生
% 合成地震响应 's'。假设 w 中的小波是因果的，
% 且第一个样本发生在时间零处。对于非因果小波，请使用 'convz'。
% 如果第一个参数是矩阵，则 convm 输出相同大小的矩阵，
% 其中第二个参数与每一列进行了卷积。默认情况下，convm
% 在道末端进行余弦锥化以减少截断伪影。
%
% r ... 反射系数
% w ... 小波
% pct ... 在道末端进行锥化的百分比，以减少截断效应
%       详见 mwhalf
%  ********** 默认值 = 10 ********

%% 参数默认值处理
if nargin < 3
    pct = 10;  % 默认锥化百分比
end

%% 转换为列向量
[a, b] = size(r);
if a == 1
    r = r.';  % 如果是行向量，转置为列向量
end
w = w(:);  % 确保小波是列向量

[nsamps, ntr] = size(r);

%% 检查小波长度
if length(w) > nsamps
    warning('second argument longer than the first, output truncated to length of first argument.');
end

%% 初始化输出矩阵
s = zeros(size(r));

%% 创建锥化窗口
if pct > 0
    mw = mwhalf(nsamps, pct);  % 余弦锥化窗口
else
    mw = ones(nsamps, 1);  % 无锥化
end

%% 对每一道进行卷积
for k = 1:ntr
    temp = conv(r(:,k), w);          % 执行卷积
    s(:,k) = temp(1:nsamps) .* mw;  % 截断并应用锥化
end

%% 恢复原始形状（如果输入是行向量）
if a == 1
    s = s.';  % 转置回行向量
end

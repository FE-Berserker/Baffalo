function s = convz(r,w,nzero,nout,flag,pct)
% CONVZ: 卷积后接截断，用于零相位滤波器
%
% s = convz(r,w,nzero,nout,flag,pct)
% s = convz(r,w,nzero,nout,flag)
% s = convz(r,w,nzero)
% s = convz(r,w)
%
% CONVZ 设计用于地震道与零相位（无时间延迟）小波的
% 便捷卷积。实际上，这可以与任何非因果小波一起使用，
% 通过指定 nzero 样本（即时间零处的样本号）来实现。
% 它默认为 w 的中间位置，但可以放置在任何位置。
% 如果第一个输入参数是行向量或列向量，则输出将是类似的向量。
% 如果第一个参数是矩阵，则输出是相同大小的矩阵，
% 其中 w 已与 r 的每一列进行了卷积。
% 使用 MATLAB 的 CONV 函数。
%
% s  = 输出道，长度为 nout
% r  = 输入道（反射系数）
% w  = 输入小波
% nzero = 小波时间零值样本号
%  *********** 默认值 = ceil((length(wavelet)+1)/2) ***************
% 注意: nzero 可以作为 w 的时间坐标向量输入。在这种情况下，
%       其长度必须等于 w 的长度，并且必须有一个 t==0 样本
%       在此向量中的某处。convz 将找到这个样本并将其用作 nzero。
% nout = 输出道长度
%   ********** 默认值 = length(r) ************
% flag = 1 --> 在输出道的开头和结尾应用余弦锥化
%             = 0 --> 不应用锥化
%      ********* 默认值 = 1 **********
% pct = 在结果的末端应用锥化的百分比，以减少
%       截断效应。详见 mwindow
% ********** 默认值 = 5% ************


%% 获取输入矩阵尺寸
[nsamps, ntr] = size(r);

%% 转换为列向量
transpose = 0;
if nsamps == 1
    r = r.';      % 如果是行向量，转置为列向量
    ntr = 1;
    nsamps = length(r);
    transpose = 1;
end

%% 参数默认值处理
if nargin < 6
    pct = 5;     % 默认锥化百分比
end
if nargin < 5
    flag = 1;    % 默认应用锥化
end
if nargin < 4
    nout = nsamps;  % 默认输出长度等于输入长度
end

%% 检查零时间样本参数
small = 100 * eps;
if nargin >= 3 && length(nzero) > 1
    % 如果 nzero 是向量，验证其长度
    if length(nzero) ~= length(w)
        error('if nzero is a vector it must equal w in length');
    end
    % 查找时间零样本
    ind = near(nzero, 0);
    if abs(nzero(ind(1))) > small
        error('no time zero sample found in vector nzero');
    end
    nzero = ind(1);
end

%% 设置默认零时间样本
if nargin < 3
    % nzero = round((length(w) + 1) / 2);
    nzero = ceil((length(w) + 1) / 2);  % 使用向上取整
end

%% 确保小波是列向量
w = w(:);

%% 初始化输出矩阵
s = zeros(nout, ntr);

%% 对每一道进行卷积
for k = 1:ntr
    temp = conv(r(:,k), w);           % 执行卷积
    if flag ~= 1
        % 不应用锥化
        s(:,k) = temp(nzero:nout + nzero - 1);
    else
        % 应用锥化
        s(:,k) = temp(nzero:nout + nzero - 1) .* mwindow(nout, pct);
    end
end

%% 恢复原始形状（如果输入是行向量）
if transpose
    s = s.';  % 转置回行向量
end

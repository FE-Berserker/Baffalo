function obj=Correlation(obj,s1,s2)
% CORRELATION: 相关性分析
%
% obj = Correlation(obj,s1,s2)
%
% 计算两个信号之间的相关性，使用 MATLAB 内置函数
%
% s1 ... 第一个信号类别
%       0 - 原始信号 (input.s)
%       1 - 转换信号 (output.s_Transform)
%       2 - 合成信号 (output.s_Synthesis)
% s2 ... 第二个信号类别
%       0 - 原始信号 (input.s)
%       1 - 转换信号 (output.s_Transform)
%       2 - 合成信号 (output.s_Synthesis)
%
%
% 如果 s1 和 s2 相同且指向相同信号，则计算自相关
% 如果 s1 和 s2 不同，则计算互相关
%
% 输出:
%   obj.output.Corr - 信号相关性结果


%% 解析可选参数


%% 获取信号数据
% 根据信号类别获取对应的信号
switch s1
    case 0
        sig1 = obj.input.s;
    case 1
        sig1 = obj.output.s_Transform;
 
    case 2
        sig1 = obj.output.s_Synthesis;
end

switch s2
    case 0
        sig2 = obj.input.s;
    case 1
        sig2 = obj.output.s_Transform;
    case 2
        sig2 = obj.output.s_Synthesis;
end



%% 计算相关性

% 使用 xcorr 计算互相关函数

% 单个信号的自相关
fprintf('\n========== 相关性分析结果 ==========\n');
fprintf('  分析类型: 自相关\n');
fprintf('  使用 MATLAB xcorr 函数\n');
[xcorr_result, lags] = xcorr(sig1, sig2);

fprintf('  显示完整互相关结果\n');
fprintf('    零延迟处的相关值: %.6f\n', xcorr_result(find(lags == 0, 1)));
fprintf('    最大相关值: %.6f\n', max(xcorr_result));
fprintf('==========================================\n');



%% 输出

obj.output.Corr.c = xcorr_result;
obj.output.Corr.lags = lags;

end

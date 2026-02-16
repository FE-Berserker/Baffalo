function obj=FreqDom(obj, varargin)
%% 解析可选参数
p = inputParser;
addParameter(p, 'Type', 0);% 0 - 原始信号 1 - 转换信号 2 - 合成信号
addParameter(p, 'p', 2);% 1=模 2=模^2，3=模^3
addParameter(p, 't1', []);
addParameter(p, 't2', []);
addParameter(p, 'taperopt', 0);% 0  表示使用矩形窗  1  表示使用半窗，仅在末端进行锥化  2  表示使用两端锥化的窗
parse(p, varargin{:});
opt = p.Results;

switch opt.Type
    case 0
        s=obj.input.s;
        t=obj.input.t;
    case 1
        s=obj.output.s_Transform;
        t=obj.output.t;
    case 2
        s=obj.output.s_Synthesis;
        t=obj.output.t;
end

if isempty(opt.t1)
    t1=t(1);
end

if isempty(opt.t2)
    t2=t(end);
end

fdom=domfreq(s,t,opt.p,t1,t2,opt.taperopt);

% 输出
switch opt.Type
    case 0
        obj.output.FreqDom_s=fdom;
    case 1
        obj.output.FreqDom_s_Transform=fdom;
    case 2
        obj.output.FreqDom_s_Synthesis=fdom;
end

fprintf('\n========== 主导频率分析结果 ==========\n');
fprintf('  主导频率     : %s\n', fdom);
fprintf('==========================================\n\n');

end

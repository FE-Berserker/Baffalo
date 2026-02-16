function obj=Hilbert(obj, varargin)
%% 解析可选参数
p = inputParser;
addParameter(p, 'n', []); 
addParameter(p, 'Type', 0);% 0 - 原始信号 1 - 转换信号 2 - 合成信号 
parse(p, varargin{:});
opt = p.Results;

switch opt.Type
    case 0
        s=obj.input.s;
    case 1
        s=obj.output.s_Transform;
    case 2
        s=obj.output.s_Synthesis;
end

if isempty(opt.n)
    h=hilbert(s);%run hilbert
else
    h=hilbert(s,opt.n);%run hilbert
end

% 输出
switch opt.Type
    case 0
        obj.output.Hilbert_s=h;
    case 1
        obj.output.Hilbert_s_Transform=h;
    case 2
        obj.output.Hilbert_s_Synthesis=h;
end



end

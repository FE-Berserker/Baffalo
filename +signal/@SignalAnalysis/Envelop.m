function obj=Envelop(obj, varargin)
%% 解析可选参数
p = inputParser;
addParameter(p, 'Type', 0);% 0 - 原始信号 1 - 转换信号 2 - 合成信号 
parse(p, varargin{:});
opt = p.Results;

obj=Hilbert(obj,'Type',opt.Type);

% 输出
switch opt.Type
    case 0
        obj.output.Env_s=abs(obj.output.Hilbert_s);
    case 1
        obj.output.Env_s_Transform=abs(obj.output.Hilbert_s_Transform);
    case 2
        obj.output.Env_s_Synthesis=abs(obj.output.Hilbert_s_Synthesis);
end

end

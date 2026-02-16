function obj = AddNoise(obj,noise)
% 添加噪声
% Author ：Xie Yu

obj.output.Noise=noise;
if ~isempty(obj.output.s_Transform)
    obj.output.s_Synthesis=obj.output.s_Transform+noise;
end

end


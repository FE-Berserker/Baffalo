function Value = GetNFace(obj)
% GetNFace - 获取表面节点数量（面数量）
% 返回壳体表面的面数
%
% Output:
%   Value - 表面节点/面的数量

Value=size(obj.output.Surface.Node,1);
end

function indList = FindBoundaryCurve(obj,MeshNum,varargin)
%FINDBOUNDARYCURVE 此处显示有关此函数的摘要
p=inputParser;
addParameter(p,'color',[]);
parse(p,varargin{:});
opt=p.Results;

E=FindMeshBoundary(obj,MeshNum,'color',opt.color);
[indList]=edgeListToCurve(E);
end


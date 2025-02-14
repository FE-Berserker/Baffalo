function Vg = RebuildCurve(obj,num,n,varargin)
% Rebuild curve
% Author : Xie Yu

p=inputParser;
addParameter(p,'interpPar','pchip');
addParameter(p,'closeLoopOpt',0);
addParameter(p,'spacingFlag',0);
parse(p,varargin{:});
opt=p.Results;

V=obj.Point.PP{num,1};
Vg= evenlySampleCurve(V,n,opt.interpPar,opt.closeLoopOpt,opt.spacingFlag);

%% Print
if obj.Echo
    fprintf('Successfully rebuild curve .\n');
end
end


function BH = MaxwellBiH2BH(BiH,varargin)
p=inputParser;
addParameter(p,'Type',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.Type
    case 1
        H=BiH(:,2)-BiH(end,2);
    case 2
        H=BiH(:,2);
end
B=BiH(:,1)+4*pi*10^-7*H;

BH=[B,H];
end


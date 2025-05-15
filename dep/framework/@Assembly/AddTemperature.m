function obj=AddTemperature(obj,partno,T,varargin)
% Add part Temperature to Assembly
% Author : Xie Yu

p=inputParser;
addParameter(p,'type',1);% Type=1 SF Type=2 SFE
parse(p,varargin{:});
opt=p.Results;

obj.Temperature=[obj.Temperature;partno,T,opt.type];
end


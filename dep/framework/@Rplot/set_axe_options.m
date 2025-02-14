function obj=set_axe_options(obj,varargin)
% set_axe_options() Set options used to axe
%
% Parameters:
p=inputParser;
addParameter(p,'grid',0);
addParameter(p,'equal',0); 
addParameter(p,'rad',0);
addParameter(p,'zerolocation','right');
parse(p,varargin{:});

for obj_ind=1:numel(obj)
    obj(obj_ind).axe_options=p.Results;
end
end
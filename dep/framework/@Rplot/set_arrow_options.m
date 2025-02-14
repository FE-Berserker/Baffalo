function obj = set_arrow_options( obj , varargin )
% set_arrow_options Set arrow options

p=inputParser;
addParameter(p, 'form', 3 );
addParameter(p, 'ad1', []);
addParameter(p, 'ad2', []);
addParameter(p, 'rot', []);
parse(p,varargin{:});

for obj_ind=1:numel(obj)
    obj(obj_ind).arrow_options=p.Results;
end

end


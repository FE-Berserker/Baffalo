function obj = set_stat_options( obj , varargin )
% set_line_options Set statistics options

p=inputParser;
addParameter(p, 'alpha', 0.05 );
addParameter(p, 'nboot', 200 );
parse(p,varargin{:});

for obj_ind=1:numel(obj)
    obj(obj_ind).stat_options=p.Results;
end

end

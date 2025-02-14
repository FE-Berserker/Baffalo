function obj=set_annotation_options(obj,varargin)
% set_axe_options() Set options used to axe
%
% Parameters:
p=inputParser;
addParameter(p,'HorizontalAlignment','center');
addParameter(p,'VerticalAlignment','top'); 
addParameter(p,'Rotation',0)

parse(p,varargin{:});

for obj_ind=1:numel(obj)
    obj(obj_ind).annotation_options=p.Results;
end
end
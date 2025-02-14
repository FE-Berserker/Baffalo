function obj=stat_bin(obj,varargin)
% geom_point Displays an histogram of the data in x
%
% Example syntax (default arguments): gramm_object.stat_bin('nbins',30,'geom','bar')
% Options can be given as 'name',value pairs:
% - 'geom' can be 'bar', 'overlaid_bar', 'line', 'stairs', 'point' or 'stacked_bar'
% The 'normalization' argument allows to optionally normalize
% the bin counts (see the doc for Matlab's histcounts() ).
% Default is 'count', for normalization to 1 use 'probability'
% Instead of 'nbins', it is possible to directly specify bin
% edges with 'edges'. If the specified bin widths are not
% equal, it's recommended to use 'countdensity'
% or 'pdf' for normalization. Aspect of the geoms can be
% customized with the 'fill' option
% ('edge','face','all','transparent')

p=inputParser;
addParameter(p,'nbins',30);
addParameter(p,'edges',[]);
addParameter(p,'geom','bar'); %line, bar, overlaid_bar, stacked_bar,stairs, point
addParameter(p,'normalization','count');
addParameter(p,'fill',[]); %edge,face,all,transparent
addParameter(p,'width',[]);
addParameter(p,'dodge',[]);
parse(p,varargin{:});

obj.geom=vertcat(obj.geom,{@(dobj,dd)my_bin(dobj,dd,p.Results)});
obj.results.stat_bin={};
end


function obj=my_bin(obj,draw_data,params)

obj.results.stat_bin{obj.result_ind,1}=my_histplot(obj,draw_data,params,true);

end

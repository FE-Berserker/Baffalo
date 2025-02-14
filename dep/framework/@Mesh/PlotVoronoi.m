function PlotVoronoi(obj,varargin)
p=inputParser;

addParameter(p,'alpha',1);
addParameter(p,'face_alpha',0.4);
addParameter(p,'grid',1);
addParameter(p,'equal',1);
addParameter(p,'axe',1);
addParameter(p,'marker',0);

parse(p,varargin{:});
opt=p.Results;
q = max(arrayfun(@(i)numel(obj.Voronoi.Faces{i}),1:1:numel(obj.Voronoi.Faces)));
s = arrayfun(@(i)[obj.Voronoi.Faces{i}, NaN(1,q-numel(obj.Voronoi.Faces{i}))],...
    (1:1:numel(obj.Voronoi.Faces))', 'UniformOutput',false);
totFaces = cell2mat(s);

if ~isempty(obj.Point_Data)
    g=Rplot('faces',totFaces,'vertices',obj.Voronoi.Nodes,'pointdata',obj.Point_Data);
else
    g=Rplot('faces',totFaces,'vertices',obj.Voronoi.Nodes );
end


g=set_layout_options(g,'axe',opt.axe);
g=set_line_options(g,'base_size',1,'step_size',0);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha);
if opt.marker==1
    g=geom_point(g);
    g=set_point_options(g,'base_size',8);
end
% figure
figure('Position',[100 100 800 800]);
draw(g);
end


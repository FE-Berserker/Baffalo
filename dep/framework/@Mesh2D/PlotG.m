function PlotG(obj,varargin)
%PLOT Plot Mesh2D object MRST G

p=inputParser;
addParameter(p,'volume',0);
addParameter(p,'grid',0);
addParameter(p,'name',1);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'base_size',1);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
parse(p,varargin{:});
parse(p,varargin{:});
opt=p.Results;

G=obj.G;
nodes = getSortedCellNodes(G);
pos   = G.cells.facePos;
cells = (1 : G.cells.num) .';
[f, verts]= get_face_topo(nodes, pos, cells );
v= G.nodes.coords(verts, :);

if opt.volume==0
    g=Rplot('faces',f,'vertices',v);
else
    volume=G.cells.volumes;
    minv=min(volume);
    maxv=max(volume);
    Delta=maxv-minv;
    Cb=round((volume-minv)/Delta*100)+1;
    g=Rplot('faces',f,'vertices',v,'facecolor',Cb);
    g=set_color_options(g,'othermap','BuOrR_14');
end

if opt.name
    g=set_title(g,obj.Name);
end
if and(~isempty(opt.xlim),~isempty(opt.ylim))
    g=axe_property(g,'xlim',opt.xlim,'ylim',opt.ylim);
elseif and(~isempty(opt.xlim),isempty(opt.ylim))
    g=axe_property(g,'xlim',opt.xlim);
elseif and(isempty(opt.xlim),~isempty(opt.ylim))
    g=axe_property(g,'ylim',opt.ylim);
end


g=set_layout_options(g,'axe',opt.axe);
g=set_line_options(g,'base_size',opt.base_size);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);

g=geom_patch(g);

% figure
figure('Position',[100 100 500 500]);
draw(g);

end


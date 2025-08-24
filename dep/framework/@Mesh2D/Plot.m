function Plot(obj,varargin)
% Plot Mesh2D object
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',0);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'base_size',1);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'constraint',1);
parse(p,varargin{:});
opt=p.Results;

%% Initial Figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
if and(~isempty(opt.xlim),~isempty(opt.ylim))
    g=axe_property(g,'xlim',opt.xlim,'ylim',opt.ylim);
elseif and(~isempty(opt.xlim),isempty(opt.ylim))
    g=axe_property(g,'xlim',opt.xlim);
elseif and(isempty(opt.xlim),~isempty(opt.ylim))
    g=axe_property(g,'ylim',opt.ylim);
end
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=axe_property(g,'view',[0,90]);
draw(g);

%% Plot face
ElNum=size(obj.Face,2);

switch ElNum
    case 3
        FF=obj.Face;
    case 4
        FF=obj.Face;
    case 6
        FF=obj.Face(:,1:3);
    case 8
        FF=obj.Face(:,1:4);
end

if isempty(obj.Cb)
    Cb=ones(size(FF,1),1);
else
    Cb=obj.Cb;
end

g=Rplot('faces',FF,'vertices',obj.Vert,'facecolor',Cb);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=set_line_options(g,'base_size',opt.base_size);
g=axe_property(g,'view',[0,90]);
g=geom_patch(g);
draw(g);
%% Plot Mid node
switch ElNum
    case 6
        g=Rplot('X',obj.Vert(:,1),'Y',obj.Vert(:,2));
        g=set_layout_options(g,'axe',opt.axe,'hold',1);
        g=axe_property(g,'view',[0,90]);
        g=set_color_options(g,'map','black');
        g=geom_point(g);
        g=set_point_options(g,'base_size',2);
        draw(g);
    case 8
        g=Rplot('X',obj.Vert(:,1),'Y',obj.Vert(:,2));
        g=set_layout_options(g,'axe',opt.axe,'hold',1);
        g=axe_property(g,'view',[0,90]);
        g=set_color_options(g,'map','black');
        g=geom_point(g);
        g=set_point_options(g,'base_size',2);
        draw(g);
end

%% Plot constraint
if opt.constraint==1
    cnode=obj.CNode;
    cedge=obj.CEdge;

    for i=1:size(cedge,1)
        pl=line(cnode(cedge(i,:),1),cnode(cedge(i,:),2));
        pl.Color = 'yellow';
        pl.LineStyle = '--';
        pl.LineWidth=1;
        hold on
    end

end

end


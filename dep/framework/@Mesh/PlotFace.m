function g=PlotFace(obj,varargin)
% Plot Face of elements
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',1);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'facecolor',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',1);
addParameter(p,'face_normal',0);
addParameter(p,'marker',0);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
addParameter(p,'view',[-37.5,30]);
parse(p,varargin{:});
opt=p.Results;

P=obj.Vert;
if isempty(opt.xlim)
    xmmin=0.95.*min(P(:,1)).*(min(P(:,1))>0)+...
        1.05.*min(P(:,1)).*(min(P(:,1))<0)-...
        0.1.*(min(P(:,1))==0);
    xmmax=1.05.*max(P(:,1)).*(max(P(:,1))>0)+...
        0.95.*max(P(:,1)).*(max(P(:,1))<0)+...
        0.1.*(max(P(:,1))==0);
else
    xmmin=opt.xlim(1,1);
    xmmax=opt.xlim(1,2);
end

if isempty(opt.ylim)
    ymmin=0.95.*min(P(:,2)).*(min(P(:,2))>0)+...
        1.05.*min(P(:,2)).*(min(P(:,2))<0)-...
        0.1.*(min(P(:,2))==0);
    ymmax=1.05.*max(P(:,2)).*(max(P(:,2))>0)+...
        0.95.*max(P(:,2)).*(max(P(:,2))<0)+...
        0.1.*(max(P(:,2))==0);
else
    ymmin=opt.ylim(1,1);
    ymmax=opt.ylim(1,2);
end

if isempty(opt.zlim)
    zmmin=0.95.*min(P(:,3)).*(min(P(:,3))>0)+...
        1.05.*min(P(:,3)).*(min(P(:,3))<0)-...
        0.1.*(min(P(:,3))==0);
    zmmax=1.05.*max(P(:,3)).*(max(P(:,3))>0)+...
        0.95.*max(P(:,3)).*(max(P(:,3))<0)+...
        0.1.*(max(P(:,3))==0);
else
    zmmin=opt.zlim(1,1);
    zmmax=opt.zlim(1,2);
end
Numel=size(obj.Face,2);

%% Intial figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],...
    'ylim',[ymmin,ymmax],...
    'zlim',[zmmin,zmmax],...
    'view',opt.view);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
draw(g);

%% Plot face
switch Numel
    case 3
        if opt.facecolor
            g=Rplot('faces',obj.Face,'vertices',obj.Vert,'facecolor',obj.Cb);
        else
            g=Rplot('faces',obj.Face,'vertices',obj.Vert);
        end
    case 4
        if opt.facecolor
            g=Rplot('faces',obj.Face,'vertices',obj.Vert,'facecolor',obj.Cb);
        else
            g=Rplot('faces',obj.Face,'vertices',obj.Vert);
        end
    case 6
        if opt.facecolor
            g=Rplot('faces',obj.Face(:,1:3),'vertices',obj.Vert,'facecolor',obj.Cb);
        else
            g=Rplot('faces',obj.Face(:,1:3),'vertices',obj.Vert);
        end
        opt.marker=1;
    case 8
        if opt.facecolor
            g=Rplot('faces',obj.Face(:,1:4),'vertices',obj.Vert,'facecolor',obj.Cb);
        else
            g=Rplot('faces',obj.Face(:,1:4),'vertices',obj.Vert);
        end
        opt.marker=1;

end

g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=set_line_options(g,'base_size',1,'step_size',0);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
draw(g);

if opt.marker==1
    % Select face node
    nn=unique(obj.Face);
    g=Rplot('X',obj.Vert(nn,1),'Y',obj.Vert(nn,2),'Z',obj.Vert(nn,3));
    g=set_layout_options(g,'axe',opt.axe,'hold',1);
    g=axe_property(g,'view',opt.view);
    g=set_color_options(g,'map','black');
    g=geom_point(g);
    g=set_point_options(g,'base_size',2);
    draw(g);
end
end


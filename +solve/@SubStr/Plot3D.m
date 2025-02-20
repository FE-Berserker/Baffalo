function Plot3D(obj,varargin)
% Plot SubStr
% Author : Xie Yu
p=inputParser;
addParameter(p,'axe',1);
addParameter(p,'grid',0);
addParameter(p,'equal',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',1);
addParameter(p,'face_normal',0);
addParameter(p,'marker_size',5);
addParameter(p,'base_size',1);
addParameter(p,'view',[-37.5,30]);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
parse(p,varargin{:});
opt=p.Results;

Shell=obj.output.Geom.Shell;
Beam=obj.output.Geom.Beam;
Face=obj.output.Geom.Face;
MNode=obj.output.Geom.MNode;
Con=obj.output.Geom.Con;

P=[Shell.V;[cell2mat(Beam.x')',cell2mat(Beam.y')',cell2mat(Beam.z')'];Face.V;[Con.X,Con.Y,Con.Z]];
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
opt.xlim=[xmmin,xmmax];
opt.ylim=[ymmin,ymmax];
opt.zlim=[zmmin,zmmax];
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

%% plot
if ~isempty(Face.el)
    g=Rplot('faces',Face.el,'vertices',Face.V,'facecolor',Face.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
    draw(g);
end

if ~isempty(Beam.x)
    g=Rplot('x',Beam.x,'y',Beam.y,'z',Beam.z,'color',Beam.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_line(g);
    draw(g);
end

if ~isempty(Shell.el)
    g=Rplot('faces',Shell.el,'vertices',Shell.V,'facecolor',Shell.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
    draw(g);
end

if ~isempty(MNode)
    g=Rplot('X',MNode(:,1),'Y',MNode(:,2),'Z',MNode(:,3));
    g=set_layout_options(g,'axe',opt.axe,'hold',1);
    g=axe_property(g,'view',opt.view);
    g=set_color_options(g,'map','black');
    g=geom_point(g);
    g=set_point_options(g,'base_size',2);
    draw(g);
end

X=Con.X;
Y=Con.Y;
Z=Con.Z;

g=Rplot('x',X,'y',Y,'z',Z);
g=axe_property(g,'xlim',[xmmin,xmmax],...
    'ylim',[ymmin,ymmax],...
    'zlim',[zmmin,zmmax],...
    'view',opt.view);
g=set_layout_options(g,'hold',1);
g=set_color_options(g,'map','yellow');
g = set_point_options(g,'base_size', opt.marker_size);
g=geom_point(g);
draw(g);
end
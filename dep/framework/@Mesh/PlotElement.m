function PlotElement(obj,varargin)
% Plor element
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',1);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',1);
addParameter(p,'section',[]);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
addParameter(p,'view',[-37.5,30]);
parse(p,varargin{:});
opt=p.Results;

P=obj.Meshoutput.nodes;
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

num=size(obj.Meshoutput.elements,2);
if isempty(opt.section)
    Face=obj.Meshoutput.faces;
else
    pos=opt.section.pos;
    v=opt.section.vec;
    center=CenterCal(obj);
    u=center-repmat(pos,size(center,1),1);
    v=repmat(v,size(center,1),1);
    u=mat2cell(u,ones(1,size(u,1)));
    v=mat2cell(v,ones(1,size(v,1)));
    angle=cellfun(@(x,y)atan2d(norm(cross(x,y)),dot(x,y)),u,v,...
        'UniformOutput',false);
    angle=cell2mat(angle);
    row=find(angle<=90);
    
    switch num
        case 4
            Face=element2patch(obj.Meshoutput.elements(row,:),[],'tet4');
        case 8
            Face=element2patch(obj.Meshoutput.elements(row,:),[],'hex8');
        case 10
            Face=element2patch(obj.Meshoutput.elements(row,:),[],'tet10');
        case 20
            Face=element2patch(obj.Meshoutput.elements(row,:),[],'hex20');   
    end
end

Vert=obj.Meshoutput.nodes;
g=Rplot('faces',Face,'vertices',Vert);

g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=set_line_options(g,'base_size',1);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha);
draw(g);

if or(num==10,num==20)
    g=Rplot('X',P(:,1),'Y',P(:,2),'Z',P(:,3));
    g=set_layout_options(g,'axe',opt.axe,'hold',1);
    g=axe_property(g,'view',opt.view);
    g=set_color_options(g,'map','black');
    g=geom_point(g);
    g=set_point_options(g,'base_size',2);
    draw(g);
end

end


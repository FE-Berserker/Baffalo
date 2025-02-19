function Plot(obj,varargin)
% Plot Line object
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',0);
addParameter(p,'axe',1);
addParameter(p,'clabel',0);
addParameter(p,'styles',[]);
addParameter(p,'crv',[]);
addParameter(p,'map','lch');
addParameter(p,'color',0);
addParameter(p,'base_size',1.5);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
addParameter(p,'subd',[]);
addParameter(p,'coefs',0);
parse(p,varargin{:});
opt=p.Results;

if ~isempty(opt.crv)
    ic=opt.crv;
else
    ic = 1:GetNcrv(obj);
end
if isempty(obj.Nurbs)
    warning('Nothing to draw.')
    return
end
%% Point calculate
PP=OutputPoint(obj);
%% Range calculation
P=cell2mat(PP);
deltax=max(P(:,1))-min(P(:,1));
deltay=max(P(:,2))-min(P(:,2));
deltaz=max(P(:,3))-min(P(:,3));
if isempty(opt.xlim)
    x1=(min(P(:,1))-0.05*deltax).*(deltax~=0)...
        +0.95*min(P(:,1)).*(deltax==0);
    x2=(max(P(:,1))+0.05*deltax).*(deltax~=0)...
        +1.05*max(P(:,1)).*(deltax==0);
    if and(x1==0,x2==0)
        x1=-0.05;
        x2=0.05;
    end
    xmmin=min(x1,x2);
    xmmax=max(x1,x2);
else
    xmmin=opt.xlim(1,1);
    xmmax=opt.xlim(1,2);
end

if isempty(opt.ylim)
    y1=(min(P(:,2))-0.05*deltay).*(deltay~=0)...
        +0.95*min(P(:,2)).*(deltay==0);
    y2=(max(P(:,2))+0.05*deltay).*(deltay~=0)...
        +1.05*max(P(:,2)).*(deltay==0);
    if and(y1==0,y2==0)
        y1=-0.05;
        y2=0.05;
    end
    ymmin=min(y1,y2);
    ymmax=max(y1,y2);

else
    ymmin=opt.ylim(1,1);
    ymmax=opt.ylim(1,2);
end

if isempty(opt.zlim)
    z1=(min(P(:,3))-0.05*deltaz).*(deltaz~=0)...
        +0.95*min(P(:,3)).*(deltaz==0);
    z2=(max(P(:,3))+0.05*deltaz).*(deltaz~=0)...
        +1.05*max(P(:,3)).*(deltaz==0);
    if and(z1==0,z2==0)
        z1=-0.05;
        z2=0.05;
    end
    zmmin=min(z1,z2);
    zmmax=max(z1,z2);
else
    zmmin=opt.zlim(1,1);
    zmmax=opt.zlim(1,2);
end
%% Initial Figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
g=set_axe_options(g,'grid',opt.grid,'equal',1);
draw(g);
%% Main Program
X=cellfun(@(x)x(:,1),PP,'UniformOutput',false);
Y=cellfun(@(x)x(:,2),PP,'UniformOutput',false);
Z=cellfun(@(x)x(:,3),PP,'UniformOutput',false);

if ~isempty(obj.Cell_Data)
    g=Rplot('x',X,'y',Y,'z',Z,'color',obj.Cell_Data);
    g=set_color_options(g,'map',opt.map);
else
    if opt.color
        g=Rplot('x',X,'y',Y,'z',Z,'color',1:size(X,1));
        g=set_color_options(g,'map',opt.map);
    else
        g=Rplot('x',X,'y',Y,'z',Z);
        g=set_color_options(g,'map','black');
    end
end
g=set_layout_options(g,'hold',1);
g=geom_line(g);


if and(opt.clabel,isempty(opt.styles))
    g=set_line_options(g,'clabel',obj.MP(ic,:),'label_num',ic',...
        'arrow',obj.Arrow,'base_size',opt.base_size);
elseif and(opt.clabel,~isempty(opt.styles))
    g=set_line_options(g,'clabel',obj.MP(ic,:),'label_num',ic',...
        'styles',opt.styles,'base_size',opt.base_size);
elseif and(opt.clabel==0,~isempty(opt.styles))
    g=set_line_options(g,'styles',opt.styles,'arrow',obj.Arrow,'base_size',opt.base_size);
else
    g=set_line_options(g,'base_size',opt.base_size);
end


% figure
draw(g);

%% Draw coefs
if opt.coefs==1
    for i = 1:length(ic)
        point = obj.Nurbs{i,1}.Coefs;
        x=point(1,:)';
        y=point(2,:)';
        z=point(3,:)';
        if iscolumn(x)
            x=x';
            y=y';
            z=z';
        end

        X{i,1}=x';
        Y{i,1}=y';
        Z{i,1}=z';
    end
    if opt.color
        g1=Rplot('x',X,'y',Y,'z',Z,'color',1:size(X,1));
        g2=Rplot('x',X,'y',Y,'z',Z,'color',1:size(X,1));
    else
        g1=Rplot('x',X,'y',Y,'z',Z);
        g2=Rplot('x',X,'y',Y,'z',Z);
    end
    g1=set_layout_options(g1,'hold',1);
    if opt.color
        g1=set_color_options(g1,'map',opt.map);
    else
        g1=set_color_options(g1,'map','black');
    end
    g1=geom_line(g1);
    g1=set_line_options(g1,'base_size',opt.base_size,'style',{':'});
    draw(g1);

    g2=set_layout_options(g2,'hold',1);
    if opt.color
        g2=set_color_options(g2,'map',opt.map);
    else
        g2=set_color_options(g2,'map','black');
    end
    g2=geom_point(g2);
    g2=set_point_options(g2,'base_size',5);
    draw(g2);
end

end


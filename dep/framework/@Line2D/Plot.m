function Plot(obj,varargin)
% Plot Line2D object
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',0);
addParameter(p,'axe',1);
addParameter(p,'clabel',0);
addParameter(p,'styles',[]);
addParameter(p,'equal',0);
addParameter(p,'crv',[]);
addParameter(p,'map','lch');
addParameter(p,'color',0);
addParameter(p,'base_size',1.5);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
parse(p,varargin{:});
opt=p.Results;

if ~isempty(opt.crv)
    ic=opt.crv;
else
    ic = 1:GetNcrv(obj);
end
if isempty(ic)
    warning('Nothing to draw.')
    return
end

%% Range calculation
P=obj.Point.P;
if isempty(opt.xlim)
    deltax=max(P(:,1))-min(P(:,1));   
    x1=(min(P(:,1))-0.05*deltax).*(deltax~=0)...
        +0.95*min(P(:,1)).*(deltax==0)...
        -0.05.*(and(deltax==0,min(P(:,1))==0));
    x2=(max(P(:,1))+0.05*deltax).*(deltax~=0)...
        +1.05*max(P(:,1)).*(deltax==0)...
        +0.05.*(and(deltax==0,min(P(:,1))==0));
    xmmin=min(x1,x2);
    xmmax=max(x1,x2);
else
    xmmin=opt.xlim(1,1);
    xmmax=opt.xlim(1,2);
end

if isempty(opt.ylim)
    deltay=max(P(:,2))-min(P(:,2));
    y1=(min(P(:,2))-0.05*deltay).*(deltay~=0)...
        +0.95*min(P(:,2)).*(deltay==0)...
        -0.05.*(and(deltay==0,min(P(:,2))==0));
    y2=(max(P(:,2))+0.05*deltay).*(deltay~=0)...
        +1.05*max(P(:,2)).*(deltay==0)...
        +0.05.*(and(deltay==0,max(P(:,2))==0));
    ymmin=min(y1,y2);
    ymmax=max(y1,y2);
else
    ymmin=opt.ylim(1,1);
    ymmax=opt.ylim(1,2);
end
%% Initial Figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax]);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=axe_property(g,'View',[0,90]);
draw(g);
%% Main Program
X=cell(size(ic,1),1);
Y=cell(size(ic,1),1);
for i = 1:length(ic)
    [x,y] = PolyCurve(obj,ic(i),'opt',1);
    if iscolumn(x)
        x=x';
        y=y';
    end

    X{i,1}=x';
    Y{i,1}=y';
end

if ~isempty(obj.Cell_Data)
    g=Rplot('x',X,'y',Y,'color',obj.Cell_Data);
    g=set_color_options(g,'map',opt.map);
else
    if opt.color
        g=Rplot('x',X,'y',Y,'color',1:size(X,1));
        g=set_color_options(g,'map',opt.map);
    else
        g=Rplot('x',X,'y',Y);
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
        'styles',opt.styles,'arrow',obj.Arrow,'base_size',opt.base_size);
elseif and(opt.clabel==0,~isempty(opt.styles))
    g=set_line_options(g,'styles',opt.styles,'arrow',obj.Arrow,'base_size',opt.base_size);
else
    g=set_line_options(g,'arrow',obj.Arrow,'base_size',opt.base_size);
end

if ~isempty(obj.Arrow)
    g=set_arrow_options(g,'form',obj.Form,'ad1',obj.Ad,'ad2',obj.Ad);
end

% figure
draw(g);

end


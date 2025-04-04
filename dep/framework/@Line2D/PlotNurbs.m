function PlotNurbs(obj,varargin)
% Plot Line2D object Nurbs
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',0);
addParameter(p,'axe',1);
addParameter(p,'clabel',0);
addParameter(p,'styles',[]);
addParameter(p,'equal',0);
addParameter(p,'crv',[]);
addParameter(p,'map','black');
addParameter(p,'color',0);
addParameter(p,'base_size',1.5);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'coefs',0);
parse(p,varargin{:});
opt=p.Results;

if ~isempty(opt.crv)
    ic=opt.crv;
else
    ic = 1:GetNNurb(obj);
end
if isempty(ic)
    warning('Nothing to draw.')
    return
end

%% Range calculation
Temp=cellfun(@(x)x(1:2,:)',obj.Coefs,'UniformOutput',false);
P=cell2mat(Temp);
% P=obj.Point.P;
if isempty(opt.xlim)
    deltax=max(P(:,1))-min(P(:,1));
    deltay=max(P(:,2))-min(P(:,2));
    x1=(min(P(:,1))-0.05*deltax).*(deltax~=0)...
        +0.95*min(P(:,1)).*(deltax==0);
    x2=(max(P(:,1))+0.05*deltax).*(deltax~=0)...
        +1.05*max(P(:,1)).*(deltax==0);
    xmmin=min(x1,x2);
    xmmax=max(x1,x2);
else
    xmmin=opt.xlim(1,1);
    xmmax=opt.xlim(1,2);
end

if isempty(opt.ylim)
    y1=(min(P(:,2))-0.05*deltay).*(deltay~=0)...
        +0.95*min(P(:,2)).*(and(deltay==0,P(1,2)~=0))...
        -0.5.*(and(deltay==0,P(1,2)==0));
    y2=(max(P(:,2))+0.05*deltay).*(deltay~=0)...
        +1.05*max(P(:,2)).*(and(deltay==0,P(1,2)~=0))...
        +0.5.*(and(deltay==0,P(1,2)==0));

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
g=set_color_options(g,'map',opt.map);
g=axe_property(g,'View',[0,90]);
draw(g);
%% Main Program
X=cell(size(ic,1),1);
Y=cell(size(ic,1),1);
for i = 1:length(ic)
    p = NrbEval(obj,i,linspace(0.0,1.0,size(obj.Coefs{i,1},2)*8));
    x=p(1,:)';
    y=p(2,:)';
    if iscolumn(x)
        x=x';
        y=y';
    end

    X{i,1}=x';
    Y{i,1}=y';
end

if opt.color
    g=Rplot('x',X,'y',Y,'color',1:size(X,1));
else
    g=Rplot('x',X,'y',Y);
end

g=set_layout_options(g,'hold',1);
g=set_color_options(g,'map',opt.map);
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

%% Draw coefs
if opt.coefs==1
    for i = 1:length(ic)
        p = obj.Coefs{i,1};
        x=p(1,:)';
        y=p(2,:)';
        if iscolumn(x)
            x=x';
            y=y';
        end

        X{i,1}=x';
        Y{i,1}=y';
    end
    if opt.color
        g1=Rplot('x',X,'y',Y,'color',1:size(X,1));
        g2=Rplot('x',X,'y',Y,'color',1:size(X,1));
    else
        g1=Rplot('x',X,'y',Y);
        g2=Rplot('x',X,'y',Y);
    end
    g1=set_layout_options(g1,'hold',1);
    g1=set_color_options(g1,'map',opt.map);
    g1=geom_line(g1);
    g1=set_line_options(g1,'base_size',opt.base_size,'style',{':'});
    draw(g1);

    g2=set_layout_options(g2,'hold',1);
    g2=set_color_options(g2,'map',opt.map);
    g2=geom_point(g2);
    g2=set_point_options(g2,'base_size',5);
    draw(g2);
end
end


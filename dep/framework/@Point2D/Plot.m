function Plot(obj,varargin)
% Plot plpt Point2D object
% Author : Xie Yu
p=inputParser;
addParameter(p,'Plabel',0);
addParameter(p,'Grid',0);
addParameter(p,'Group',[]);
addParameter(p,'Equal',0);
addParameter(p,'Vector',0);
addParameter(p,'VectorScale',1);
parse(p,varargin{:});
opt=p.Results;
%% Range calculation
P=obj.P;

deltax=max(P(:,1))-min(P(:,1));
deltay=max(P(:,2))-min(P(:,2));
x1=(min(P(:,1))-0.05*deltax).*(deltax~=0)...
    +0.95*min(P(:,1)).*(deltax==0);
x2=(max(P(:,1))+0.05*deltax).*(deltax~=0)...
    +1.05*max(P(:,1)).*(deltax==0);
xmmin=min(x1,x2);
xmmax=max(x1,x2);

y1=(min(P(:,2))-0.05*deltay).*(deltay~=0)...
    +0.95*min(P(:,2)).*(deltay==0);
y2=(max(P(:,2))+0.05*deltay).*(deltay~=0)...
    +1.05*max(P(:,2)).*(deltay==0);
ymmin=min(y1,y2);
ymmax=max(y1,y2);

%% Initial Figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax]);
g=set_axe_options(g,'grid',opt.Grid,'equal',opt.Equal);
g=axe_property(g,'View',[0,90]);
draw(g);

%% Point Figure
if isempty(opt.Group)
    if isempty(obj.Point_Data)
        g=Rplot('x',obj.P(:,1),'y',obj.P(:,2));
    else
        g=Rplot('x',obj.P(:,1),'y',obj.P(:,2),'color',obj.Point_Data);
    end
else
    pp=cell(numel(opt.Group),1);Plabel=cell(numel(opt.Group),1);
    for i=1:numel(opt.Group)
        Temp=obj.PP{opt.Group(i,1),1};
        pp{i,1}=Temp;
        Plabel{i,1}=repmat(opt.Group(i,1),size(Temp,1),1);
    end
    pp=cell2mat(pp);Plabel=cell2mat(Plabel);
    g=Rplot('x',pp(:,1),'y',pp(:,2),'color',Plabel);
    g=set_names(g,'color','Groups');
end
g=set_layout_options(g,'hold',1);
% Plot raw data as points
g=geom_point(g);

if opt.Plabel==1
    g=set_point_options(g,'Plabel',1);
end

% figure
draw(g);

if opt.Vector==1
    g1=Rplot('x',obj.P(:,1),'y',obj.P(:,2),...
        'u',obj.Point_Vector(:,1)*opt.VectorScale,...
        'v',obj.Point_Vector(:,2)*opt.VectorScale);
    g1=set_layout_options(g1,'hold',1);
    g1=set_color_options(g1,'map','black');
    g1=geom_quiver(g1);
    draw(g1);
end

end


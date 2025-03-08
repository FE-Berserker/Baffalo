function Plot2D(obj,varargin)
% Plot BossPlate 2D surface
% Author : Xie Yu
p=inputParser;
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'grid',0);
addParameter(p,'color',[1 0.5 0.5]);
parse(p,varargin{:});

opt=p.Results;

% close polygon
X{1,1}=obj.input.OutLine.Point.P(:,1);
X{2,1}=obj.input.MidLine.Point.P(:,1);
Y{1,1}=obj.input.OutLine.Point.P(:,2);
Y{2,1}=obj.input.MidLine.Point.P(:,2);

if ~isempty(obj.input.InnerLine)
    X{3,1}=obj.input.InnerLine.Point.P(:,1);
    Y{3,1}=obj.input.InnerLine.Point.P(:,2);
    cmap=[1,0.5,0.5;0.5,0.5,1;1,1,1];
else
    cmap=[1,0.5,0.5;1,1,1];

end

g=Rplot('x',X,'y',Y);
g=set_layout_options(g,'axe',opt.axe);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=geom_line(g,'alpha',0);
g=geom_polygon(g,'x',X,'y',Y,'color',cmap,'alpha',1);
% figure
figure('Position',[100 100 800 800]);
draw(g);


end
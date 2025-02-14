function g=Plot(obj,varargin)
% Plot surface2D
% Author : Xie Yu
p=inputParser;
addParameter(p,'face',[]);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'grid',0);
addParameter(p,'color',[1 0.5 0.5]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.face)
    FN=1:GetNface(obj);
else
    FN=opt.face;
end

Node=obj.Node(FN',1);
% close polygon
X1=cellfun(@(x)x(:,1)',Node,'UniformOutput',0);
Y1=cellfun(@(y)y(:,2)',Node,'UniformOutput',0);

X2=cellfun(@(x)[x,x(1,1)],X1,'UniformOutput',0);
Y2=cellfun(@(y)[y,y(1,1)],Y1,'UniformOutput',0);

STAT=obj.FS(FN,1)';
cmap=STAT'*[1,1,1]+abs(STAT'-1)*opt.color;
g=Rplot('x',X2,'y',Y2);
g=set_layout_options(g,'axe',opt.axe);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
g=geom_line(g,'alpha',0);
g=geom_polygon(g,'x',X1,'y',Y1,'color',cmap,'alpha',1);
% figure
figure('Position',[100 100 800 800]);
draw(g);

end


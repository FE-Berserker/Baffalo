function PlotParameter(obj,varargin)
% Plot Iteration parameter
% Author : Xie Yu
p=inputParser;
addParameter(p,'Num',[]);
parse(p,varargin{:});
opt=p.Results;

x=1:size(obj.output.G_Iteration,1);

if isempty(opt.Num)
    Parameter=obj.output.G_Iteration;
    g=Rplot('x',x,'y',Parameter','color',1:size(Parameter,2));
else
    Parameter=obj.output.G_Iteration(:,opt.Num);
    g=Rplot('x',x,'y',Parameter','color',opt.Num);
end
g=geom_line(g);
  g=axe_property(g,'XGrid','on','Ygrid','on');
g=set_names(g,'column','Origin','x',"Iteration",'y','Parameter','color','Num');
figure('Position',[100 100 800 600]);
draw(g);

end
function obj=PlotCampbell(obj,varargin)
% Plot Campbell
% Author : Xie Yu
p=inputParser;
addParameter(p,'NMode',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.NMode)
    opt.NMode=obj.params.NMode;
end

if isempty(obj.output.Campbell)
    obj=ImportCampbell(obj,'Campbell.txt',opt.NMode);
end
X=obj.input.Speed;
Y=table2array(obj.output.Campbell(:,3:end));

if ~isempty(opt.NMode)
    Y=Y(1:opt.NMode,:);
end

figure
g=Rplot('x',X,'y',Y,'color',1:size(Y,1));
g=set_title(g,'Campbell Chart');
g=set_layout_options(g,'axe',1);
g=axe_property(g,'xlim',[0,X(1,end)],'ylim',[0,max(max(Y))]);
g=set_names(g,'column','Origin','x','Speed [RPM]','y','Frequency [Hz]','color','Mode');
g=set_axe_options(g,'grid',1);
g=geom_line(g);
draw(g);

end
function PlotTimeSeries(obj,varargin)
p=inputParser;
addParameter(p,'Time',[]);
addParameter(p,'Num',[]);
parse(p,varargin{:});
opt=p.Results;

x=obj.output.T;
y=obj.input.TimeSeries;

if ~isempty(opt.Num)
    x=x(opt.Num',:);
    y=y(opt.Num',:);
end

if isempty(opt.Time)
    T=[min(x) max(x)];
else
    T=opt.Time;
end

figure
g=Rplot('x',x,'y',y);
g=geom_line(g);
g=set_names(g,'column','Origin','x','Time [s]','y',obj.params.DataName);
g=axe_property(g,'XLim',T);
g=set_title(g,'Time Series');
draw(g);

end
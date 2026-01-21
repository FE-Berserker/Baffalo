function PlotMass(obj,varargin)
% Plot Mass
% Author : Xie Yu
p=inputParser;
addParameter(p,'Axis',[]);
addParameter(p,'Seg',100);
addParameter(p,'Scope',[]);
parse(p,varargin{:});
opt=p.Results;

MassTable = OutputMass(obj,'Axis',opt.Axis,'Seg',opt.Seg,'Scope',opt.Scope);

if isempty(opt.Axis)
    g=Rplot('x',1:size(MassTable,1),'y',MassTable.PartMass);
    g=geom_line(g);
    g=set_names(g,'x','PartNumber','y','PartMass');
    figure('Position',[100 100 800 600]);
    draw(g);
else
    g=Rplot('x',MassTable.PartName,'y',MassTable.PartMass);
    g=geom_line(g);
g=set_names(g,'x','Length','y','Mass');
    figure('Position',[100 100 800 600]);
    draw(g);
   
end

end


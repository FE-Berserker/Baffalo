function PlotData(obj,varargin)
% Plot foil data
% Author : Xie Yu

Data=obj.output.Data;
X=repmat(Data.alpha',4,1);
Y=[Data.CD';Data.CL';Data.Cm';Data.CDp'];
C={'CD','CL','Cm','CDp'};
g=Rplot('x',X,'y',Y,'color',C);
g=geom_line(g);
g=set_names(g,'x','Alpha [°]','y','Cp','color','Factor');
g=set_title(g,strcat(Data.name,' Re=',num2str(Data.Re),' Mach=',num2str(obj.params.Mach)));
figure('Position',[100 100 800 550]);
draw(g);

end
function PlotBoltDiagram(obj)
% Plot Bolt Diagram
% Author : Xie Yu
deltap=obj.output.deltap;
deltas=obj.output.deltas;
PMmax=obj.input.Bolt.output.FMmax;
PMmin=obj.input.Bolt.output.FMmin;

x=[0,PMmax*deltas;0,PMmin*deltas;...
    PMmax*deltas,PMmax*deltas+PMmax*deltap;...
    PMmin*deltas,PMmin*deltas+PMmin*deltap];
y=[0,PMmax;0,PMmin;PMmax,0;PMmin,0];
C={'fs_{MaxPreload}','fs_{MinPreload}','fp_{MaxPreload}','fp_{MinPreload}'};
g=Rplot('x',x,'y',y,'color',C);
g=geom_line(g);
g=set_names(g,'x','Length Change [mm]','y','Force [N]','color','Type');
g=set_axe_options(g,'grid',1);
figure('Position',[100 100 800 600]);
draw(g);

end


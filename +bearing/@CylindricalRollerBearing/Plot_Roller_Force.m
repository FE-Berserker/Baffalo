function Plot_Roller_Force(obj)
% Plot roller force
% Author : Xie Yu
z=obj.input.Z;
x=0:360/z:360;
Roller_Force=obj.output.Roller_Force;
Roller_Force=[Roller_Force;Roller_Force(1,1)];
g=Rplot('x',x','y',Roller_Force);
g=geom_radar(g);
g=set_title(g,'Bearing Force');
figure('Position',[100 100 800 600]);
draw(g)
end


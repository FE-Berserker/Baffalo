function Plot2D(obj)
% Plot 2D foil
% Author : Xie Yu

a=Point2D('Temp','Echo',0);
a=AddPoint(a,obj.input.Foil(:,1),obj.input.Foil(:,2));
b=Line2D(obj.params.Name);
b=AddCurve(b,a,1);
Plot(b,'equal',1)

end
function Plot2D(obj)
% Plot foil
% Author : Xie Yu

a=Point2D('Temp','Echo',0);
a=AddPoint(a,obj.output.Coor(:,1),obj.output.Coor(:,2));
b=Line2D(obj.params.Name);
b=AddCurve(b,a,1);
Plot(b,'equal',1)

end
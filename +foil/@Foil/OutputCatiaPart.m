function OutputCatiaPart(obj)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

a=Point2D('Temp','Echo',0);
a=AddPoint(a,obj.output.Coor(:,1),obj.output.Coor(:,2));
b=Line2D(obj.params.Name);
b=AddCurve(b,a,1);

Cap=CatiaPart(obj.params.Name);
Cap=AddSketch(Cap,b);
CatiaOutput(Cap);

end

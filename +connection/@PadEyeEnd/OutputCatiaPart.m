function OutputCatiaPart(obj)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

w=obj.input.w;
h=obj.input.h;
R=obj.input.HoleDia/2;
b=obj.input.b;
l=obj.input.l;
T=obj.input.Thickness;
R2=obj.input.Dia2/2;

aa=Point2D('Temp','Echo',0);
aa=AddPoint(aa,[b;b;-b;-b;-b;b;b],[0;T/2;T/2;0;-T/2;-T/2;0]);
aa=AddPoint(aa,0,0);

bb=Line2D('Temp','Echo',0);
bb=AddCurve(bb,aa,1);

bb1=Line2D('Temp','Echo',0);
bb1=AddCircle(bb1,R2,aa,2);

Cap=CatiaPart(obj.params.Name);
Cap=AddPlane(Cap,'YZ','Offset',-R-w+h);
Cap=AddPlane(Cap,'YZ','Offset',-R-w);
Cap=AddSketch(Cap,obj.output.Surface);
Cap=AddSketch(Cap,bb,'Plane',1);
Cap=AddSketch(Cap,bb1,'Plane',2);
Cap=AddExtrude(Cap,1,T/2,'Height2',T/2);
Cap=AddLoft(Cap,2,3,'Type',1);
Cap=AddExtrude(Cap,3,-l);
CatiaOutput(Cap);

end

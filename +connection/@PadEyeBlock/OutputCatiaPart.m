function OutputCatiaPart(obj)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

w=obj.input.w;
h=obj.input.h;
R=obj.input.HoleDia/2;
b=obj.input.b;
l=obj.input.l;
T=obj.input.Thickness;

aa=Point2D('Temp','Echo',0);
aa=AddPoint(aa,[-R-w;-R-w+h;-R-w+h;-R-w;-R-w],[-b;-b;b;b;-b]);

bb=Line2D('Temp','Echo',0);
bb=AddCurve(bb,aa,1);

Cap=CatiaPart(obj.params.Name);
Cap=AddSketch(Cap,obj.output.Surface);
Cap=AddSketch(Cap,bb);
Cap=AddExtrude(Cap,1,-l/2,'Height2',l/2-T);
Cap=AddExtrude(Cap,1,l/2,'Height2',-l/2+T);
Cap=AddExtrude(Cap,2,l/2-T,'Height2',l/2-T);
CatiaOutput(Cap);

end

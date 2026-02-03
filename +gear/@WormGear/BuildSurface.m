function obj=BuildSurface(obj)
% Build Surface of WormGear
% Author: Xie Yu

d2=obj.output.d2;
d1=obj.output.d1;
aa=obj.input.a;
b1=obj.input.b1;

a=Point2D('Temp','Echo',0);
a=AddPoint(a,[-d1/2;d1/2],[-b1/2;-b1/2]);
a=AddPoint(a,[d1/2;d1/2],[-b1/2;b1/2]);
a=AddPoint(a,[d1/2;-d1/2],[b1/2;b1/2]);
a=AddPoint(a,[-d1/2;-d1/2],[b1/2;-b1/2]);
a=AddPoint(a,aa,0);
b1=Line2D('Worm','Echo',0);
b2=Line2D('Wheel','Echo',0);

for i=1:4
    b1=AddLine(b1,a,i);
end

b2=AddCircle(b2,d2/2,a,5);

S1=Surface2D(b1,'Echo',0);
S2=Surface2D(b2,'Echo',0);

m1=Mesh2D('Worm','Echo',0);
m1=AddSurface(m1,S1);
m1=Mesh(m1);

m2=Mesh2D('Wheel','Echo',0);
m2=AddSurface(m2,S2);
m2=Mesh(m2);

L=Layer('Surface','Echo',0);
L=AddElement(L,m1);
L=AddElement(L,m2);

obj.output.Surface=L;

end


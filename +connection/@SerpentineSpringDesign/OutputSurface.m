function obj = OutputSurface(obj)
% Output Surface of spring
% Author : Xie Yu

a=Point2D('TempPoint','Echo',0);
b1=Line2D('TempLine','Echo',0);
b2=Line2D('TempLine','Echo',0);

X1=obj.output.ProfileInner(:,1);
Y1=obj.output.ProfileInner(:,2);
X2=obj.output.ProfileOuter(:,1);
Y2=obj.output.ProfileOuter(:,2);


a=AddPoint(a,X1,Y1);
a=AddPoint(a,X2,Y2);
b2=AddCurve(b2,a,1);
b1=AddCurve(b1,a,2);

S=Surface2D(b1,'Echo',0);
S=AddHole(S,b2);

obj.output.Surface=S;
end


function obj = AddBall(obj,dia)
% Add ball to Catia
% Author : Xie Yu

% Semi circle
a=Point2D('Circle center');
a=AddPoint(a,0,0);
a=AddPoint(a,[-dia/2;dia/2],[0;0]);
b=Line2D('Semi circle');
b=AddCircle(b,dia/2,a,1,'ang',180);
b=AddLine(b,a,2);

obj=AddSketch(obj,b);
obj=AddRotate(obj,1);
end
function obj=CalSurface(obj)
% Calculate surface of IBeam
% Author: Xie Yu


t1=obj.input.t(1);
t2=obj.input.t(2);
h=obj.input.h;
if ~isempty(obj.input.r)
    r1=obj.input.r(1);
    r2=obj.input.r(2);
end
d=obj.input.d;
b1=obj.input.b(1);
b2=obj.input.b(2);
a=Point2D('Point Ass','Echo',0);
a=AddPoint(a,[-b1/2;b1/2],[-h/2;-h/2]);
a=AddPoint(a,[b1/2;b1/2],[-h/2;t1-h/2]);
a=AddPoint(a,[b1/2;d/2],[t1-h/2;t1-h/2]);
a=AddPoint(a,[d/2;d/2],[t1-h/2;h/2-t2]);
a=AddPoint(a,[d/2;b2/2],[h/2-t2;h/2-t2]);
a=AddPoint(a,[b2/2;b2/2],[h/2-t2;h/2]);
a=AddPoint(a,[b2/2;-b2/2],[h/2;h/2]);
a=AddPoint(a,[-b2/2;-b2/2],[h/2;h/2-t2]);
a=AddPoint(a,[-b2/2;-d/2],[h/2-t2;h/2-t2]);
a=AddPoint(a,[-d/2;-d/2],[h/2-t2;-h/2+t1]);
a=AddPoint(a,[-d/2;-b1/2],[-h/2+t1;-h/2+t1]);
a=AddPoint(a,[-b1/2;-b1/2],[-h/2+t1;-h/2]);
bb1=Line2D('Line Ass','Echo',0);
for i=1:12
    bb1=AddLine(bb1,a,i);
end

if ~isempty(obj.input.r)
    bb1=CreateRadius(bb1,3,r1);
    bb1=CreateRadius(bb1,5,r2);
    bb1=CreateRadius(bb1,11,r2);
    bb1=CreateRadius(bb1,13,r1);
end

S1=Surface2D(bb1,'Echo',0);

if ~isempty(obj.input.Stiffner)
    a1=Point2D('Point Ass','Echo',0);
    a1=AddPoint(a1,[d/2;b1/2],[t1-h/2;t1-h/2]);
    a1=AddPoint(a1,[b1/2;b1/2],[t1-h/2;h/2-t2]);
    a1=AddPoint(a1,[b1/2;d/2],[h/2-t2;h/2-t2]);
    a1=AddPoint(a1,[d/2;d/2],[h/2-t2;t1-h/2]);
    bb2=Line2D('Line Ass','Echo',0);
    for i=1:4
        bb2=AddLine(bb2,a1,i);
    end

    if ~isempty(obj.input.r)
        bb2=CreateRadius(bb2,3,r2);
        bb2=CreateRadius(bb2,5,r1);
    end

    S2=Surface2D(bb2,'Echo',0);
    obj.output.Stiffner_Surface=S2;
end

%% Parse
obj.output.Surface=S1;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate surface .\n');
end
end
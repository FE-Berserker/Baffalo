function obj=CalSurface(obj)
% Calculate surface of CBeam
% Author: Xie Yu

r=obj.input.r;
d1=obj.input.d(1);
d2=obj.input.d(2);

b1=obj.input.b(1);
b2=obj.input.b(2);
a=Point2D('Point Ass','Echo',0);
a=AddPoint(a,[0;b1],[0;0]);
a=AddPoint(a,[b1;b1],[0;d1]);
a=AddPoint(a,[b1;d2],[d1;d1]);
a=AddPoint(a,[d2;d2],[d1;b2]);
a=AddPoint(a,[d2;0],[b2;b2]);
a=AddPoint(a,[0;0],[b2;0]);
bb1=Line2D('Line Ass','Echo',0);
for i=1:6
    bb1=AddLine(bb1,a,i);
end

if ~isempty(obj.input.r)
    bb1=CreateRadius(bb1,3,r);
end

S1=Surface2D(bb1,'Echo',0);

if ~isempty(obj.input.Stiffner)
    a1=Point2D('Point Ass','Echo',0);
    a1=AddPoint(a1,[d2;b1],[d1;d1]);
    a1=AddPoint(a1,[b1;b1],[d1;b2]);
    a1=AddPoint(a1,[b1;d2],[b2;b2]);
    a1=AddPoint(a1,[d2;d2],[b2;d1]);
    bb2=Line2D('Line Ass','Echo',0);
    for i=1:4
        bb2=AddLine(bb2,a1,i);
    end

    if ~isempty(obj.input.r)
        bb2=CreateRadius(bb2,4,r);
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
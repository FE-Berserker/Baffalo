function obj=CalSurface(obj)
% Calculate surface of Rod
% Author: Xie Yu

G=obj.input.GeometryData;
switch obj.params.Type
    case 1
        a=Point2D('Point Ass','Echo',0);
        a=AddPoint(a,[-G(1,1)/2;G(1,1)/2],[G(1,2)/2;G(1,2)/2]);
        a=AddPoint(a,[G(1,1)/2;G(1,1)/2],[G(1,2)/2;-G(1,2)/2]);
        a=AddPoint(a,[G(1,1)/2;-G(1,1)/2],[-G(1,2)/2;-G(1,2)/2]);
        a=AddPoint(a,[-G(1,1)/2;-G(1,1)/2],[-G(1,2)/2;G(1,2)/2]);
        b=Line2D('Line Ass','Echo',0);
        for i=1:4
            b=AddLine(b,a,i);
        end
    case 2
        a=Point2D('Point Ass','Echo',0);
        a=AddPoint(a,0,0);
        b=Line2D('Line Ass','Echo',0);
        b=AddCircle(b,G(1,1),a,1);
    case 3
        a=Point2D('Point Ass','Echo',0);
        a=AddPoint(a,0,0);
        b=Line2D('Line Ass','Echo',0);
        b=AddCircle(b,G(1,1),a,1,'ang',180);

end

S=Surface2D(b,'Echo',0);
for i=1:size(obj.input.Hole,1)
    a=Point2D('Temp','Echo',0);
    a=AddPoint(a,obj.input.Hole(i,1),obj.input.Hole(i,2));
    h=Line2D('Temp','Echo',0);
    h=AddCircle(h,obj.input.Hole(i,3),a,1);
    S=AddHole(S,h);
end

%% Parse
obj.output.Surface=S;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate surface .\n');
end
end
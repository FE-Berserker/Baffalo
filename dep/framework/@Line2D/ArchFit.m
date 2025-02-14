function b=ArchFit(obj,LineNum,e,min_dots,max_dist)
% Calculate arch fit curve
N=obj.Point.PP{LineNum,1};
Instructions=FitPolyLine(N,e,min_dots,max_dist);
b=Line2D('Arc Fit','Echo',0);
Num=size(Instructions,1);
for i=1:Num
    if Instructions(i,3)==0
        continue
    else
        a=Point2D('Temp','Echo',0);
        a=AddPoint(a,Instructions(i,1),Instructions(i,2));
        b=AddCircle(b,Instructions(i,3),a,1,'sang',Instructions(i,4)/pi*180,'ang',Instructions(i,5)/pi*180);
    end
end

%% Print
if obj.Echo
    fprintf('Successfully calculate arch .\n');
end
end
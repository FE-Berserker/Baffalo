function obj=CalSurface(obj)
% Calculate surface of Pin
% Author: Xie Yu

a=Point2D('Point Ass','Echo',0);
a=AddPoint(a,0,0);
b=Line2D('Line Ass','Echo',0);
b=AddCircle(b,obj.input.R,a,1);
S=Surface2D(b,'Echo',0);

%% Parse
obj.output.Surface=S;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate surface .\n');
end
end
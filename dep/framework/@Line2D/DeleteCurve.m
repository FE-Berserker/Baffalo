function obj=DeleteCurve(obj,ic)
% Delete curve
% Author : Xie Yu

Temp_PP=obj.Point.PP;
Temp_PP{ic,1}=[];
Temp_PP= Temp_PP(cellfun(@(x) ~isempty(x), Temp_PP));

a=Point2D('Temp_Point','Echo',0);
b=Line2D('Temp_Line','Echo',obj.Echo,'Gtol',obj.Gtol,'Dtol',obj.Dtol,...
    'Atol',obj.Atol,'Rtol',obj.Rtol,'Adfac',obj.Adfac,'Compress',obj.Compress,...
    'Arrow',obj.Arrow,'Form',obj.Form);
for i=1:size(Temp_PP,1)
    a=AddPoint(a,Temp_PP{i,1}(:,1),Temp_PP{i,1}(:,2));
    b=AddCurve(b,a,i);
end
obj.Point=b.Point;

is = obj.CIX(ic);
ie = obj.CIX(ic+1) - 1;
obj.C(is:ie,:)=[];
Temp=obj.CIX;
Num=ie-is+1;
if ic==size(obj.CIX,2)-1
    Temp(end-1)=Temp(end)-Num;
else
    Temp(ic+1:end-1)=Temp(ic+2:end)-Num;
end

Temp(end)=[];
obj.CIX=Temp;

obj.CT(ic)=[];
obj.MP(:,ic)=[];
obj.CJ(ic)=[];
obj.CN(ic)=[];
obj.CL(ic)=[];
obj.CL0(ic)=[];
obj.CHD(ic)=[];

%% Print
if obj.Echo
    fprintf('Successfully delete curve .\n');
end


end


function obj=AddCurve(obj,Point,P)
% Add curve

x=Point.PP{P,1}(:,1);
y=Point.PP{P,1}(:,2);
z=Point.PP{P,1}(:,3);

pnts=[x,y,z]';
Knots=[0,0:1/(size(x,1)-1):1,1];
curve = nrbmak(pnts,Knots); 

n = GetNcrv(obj);
obj.Nurbs{n+1,1}.Coefs=curve.coefs;
obj.Nurbs{n+1,1}.Knots=curve.knots;
obj.Nurbs{n+1,1}.Order=curve.order;
obj.Nurbs{n+1,1}.Dim=curve.dim;
obj.Subd{n+1,1}=size(x,1)-1;
obj.MP(n+1,:)=mean(Point.PP{P,1});
end


function obj=AddLine(obj,Point,P)
% Add line

if numel(Point.PP{P,1})~=6
    error('The Line only contains 2 points')
end

curve = nrbline(Point.PP{P,1}(1,:)',Point.PP{P,1}(2,:)');

n = GetNcrv(obj);
obj.Nurbs{n+1,1}.Coefs=curve.coefs;
obj.Nurbs{n+1,1}.Knots=curve.knots;
obj.Nurbs{n+1,1}.Order=curve.order;
obj.Nurbs{n+1,1}.Dim=curve.dim;
obj.Subd{n+1,1}=1;
obj.MP(n+1,:)=mean(Point.PP{P,1});
end


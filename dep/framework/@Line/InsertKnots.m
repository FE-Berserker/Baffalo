function obj=InsertKnots(obj,LineNo,knots)
% Add new knots to line

pnts=obj.Nurbs{LineNo,1}.Coefs;
k=obj.Nurbs{LineNo,1}.Knots;
crv = nrbmak(pnts,k); 
icrv = nrbkntins(crv,knots); 

obj.Nurbs{LineNo,1}.Coefs=icrv.coefs;
obj.Nurbs{LineNo,1}.Knots=icrv.knots;
obj.Nurbs{LineNo,1}.Order=icrv.order;
obj.Nurbs{LineNo,1}.Dim=icrv.dim;
%% Print
if obj.Echo
    fprintf('Successfully insert knots. \n');
end
end


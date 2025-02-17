function obj=Move(obj,num,dis,varargin)
% Move curve
% Author : Xie Yu
p=inputParser;
addParameter(p,'new',[]);
parse(p,varargin{:});
opt=p.Results;

%% Move Curve
coefs=obj.Nurbs{num,1}.Coefs;
knots=obj.Nurbs{num,1}.Knots;
curve0=nrbmak(coefs,knots);
trans = vectrans(dis);
curve=nrbtform(curve0,trans);

if opt.new==1
    n = GetNcrv(obj);
    obj.Nurbs{n+1,1}.Coefs=curve.coefs;
    obj.Nurbs{n+1,1}.Knots=curve.knots;
    obj.Nurbs{n+1,1}.Order=curve.order;
    obj.Nurbs{n+1,1}.Dim=curve.dim;
    obj.Subd{n+1,1}= obj.Subd{num,1};
else
    obj.Nurbs{num,1}.Coefs=curve.coefs;
    obj.Nurbs{num,1}.Knots=curve.knots;
end
%% Print
if obj.Echo
    fprintf('Successfully move curve. \n');
end
end


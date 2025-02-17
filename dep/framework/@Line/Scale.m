function obj=Scale(obj,num,factor,varargin)
% Scale curve
% Author : Xie Yu
p=inputParser;
addParameter(p,'new',[]);
addParameter(p,'ori',[0,0,0]);
parse(p,varargin{:});
opt=p.Results;

%% Move Curve
coefs=obj.Nurbs{num,1}.Coefs;
knots=obj.Nurbs{num,1}.Knots;
curve0=nrbmak(coefs,knots);
trans = vectrans(-opt.ori);
curve1=nrbtform(curve0,trans);
trans = vecscale(factor);
curve2=nrbtform(curve1,trans);
trans = vectrans(opt.ori);
curve=nrbtform(curve2,trans);

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
    fprintf('Successfully scale curve. \n');
end
end


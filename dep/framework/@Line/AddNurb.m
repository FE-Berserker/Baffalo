function obj=AddNurb( obj,coefs,knots, varargin )
% Add Nurb
% Author : Xie Yu
k=inputParser;
addParameter(k,'seg',[]);
parse(k,varargin{:});
opt=k.Results;
 
% Parameter
coefs=coefs';
np = size(coefs);

% constructing a curve
curve = nrbmak(coefs,knots);

n = GetNcrv(obj);
obj.Nurbs{n+1,1}.Coefs=curve.coefs;
obj.Nurbs{n+1,1}.Knots=curve.knots;
obj.Nurbs{n+1,1}.Order=curve.order;
obj.Nurbs{n+1,1}.Dim=curve.dim;
if isempty(opt.seg)
    obj.Subd{n+1,1}=np(2)*8;
else
    obj.Subd{n+1,1}=opt.seg;
end
obj.MP(n+1,:)=mean(coefs'); %#ok<UDIM> 

end


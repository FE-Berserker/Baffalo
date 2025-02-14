function obj = NurbRuled(obj,Points,crv1,crv2,varargin)
% Nurb ruled
p=inputParser;
addParameter(p,'subd',[]);
parse(p,varargin{:});
opt=p.Results;

coefs=Points.Nurbs{crv1,1}.Coefs;
knots=Points.Nurbs{crv1,1}.Knots;
curve1=nrbmak(coefs,knots);

coefs=Points.Nurbs{crv2,1}.Coefs;
knots=Points.Nurbs{crv2,1}.Knots;
curve2=nrbmak(coefs,knots);

if isempty(opt.subd)
    opt.subd=[4*size(coefs,2),10]; 
end
subd = opt.subd+1; 

srf = nrbruled(curve1,curve2); 

% plot a NURBS surface
p = nrbeval(srf,{linspace(0.0,1.0,subd(1)) linspace(0.0,1.0,subd(2))});

m=Mesh2D('Temp');
m=MeshQuadPlate(m,[1,1],[opt.subd(2),opt.subd(1)]);

x=p(1,:,:);
y=p(2,:,:);
z=p(3,:,:);

xx=reshape(x,[],1);
yy=reshape(y,[],1);
zz=reshape(z,[],1);

obj.Face=m.Face;
obj.Vert=[xx,yy,zz];

end


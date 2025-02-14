function obj = NurbSurf(obj,pnts,knots,varargin)
% Nurb surface
p=inputParser;
addParameter(p,'subd',[]);
parse(p,varargin{:});
opt=p.Results;

srf = nrbmak(pnts,knots);

if isempty(opt.subd)
    [~,n1,n2]=size(pnts);
    subd(1)=n1*2+1;
    subd(2)=n2*2+1;
else
    subd=opt.subd+1;
end
% plot a NURBS surface
p = nrbeval(srf,{linspace(0.0,1.0,subd(2)) linspace(0.0,1.0,subd(1))});

subd=subd-1;
m=Mesh2D('Temp');
m=MeshQuadPlate(m,[1,1],subd);

x=p(1,:,:);
y=p(2,:,:);
z=p(3,:,:);

xx=reshape(x,[],1);
yy=reshape(y,[],1);
zz=reshape(z,[],1);

obj.Face=m.Face;
obj.Vert=[xx,yy,zz];

end


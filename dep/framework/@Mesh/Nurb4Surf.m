function obj = Nurb4Surf(obj,Points,varargin)
% 4 points nurb surface
p=inputParser;
addParameter(p,'subd',[10,10]);
parse(p,varargin{:});
opt=p.Results;

srf = nrb4surf(Points(1,:),Points(2,:),Points(3,:),Points(4,:)); 
subd = opt.subd+1; 
% plot a NURBS surface
p = nrbeval(srf,{linspace(0.0,1.0,subd(2)) linspace(0.0,1.0,subd(1))});

m=Mesh2D('Temp');
m=MeshQuadPlate(m,[1,1],opt.subd);

x=p(1,:,:);
y=p(2,:,:);
z=p(3,:,:);

xx=reshape(x,[],1);
yy=reshape(y,[],1);
zz=reshape(z,[],1);

obj.Face=m.Face;
obj.Vert=[xx,yy,zz];

end


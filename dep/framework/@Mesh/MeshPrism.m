function obj = MeshPrism(obj,n,l,height,varargin)
% Mesh prism
% Author : Xie Yu

p=inputParser;
addParameter(p,'Meshsize',[]);
parse(p,varargin{:});
opt=p.Results;


r=l/2/sin(pi/n);
b=Line2D('Line Ass1','Echo',0);
b=AddPolygon(b,r,n,'sang',90,'close',1);

S=Surface2D(b,'Echo',0);

m=Mesh2D('Temp','Echo',0);
m=AddSurface(m,S);
if isempty(opt.Meshsize)
    m=SetSize(m,l/5);
    m=Mesh(m);
else
    m=SetSize(m,opt.Meshsize);
    m=Mesh(m);
end

obj=Extrude2Solid(obj,m,height,ceil(height/m.Size));

%% Print
if obj.Echo
    fprintf('Successfully mesh prism . \n');
end

end


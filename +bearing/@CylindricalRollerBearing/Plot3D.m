function obj=Plot3D(obj,varargin)
%Plot3D of bearing
% Author : Xie Yu

p=inputParser;
addParameter(p,'save',0);
parse(p,varargin{:});
opt=p.Results;

Radius=obj.input.Dw/2;
Height=obj.input.L;
mm=Mesh('Roller Bearing','Echo',0);
mm=MeshCylinder(mm,Radius/5,Radius,Height);

mm=Mesh3D(mm);
t = (0:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z)'...
    +obj.params.ROTX;
y=obj.input.Dpw/2.*cos(t);
z=obj.input.Dpw/2.*sin(t);

L=Layer('Roller Bearing View','Echo',0);
for i=1:obj.input.Z
    position=[obj.input.T/2,y(i),z(i),0,90,0];
    L=AddElement(L,mm,'Transform',position);
end
Num=size(obj.output.Surface.Meshes,1);
if Num>1
    for i=2:Num
        mesh=obj.output.Surface.Meshes{i,1};
        m=Mesh2D('Ring section','Echo',0);
        m.Vert=mesh.Vert(:,1:2);
        m.Face=mesh.Face;
        mm=Mesh('Ring','Echo',0);
        mm=Revolve2Solid(mm,m,'Slice',obj.input.Z*3);
        L=AddElement(L,mm);
    end
end

if opt.save
  Plot(L,'save',strcat(obj.params.Name,'_3D'));
else
  Plot(L);
end

end
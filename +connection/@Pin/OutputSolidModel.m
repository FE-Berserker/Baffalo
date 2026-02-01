function obj=OutputSolidModel(obj,varargin)
% Output SolidModel of Pin
% Author: Xie Yu
% p=inputParser;
% addParameter(p,'SubOutline',0);
% parse(p,varargin{:});
% opt=p.Results;

m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);
if isempty(obj.input.Meshsize)
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.input.Meshsize;
end

m=SetSize(m,Meshsize);
m=Mesh(m);
mm=Mesh('Mesh','Echo',0);

Marker=sort(obj.input.Marker);
Height=Marker+obj.input.Length/2;
Height=unique([0;Height;obj.input.Length]);
Delta=Height(2:end,:)-Height(1:end-1,:);
Slice=ceil(Delta./Meshsize);
mm=Extrude2Solid(mm,m,obj.input.Length,sum(Slice));
NumNode=size(m.Meshoutput.nodes,1);
Temp=Delta./Slice;
H=0;
Acc=0;
for i=1:size(Temp,1)
    TempH=(1:Slice(i,1)).*Temp(i,1)+Acc;
    H=[H,TempH];
    Acc=H(end);
end

H=repmat(H,NumNode,1);
mm.Vert(:,3)=reshape(H,[],1);
mm.Meshoutput.nodes=mm.Vert;

if obj.params.Order==2
    mm = Convert2Order2(mm);
end
mm.Vert(:,3)=mm.Vert(:,3)-obj.input.Length/2;
mm.Meshoutput.nodes(:,3)=mm.Meshoutput.nodes(:,3)-obj.input.Length/2;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

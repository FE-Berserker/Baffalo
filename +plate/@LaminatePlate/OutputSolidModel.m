function obj=OutputSolidModel(obj)
% Output SolidModel of common plate
% Author: Xie Yu

Tply=obj.input.Tply;

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
mm=Extrude2Solid(mm,m,Tply,0);

% Cb calculation
Face=mm.Face;
Cb=mm.Cb;
Vm=PatchCenter(mm);
Temp_Face=Face(Cb==1,:);
Temp_Vm=Vm(Cb==1,:);
% Check repeat nodes
Temp_dev=Temp_Face(:,1)-Temp_Face(:,2);
Temp_Vm1=Temp_Vm(Temp_dev~=0,:);

% Calculate 
dist=NaN(size(Temp_Vm1,1),size(obj.output.Surface.Node,1));
for i=1:size(obj.output.Surface.Node,1)
    PP1=obj.output.Surface.Node{i,1};
    PP2=[PP1(2:end,:);PP1(1,:)];
    k1=Temp_Vm1(:,1)*PP1(:,2)';
    k2=PP1(:,1).*PP2(:,2);
    k2=repmat(k2',size(Temp_Vm1,1),1);
    k3=Temp_Vm1(:,2)*PP2(:,1)';
    k4=Temp_Vm1(:,1)*PP2(:,2)';
    k5=Temp_Vm1(:,2)*PP1(:,1)';
    k6=PP1(:,2).*PP2(:,1);
    k6=repmat(k6',size(Temp_Vm1,1),1);
    k=min(abs(k1+k2+k3-k4-k5-k6),[],2);
    dist(:,i)=k;
end

mindist=min(dist,[],2);
Temp=dist-repmat(mindist,1,size(obj.output.Surface.Node,1));
[row,col]=find(Temp==0);
if size(col,1)~=size(Temp,1)
    dist=NaN(size(Temp_Vm1,1),size(obj.output.Surface.Node,1));
    for i=1:size(obj.output.Surface.Node,1)
        P=obj.output.Surface.Node{i,1};
        [~,dist(:,i)] = dsearchn(P,Temp_Vm1(:,1:2));
    end
    mindist=min(dist,[],2);
    Temp=dist-repmat(mindist,1,size(obj.output.Surface.Node,1));
    [row,col]=find(Temp==0);
end

[~,I]=sort(row);
col=col(I,:);
Temp_Cb=Cb(Cb==1,:);
Temp_Cb(Temp_dev~=0,:)=col+100;
Cb(Cb==1,:)=Temp_Cb;


if obj.params.Order==2
    mm = Convert2Order2(mm);
end

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end

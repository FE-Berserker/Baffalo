function obj=OutputShellModel(obj,varargin)
% Output ShellModel of common plate
% Author: Xie Yu
p=inputParser;
addParameter(p,'SubOutline',0);
parse(p,varargin{:});
opt=p.Results;

m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);
if isempty(obj.input.Meshsize)
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.input.Meshsize;
end

m=SetSize(m,Meshsize);
m=Mesh(m);

% Cb calculation
Vm = PatchBoundaryCentre(m);
Cb=m.Meshoutput.boundaryMarker;
Temp_Vm=Vm(Cb==1,:);

% Calculate 
dist=NaN(size(Temp_Vm,1),size(obj.output.Surface.Node,1));
for i=1:size(obj.output.Surface.Node,1)
    PP1=obj.output.Surface.Node{i,1};
    PP2=[PP1(2:end,:);PP1(1,:)];
    k1=Temp_Vm(:,1)*PP1(:,2)';
    k2=PP1(:,1).*PP2(:,2);
    k2=repmat(k2',size(Temp_Vm,1),1);
    k3=Temp_Vm(:,2)*PP2(:,1)';
    k4=Temp_Vm(:,1)*PP2(:,2)';
    k5=Temp_Vm(:,2)*PP1(:,1)';
    k6=PP1(:,2).*PP2(:,1);
    k6=repmat(k6',size(Temp_Vm,1),1);
    k=min(abs(k1+k2+k3-k4-k5-k6),[],2);
    dist(:,i)=k;
end

mindist=min(dist,[],2);
Temp=dist-repmat(mindist,1,size(obj.output.Surface.Node,1));
[row,col]=find(Temp==0);
if size(col,1)~=size(Temp,1)
    dist=NaN(size(Temp_Vm,1),size(obj.output.Surface.Node,1));
    for i=1:size(obj.output.Surface.Node,1)
        P=obj.output.Surface.Node{i,1};
        [~,dist(:,i)] = dsearchn(P,Temp_Vm(:,1:2));
    end
    mindist=min(dist,[],2);
    Temp=dist-repmat(mindist,1,size(obj.output.Surface.Node,1));
    [row,col]=find(Temp==0);
end

[~,I]=sort(row);
col=col(I,:);
Temp_Cb=col+100;
Cb(Cb==1,:)=Temp_Cb;
% Outline
if opt.SubOutline==1
    line=obj.input.Outline.Point.PP;
    Temp_Vm=Vm(Cb==101,:);
    Cb_Outline=FindOutlineDistance(Temp_Vm,line);
    Cb(Cb==101,:)=Cb_Outline;
end

if obj.params.Order==2
    m = Convert2Order2(m);
end

m.Meshoutput.boundaryMarker=Cb;
obj.output.ShellMesh=m;

%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh .\n');
end
end

function Cb=FindOutlineDistance(Vm,line)
Cb=NaN(size(Vm,1),1);
for i=1:size(Vm,1)
    V=Vm(i,:);
    Temp=cellfun(@(x)sort(sqrt((x(:,1)-V(1,1)).^2+(x(:,2)-V(1,2)).^2)),line,'UniformOutput',false);
    Temp=cellfun(@(x)x(2,1),Temp,'UniformOutput',false);
    Temp=cell2mat(Temp);
    [row,~]=find(Temp==min(Temp));
    Cb(i,1)=200+row(1,1);
end
end
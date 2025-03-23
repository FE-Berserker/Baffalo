function obj=OutputSolidModel(obj,varargin)
% Output SolidModel
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
mm=Mesh(obj.params.Name,'Echo',0);
if obj.params.Axis=='x'
    mm=Revolve2Solid(mm,m,'Type',1,'Slice',obj.params.N_Slice,'Degree',obj.params.Degree);
elseif obj.params.Axis=='y'
    mm=Revolve2Solid(mm,m,'Type',2,'Slice',obj.params.N_Slice,'Degree',obj.params.Degree);
end

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);
if obj.params.Degree~=360
    % base face
    switch obj.params.Axis
        case 'x'
            Temp_Vm=Vm(Vm(:,3)==0,:);
            Temp_Cb=Cb(Vm(:,3)==0,:);
            if obj.input.Outline.Point.P(1,2)>0
                Temp_Cb(Temp_Vm(:,2)>0,:)=11;
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,2)<0,:)=12;
                end
            else
                Temp_Cb(Temp_Vm(:,2)<0,:)=11;
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,2)>0,:)=12;
                end
            end
        case 'y'
            Temp_Vm=Vm(Vm(:,3)==0,:);
            Temp_Cb=Cb(Vm(:,3)==0,:);
            if obj.input.Outline.Point.P(1,1)>0
                Temp_Cb(Temp_Vm(:,1)>0,:)=11;
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,1)<0,:)=12;
                end
            else
                Temp_Cb(Temp_Vm(:,1)<0,:)=11;
                if obj.params.Degree==180
                    Temp_Cb(Temp_Vm(:,1)>0,:)=12;
                end
            end
    end
    Cb(Vm(:,3)==0,:)=Temp_Cb;
end

Temp_Vm=Vm(and(Cb~=11,Cb~=12),:);
% Temp_Cb=Cb(and(Cb~=11,Cb~=12),:);
switch obj.params.Axis
    case 'x'
        Temp_R=sqrt(Temp_Vm(:,2).^2+Temp_Vm(:,3).^2)...
            ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
        Temp_Vm=[Temp_Vm(:,1),Temp_R];
    case 'y'
        Temp_R=sqrt(Temp_Vm(:,1).^2+Temp_Vm(:,2).^2)...
            ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
        Temp_Vm=[Temp_R,Temp_Vm(:,2)];
end


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
[~,I]=sort(row);
col=col(I,:);
Temp_Cb=col+100;
Cb(and(Cb~=11,Cb~=12),:)=Temp_Cb;

% Outline
if opt.SubOutline==1
    line=obj.input.Outline.Point.PP;
    Temp_Vm=Vm(Cb==101,:);
    switch obj.params.Axis
        case 'x'
            Temp_R=sqrt(Temp_Vm(:,2).^2+Temp_Vm(:,3).^2)...
                ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
            Temp_Vm=[Temp_Vm(:,1),Temp_R];
        case 'y'
            Temp_R=sqrt(Temp_Vm(:,1).^2+Temp_Vm(:,3).^2)...
                ./cos(obj.params.Degree/obj.params.N_Slice/180*pi/2);
            Temp_Vm=[Temp_R,Temp_Vm(:,2)];
    end
    Cb_Outline=FindOutlineDistance(Temp_Vm,line);
    Cb(Cb==101,:)=Cb_Outline;
end

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end

function Cb=FindOutlineDistance(Vm,line)
Cb=NaN(size(Vm,1),1);
for i=1:size(Vm,1)
    V=Vm(i,:);
    Temp=cellfun(@(x)sort(sqrt((x(:,1)-V(1,1)).^2+(x(:,2)-V(1,2)).^2)),line,'UniformOutput',false);
    Temp=cellfun(@(x)min(x),Temp,'UniformOutput',false);
    Temp=cell2mat(Temp);
    [row,~]=find(Temp==min(Temp));
    Cb(i,1)=200+row(1,1);
end
end
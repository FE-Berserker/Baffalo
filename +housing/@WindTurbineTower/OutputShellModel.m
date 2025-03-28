function obj=OutputShellModel(obj,varargin)
% Output ShellModel of WindturbineTower
% Author: Xie Yu
% p=inputParser;
% addParameter(p,'SubOutline',0);
% parse(p,varargin{:});
% opt=p.Results;

Height=tril(ones(size(obj.input.Length,1)))*obj.input.Length;
Height=[0;Height];
Radius=[obj.input.Diameter(:,1)/2;obj.input.Diameter(end,2)/2];
Slice=round(obj.params.N_Slice/(360/obj.params.Degree));

if isempty(obj.input.Meshsize)
    Meshsize=2*pi*mean(Radius)/obj.params.N_Slice;
else
    Meshsize=obj.input.Meshsize;
end

a=Point2D('Temp','Echo',0);
b=Line2D('Temp','Echo',0);
 Height_Slice=zeros(size(obj.input.Diameter,1),1);
for i=1:size(obj.input.Diameter,1)
    R1=Radius(i,1);
    R2=Radius(i+1,1);
    H1=Height(i,1);
    H2=Height(i+1,1);
    dis=sqrt((R2-R1)^2+(H1-H2)^2);
    Temp_Slice=round(dis/Meshsize);
    if R1~=R2
    a=AddPoint(a,(R1:(R2-R1)/Temp_Slice:R2)',(H1:(H2-H1)/Temp_Slice:H2)');
    else
        a=AddPoint(a,repmat(R1,Temp_Slice+1,1),(H1:(H2-H1)/Temp_Slice:H2)');
    end
    b=AddCurve(b,a,i);
    Height_Slice(i,1)=Temp_Slice;
end
Total=sum(Height_Slice);
% Calculate Matrix
pre=0;
FaceCb=[];
for i=1:size(obj.input.Diameter,1)
    Temp1=pre+1:pre+Height_Slice(i,1);
    Temp1=repmat(Temp1',1,Slice);
    Temp2=0:Slice-1;
    Temp2=Temp2*Total;
    Temp2=repmat(Temp2,Height_Slice(i,1),1);
    Matrix{i,1}=reshape(Temp1+Temp2,[],1); %#ok<AGROW>
    pre=pre+Height_Slice(i,1);
    FaceCb=[FaceCb;repmat(i,Height_Slice(i,1),1)]; %#ok<AGROW>
end

m=Mesh(obj.params.Name,'Echo',0);
m=Rot2Shell(m,b,'Type',2,...
    'Degree',obj.params.Degree,...
    'Slice',Slice);
% Cb calculation
Vm = PatchCenter(m);
EdgeCb=m.Meshoutput.boundaryMarker;
EdgeCb(Vm(:,2)==0,:)=101;
EdgeCb(Vm(:,2)==sum(obj.input.Length),:)=102;
m.Meshoutput.boundaryMarker=EdgeCb;

m.Cb=repmat(FaceCb,Slice,1);
% Order
if obj.params.Order==2
    m = Convert2Order2(m);
end
%% Parse
obj.output.Matrix=Matrix;
obj.output.ShellMesh=m;
%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh .\n');
end

end
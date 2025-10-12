function obj=OutputSolidModel(obj)
% Output SolidModel
% Author: Xie Yu

Rref=max(obj.input.Outline.Point.P(:,2));
r=obj.input.r;
EdgeNum=obj.input.EdgeNum;
Ang=360/EdgeNum/2;

b=Line2D('Round Polygon','Echo',0);
b=AddRoundPolygon(b,Rref/cos(Ang/180*pi),EdgeNum,r);

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

Point=b.Point.P;
NumSeg=size(Point,1);

rr=sqrt(Point(:,1).^2+Point(:,2).^2);

Angle = calculateAngle(Point(1:NumSeg/EdgeNum,:),zeros(NumSeg/EdgeNum,2),Point(2:NumSeg/EdgeNum+1,:));

% Check Angle
SumAng=sum(Angle);
Delta=(360/EdgeNum-SumAng)/(NumSeg/EdgeNum);
Slice=obj.params.Slice;
Angle=Angle+Delta;
TempAng=(Angle(1,1)+Angle(2,1))/Slice;
FixAngle=sum(Angle(3:end,:))/2;
Angle=[repmat(TempAng,Slice,1);Angle(3:end,:)];

Num1=size(Angle,1);
Gap=repmat(Angle,EdgeNum,1);
mm=Revolve2Solid(mm,m,'Type',1,'Gap',Gap,'Degree',360);


Ratio=ones(Num1,1);
acc=-sum(TempAng)*Slice/2;
for i=1:Num1
    if i<=Slice
        acc=acc+Angle(i,1);
        Ratio(i,1)=1/cos(acc/180*pi);
    else
        acc=acc+Angle(i,1);
        Ratio(i,1)=rr(i-Slice+3,1)/Rref;
    end
end

NumNode=size(m.Vert,1);

for i=1:size(Gap,1)
    j=mod(i,Num1);
    if j==1
        Rat=Ratio(end,1);
    elseif j==0
        Rat=Ratio(end-1,1);
    else
        Rat=Ratio(j-1,1);
    end
    Start=(i-1)*NumNode+1;
    RRat=Rat;
    mm.Vert(Start:Start+NumNode-1,2)=mm.Vert(Start:Start+NumNode-1,2).*RRat;
    mm.Vert(Start:Start+NumNode-1,3)=mm.Vert(Start:Start+NumNode-1,3).*RRat;
end

T=Transform(mm.Vert);
T=Rotate(T,FixAngle,0,0);
P2=Solve(T);

mm.Vert=P2;
mm.Meshoutput.nodes=mm.Vert;


% Cb calculation
Cb=mm.Cb;
N = GetFaceNormal(mm);
Vm=PatchCenter(mm);
Vec=Vm+N;
len1=Vm(:,2).^2+Vm(:,3).^2;
len2=Vec(:,2).^2+Vec(:,3).^2;

Cb(and(abs(N(:,1))<=1e-5,len1<len2),:)=4;

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
obj.output.SolidMesh=mm;
obj.output.ShellMesh=m;

%% Print
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end

function angle = calculateAngle(A, B, C) 
    % 计算向量BA和BC
    BA = A - B;
    BC = C - B;
    
    % 计算点积
    dotProduct = dot(BA, BC,2);
    
    % 计算向量的模
    normBA = vecnorm(BA')';
    normBC = vecnorm(BC')';
        
    % 计算夹角的余弦值
    cosTheta = dotProduct ./ (normBA .* normBC);
    
    % 确保余弦值在[-1, 1]范围内（由于浮点误差可能超出）
    cosTheta = max(min(cosTheta, 1), -1);
    
    % 计算弧度并转换为角度
    angle = rad2deg(acos(cosTheta));
end


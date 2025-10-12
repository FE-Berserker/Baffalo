function obj=OutputSolidModel(obj)
% Output SolidModel
% Author: Xie Yu

Divider1=obj.output.Divider1;
Divider2=obj.output.Divider2;
ToothType=obj.params.ToothType;
SlotType=obj.params.SlotType;

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

y0=Divider1(:,2);
numy0=round((y0(1,1)-y0(2,1))/Meshsize)*2;
stepy0=(y0(2,1)-y0(1,1))/abs(numy0);

y1=Divider2(:,2);
numy1=round((y1(1,1)-y1(2,1))/Meshsize)*2;
stepy1=(y1(2,1)-y1(1,1))/abs(numy1);

% Build Cnode
yy0=y0(1,1):stepy0:y0(2,1);
xx0=ones(abs(numy0)+1,1)*obj.input.SlotPos(1);
Cnode0=[xx0,yy0'];
m=AddCNode(m,Cnode0);

Cedge0=[(1:abs(numy0))',(2:abs(numy0)+1)'];
m=AddCEdge(m,Cedge0);

yy1=y1(1,1):stepy1:y1(2,1);
xx1=ones(abs(numy1)+1,1)*obj.input.SlotPos(2);
Cnode1=[xx1,yy1'];
m=AddCNode(m,Cnode1);

Cedge1=[(1:abs(numy1))'+abs(numy0)+1,(2:abs(numy1)+1)'+abs(numy0)+1];
m=AddCEdge(m,Cedge1);

m=Mesh(m);
mm=Mesh(obj.params.Name,'Echo',0);

Point=b.Point.P;
NumSeg=size(Point,1);

rr=sqrt(Point(:,1).^2+Point(:,2).^2);

Angle = calculateAngle(Point(1:NumSeg/EdgeNum,:),zeros(NumSeg/EdgeNum,2),Point(2:NumSeg/EdgeNum+1,:));

% Check Angle
SumAng=sum(Angle);
Delta=(360/EdgeNum-SumAng)/(NumSeg/EdgeNum);
Angle=Angle+Delta;
SlotSlice=obj.params.SlotSlice;
Slice=SlotSlice+ceil(SlotSlice/2)*2;

Width=obj.input.SlotWidth;
dd=Width/SlotSlice;

Rf=max(obj.output.Divider1(:,2));
AA=SlotAngle(SlotSlice,Rf,dd);


TempAng=(Angle(1,1)+Angle(2,1)-sum(AA))/ceil(SlotSlice/2)/2;
FixAngle=sum(Angle(3:end,:))/2;
Num2=size(Angle(3:end,:),1);% Radius number
acc=-Angle(1,1);
Angle=[repmat(TempAng,ceil(SlotSlice/2),1);AA;repmat(TempAng,ceil(SlotSlice/2),1);Angle(3:end,:)];

Num1=size(Angle,1);

Gap=repmat(Angle,EdgeNum,1);
mm=Revolve2Solid(mm,m,'Type',1,'Gap',Gap,'Degree',360);


Ratio=ones(Num1,1);

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

SlotNum=obj.input.EdgeNum;
mm.Meshoutput.nodes=mm.Vert;

% Reflect node
Bot=obj.params.LeftLimit;
Top=obj.params.RightLimit;
SlotPos=obj.input.SlotPos;


if and(ToothType==1,SlotType==2)
    Node=m.Meshoutput.nodes;
    rr=Node(:,2);


    ix=0;
    ileft=1-size(rr,1);
    iright=0;

    GrooveRadius1=Width/2;

    for i=1:size(Gap,1)
        ix=ix+1;
        if ix>Num1
            ix=1;
        end

        ileft=ileft+size(rr,1);
        iright=iright+size(rr,1);

        if and(ix>Num2+1,ix<Num2+SlotSlice+1)
            DD=GrooveRadius1/Rf.*rr*sin((ix-Num2-1)/SlotSlice*pi);
            mm.Vert(ileft:iright,1)=(mm.Vert(ileft:iright,1)-DD.*(mm.Vert(ileft:iright,1)-Bot)./(SlotPos(1)-Bot)).*(and(mm.Vert(ileft:iright,1)>Bot,mm.Vert(ileft:iright,1)<(Bot+Top)/2))+...
                mm.Vert(ileft:iright,1).*(mm.Vert(ileft:iright,1)<=Bot)+...
                mm.Vert(ileft:iright,1).*(mm.Vert(ileft:iright,1)>=Top)+...
                (mm.Vert(ileft:iright,1)+DD.*(Top-mm.Vert(ileft:iright,1))./(Top-SlotPos(2))).*(and(mm.Vert(ileft:iright,1)<Top,mm.Vert(ileft:iright,1)>=(Bot+Top)/2));
        end
    end
    mm.Meshoutput.nodes=mm.Vert;
end

if ToothType==2
    % RotPoint calculation
    acc=-Angle(end,1);
    RotPoint=zeros(SlotNum*size(Angle,1),3);
    for i=1:SlotNum
        for j=1:size(Angle,1)
            if j==1
                Rat=Ratio(end,1);   
                acc=acc+Angle(end,1);
            else
                Rat=Ratio(j-1,1);
                acc=acc+Angle(j-1,1);
            end

            
            
            RotPoint((i-1)*size(Angle,1)+j,2)=Rf*cos(acc/180*pi)*Rat;
            RotPoint((i-1)*size(Angle,1)+j,3)=Rf*sin(acc/180*pi)*Rat;
        end
    end
    
    % RotAngle calculation
    RotAng=ModifyAngle(SlotSlice,Rf,dd);
    RRatio=cos(RotAng/180*pi);
    TempDelta=RotAng(1,1)/(ceil(SlotSlice/2));
    TempRotAng=(1:ceil(SlotSlice/2)-1)*TempDelta;
    TempRRatio=cos(((ceil(SlotSlice/2)-1:-1:1)*Angle(1,1)+RotAng(1,1))/180*pi)./cos(((ceil(SlotSlice/2)-1:-1:1)*Angle(1,1)+RotAng(1,1)-TempRotAng)/180*pi);
    RotAng=[0;TempRotAng';RotAng;-flip(TempRotAng');zeros(Num2,1)];
    RRatio=[1;TempRRatio';RRatio;flip(TempRRatio');ones(Num2,1)];
    RotAng=repmat(RotAng,SlotNum,1);
    RRatio=repmat(RRatio,SlotNum,1);

    % Rotate face node
    Node=m.Meshoutput.nodes;
    rr=Node(:,2);
    ileft=1-size(rr,1);
    iright=0;
    for i=1:size(RotAng,1)

        ileft=ileft+size(rr,1);
        iright=iright+size(rr,1);

        T=Transform(mm.Vert(ileft:iright,:));
        T=Rotate(T,(RotAng(i,1)),0,0,'Ori',RotPoint(i,:));

        T=Scale(T,1,RRatio(i,1),RRatio(i,1),'Ori',RotPoint(i,:));
        P2=Solve(T);

        mm.Vert(ileft:iright,:)=P2;
    end

    ix=0;
    ileft=1-size(rr,1);
    iright=0;

    if SlotType==2
        GrooveRadius=Width/2;
    else
        GrooveRadius=0;
    end

    for i=1:size(Gap,1)
        ix=ix+1;

        if ix>Num1
            ix=1;
        end

        ileft=ileft+size(rr,1);
        iright=iright+size(rr,1);

        % mm.Vert(ileft:iright,2)=rr.*cos(Acc1/180*pi);
        % mm.Vert(ileft:iright,3)=rr.*sin(Acc1/180*pi);

        if and(ix>Num2+1,ix<Num2+SlotSlice+1)
            DD=sqrt(GrooveRadius^2-(GrooveRadius-(ix-Num2-1)*GrooveRadius*2/SlotSlice)^2);
            mm.Vert(ileft:iright,1)=(mm.Vert(ileft:iright,1)-DD.*(mm.Vert(ileft:iright,1)-Bot)./(SlotPos(1)-Bot)).*(and(mm.Vert(ileft:iright,1)>Bot,mm.Vert(ileft:iright,1)<(Bot+Top)/2))+...
                mm.Vert(ileft:iright,1).*(mm.Vert(ileft:iright,1)<=Bot)+...
                mm.Vert(ileft:iright,1).*(mm.Vert(ileft:iright,1)>=Top)+...
                (mm.Vert(ileft:iright,1)+DD.*(Top-mm.Vert(ileft:iright,1))./(Top-SlotPos(2))).*(and(mm.Vert(ileft:iright,1)<Top,mm.Vert(ileft:iright,1)>=(Bot+Top)/2));
        end

    end
    mm.Vert=real(mm.Vert);
    mm.Meshoutput.nodes=mm.Vert;
end

% Delete slot element
Node=m.Meshoutput.nodes;
col=find(and(Node(:,1)>Divider1(1,1),Node(:,1)<Divider2(1,1)));
ShellNum=size(Node,1);


delNum=(ceil(SlotSlice/2)+1:ceil(SlotSlice/2)+size(AA,1)-1)*ShellNum;
delNum=repmat(delNum,size(col,1),1);
delNum=reshape(delNum,[],1)+repmat(col,SlotSlice-1,1);


TempNum=0:SlotNum-1;
TempNum=repmat(TempNum,size(delNum,1),1)*ShellNum*(size(Angle,1));

delNum=repmat(delNum,SlotNum,1)+reshape(TempNum,[],1);


mm.Vert(delNum,1)=NaN;


mm=DelNullElement(mm);

% Cb calculation
Cb=mm.Cb;
N = GetFaceNormal(mm);
Vm=PatchCenter(mm);
Vec=Vm+N;
len1=Vm(:,2).^2+Vm(:,3).^2;
len2=Vec(:,2).^2+Vec(:,3).^2;

Cb(and(abs(N(:,1))<=1e-5,len1<len2),:)=4;
Cb(and(Vm(:,1)>Divider1(1,1),Vm(:,1)<Divider2(1,1)),:)=2;

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

% Fix Angle
T=Transform(mm.Vert);
T=Rotate(T,FixAngle,0,0);
P2=Solve(T);

mm.Vert=P2;
mm.Meshoutput.nodes=P2;

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

function AA=SlotAngle(SlotSlice,Rf,dd)
AA=0;
if mod(SlotSlice,2)==0
    for i=1:SlotSlice/2
        Tempd=dd*i;
        TempAA=atan(Tempd/Rf)/pi*180-sum(AA);
        AA=[AA;TempAA]; %#ok<AGROW>
    end
    AA=[flip(AA(2:end,1));AA(2:end,1)];
else
    Tempd=dd;
    TempAA=atan(Tempd/Rf)/pi*180;
    AA=TempAA/2;
    for i=2:(SlotSlice+1)/2
        Tempd=dd*i-dd/2;
        TempAA=atan(Tempd/Rf)/pi*180-sum(AA);
        AA=[AA;TempAA]; %#ok<AGROW>
    end
    AA=[flip(AA(2:end,1));AA(1,1)*2;AA(2:end,1)];
end
end

function RotAng=ModifyAngle(SlotSlice,Rf,dd)

RotAng=0;
if mod(SlotSlice,2)==0
    for i=1:SlotSlice/2
        Tempd=dd*i;
        TempAA=atan(Tempd/Rf)/pi*180+RotAng(end,1);
        RotAng=[RotAng;-TempAA+RotAng(end,1)]; %#ok<AGROW>
    end
    RotAng=[-flip(RotAng(2:end,1));RotAng(1:end,1)];
else
    Tempd=dd;
    TempAA=atan(Tempd/Rf)/pi*180;
    RotAng=-TempAA/2;
    for i=2:(SlotSlice+1)/2
        Tempd=dd*i-dd/2;
        TempAA=atan(Tempd/Rf)/pi*180+RotAng(end,1);
        RotAng=[RotAng;-TempAA+RotAng(end,1)]; %#ok<AGROW>
    end
    RotAng=[-flip(RotAng(1:end,1));RotAng(1:end,1)];
end
end


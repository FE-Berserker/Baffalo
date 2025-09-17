function obj=OutputSolidModel(obj)
% Output SolidModel
% Author: Xie Yu

Divider1=obj.output.Divider1;
Divider2=obj.output.Divider2;
SlotWidth=obj.input.SlotWidth;
SlotNum=obj.input.SlotNum;
SlotSlice=obj.params.SlotSlice;
ToothSlice=obj.params.ToothSlice;
SlotType=obj.params.SlotType;
ToothType=obj.params.ToothType;
SlotPos=obj.input.SlotPos;

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

Angle2=asin(SlotWidth/2/max(abs(Divider1(:,2))))*2/pi*180;
Angle1=360/SlotNum-Angle2;

SlotWidth1=abs(sin(Angle2/180*pi/2)*max(Divider2(:,2)))*2;

Angle=[repmat(Angle1/ToothSlice,ToothSlice,1);repmat(Angle2/SlotSlice,SlotSlice,1)];
Gap=repmat(Angle,SlotNum,1);

mm=Revolve2Solid(mm,m,'Type',1,'Gap',Gap,'Degree',360);

T=Transform(mm.Vert);
T=Rotate(T,-Angle1-Angle2/2,0,0);
P2=Solve(T);

mm.Vert=P2;

% Reflect node
Bot=obj.params.LeftLimit;
Top=obj.params.RightLimit;

if and(ToothType==1,SlotType==2)
    Node=m.Meshoutput.nodes;
    rr=Node(:,2);

    Ang2=asin(SlotWidth/2./rr)*2/pi*180;
    Ang1=360/SlotNum-Ang2;

    Ang1=Ang1/ToothSlice;
    Ang2=Ang2/SlotSlice;

    Acc1=-Ang1*ToothSlice-Ang2*SlotSlice/2-Ang1;
    ix=-1;
    ileft=1-size(rr,1);
    iright=0;

    GrooveRadius1=SlotWidth/2;
    rf=abs(max(abs(Divider1(:,2)))*cos(Angle2/2)); % reference radius


    for i=1:size(Gap,1)
        ix=ix+1;
        if ix<=ToothSlice
            Acc1=Acc1+Ang1;
        elseif ix<=ToothSlice+SlotSlice
            Acc1=Acc1+Ang2;
        else
            ix=1;
            Acc1=Acc1+Ang1;
        end

        ileft=ileft+size(rr,1);
        iright=iright+size(rr,1);

        if ix>ToothSlice
            DD=GrooveRadius1/rf.*rr*sin((ix-ToothSlice)/SlotSlice*pi);
            mm.Vert(ileft:iright,1)=(mm.Vert(ileft:iright,1)-DD.*(mm.Vert(ileft:iright,1)-Bot)./(SlotPos(1)-Bot)).*(and(mm.Vert(ileft:iright,1)>Bot,mm.Vert(ileft:iright,1)<(Bot+Top)/2))+...
                mm.Vert(ileft:iright,1).*(mm.Vert(ileft:iright,1)<=Bot)+...
                mm.Vert(ileft:iright,1).*(mm.Vert(ileft:iright,1)>=Top)+...
                (mm.Vert(ileft:iright,1)+DD.*(Top-mm.Vert(ileft:iright,1))./(Top-SlotPos(2))).*(and(mm.Vert(ileft:iright,1)<Top,mm.Vert(ileft:iright,1)>=(Bot+Top)/2));
        end
    end
    mm.Meshoutput.nodes=mm.Vert;


end


if ToothType==2
    Node=m.Meshoutput.nodes;
    rr=Node(:,2);

    Ang2=asin(SlotWidth/2./rr)*2/pi*180;
    Ang1=360/SlotNum-Ang2;

    Ang1=Ang1/ToothSlice;
    Ang2=Ang2/SlotSlice;

    Acc1=-Ang1*ToothSlice-Ang2*SlotSlice/2-Ang1;
    ix=-1;
    ileft=1-size(rr,1);
    iright=0;

    if SlotType==2
        GrooveRadius=SlotWidth/2;
    else
        GrooveRadius=0;
    end

    for i=1:size(Gap,1)
        ix=ix+1;
        if ix<=ToothSlice
            Acc1=Acc1+Ang1;
        elseif ix<=ToothSlice+SlotSlice
            Acc1=Acc1+Ang2;
        else
            ix=1;
            Acc1=Acc1+Ang1;
        end

        ileft=ileft+size(rr,1);
        iright=iright+size(rr,1);
        
        mm.Vert(ileft:iright,2)=rr.*cos(Acc1/180*pi);
        mm.Vert(ileft:iright,3)=rr.*sin(Acc1/180*pi);
        
        if ix>ToothSlice   
            DD=sqrt(GrooveRadius^2-(GrooveRadius-(ix-ToothSlice)*GrooveRadius*2/SlotSlice)^2);
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

delNum=(ToothSlice+1:ToothSlice+SlotSlice-1)*ShellNum;
delNum=repmat(delNum,size(col,1),1);
delNum=reshape(delNum,[],1)+repmat(col,SlotSlice-1,1);

TempNum=0:SlotNum-1;
TempNum=repmat(TempNum,size(delNum,1),1)*ShellNum*(ToothSlice+SlotSlice);

delNum=repmat(delNum,SlotNum,1)+reshape(TempNum,[],1);


mm.Vert(delNum,1)=NaN;


mm=DelNullElement(mm);

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);

Cb(and(Vm(:,1)>Divider1(1,1),Vm(:,1)<Divider2(1,1)),:)=2;

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

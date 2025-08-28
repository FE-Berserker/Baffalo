function obj=OutputSolidModel(obj)
% Output SolidModel
% Author: Xie Yu

Divider=obj.output.Divider;
ToothWidth=obj.input.ToothWidth;
ToothNum=obj.input.ToothNum;
SlotSlice=obj.params.SlotSlice;
ToothSlice=obj.params.ToothSlice;

m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);

if isempty(obj.input.Meshsize)
    Meshsize=sqrt((max(obj.output.Surface.N(:,1)))^2+(max(obj.output.Surface.N(:,2)))^2)/20;
else
    Meshsize=obj.input.Meshsize;
end

m=SetSize(m,Meshsize);

y0=Divider(:,2);
numy=round((y0(1,1)-y0(2,1))/Meshsize)*2;

stepy=(y0(2,1)-y0(1,1))/abs(numy);

% Build Cnode
yy=y0(1,1):stepy:y0(2,1);
xx=ones(abs(numy)+1,1)*obj.input.ToothPos;
Cnode=[xx,yy'];
m=AddCNode(m,Cnode);

Cedge=[(1:abs(numy))',(2:abs(numy)+1)'];
m=AddCEdge(m,Cedge);
m=Mesh(m);
mm=Mesh(obj.params.Name,'Echo',0);

Angle1=asin(ToothWidth/2/max(abs(Divider(:,2))))*2/pi*180;
Angle2=360/ToothNum-Angle1;
Angle=[repmat(Angle1/ToothSlice,ToothSlice,1);repmat(Angle2/SlotSlice,SlotSlice,1)];
Gap=repmat(Angle,ToothNum,1);

mm=Revolve2Solid(mm,m,'Type',1,'Gap',Gap,'Degree',360);

T=Transform(mm.Vert);
T=Rotate(T,-Angle1-Angle2/2,0,0);
P2=Solve(T);

mm.Vert=P2;

% Reflect node
ToothType=obj.params.ToothType;

if ToothType==2
    Node=m.Meshoutput.nodes;
    rr=Node(:,2);

    SlotWidth=max(abs(Divider(:,2)))*sin(Angle2/2)*2;

    Ang2=asin(SlotWidth/2./rr)*2/pi*180;
    Ang1=360/ToothNum-Ang2;

    Ang1=Ang1/ToothSlice;
    Ang2=Ang2/SlotSlice;

    % Acc=0;
    Acc1=-Ang1*ToothSlice-Ang2*SlotSlice/2-Ang1;
    ix=-1;
    ileft=1-size(rr,1);
    iright=0;
    for i=1:size(Gap,1)
        % Acc=Acc+Gap(i,1);
        ix=ix+1;
        if ix<=SlotSlice
            Acc1=Acc1+Ang1;
        elseif ix<=ToothSlice+SlotSlice
            Acc1=Acc1+Ang2;
        else
            ix=1;
            Acc1=Acc1+Ang1;
        end

        ileft=ileft+size(rr,1);
        iright=iright+size(rr,1);
        
        % ymodi=cos(Ang1/180*pi)/cos(Acc/180*pi);
        % zmodi=sin(Ang1/180*pi)/sin(Acc/180*pi);
        % mm.Vert(ileft:iright,2)=mm.Vert(ileft:iright,2).*ymodi;
        % mm.Vert(ileft:iright,3)=mm.Vert(ileft:iright,3).*zmodi;
        mm.Vert(ileft:iright,2)=rr.*cos(Acc1/180*pi);
        mm.Vert(ileft:iright,3)=rr.*sin(Acc1/180*pi);
      
    end
    mm.Meshoutput.nodes=mm.Vert;

end


% Delete slot element
Node=m.Meshoutput.nodes;
col=find(Node(:,1)>Divider(1,1));
ShellNum=size(Node,1);

delNum=(ToothSlice+1:ToothSlice+SlotSlice-1)*ShellNum;
delNum=repmat(delNum,size(col,1),1);
delNum=reshape(delNum,[],1)+repmat(col,SlotSlice-1,1);

TempNum=0:ToothNum-1;
TempNum=repmat(TempNum,size(delNum,1),1)*ShellNum*(ToothSlice+SlotSlice);

delNum=repmat(delNum,ToothNum,1)+reshape(TempNum,[],1);


mm.Vert(delNum,1)=NaN;


mm=DelNullElement(mm);

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);

Cb(Vm(:,1)>Divider(1,1),:)=2;

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

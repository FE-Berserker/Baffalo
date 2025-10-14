function obj=OutputSolidMesh(obj)
% Output SolidModel
% Author: Xie Yu

m=obj.output.ShellMesh;
TaperAngle=obj.params.TaperAngle;

mm=Mesh(obj.params.Name,'Echo',0);
mm=Revolve2Solid(mm,m,'Type',2,'Slice',obj.params.N_Slice);

StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;

Cb=CalculateCb(m,TaperAngle,StatorR,RotorR,Height,obj.params.N_Slice);

mm.Cb=Cb;

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

mm.Meshoutput.boundaryMarker=Cb;


% Parse
obj.output.ShellMesh=m;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end

function Cb=CalculateCb(m,TaperAngle,StatorR,RotorR,Height,N_Slice)

% Rotate angle
P1=[m.Vert,zeros(size(m.Vert,1),1)];
T=Transform(P1);
TempR1=max(StatorR(1),RotorR(1));
TempR2=min(StatorR(end),RotorR(end));
T=Rotate(T,0,0,-TaperAngle,'Ori',[(TempR1+TempR2)/2,(Height(1)+Height(end))/2,0]);
P2=Solve(T);
m.Vert=P2(:,1:2);
m.Meshoutput.nodes=P2;


mm=Mesh('Temp','Echo',0);
mm=Revolve2Solid(mm,m,'Type',2,'Slice',N_Slice);

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);
Rm=sqrt(Vm(:,1).^2+Vm(:,3).^2);

% Parse Cb

Cb(and(abs(Vm(:,2)-Height(1))<1e-5,and(Rm>StatorR(1),Rm<StatorR(2))),:)=11;
Cb(and(abs(Vm(:,2)-Height(end))<1e-5,and(Rm>StatorR(1),Rm<StatorR(2))),:)=12;
Cb(and(Rm<mean(StatorR),Cb<10),:)=13;
Cb(and(Rm>mean(StatorR),Cb<10),:)=14;

Cb(and(abs(Vm(:,2)-Height(1))<1e-5,and(Rm>RotorR(1),Rm<RotorR(2))),:)=21;
Cb(and(abs(Vm(:,2)-Height(end))<1e-5,and(Rm>RotorR(1),Rm<RotorR(2))),:)=22;
Cb(and(Rm<mean(RotorR),Cb<10),:)=23;
Cb(and(Rm>mean(RotorR),Cb<10),:)=24;

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;


end
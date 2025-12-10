function obj=OutputSolidMesh(obj)
% Output SolidModel
% Author: Xie Yu

m=obj.output.ShellMesh;
m1=obj.output.ShellMesh1;
m2=obj.output.ShellMesh2;
TaperAngle=obj.params.TaperAngle;

mm=Mesh(obj.params.Name,'Echo',0);
mm=Revolve2Solid(mm,m,'Type',2,'Slice',obj.params.N_Slice);

mm1=Mesh(strcat(obj.params.Name,'_Stator'),'Echo',0);
mm1=Revolve2Solid(mm1,m1,'Type',2,'Slice',obj.params.N_Slice);

mm2=Mesh(strcat(obj.params.Name,'_Rotor'),'Echo',0);
mm2=Revolve2Solid(mm2,m2,'Type',2,'Slice',obj.params.N_Slice);

StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;

[Cb,Cb1,Cb2]=CalculateCb(m,m1,m2,TaperAngle,StatorR,RotorR,Height,obj.params.N_Slice);

mm.Cb=Cb;
mm1.Cb=Cb1;
mm2.Cb=Cb2;

if obj.params.Order==2
    mm = Convert2Order2(mm);
    mm1 = Convert2Order2(mm1);
    mm2 = Convert2Order2(mm2);
end

mm.Meshoutput.boundaryMarker=Cb;
mm1.Meshoutput.boundaryMarker=Cb1;
mm2.Meshoutput.boundaryMarker=Cb2;
% Parse

obj.output.SolidMesh=mm;
obj.output.SolidMesh1=mm1;
obj.output.SolidMesh2=mm2;

%% Print
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end

function [Cb,Cb1,Cb2]=CalculateCb(m,m1,m2,TaperAngle,StatorR,RotorR,Height,N_Slice)

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
Cb(abs(Rm/cos(pi/N_Slice)-StatorR(1))<=1e-3,:)=13;
Cb(abs(Rm/cos(pi/N_Slice)-StatorR(2))<=0.1,:)=14;

Cb(and(abs(Vm(:,2)-Height(1))<1e-5,and(Rm>RotorR(1),Rm<RotorR(2))),:)=21;
Cb(and(abs(Vm(:,2)-Height(end))<1e-5,and(Rm>RotorR(1),Rm<RotorR(2))),:)=22;
Cb(abs(Rm/cos(pi/N_Slice)-RotorR(1))<=0.1,:)=23;
Cb(abs(Rm/cos(pi/N_Slice)-RotorR(2))<=0.1,:)=24;


% Rotate angle
P1=[m1.Vert,zeros(size(m1.Vert,1),1)];
T=Transform(P1);
TempR1=max(StatorR(1),RotorR(1));
TempR2=min(StatorR(end),RotorR(end));
T=Rotate(T,0,0,-TaperAngle,'Ori',[(TempR1+TempR2)/2,(Height(1)+Height(end))/2,0]);
P2=Solve(T);
m1.Vert=P2(:,1:2);
m1.Meshoutput.nodes=P2;


mm1=Mesh('Temp','Echo',0);
mm1=Revolve2Solid(mm1,m1,'Type',2,'Slice',N_Slice);

% Cb calculation
Cb1=mm1.Cb;
Vm=PatchCenter(mm1);
Rm=sqrt(Vm(:,1).^2+Vm(:,3).^2);

% Parse Cb

Cb1(and(abs(Vm(:,2)-Height(1))<1e-5,and(Rm>StatorR(1),Rm<StatorR(2))),:)=11;
Cb1(and(abs(Vm(:,2)-Height(end))<1e-5,and(Rm>StatorR(1),Rm<StatorR(2))),:)=12;
Cb1(and(Rm<mean(StatorR),Cb1<10),:)=13;
Cb1(and(Rm>mean(StatorR),Cb1<10),:)=14;

% Rotate angle
P1=[m2.Vert,zeros(size(m2.Vert,1),1)];
T=Transform(P1);
TempR1=max(StatorR(1),RotorR(1));
TempR2=min(StatorR(end),RotorR(end));
T=Rotate(T,0,0,-TaperAngle,'Ori',[(TempR1+TempR2)/2,(Height(1)+Height(end))/2,0]);
P2=Solve(T);
m2.Vert=P2(:,1:2);
m2.Meshoutput.nodes=P2;


mm2=Mesh('Temp','Echo',0);
mm2=Revolve2Solid(mm2,m2,'Type',2,'Slice',N_Slice);

% Cb calculation
Cb2=mm2.Cb;
Vm=PatchCenter(mm2);
Rm=sqrt(Vm(:,1).^2+Vm(:,3).^2);

% Parse Cb
Cb2(and(abs(Vm(:,2)-Height(1))<1e-5,and(Rm>RotorR(1),Rm<RotorR(2))),:)=21;
Cb2(and(abs(Vm(:,2)-Height(end))<1e-5,and(Rm>RotorR(1),Rm<RotorR(2))),:)=22;
Cb2(and(Rm<mean(RotorR),Cb2<10),:)=23;
Cb2(and(Rm>mean(RotorR),Cb2<10),:)=24;



end
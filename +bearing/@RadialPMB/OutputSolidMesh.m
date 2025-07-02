function obj=OutputSolidMesh(obj)
% Output SolidModel
% Author: Xie Yu

m=obj.output.ShellMesh;
mm=Mesh(obj.params.Name,'Echo',0);
mm=Revolve2Solid(mm,m,'Type',2,'Slice',obj.params.N_Slice);

% Cb calculation
Cb=mm.Cb;
Vm=PatchCenter(mm);
Rm=sqrt(Vm(:,1).^2+Vm(:,3).^2);

% Parse Cb
StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;

Cb(and(Vm(:,2)==Height(1),and(Rm>StatorR(1),Rm<StatorR(2))),:)=11;
Cb(and(Vm(:,2)==Height(end),and(Rm>StatorR(1),Rm<StatorR(2))),:)=12;
Cb(and(Rm<mean(StatorR),Cb<10),:)=13;
Cb(and(Rm>mean(StatorR),Cb<10),:)=14;

Cb(and(Vm(:,2)==Height(1),and(Rm>RotorR(1),Rm<RotorR(2))),:)=21;
Cb(and(Vm(:,2)==Height(end),and(Rm>RotorR(1),Rm<RotorR(2))),:)=22;
Cb(and(Rm<mean(RotorR),Cb<10),:)=23;
Cb(and(Rm>mean(RotorR),Cb<10),:)=24;

mm.Cb=Cb;

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

mm.Meshoutput.boundaryMarker=Cb;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end
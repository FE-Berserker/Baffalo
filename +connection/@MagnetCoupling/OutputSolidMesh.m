function obj=OutputSolidMesh(obj)
% Output SolidModel
% Author: Xie Yu
W=obj.input.Width;
Num=obj.params.WidthNum;

m=obj.output.ShellMesh;
mm1=Mesh(m{1,1}.Name,'Echo',0);
mm1=Extrude2Solid(mm1,m{1,1},W,Num);

mm2=Mesh(m{2,1}.Name,'Echo',0);
mm2=Extrude2Solid(mm2,m{2,1},W,Num);

mm3=Mesh(m{3,1}.Name,'Echo',0);
mm3=Extrude2Solid(mm3,m{3,1},W,Num);

mm4=Mesh(m{4,1}.Name,'Echo',0);
mm4=Extrude2Solid(mm4,m{4,1},W,Num);

% Cb calculation
Cb=mm3.Cb;
Vm=PatchCenter(mm3);
Rm=sqrt(Vm(:,1).^2+Vm(:,2).^2);

R1=obj.input.B/2-obj.input.InnerMagnetSize(2);

Cb(and(Rm<R1,Cb==1),:)=4;

mm3.Cb=Cb;
mm3.Meshoutput.boundaryMarker=Cb;

Cb=mm4.Cb;
Vm=PatchCenter(mm4);
Rm=sqrt(Vm(:,1).^2+Vm(:,2).^2);

Size2=obj.input.OuterMagnetSize;
R2=obj.input.C/2+obj.input.OuterMagnetSize(2);
Angle2=atan(Size2(1)/2/R2)*180/pi;
TempR2=R2/cos(Angle2/180*pi);

Cb(and(Rm>TempR2,Cb==1),:)=4;

mm4.Cb=Cb;
mm4.Meshoutput.boundaryMarker=Cb;


obj.output.SolidMesh{1,1}=mm1;
obj.output.SolidMesh{2,1}=mm2;
obj.output.SolidMesh{3,1}=mm3;
obj.output.SolidMesh{4,1}=mm4;

%% Print
if obj.params.Echo
    fprintf('Successfully Output Solid mesh .\n');
end
end
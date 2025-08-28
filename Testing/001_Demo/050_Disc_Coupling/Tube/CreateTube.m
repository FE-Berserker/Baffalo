clc
clear
close all
%% Parameter
load('..\Params.mat');
Dp1=Params.Flange1_Dp;
Dp2=Params.Flange2_Dp;
%% Main
inputTube.Length = [8;67.8;75.8];
inputTube.ID = [[32,32];[32,32];[32,32]];
inputTube.OD = [[81,81];[42,42];[81,81]];
paramsTube = struct();
Tube = shaft.Commonshaft(paramsTube, inputTube);
Tube = Tube.solve();
Plot2D(Tube);
Plot3D(Tube);

% Cb defination
mm=Tube.output.SolidMesh;
Vm=PatchCenter(mm);

Cb=mm.Cb;
Cb(and(and(Vm(:,1)==0,Vm(:,2)>0),Vm(:,3)>0),:)=1001;
Cb(and(and(Vm(:,1)==0,Vm(:,2)<0),Vm(:,3)>0),:)=1002;
Cb(and(and(Vm(:,1)==0,Vm(:,2)<0),Vm(:,3)<0),:)=1003;
Cb(and(and(Vm(:,1)==0,Vm(:,2)>0),Vm(:,3)<0),:)=1004;

Cb(and(and(Vm(:,1)==inputTube.Length(1,1),Vm(:,2)>0),Vm(:,3)>0),:)=1005;
Cb(and(and(Vm(:,1)==inputTube.Length(1,1),Vm(:,2)<0),Vm(:,3)>0),:)=1006;
Cb(and(and(Vm(:,1)==inputTube.Length(1,1),Vm(:,2)<0),Vm(:,3)<0),:)=1007;
Cb(and(and(Vm(:,1)==inputTube.Length(1,1),Vm(:,2)>0),Vm(:,3)<0),:)=1008;

Cb(and(and(Vm(:,1)==inputTube.Length(2,1),Vm(:,2)>0),Vm(:,3)>0),:)=1009;
Cb(and(and(Vm(:,1)==inputTube.Length(2,1),Vm(:,2)<0),Vm(:,3)>0),:)=1010;
Cb(and(and(Vm(:,1)==inputTube.Length(2,1),Vm(:,2)<0),Vm(:,3)<0),:)=1011;
Cb(and(and(Vm(:,1)==inputTube.Length(2,1),Vm(:,2)>0),Vm(:,3)<0),:)=1012;

Cb(and(and(Vm(:,1)==inputTube.Length(3,1),Vm(:,2)>0),Vm(:,3)>0),:)=1013;
Cb(and(and(Vm(:,1)==inputTube.Length(3,1),Vm(:,2)<0),Vm(:,3)>0),:)=1014;
Cb(and(and(Vm(:,1)==inputTube.Length(3,1),Vm(:,2)<0),Vm(:,3)<0),:)=1015;
Cb(and(and(Vm(:,1)==inputTube.Length(3,1),Vm(:,2)>0),Vm(:,3)<0),:)=1016;

mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;

% Drill through hole
Position=[Dp1/2*cos(pi/4),Dp1/2*sin(pi/4)];
mm=DrillThroughHole(mm,15/2,inputTube.Length(1,1),Position,[1001;1005],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4+pi/2),Dp1/2*sin(pi/4+pi/2)];
mm=DrillThroughHole(mm,8.1/2,inputTube.Length(1,1),Position,[1002;1006],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4+pi),Dp1/2*sin(pi/4+pi)];
mm=DrillThroughHole(mm,15/2,inputTube.Length(1,1),Position,[1003;1007],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4+pi/2*3),Dp1/2*sin(pi/4+pi/2*3)];
mm=DrillThroughHole(mm,8.1/2,inputTube.Length(1,1),Position,[1004;1008],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4),Dp1/2*sin(pi/4)];
mm=DrillThroughHole(mm,8.1/2,inputTube.Length(1,1),Position,[1013;1009],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4+pi/2),Dp1/2*sin(pi/4+pi/2)];
mm=DrillThroughHole(mm,15/2,inputTube.Length(1,1),Position,[1014;1010],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4+pi),Dp1/2*sin(pi/4+pi)];
mm=DrillThroughHole(mm,8.1/2,inputTube.Length(1,1),Position,[1015;1011],'type',1,'slice',16,'reverse',1);

Position=[Dp1/2*cos(pi/4+pi/2*3),Dp1/2*sin(pi/4+pi/2*3)];
mm=DrillThroughHole(mm,15/2,inputTube.Length(1,1),Position,[1016;1012],'type',1,'slice',16,'reverse',1);

mm=Mesh3D(mm);
Tube.output.SolidMesh=mm;
Tube=OutputAss(Tube);
Plot3D(Tube);

%% Parse
Params.Tube_Length=inputTube.Length(end,1);
Params.Tube_Assembly_X=(Params.Shaft1_Assembly_X+Params.Shaft2_Assembly_X)/2-Params.Tube_Length/2;
Params.Tube_Dp1=Dp1;
Params.Tube_Dp2=Dp2;
%% Save
save ..\Params Params
save Tube Tube

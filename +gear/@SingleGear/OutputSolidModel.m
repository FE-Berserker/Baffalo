function obj=OutputSolidModel(obj,varargin)
% Output SolidModel of SingleGear
% Author: Xie Yu
b=obj.input.b;
Layer=obj.params.NWidth;
Lsize=obj.params.Lsize2;
rf=obj.output.df/2;
ra=obj.output.da/2;
Z=obj.input.Z;
P=obj.output.GearCurve.Point.PP;
b=obj.input.b;

m=OutputShellModel(obj,Lsize);
mm=Mesh(obj.params.Name,'Echo',0);
mm=Extrude2Solid(mm,m,b,Layer);


if obj.input.beta~=0
    beta=obj.input.beta;
    Num1=size(m.Vert,1);
    switch obj.params.Helix
        case 'Left'
            for i=1:Layer
                Matrix=[cos(beta/Layer*i/180*pi),sin(beta/Layer*i/180*pi);-sin(beta/Layer*i/180*pi),cos(beta/Layer*i/180*pi)];
                mm.Vert(Num1*i+1:Num1*(i+1),1:2)=(Matrix* mm.Vert(Num1*i+1:Num1*(i+1),1:2)')';
            end

        case 'Right'
            for i=1:Layer
                Matrix=[cos(-beta/Layer*i/180*pi),sin(-beta/Layer*i/180*pi);-sin(-beta/Layer*i/180*pi),cos(-beta/Layer*i/180*pi)];
                mm.Vert(Num1*i+1:Num1*(i+1),1:2)=(Matrix* mm.Vert(Num1*i+1:Num1*(i+1),1:2)')';
            end
    end
    mm.Meshoutput.nodes=mm.Vert;
end

% Cb calculation
Vm=PatchCenter(mm);
Cb=mm.Cb;
TempCb=Cb(Cb==1,:);
TempVm=Vm(Cb==1,:);
R=sqrt(TempVm(:,1).^2+TempVm(:,2).^2);
Ang=(2*pi-asin(TempVm(:,2)./R)).*(and(TempVm(:,1)>=0,TempVm(:,2)>=0))...
    -asin(TempVm(:,2)./R).*(and(TempVm(:,1)>=0,TempVm(:,2)<0))...
    +(pi+asin(TempVm(:,2)./R)).*(and(TempVm(:,1)<0,TempVm(:,2)<0))...
    +(pi+asin(TempVm(:,2)./R)).*(and(TempVm(:,1)<0,TempVm(:,2)>=0));

R2=sqrt((P{3,1}(1,1)+rf*cos(pi/Z))^2+P{3,1}(1,2)^2);
Ang1=atan(P{3,1}(end,2)/(P{3,1}(end,1)+rf*cos(pi/Z)));

if obj.input.beta~=0
    switch obj.params.Helix
        case 'Left'
            Gap=beta/180*pi/Layer;
        case 'Right'
            Gap=-beta/180*pi/Layer;
    end
else
    Gap=0;
end

for i=1:Layer
    TCb=TempCb(and(TempVm(:,3)>b/Layer*(i-1),TempVm(:,3)<b/Layer*i),:);
    TR=R(and(TempVm(:,3)>b/Layer*(i-1),TempVm(:,3)<b/Layer*i),:);
    TAng=Ang(and(TempVm(:,3)>b/Layer*(i-1),TempVm(:,3)<b/Layer*i),:);
    TAng=TAng+pi/Z-Gap/2-Gap*(i-1);
    TAng(TAng>=2*pi,:)=TAng(TAng>=2*pi,:)-2*pi;

    for j=1:obj.params.MeshNTooth
        TCb(and(and(TR>R2,TR<ra),and(TAng>(j-1)*2*pi/Z,TAng<(pi/Z-Ang1+(j-1)*2*pi/Z))),:)=101+(j-1)*5;
        TCb(and(and(TR<=R2,TR>=rf*0.9),and(TAng>(j-1)*2*pi/Z,TAng<(pi/Z+(j-1)*2*pi/Z))),:)=102+(j-1)*5j;
        TCb(and(and(TR>R2,TR<ra),and(TAng<2*pi/Z+(j-1)*2*pi/Z,TAng>(pi/Z+Ang1+(j-1)*2*pi/Z))),:)=103+(j-1)*5;
        TCb(and(and(TR<=R2,TR>=rf*0.9),and(TAng<2*pi/Z+(j-1)*2*pi/Z,TAng>(pi/Z+(j-1)*2*pi/Z))),:)=104+(j-1)*5;
        TCb(and(TR>R2,and(TAng>(pi/Z-Ang1+(j-1)*2*pi/Z),TAng<(pi/Z+Ang1+(j-1)*2*pi/Z))),:)=105+(j-1)*5;
    end

    if obj.params.MeshNTooth<Z
        TCb(abs(TAng-min(TAng))<1e-5,:)=11;
        TCb(abs(TAng-max(TAng))<1e-5,:)=12;
    end

    TempCb(and(TempVm(:,3)>b/Layer*(i-1),TempVm(:,3)<b/Layer*i),:)=TCb;
end


delta=obj.input.b/obj.params.NMaster;
TempCb(real(TempCb)==1,:)=1001;
if obj.params.NMaster>1
    for i=2:obj.params.NMaster
        TempCb(and(real(TempCb)==999+i,TempVm(:,3)>=delta*(i-1)),:)=1000+i;
    end
end
if obj.params.Order==2
    mm = Convert2Order2(mm);
end

Cb(Cb==1,:)=real(TempCb);
mm.Cb=Cb;
mm.Meshoutput.boundaryMarker=Cb;
mm.Vert(:,3)=mm.Vert(:,3)-b/2;
mm.Meshoutput.nodes(:,3)=mm.Meshoutput.nodes(:,3)-b/2;
obj.output.SolidMesh=mm;

%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh .\n');
end
end
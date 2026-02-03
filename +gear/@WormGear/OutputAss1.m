function obj = OutputAss1(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
gamma=obj.output.gamma;
a=obj.input.a;
d1=obj.output.d1;
d2=obj.output.d2-1;
ID1=obj.input.ID1;
ID2=obj.input.ID2;
b1=obj.input.b1;
b2H=obj.input.b2H;
Z2=obj.input.Z2;
alphan=obj.input.alphan;
Helix=obj.params.Helix;

% Build Worm
inputshaft1.Length = b1;
inputshaft1.ID = [ID1,ID1];
inputshaft1.OD = [d1,d1];
paramsshaft1.Echo = 0;
paramsshaft1.Material=obj.params.Material{1,1};
Worm = shaft.Commonshaft(paramsshaft1, inputshaft1);
Worm = Worm.solve();

% Build wheel
inputshaft2.Length = b2H;
inputshaft2.ID = [ID2,ID2];
inputshaft2.OD = [d2,d2];
inputshaft2.Meshsize=(d2-ID2)/6;
paramsshaft2.Echo = 0;
paramsshaft2.E_Revolve=Z2*4;
paramsshaft2.Material=obj.params.Material{2,1};
Wheel = shaft.Commonshaft(paramsshaft2, inputshaft2);
Wheel = Wheel.solve();


Ass=Assembly(obj.params.Name,'Echo',0);
% Ass wormgear
position=[-b1/2,0,0,0,0,0];
Ass=AddAssembly(Ass,Worm.output.Assembly,'position',position);
position=[0,-obj.input.a,-b2H/2,0,-90,0];
Ass=AddAssembly(Ass,Wheel.output.Assembly,'position',position);

ix=cos(alphan/180*pi)*cos(gamma/180*pi);
iy=ix*tan(gamma/180*pi);
iz=sqrt(1-ix^2-iy^2);
ratio=(a-d1/2-d2/2)/iy;
switch Helix
    case 'Right'
        x1=[-ix*ratio;ix*ratio];
        y1=[-d1/2;-d1/2];
        z1=[-iz*ratio;iz*ratio];
        x2=0;
        y2=-a+d2/2;
        z2=0;
    case 'Left'
        x1=[-ix*ratio;ix*ratio];
        y1=[-d1/2;-d1/2];
        z1=[iz*ratio;-iz*ratio];
        x2=0;
        y2=-a+d2/2;
        z2=0;
end

% Stiffness
coor=[x1 y1 z1;x2 y2 z2];
meshoutput.nodes=coor;
meshoutput.elements=[1,3;2,3];
meshoutput.faces=[];
meshoutput.facesBoundary=[];
meshoutput.boundaryMarker=[1;2;3];
meshoutput.elementMaterialID=ones(2,1);
meshoutput.faceMaterialID=[];
meshoutput.order=1;
Ass=AddPart(Ass,meshoutput);

% Master
for j=1:3
    Ass=AddMaster(Ass,3,j);
end

% ET
ET.name='39';ET.opt=[4,1];
ET.R=reshape(obj.output.SpringStiffness,[],1)';
Ass=AddET(Ass,ET);
Acc_ET=GetNET(Ass);
Ass=SetET(Ass,3,Acc_ET);

% Connection
switch Helix
    case 'Right'
        cube1.origin=[-ix*ratio,-d1/2,-iz*ratio];
        cube1.dx=[-Worm.input.Meshsize*1.2,ix*ratio-1e-3];
        Temp=2*pi/Worm.params.E_Revolve;
        cube1.dy=[0,d1/2*(1-cos(Temp))*2];
        cube1.dz=[-d1/2*sin(Temp),d1/2*sin(Temp)];
        Ass=AddSlaver(Ass,1,'face',101,'cube1',cube1);
        Ass=SetRbe3(Ass,1,1);

        cube1.origin=[ix*ratio,-d1/2,iz*ratio];
        cube1.dx=[-ix*ratio+1e-3,Worm.input.Meshsize*1.2];
        Temp=2*pi/Worm.params.E_Revolve;
        cube1.dy=[0,d1/2*(1-cos(Temp))*2];
        cube1.dz=[-d1/2*sin(Temp),d1/2*sin(Temp)];
        Ass=AddSlaver(Ass,1,'face',101,'cube1',cube1);
        Ass=SetRbe3(Ass,2,2);
    case 'Left'
        cube1.origin=[-ix*ratio,-d1/2,iz*ratio];
        cube1.dx=[-Worm.input.Meshsize*1.2,ix*ratio-1e-3];
        Temp=2*pi/Worm.params.E_Revolve;
        cube1.dy=[0,d1/2*(1-cos(Temp))*2];
        cube1.dz=[-d1/2*sin(Temp),d1/2*sin(Temp)];
        Ass=AddSlaver(Ass,1,'face',101,'cube1',cube1);
        Ass=SetRbe3(Ass,1,1);

        cube1.origin=[ix*ratio,-d1/2,-iz*ratio];
        cube1.dx=[-ix*ratio+1e-3,Worm.input.Meshsize*1.2];
        Temp=2*pi/Worm.params.E_Revolve;
        cube1.dy=[0,d1/2*(1-cos(Temp))*2];
        cube1.dz=[-d1/2*sin(Temp),d1/2*sin(Temp)];
        Ass=AddSlaver(Ass,1,'face',101,'cube1',cube1);
        Ass=SetRbe3(Ass,2,2);
end

cube1.origin=[0,-a+d2/2,0];
Temp=2*pi/Z2;
cube1.dx=[-d2/2*sin(Temp/2),d2/2*sin(Temp/2)];
cube1.dy=[-d2/2*(1-cos(Temp))*2,0];
cube1.dz=[-b2H/2,b2H/2];
Ass=AddSlaver(Ass,2,'face',101,'cube1',cube1);
Ass=SetRbe3(Ass,3,3);


%% Parse
obj.output.Assembly1=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end
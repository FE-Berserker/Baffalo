function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu

Ass=Assembly(obj.params.Name,'Echo',0);
d=obj.input.d;
MuK=obj.params.MuK;
K=obj.output.K;
sw=obj.output.sw;
% Create Bolt
ds=obj.output.ds;
lk=obj.input.lk;
l1=obj.output.l1;
d0=obj.output.d0;

m1=Mesh2D('Bolt','Echo',0);
m1=MeshRing(m1,ds/2,sw/2,'Seg',8,'Num',2,'ElementType','tri');
if d0==0
    m1=MeshEdge(m1,1);
else
    m1=MeshLayerEdge(m1,1,(ds-d0)/2);
end

mm1=Mesh('Bolt Head','Echo',0);
mm1=Extrude2Solid(mm1,m1,K,2);
Vm = PatchCenter(mm1);
r=sqrt(Vm(:,1).^2+Vm(:,2).^2);

Cb=mm1.Meshoutput.boundaryMarker;
Cb(and(r<ds/2*0.8,Cb==3),:)=4;
mm1.Cb=Cb;
mm1.Meshoutput.boundaryMarker=Cb;
% Create Bolt Shank
if obj.params.Washer
    Washer_d1=obj.output.Washer_d1;
    Washer_d2=obj.output.Washer_d2;
    h1=obj.output.Washer_h;
    lk=lk+h1;
end

if obj.params.NutWasher
    NutWasher_d1=obj.output.NutWasher_d1;
    NutWasher_d2=obj.output.NutWasher_d2;
    h2=obj.output.NutWasher_h;
    lk=lk+h2;
end

if l1~=0
    inputShank.Length = [l1;lk];
    inputShank.ID = [[d0,d0];[d0,d0]];
    inputShank.OD = [[d,d];[ds,ds]];
else
    inputShank.Length = lk;
    inputShank.ID = [d0,d0];
    inputShank.OD = [ds,ds];
end
paramsShank.Material=obj.params.Material{1,1};
Slice=ceil(lk/ds*3);
if mod(Slice,2)~=0
    Slice=Slice+1;
end
paramsShank.N_Slice=Slice;
Shank = shaft.Commonshaft(paramsShank, inputShank);
Shank = Shank.solve();

% Create Washer
if obj.params.Washer
    position=[-h1-K,0,0,0,90,0];
    Ass=AddPart(Ass,mm1.Meshoutput  ,'position',position);
    BoltHead_Assembly_Num=1;

    m2=Mesh2D('Washer','Echo',0);
    m2=MeshRing(m2,Washer_d1/2,Washer_d2/2,'Seg',16,'Num',3,'ElementType','tri');
    mm2=Mesh('Washer','Echo',0);
    mm2=Extrude2Solid(mm2,m2,h1,3);
    position=[-h1,0,0,0,90,0];
    Ass=AddPart(Ass,mm2.Meshoutput  ,'position',position);
    Washer_Assembly_Num=2;

    position=[-h1,0,0,0,0,0];
    Ass=AddAssembly(Ass,Shank.output.Assembly1,'position',position);
    BoltShank_Assembly_Num=3;
else
    h1=0;
    position=[-K,0,0,0,90,0];
    Ass=AddPart(Ass,mm1.Meshoutput,'position',position);
    BoltHead_Assembly_Num=1;
    Ass=AddAssembly(Ass,Shank.output.Assembly1);
    BoltShank_Assembly_Num=2;
    
end

% Create Nut
if obj.params.Nut
    s=obj.output.Nut_s;
    m=obj.output.Nut_m;
    m3=Mesh2D('Nut','Echo',0);
    m3=MeshRing(m3,ds/2,s/sqrt(3),'Seg',6,'Num',3,'ElementType','tri');
    mm3=Mesh('Nut','Echo',0);
    mm3=Extrude2Solid(mm3,m3,m,3);
    Vm = PatchCenter(mm3);
    r=sqrt(Vm(:,1).^2+Vm(:,2).^2);

    Cb=mm3.Meshoutput.boundaryMarker;
    Cb(and(r<=ds/2,Cb==1),:)=4;

    mm3.Cb=Cb;
    mm3.Meshoutput.boundaryMarker=Cb;
    if obj.params.NutWasher
        m4=Mesh2D('NutWasher','Echo',0);
        m4=MeshRing(m4,NutWasher_d1/2,NutWasher_d2/2,'Seg',16,'Num',3,'ElementType','tri');
        mm4=Mesh('Washer','Echo',0);
        mm4=Extrude2Solid(mm4,m4,h2,3);

        position=[lk-h1,0,0,0,90,0];
        Ass=AddPart(Ass,mm3.Meshoutput,'position',position);
        Nut_Assembly_Num=BoltShank_Assembly_Num+size(Shank.output.Assembly1.Part,1);

        position=[lk-h1-h2,0,0,0,90,0];
        Ass=AddPart(Ass,mm4.Meshoutput,'position',position);
        NutWasher_Assembly_Num=Nut_Assembly_Num+1;

    else
        position=[lk-h1,0,0,0,90,0];
        Ass=AddPart(Ass,mm3.Meshoutput,'position',position);
        Nut_Assembly_Num=BoltShank_Assembly_Num+size(Shank.output.Assembly1.Part,1);
    end
end


% ET
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,BoltHead_Assembly_Num,2);
%  BoltMaterial
AccMat=GetNMaterial(Ass);
mat1.name=obj.params.Material{1,1}.Name;
mat1.table=["DENS",obj.params.Material{1,1}.Dens;"EX",obj.params.Material{1,1}.E;...
    "NUXY",obj.params.Material{1,1}.v;"ALPX",obj.params.Material{1,1}.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,BoltHead_Assembly_Num, AccMat+1);

%  WasherMaterial
if obj.params.Washer
    AccMat=GetNMaterial(Ass);
    mat2.name=obj.params.Material{2,1}.Name;
    mat2.table=["DENS",obj.params.Material{2,1}.Dens;"EX",obj.params.Material{2,1}.E;...
        "NUXY",obj.params.Material{2,1}.v;"ALPX",obj.params.Material{2,1}.a];
    Ass=AddMaterial(Ass,mat2);
    Ass=SetET(Ass,Washer_Assembly_Num,2);
    Ass=SetMaterial(Ass,Washer_Assembly_Num, AccMat+1);
end

%  NutMaterial
if obj.params.Nut
    AccMat=GetNMaterial(Ass);
    mat3.name=obj.params.Material{3,1}.Name;
    mat3.table=["DENS",obj.params.Material{3,1}.Dens;"EX",obj.params.Material{3,1}.E;...
        "NUXY",obj.params.Material{3,1}.v;"ALPX",obj.params.Material{3,1}.a];
    Ass=AddMaterial(Ass,mat3);
    Ass=SetET(Ass,Nut_Assembly_Num,2);
    Ass=SetMaterial(Ass,Nut_Assembly_Num, AccMat+1);
end

%  WasherMaterial
if obj.params.NutWasher
    AccMat=GetNMaterial(Ass);
    mat2.name=obj.params.Material{2,1}.Name;
    mat2.table=["DENS",obj.params.Material{2,1}.Dens;"EX",obj.params.Material{2,1}.E;...
        "NUXY",obj.params.Material{2,1}.v;"ALPX",obj.params.Material{2,1}.a];
    Ass=AddMaterial(Ass,mat2);
    Ass=SetET(Ass,NutWasher_Assembly_Num,2);
    Ass=SetMaterial(Ass,NutWasher_Assembly_Num, AccMat+1);
end

if or(obj.params.Washer,obj.params.NutWasher)
    % Define Element Types
    ET5.name='173';ET5.opt=[5,3;9,1;10,2;12,5];ET5.R=[]; % Bonded contact
    Ass=AddET(Ass,ET5);
    ET9.name='170';ET9.opt=[];ET9.R=[];
    Ass=AddET(Ass,ET9);
    Acc_ET=GetNET(Ass);
    mat1.table=["MU",MuK];
    Ass=AddMaterial(Ass,mat1);
    Acc_Mat=GetNMaterial(Ass);

    % Define Contacts
    if obj.params.Washer
        % 1. BoltHead - Washer
        Ass=AddCon(Ass,BoltHead_Assembly_Num,3);
        Ass=AddTar(Ass,1,Washer_Assembly_Num,2);
        Ass=SetConMaterial(Ass,1,Acc_Mat);
        Ass=SetConET(Ass,1,Acc_ET-1);
        Ass=SetTarET(Ass,1,Acc_ET);
    end

    if obj.params.NutWasher
        % 2. Nut - NutWasher
        Acc_Con=GetNContactPair(Ass);
        Ass=AddCon(Ass,Nut_Assembly_Num,2);
        Ass=AddTar(Ass,Acc_Con+1,NutWasher_Assembly_Num,3);
        Ass=SetConMaterial(Ass,Acc_Con+1,Acc_Mat);
        Ass=SetConET(Ass,Acc_Con+1,Acc_ET-1);
        Ass=SetTarET(Ass,Acc_Con+1,Acc_ET);
    end
end

%% Add BeamPreload
switch obj.params.Type
    case 1
        Ass=AddBeamPreload(Ass,BoltShank_Assembly_Num+(Slice)/2,obj.output.FMmax);
    case 2
        Ass=AddBeamPreload(Ass,BoltShank_Assembly_Num+(Slice)/2,obj.output.FMmin);
end

%% Define Connections
% 1. BoltHead - BoltShank
Ass=AddMaster(Ass,BoltShank_Assembly_Num,1);
Ass=AddSlaver(Ass,BoltHead_Assembly_Num,'face',4);
Ass=SetRbe2(Ass,1,1);

% 2. Nut - BoltShank
if obj.params.Nut
    Ass=AddMaster(Ass,BoltShank_Assembly_Num,Slice+1);
    Ass=AddSlaver(Ass,Nut_Assembly_Num,'face',4);
    Ass=SetRbe2(Ass,2,2);
end


%% Parse
obj.output.Assembly=Ass;
obj.output.BoltHead_Assembly_Num= BoltHead_Assembly_Num;
obj.output.BoltShank_Assembly_Num= BoltShank_Assembly_Num;
if obj.params.Washer
    obj.output.Washer_Assembly_Num= Washer_Assembly_Num;
end
if obj.params.Nut
    obj.output.Nut_Assembly_Num= Nut_Assembly_Num;
end
if obj.params.NutWasher
    obj.output.NutWasher_Assembly_Num= NutWasher_Assembly_Num;
end

obj.output.BoltShank_Slice=Slice;
%% Print
if obj.params.Echo
    fprintf('Successfully output bolt mesh assembly .\n');
end
end
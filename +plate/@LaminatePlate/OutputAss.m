function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

Ass=Assembly(obj.params.Name,'Echo',0);
%% Add  Laminateplate
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput,'position',position);

%% ET
if obj.params.Order==2
    ET1.name='186';ET1.opt=[2,2;3,1;6,0;8,1];ET1.R=[];
else
    ET1.name='185';ET1.opt=[2,2;3,1;6,0;8,1];ET1.R=[];
end

Ass=AddET(Ass,ET1);
%% ESYS
Ass=AddCS(Ass,0,[0,0,0]);
Ass=SetESYS(Ass,1,11);

%% Material
Material=obj.params.Material;

for i=1:size(Material,1)
    mat.Name= Material{i,1}.Name;
    mat.table=["DENS",Material{i,1}.Dens;"EX",Material{i,1}.E1;"EY",Material{i,1}.E2;"EZ",Material{i,1}.E3;...
        "PRXY",Material{i,1}.v12;"PRYZ",Material{i,1}.v23;"PRXZ",Material{i,1}.v13;...
        "GXY",Material{i,1}.G12;"GYZ",Material{i,1}.G23;"GXZ",Material{i,1}.G13];
    if isfield(Material{i,1},"allowables")
        FC=Material{i,1}.allowables;
        mat.FC=["XTEN",FC.F1t;"XCMP",-FC.F1c;...
            "YTEN",FC.F2t;"YCMP",-FC.F2c;...
            "ZTEN",FC.F3t;"ZCMP",-FC.F3c;...
            "YZ",FC.F4;"XZ",FC.F5;"XY",FC.F6];
        mat.FCType="S";% Stress limit
        if ~isnan(FC.XZIT)
            mat.FC=[mat.FC;"XZIT",FC.XZIT;...
                "XZIC",FC.XZIC;...
                "YZIT",FC.YZIT;...
                "YZIC",FC.YZIC];
        end
    end
    Ass=AddMaterial(Ass,mat);
end

%% Section

Orient=obj.input.Orient;
Plymat=obj.input.Plymat;
Tply=obj.input.Tply;

Sec.type="shell";
Sec.subtype=[];

for i=1:size(Orient,1)
    

    Sec.data=[Tply(i,1),Plymat(i,1),Orient(i,1),3];
    Ass=AddSection(Ass,Sec);
end

%% Divide Part
PartElNum=Ass.Part{1, 1}.NumElements/size(Orient,1);
Acc=0;
matrix=cell(size(Orient,1),1);
for i=1:size(Orient,1)
    matrix{i,1}=(Acc+1:Acc+PartElNum)';
    Acc=Acc+PartElNum;
end

Ass=DividePart(Ass,1,matrix);

for i=1:size(Orient,1)
    Ass=SetSection(Ass,i,i);
    Ass=SetET(Ass,i,1);
    Ass=SetMaterial(Ass,i,Plymat(i,1));
end

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end
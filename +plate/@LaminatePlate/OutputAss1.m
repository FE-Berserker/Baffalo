function obj = OutputAss1(obj)
% Output shellmesh to Assembly
% Author : Xie Yu
if isempty(obj.output.ShellMesh)
    obj=OutputShellModel(obj);
end

Ass=Assembly(obj.params.Name,'Echo',0);
%% Create plate
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.ShellMesh.Meshoutput,'position',position);

%% ESYS
Ass=AddCS(Ass,0,[0,0,0]);
Ass=SetESYS(Ass,1,11);

%%  Material
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
Temp=[];

for i=1:size(Orient,1)
    Temp=[Temp;Tply(i,1),Plymat(i,1),Orient(i,1),3]; %#ok<AGROW>
end

Sec.data=Temp;
Sec.offset=obj.params.Offset;
Ass=AddSection(Ass,Sec);
Ass=SetSection(Ass,1,1);
% ET
if obj.params.Order==2
    ET1.name='281';ET1.opt=[8,1];ET1.R=[];
else
    ET1.name='181';ET1.opt=[8,1];ET1.R=[];
end
Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);

%% Parse
obj.output.Assembly1=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output shell mesh assembly .\n');
end
end
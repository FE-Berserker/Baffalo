function obj=OutputAss(obj,varargin)
% Output Assembly
% Author : Xie Yu
k=inputParser;
addParameter(k,'Mat_Sep',0);
parse(k,varargin{:});
opt=k.Results;

Material=obj.params.Material;
Thickness=obj.input.Thickness;
Di=obj.input.Di;
Angle=obj.input.Angle;
MatNum=obj.input.MatNum;
numElementsThickness=obj.output.NRot;
numElementsHeight=obj.params.NHeight;
Temp=tril(ones(size(Thickness,2),size(Thickness,2)))*Thickness';
R=[Di/2,Di/2+Temp'];
TotalLayers=size(R,2)-1;
%% Assembly
Ass=Assembly(obj.params.Name);
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput);

% Material
for i=1:size(Material,1)
    mat.Name= Material{i,1}.Name;
    mat.table=["DENS",Material{i,1}.Dens;"EX",Material{i,1}.E1;"EY",Material{i,1}.E2;"EZ",Material{i,1}.E3;...
        "PRXY",Material{i,1}.v12;"PRYZ",Material{i,1}.v23;"PRXZ",Material{i,1}.v13;...
        "GXY",Material{i,1}.G12;"GYZ",Material{i,1}.G23;"GXZ",Material{i,1}.G13];
    if isfield(Material{i,1},"a1")
        mat.table=[mat.table;...
            "ALPX",Material{i,1}.a1;"ALPY",Material{i,1}.a2;"ALPZ",Material{i,1}.a3];
    end

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

% Section
Sec.type="shell";
Sec.subtype=[];
% Element type
ReverseAngle=(90-Angle).*(Angle>=0)+(-90-Angle).*(Angle<0);
for i=1:size(ReverseAngle,2)
    ET1.name='185';ET1.opt=[2,2;3,1;6,0;8,1];ET1.R=[];
    Ass=AddET(Ass,ET1);
    Sec.data=[Thickness(i),MatNum(i),ReverseAngle(i),3];
    Ass=AddSection(Ass,Sec);
end

a1=(0:TotalLayers:numElementsHeight*TotalLayers-TotalLayers)*numElementsThickness;
a1=repmat(a1,numElementsThickness,1);

b1=(1:numElementsThickness)';
b1=repmat(b1,1,numElementsHeight);

c1=reshape(a1+b1,[],1);

matrix=cell(TotalLayers,1);
for i=1:TotalLayers
    matrix{i,1}=c1+(i-1)*numElementsThickness.*ones(size(c1,1),1);
end
Ass=DividePart(Ass,1,matrix);

for i=1:TotalLayers
    Ass=SetMaterial(Ass,i,MatNum(i));
    Ass=SetET(Ass,i,i);
    Ass=SetSection(Ass,i,i);
    Ass=AddTemperature(Ass,i,obj.params.T);
end

% Parse
obj.output.Matrix=matrix;
obj.output.Assembly=Ass;

% Print
if obj.params.Echo
    fprintf('Successfully output solid assembly .\n');
end
end


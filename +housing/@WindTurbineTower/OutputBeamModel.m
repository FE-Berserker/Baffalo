function obj=OutputBeamModel(obj)
% Output Beam model
% Author : Xie Yu
%% Create points
a=Point2D('Point1','Echo',0);
b=Line2D('Line1','Echo',0);
Height_Slice=zeros(size(obj.input.Diameter,1),1);
Height=tril(ones(size(obj.input.Length,1)))*obj.input.Length;
Height=[0;Height];
% Radius=[obj.input.Diameter(:,1)/2;obj.input.Diameter(end,2)/2];

% if isempty(obj.input.Meshsize)
%     Meshsize=2*pi*mean(Radius)/obj.params.N_Slice;
% else
%     Meshsize=obj.input.Meshsize;
% end

switch obj.params.Offset
    case "MID"
        OD=obj.input.Diameter+repmat(obj.input.Thickness,1,2);
        ID=obj.input.Diameter-repmat(obj.input.Thickness,1,2);
    case "BOT"
        OD=obj.input.Diameter+2*repmat(obj.input.Thickness,1,2);
        ID=obj.input.Diameter;
    case "TOP"
        OD=obj.input.Diameter;
        ID=obj.input.Diameter-2*repmat(obj.input.Thickness,1,2);
end

IR=[];
OR=[];
for i=1:size(obj.input.Diameter,1)
    % R1=Radius(i,1);
    % R2=Radius(i+1,1);
    H1=Height(i,1);
    H2=Height(i+1,1);
    % dis=sqrt((R2-R1)^2+(H1-H2)^2);
    % Temp_Slice=round(dis/Meshsize);
    Temp_Slice=1;
    a=AddPoint(a,zeros(Temp_Slice+1,1),(H1:(H2-H1)/Temp_Slice:H2)');
    b=AddCurve(b,a,i);
    Height_Slice(i,1)=Temp_Slice;
    Delta_OD=OD(i,2)-OD(i,1);
    Delta_ID=ID(i,2)-ID(i,1);

    Temp=1/Temp_Slice/2:1/Temp_Slice:1-1/Temp_Slice/2;

    IR=[IR;(ID(i,1)+Temp'*Delta_ID)/2]; %#ok<AGROW>
    OR=[OR;(OD(i,1)+Temp'*Delta_OD)/2]; %#ok<AGROW>
end
b=Meshoutput(b);
obj.output.BeamMesh.Meshoutput=b.Meshoutput;
%% Create Section
SecNum=size(IR,1);
Section=cell(SecNum,1);
for i=1:SecNum
    Section{i,1}.type="beam";
    Section{i,1}.subtype="CTUBE";
    Section{i,1}.data=[IR(i,1),OR(i,1),16];

end
%% Parse
obj.output.BeamMesh.Section=Section;
%% Print
if obj.params.Echo
    fprintf('Successfully output beam mesh .\n');
end
end
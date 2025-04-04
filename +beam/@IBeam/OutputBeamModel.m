function obj=OutputBeamModel(obj)
% Output Beam model
% Author : Xie Yu
%% Create points
a=Point2D('Point1','Echo',0);
x=obj.output.Node;
y=zeros(size(x,1),1);
a=AddPoint(a,x,y);
%% Create lines
b=Line2D('Line1','Echo',0);
b=AddCurve(b,a,1);
b=Meshoutput(b);
obj.output.BeamMesh.Meshoutput=b.Meshoutput;
%% Create Section
SecNum=size(obj.output.ID,1)-1;
Section=cell(SecNum,1);
for i=1:SecNum
Section{i,1}.type="beam";
IR=obj.output.ID(i)/4+obj.output.ID(i+1)/4;
OR=obj.output.OD(i)/4+obj.output.OD(i+1)/4;
if IR==0
    Section{i,1}.subtype="CSOLID";
    Section{i,1}.data=[OR,obj.params.Beam_N];
else
    Section{i,1}.subtype="CTUBE";
    Section{i,1}.data=[IR,OR,obj.params.Beam_N];
end
end
%% Parse
obj.output.BeamMesh.Section=Section;
%% Print
if obj.params.Echo
    fprintf('Successfully output beam assembly .\n');
end
end
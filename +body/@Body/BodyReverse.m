function obj=BodyReverse(obj)
% Reverse Body
 %Author: Xie Yu

Temp.Face=obj.output.OriginSolidMesh.Face;
Temp.Vert=obj.output.OriginSolidMesh.Vert;
Temp.Cb=obj.output.OriginSolidMesh.Cb;
Temp.El=obj.output.OriginSolidMesh.El;
Temp.G=obj.output.OriginSolidMesh.G;
Temp.Meshoutput=obj.output.OriginSolidMesh.Meshoutput;

mm=obj.output.OriginSolidMesh;
Num=GetNTimes(obj);
logic=obj.output.Times{Num,1}.logic;
logic=1-logic;
mm = RemoveCells(mm,~logic);

obj.output.Times{Num+1,1}.logic=logic;
obj.output.SolidMesh.Face=mm.Face;
obj.output.SolidMesh.Vert=mm.Vert;
obj.output.SolidMesh.Cb=mm.Cb;
obj.output.SolidMesh.El=mm.El;
obj.output.SolidMesh.G=mm.G;
obj.output.SolidMesh.Meshoutput=mm.Meshoutput;

obj.output.OriginSolidMesh.Face=Temp.Face;
obj.output.OriginSolidMesh.Vert=Temp.Vert;
obj.output.OriginSolidMesh.Cb=Temp.Cb;
obj.output.OriginSolidMesh.El=Temp.El;
obj.output.OriginSolidMesh.G=Temp.G;
obj.output.OriginSolidMesh.Meshoutput=Temp.Meshoutput;

%% Print
if obj.params.Echo
    fprintf('Successfully reverse body .\n');
end
end

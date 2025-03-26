function obj=SmoothFace(obj,PointSpacing)

if nargin<2
    Length=obj.input.Meshsize;
else
    Length=PointSpacing;
end
mm=obj.output.SolidMesh;
mm=Remesh(mm,Length);
obj.output.SolidMesh=mm;
end
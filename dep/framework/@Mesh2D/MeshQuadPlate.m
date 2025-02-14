function obj=MeshQuadPlate(obj,plateDim,plateEl)
% Mesh quad Plate
% Author : Xie Yu
%% Parse input 
if nargin<3
    plateEl=[10 10];
end

%% Main
dX=plateDim(1); 
dY=plateDim(2); 
nX=plateEl(1); 
nY=plateEl(2);
% Grid
[X,Y] = meshgrid(linspace(-dX/2,dX/2,nX+1),linspace(-dY/2,dY/2,nY+1));
% Convert to patch data (quadrilateral faces)
[F,V] = grid2patch(X,Y,zeros(size(X)));

obj.Vert=V;
obj.Face=F;
obj.Cb=ones(size(F,1),1);

obj.Boundary=FindBoundary(obj);
%% Parse
obj.Meshoutput.nodes=[V,zeros(size(obj.Vert,1),1)];
obj.Meshoutput.facesBoundary=obj.Boundary;
obj.Meshoutput.boundaryMarker=ones(size(obj.Boundary,1),1);
obj.Meshoutput.faces=[];
obj.Meshoutput.elements=obj.Face;
obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;
%% Print
if obj.Echo
    fprintf('Successfully mesh quad plate .\n');
end

end


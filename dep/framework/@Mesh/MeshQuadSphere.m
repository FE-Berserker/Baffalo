function obj = MeshQuadSphere(obj,n,r,varargin)
%Mesh quad sphere
p=inputParser;
addParameter(p,'hollow',0);
addParameter(p,'coreRadius',r/2);
parse(p,varargin{:});
opt=p.Results;


% oriOpt=1 -> Tetrahedron
% oriOpt=2 -> Cube
% oriOpt=3 -> Octahedron
% oriOpt=4 -> Icosahedron
% oriOpt=5 -> Rhombic dodecahedron
% if nargin<4
%     [F,V]=quadSphere(n,r);
% else
%     oriOpt=varargin{1};
%     [F,V]=quadSphere(n,r,oriOpt);
% end
% 
% obj.Face=F;
% obj.Vert=V;
% obj.Cb=ones(size(F,1),1);
%Control settings
optionStruct.sphereRadius=r;
optionStruct.coreRadius=opt.coreRadius;
optionStruct.numElementsMantel=n; 
optionStruct.numElementsCore=n*2; 
optionStruct.makeHollow=opt.hollow;
optionStruct.outputStructType=2;

%Creating sphere
[meshStruct]=hexMeshSphere(optionStruct);
obj.Meshoutput=meshStruct;
obj.Face=meshStruct.facesBoundary;
obj.Vert=meshStruct.nodes;
obj.Cb=meshStruct.boundaryMarker ;
end


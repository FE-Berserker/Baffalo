function obj= MeshHemiSphere(obj,Radius,MantelNum,varargin)
%Create Hemi Sphere mesh
p=inputParser;
addParameter(p,'coreRadius',Radius/2);
addParameter(p,'outputStructType',2);
addParameter(p,'hollow',0);
addParameter(p,'smoothstep',25);
parse(p,varargin{:});
opt=p.Results;

inputStruct.sphereRadius=Radius;
inputStruct.coreRadius=opt.coreRadius;
inputStruct.numElementsMantel=MantelNum;
inputStruct.numElementsCore=MantelNum*2;
inputStruct.outputStructType=opt.outputStructType;
inputStruct.makeHollow=opt.hollow;
inputStruct.cParSmooth.n=opt.smoothstep;

[obj.Meshoutput]=hexMeshHemiSphere(inputStruct);
% Access model element and patch data
obj.Face=obj.Meshoutput.facesBoundary;
obj.Cb=obj.Meshoutput.boundaryMarker;
obj.Vert=obj.Meshoutput.nodes;
end



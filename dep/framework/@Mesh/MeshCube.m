function obj=MeshCube(obj,cubeDimensions,cubeElementNumbers,varargin)
% Mesh cube
% Author : Xie Yu
p=inputParser;
addParameter(p,'ElementType','hex8');
addParameter(p,'outputStructType',2);

parse(p,varargin{:});
opt=p.Results;

[obj.Meshoutput]=hexMeshBox(cubeDimensions,cubeElementNumbers,opt.outputStructType);
obj.Vert=obj.Meshoutput.nodes;
obj.El=obj.Meshoutput.elements; %The elements
obj.Face=obj.Meshoutput.facesBoundary; %The boundary faces
obj.Cb=obj.Meshoutput.boundaryMarker; %The "colors" or labels for the boundary faces
obj.Meshoutput.order=1;

if opt.ElementType=="hex20"
    [obj.El,obj.Vert,~,obj.Face]=hex8_hex20(obj.El,obj.Vert,{},obj.Face);
    obj.Meshoutput.elements=obj.El;
    obj.Meshoutput.nodes=obj.Vert;
    obj.Meshoutput.facesBoundary=obj.Face;
    obj.Meshoutput.order=2;
end


obj.Vert=obj.Meshoutput.nodes;
obj.El=obj.Meshoutput.elements; %The elements
obj.Face=obj.Meshoutput.facesBoundary; %The boundary faces

%% Print
if obj.Echo
    fprintf('Successfully mesh cube . \n');
end
end
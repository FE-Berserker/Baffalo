function obj=Mesh3D(obj,varargin)
% Create 3D Mesh
% Author : Xie Yu
p=inputParser;
addParameter(p,'stringOpt','-pq1.2AaY');
addParameter(p,'minRegionMarker',2);
parse(p,varargin{:});
opt=p.Results;

inputStruct.stringOpt=opt.stringOpt;
inputStruct.minRegionMarker=opt.minRegionMarker; %Minimum region marker

inputStruct.Faces=obj.Face;
inputStruct.Nodes=obj.Vert;
inputStruct.faceBoundaryMarker=obj.Cb; %Face boundary markers
inputStruct.regionPoints=getInnerPoint(obj.Face,obj.Vert); %region points
inputStruct.regionA=tetVolMeanEst(obj.Face,obj.Vert); %Volume for regular tets

obj.Meshoutput=runTetGen(inputStruct);
% el=obj.Meshoutput.elements;
% obj.Meshoutput.elements=el;
Temp=ones(numel(obj.Meshoutput.elementMaterialID),1);
obj.Meshoutput.elementMaterialID=Temp;
obj.Meshoutput.order=1;
end
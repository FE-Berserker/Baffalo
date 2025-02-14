function obj= MeshCylinder(obj,esize,Radius,Height,varargin)
% Create Cylinder mesh
% Author : Xie Yu
p=inputParser;
addParameter(p,'ElementType','tri');
addParameter(p,'close',1);
parse(p,varargin{:});
opt=p.Results;
%% parameter
pointSpacing=esize;
inputStruct.cylRadius=Radius;
inputStruct.numRadial=round((inputStruct.cylRadius*pi)/4/pointSpacing)*4;
inputStruct.cylHeight=Height;
inputStruct.numHeight=round(inputStruct.cylHeight/pointSpacing);
inputStruct.meshType=opt.ElementType;
inputStruct.closeOpt=opt.close;
[Fs,Vs,Cs]=patchcylinder(inputStruct);
obj.Vert=Vs;
obj.Face=Fs;
obj.Cb=Cs;

%% Parse
obj.Meshoutput.nodes=Vs;
obj.Meshoutput.facesBoundary=FindBoundary(obj);
obj.Meshoutput.boundaryMarker=Cs;
obj.Meshoutput.faces=[];
obj.Meshoutput.elements=Fs;
obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;
%% Print
if obj.Echo
    fprintf('Successfully mesh cylinder .\n');
end
end


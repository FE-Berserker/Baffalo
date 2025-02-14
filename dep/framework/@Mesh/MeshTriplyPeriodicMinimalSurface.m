function obj= MeshTriplyPeriodicMinimalSurface(obj,length,varargin)
%Create TriplyPeriodicMinimalSurface
p=inputParser;
addParameter(p,'cap',1);
addParameter(p,'surfaceCase','g');
addParameter(p,'numPeriods',[2 2 2]);
addParameter(p,'levelset',0.3);
parse(p,varargin{:});
opt=p.Results;

pointSpacing=length/25;
overSampleRatio=2;
numStepsLevelset=ceil(overSampleRatio.*(length./pointSpacing)); %Number of voxel steps across period for image data (roughly number of points on mesh period)
inputStruct.L=length; % characteristic length
inputStruct.Ns=numStepsLevelset; % number of sampling points
inputStruct.isocap=opt.cap; %Option to cap the isosurface
inputStruct.surfaceCase=opt.surfaceCase; %Surface type
inputStruct.numPeriods=opt.numPeriods; %Number of periods in each direction
inputStruct.levelset=opt.levelset; %Isosurface level

[F,V,C,~]=triplyPeriodicMinimalSurface(inputStruct);
% Access model element and patch data
obj.Face=F;
obj.Cb=C+1;
obj.Vert=V;
end



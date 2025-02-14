function obj= MeshSpinodoid(obj,Length,paticleLength,varargin)
%Create Spinodoid
p=inputParser;
addParameter(p,'Nw',500);
addParameter(p,'WaveNum',8*pi);
addParameter(p,'relD',0.5);
addParameter(p,'thetas',[90 0 0]);
addParameter(p,'cap',1);
parse(p,varargin{:});
opt=p.Results;

sampleSize=Length; %Length of the sample
pointSpacing=sampleSize/25;
overSampleRatio=2;
numStepsLevelset=ceil(overSampleRatio.*(sampleSize./pointSpacing));
inputStruct.isocap=opt.cap; % option to cap the isosurface
inputStruct.domainSize=paticleLength; % domain size
inputStruct.resolution=numStepsLevelset; % resolution for sampling GRF
inputStruct.waveNumber=opt.WaveNum; % GRF wave number
inputStruct.numWaves=opt.Nw; % number of waves in GRF
inputStruct.relativeDensity=opt.relD; % relative density: between [0.3,1]
inputStruct.thetas=opt.thetas; % conical half angles (in degrees) along xyz

[F,V,C,~]=spinodoid(inputStruct);
% Access model element and patch data
obj.Face=F;
obj.Cb=C+1;
obj.Vert=V;
end



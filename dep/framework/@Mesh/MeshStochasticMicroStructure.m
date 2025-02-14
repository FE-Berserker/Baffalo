function obj= MeshStochasticMicroStructure(obj,Length,paticleLength,varargin)
%Create Stochastic MicroStructure
p=inputParser;
addParameter(p,'Nw',60);
addParameter(p,'q0',25);
addParameter(p,'relD',0.3);
addParameter(p,'anisotropy',[1 1 1]);
addParameter(p,'cap',1);
parse(p,varargin{:});
opt=p.Results;

pointSpacing=Length/25;
overSampleRatio=2;
numStepsLevelset=ceil(overSampleRatio.*(Length./pointSpacing));
inputStruct.L=paticleLength; % characteristic length
inputStruct.Ns=numStepsLevelset; % number of sampling points
inputStruct.Nw=opt.Nw; % number of waves
inputStruct.q0=opt.q0; % wave number
inputStruct.relD=opt.relD; % relative density
inputStruct.anisotropyFactors=opt.anisotropy; %Anisotropy factors
inputStruct.isocap=opt.cap; %Option to cap the isosurface

[F,V,C,~]=stochasticMicrostructure(inputStruct);
% Access model element and patch data
obj.Face=F;
obj.Cb=C+1;
obj.Vert=V;
end


